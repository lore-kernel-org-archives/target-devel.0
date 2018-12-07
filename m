From: Christoph Hellwig <hch@lst.de>
Date: Fri, 07 Dec 2018 19:23:04 +0000
Subject: Re: BUG in copy_page_to_iter() when iscsi sets ENABLE_CLUSTERING
Message-Id: <20181207192304.GA29316@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181205200940.81D81BD4D4@localhost>
In-Reply-To: <20181205200940.81D81BD4D4@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Note that independent of what we do in the Linux iSCSI initiator
this is a network DOS, so we'll have to fix it.

On Wed, Dec 05, 2018 at 12:09:40PM -0800, Lee Duncan wrote:
> I recently found what I believe is a bug, and I'd appreciate feedback
> on if that is correct, and if so how to proceed.
> 
> BACKGROUND
> 
> Recently Christoph Hellwig sent an email to driver maintainers for
> drivers that set ".use_clustering" to DISABLE_CLUSTERING in their SCSI
> Host templates, asking if the setting could be changed to
> ENABLE_CLUSTERING.
> 
> As part of answering that question, I set ENABLE_CLUSTERING in
> drivers/scsi/iscsi_tcp.c and tested both the iscsi initiator and
> target.
> 
> As a reminder, setting ENABLE_CLUSTERING means that adjacent bio-s can
> be merged. This can make IO faster, but it means that drivers must be
> able to deal with IOs that cross page boundaries, since bio merges can
> create such IOs.
> 
> RESULTS
> 
> The iscsi initiator code can handle ENABLE_CLUSTERING just fine, but
> the iscsi target code fails. It seems to assume that IOs do *NOT*
> cross a page boundary.
> 
> The problem is in iscsi lib/iov_iter.c, in the functions
> copy_page_to_iter() and page_copy_sane() (see below for how to
> reproduce):
> 
> >> static inline bool page_copy_sane(struct page *page, size_t offset, size_t n)
> >> {
> >>         struct page *head = compound_head(page);
> >>         size_t v = n + offset + page_address(page) - page_address(head);
> >> 
> >>         if (likely(n <= v && v <= (PAGE_SIZE << compound_order(head))))
> >>                 return true;
> >>         WARN_ON(1);
> >>         return false;
> >> }
> >> 
> >> size_t copy_page_to_iter(struct page *page, size_t offset, size_t bytes,
> >>                          struct iov_iter *i)
> >> {
> >>         if (unlikely(!page_copy_sane(page, offset, bytes)))
> >>                 return 0;
> >>         if (i->type & (ITER_BVEC|ITER_KVEC)) {
> >>                 void *kaddr = kmap_atomic(page);
> >>                 size_t wanted = copy_to_iter(kaddr + offset, bytes, i);
> >>                 kunmap_atomic(kaddr);
> >>                 return wanted;
> >>         } else if (unlikely(iov_iter_is_discard(i)))
> >>                 return bytes;
> >>         else if (likely(!iov_iter_is_pipe(i)))
> >>                 return copy_page_to_iter_iovec(page, offset, bytes, i);
> >>         else
> >>                 return copy_page_to_iter_pipe(page, offset, bytes, i);
> >> }
> 
> Causing the following WARN_ON stack trace (repeatedly):
> 
> >> ...
> >> [   78.644559] WARNING: CPU: 0 PID: 2192 at lib/iov_iter.c:830 copy_page_to_iter+0x1a6/0x2e0
> >> [   78.644561] Modules linked in: iscsi_tcp(E) libiscsi_tcp(E) libiscsi(E) scsi_transport_iscsi(E) rfcomm(E) iscsi_target_mod(E) target_core_pscsi(E) target_core_file(E) target_core_iblock(E) target_core_user(E) uio(E) target_core_mod(E) configfs(E) af_packet(E) iscsi_ibft(E) iscsi_boot_sysfs(E) vmw_vsock_vmci_transport(E) vsock(E) bnep(E) fuse(E) crct10dif_pclmul(E) crc32_pclmul(E) ghash_clmulni_intel(E) xfs(E) aesni_intel(E) snd_ens1371(E) aes_x86_64(E) snd_ac97_codec(E) crypto_simd(E) cryptd(E) ac97_bus(E) glue_helper(E) snd_rawmidi(E) vmw_balloon(E) snd_seq_device(E) snd_pcm(E) pcspkr(E) snd_timer(E) snd(E) uvcvideo(E) btusb(E) videobuf2_vmalloc(E) btrtl(E) videobuf2_memops(E) videobuf2_v4l2(E) btbcm(E) btintel(E) videodev(E) bluetooth(E) videobuf2_common(E) vmw_vmci(E) ecdh_generic(E) rfkill(E) soundcore(E) mptctl(E) gameport(E) joydev(E) i2c_piix4(E) e1000(E) ac(E) button(E) btrfs(E) libcrc32c(E) xor(E) raid6_pq(E) hid_generic(E) usbhid(E) sr_mod(E) cdrom(E) ata_generic(E)
> >> [   78.644583]  crc32c_intel(E) serio_raw(E) mptspi(E) scsi_transport_spi(E) mptscsih(E) ata_piix(E) uhci_hcd(E) ehci_pci(E) ehci_hcd(E) vmwgfx(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) usbcore(E) ttm(E) mptbase(E) drm(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E)
> >> [   78.644593] CPU: 0 PID: 2192 Comm: iscsi_trx Tainted: G            E     4.20.0-rc4-1-default+ #1 openSUSE Tumbleweed (unreleased)
> >> [   78.644593] Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
> >> [   78.644595] RIP: 0010:copy_page_to_iter+0x1a6/0x2e0
> >> [   78.644596] Code: 0c 24 48 98 49 89 ce 48 89 c2 49 29 c6 48 29 ca 4d 01 f4 48 01 d5 48 85 c0 0f 85 71 ff ff ff 48 85 ed 0f 84 68 ff ff ff eb b2 <0f> 0b 45 31 ed eb 8d bf 01 00 00 00 e8 d9 1e c5 ff 65 4c 8b 34 25
> >> [   78.644596] RSP: 0018:ffffa04b41eefbe0 EFLAGS: 00010206
> >> [   78.644597] RAX: fffff7acc40de180 RBX: ffffa04b41eefd80 RCX: 002ffff80000a014
> >> [   78.644598] RDX: 0000000000002000 RSI: 0000000000001000 RDI: fffff7acc0000000
> >> [   78.644598] RBP: fffff7acc40de180 R08: ffff8f1703786000 R09: 0000000000002000
> >> [   78.644599] R10: 00000000000002c0 R11: ffff8f16b3f31400 R12: 0000000000000000
> >> [   78.644600] R13: 0000000000002000 R14: 0000000000000008 R15: 0000000000003800
> >> [   78.644601] FS:  0000000000000000(0000) GS:ffff8f1739c00000(0000) knlGS:0000000000000000
> >> [   78.644601] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [   78.644602] CR2: 00007f0f54772000 CR3: 000000012e670004 CR4: 00000000003606f0
> >> [   78.644624] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >> [   78.644625] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> >> [   78.644625] Call Trace:
> >> [   78.644631]  skb_copy_datagram_iter+0x16f/0x270
> >> [   78.644633]  tcp_recvmsg+0x223/0xc30
> >> [   78.644637]  inet_recvmsg+0x4b/0xe0
> >> [   78.644644]  iscsit_do_rx_data.constprop.9+0x89/0x110 [iscsi_target_mod]
> >> [   78.644650]  rx_data+0x58/0x70 [iscsi_target_mod]
> >> [   78.644654]  iscsit_get_rx_pdu+0xa7b/0xd20 [iscsi_target_mod]
> >> [   78.644657]  ? preempt_count_sub+0x43/0x50
> >> [   78.644659]  ? _raw_spin_unlock_irq+0x22/0x40
> >> [   78.644663]  ? iscsi_target_tx_thread+0x1d0/0x1d0 [iscsi_target_mod]
> >> [   78.644667]  ? iscsi_target_rx_thread+0x71/0xd0 [iscsi_target_mod]
> >> [   78.644670]  iscsi_target_rx_thread+0x71/0xd0 [iscsi_target_mod]
> >> [   78.644672]  kthread+0x116/0x130
> >> [   78.644673]  ? kthread_create_worker_on_cpu+0x40/0x40
> >> [   78.644675]  ret_from_fork+0x24/0x50
> >> [   78.644678] ---[ end trace a0d6d5ab0e8625ee ]---
> >> [   78.644725]  connection1:0: detected conn error (1020)
> >> ...
> >> [  108.859031]  connection1:0: detected conn error (1020)
> >> [  108.859104] sd 3:0:0:0: [sdc] tag#0 FAILED Result: hostbyte=DID_TRANSPORT_DISRUPTED driverbyte=DRIVER_OK
> >> [  108.859106] sd 3:0:0:0: [sdc] tag#0 CDB: Write(10) 2a 00 00 00 11 a2 00 00 50 00
> >> [  108.859107] print_req_error: I/O error, dev sdc, sector 4514
> >> ...
> 
> 
> TO REPRODUCE:
> 
> I used openSUSE Tumbleweed using a 4.20 kernel, but any recent kernel
> should display this issue.
> 
> I used the same system for both the iSCSI initiator (using open-iscsi)
> and the iscsi target (using targetcli-fb). [I believe you _could_ use
> a different system for the initiator, but I did not test this.]
> 
> I set up a file-based iSCSI target of size 5G using the targetcli
> shell, with an ACL allowing the local iscsi initiator to connect. The
> backing store file's contents do not matter, but I initialized my file
> to all zeros.
> 
> I then connect from the same system using "iscsiadm -m discovery
> $HOST" to discover the new target, then "iscsiadm -m node -l" to login
> to the discovered target. [Any connection strategy should work,
> though.] This should create a new disc device. In my case, it was
> "/dev/sdc", since I already have two hard discs.
> 
> I then do writes to the new device using "dd". There must be enough
> writes, so I wrote 100 64k blocks of zeros:
> 
> > dd if=/dev/zero of=/dev/sdc bsdk count0
> 
> Observe "dmesg --follow" output from the kernel to see the errors and
> stack traces.
> --
> Lee Duncan
---end quoted text---

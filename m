From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Sat, 11 Aug 2018 09:36:55 +0000
Subject: BUG in slab_free after iSCSI login timeout
Message-Id: <20180811093655.42922d8e@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello,

I am getting the following BUG with a Windows 10 initiator and a
Debian sid LIO iSCSI target:

Aug 11 11:28:28 boke kernel: [  141.536023] iSCSI Login timeout on Network Portal [::]:3260
Aug 11 11:28:28 boke kernel: [  141.536164] iSCSI Login negotiation failed.
Aug 11 11:28:28 boke kernel: [  141.536247] ------------[ cut here ]------------
Aug 11 11:28:28 boke kernel: [  141.536250] kernel BUG at /build/linux-0buYvw/linux-4.17.8/mm/slub.c:296!
Aug 11 11:28:28 boke kernel: [  141.536362] invalid opcode: 0000 [#1] SMP PTI
Aug 11 11:28:28 boke kernel: [  141.536432] Modules linked in: target_core_user uio target_core_pscsi target_core_file target_core_iblock iscsi_target_mod target_core_mod configfs hid_generic usbhid uas usb_storage snd_hda_codec_hdmi spi_pxa2xx_platform evdev intel_rapl intel_soc_dts_thermal intel_soc_dts_iosf intel_powerclamp coretemp kvm_intel i915 kvm drm_kms_helper drm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel snd_hda_intel intel_cstate snd_hda_codec efi_pstore pcspkr efivars snd_hda_core snd_hwdep snd_pcm sg snd_timer iTCO_wdt iTCO_vendor_support snd ir_rc6_decoder soundcore spi_pxa2xx_pci shpchp rc_rc6_mce fintek_cir rc_core video pwm_lpss_platform pwm_lpss button gpio_keys_polled(O) input_polldev leds_gpio nfsd auth_rpcgss nfs_acl lockd grace sunrpc gpio_f7188x(O) qnap_tsx51(O) ledtrig_timer f71882fg efivarfs
Aug 11 11:28:28 boke kernel: [  141.537528]  ip_tables x_tables autofs4 ext4 crc16 mbcache jbd2 fscrypto ecb crypto_simd cryptd glue_helper aes_x86_64 dm_mod raid10 raid456 async_raid6_recov async_memcpy async_pq async_xor async_tx xor raid6_pq libcrc32c crc32c_generic raid0 multipath linear raid1 md_mod sd_mod crc32c_intel lpc_ich i2c_i801 igb i2c_algo_bit dca ahci libahci libata xhci_pci xhci_hcd i2c_designware_pci scsi_mod usbcore usb_common sdhci_pci cqhci sdhci mmc_core i2c_hid hid thermal fan
Aug 11 11:28:28 boke kernel: [  141.538191] CPU: 0 PID: 992 Comm: iscsi_np Tainted: G           O      4.17.0-1-amd64 #1 Debian 4.17.8-1
Aug 11 11:28:28 boke kernel: [  141.538333] Hardware name: To be filled by O.E.M. To be filled by O.E.M./Aptio CRB, BIOS 5.6.5 05/19/2014
Aug 11 11:28:28 boke kernel: [  141.538481] RIP: 0010:__slab_free+0x18a/0x300
Aug 11 11:28:28 boke kernel: [  141.538550] RSP: 0018:ffffb44380a57dd0 EFLAGS: 00010246
Aug 11 11:28:28 boke kernel: [  141.538633] RAX: ffff9c6f36dfbc00 RBX: ffff9c6f36dfbc00 RCX: 000000018010000e
Aug 11 11:28:28 boke kernel: [  141.538744] RDX: ffff9c6f36dfbc00 RSI: ffffe52004db7e80 RDI: ffff9c6f3b003080
Aug 11 11:28:28 boke kernel: [  141.538851] RBP: ffffb44380a57e70 R08: 0000000000000001 R09: ffffffffc0ca83c6
Aug 11 11:28:28 boke kernel: [  141.541763] R10: ffffe52004db7e80 R11: 00000000ffffffff R12: ffff9c6f3b003080
Aug 11 11:28:28 boke kernel: [  141.544714] R13: ffffe52004db7e80 R14: ffff9c6f36dfbc00 R15: 0000000000000000
Aug 11 11:28:28 boke kernel: [  141.547638] FS:  0000000000000000(0000) GS:ffff9c6f3fc00000(0000) knlGS:0000000000000000
Aug 11 11:28:28 boke kernel: [  141.550593] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Aug 11 11:28:28 boke kernel: [  141.553496] CR2: 00007f3331ff3300 CR3: 000000000aa0a000 CR4: 00000000001006f0
Aug 11 11:28:28 boke kernel: [  141.556422] Call Trace:
Aug 11 11:28:28 boke kernel: [  141.559290]  ? vprintk_emit+0x3e4/0x450
Aug 11 11:28:28 boke kernel: [  141.562112]  ? __slab_free+0x15a/0x300
Aug 11 11:28:28 boke kernel: [  141.564861]  ? printk+0x52/0x6e
Aug 11 11:28:28 boke kernel: [  141.567531]  ? iscsi_target_login_sess_out+0x1e6/0x240 [iscsi_target_mod]
Aug 11 11:28:28 boke kernel: [  141.570233]  iscsi_target_login_sess_out+0x1e6/0x240 [iscsi_target_mod]
Aug 11 11:28:28 boke kernel: [  141.572897]  iscsi_target_login_thread+0x432/0xff0 [iscsi_target_mod]
Aug 11 11:28:28 boke kernel: [  141.575488]  ? iscsi_target_login_sess_out+0x240/0x240 [iscsi_target_mod]
Aug 11 11:28:28 boke kernel: [  141.578027]  kthread+0x113/0x130
Aug 11 11:28:28 boke kernel: [  141.580483]  ? kthread_create_worker_on_cpu+0x70/0x70
Aug 11 11:28:28 boke kernel: [  141.582904]  ret_from_fork+0x35/0x40
Aug 11 11:28:28 boke kernel: [  141.585239] Code: fe ff ff 44 0f b6 bd 7f ff ff ff 80 7d ab 00 79 05 45 84 ff 74 7b 48 83 c4 78 5b 41 5c 41 5d 41 5e 41 5f 5d 49 8d 65 f0 41 5d c3 <0f> 0b 4c 89 d0 4c 89 55 88 45 89 fa 48 85 c0 44 0f b6 bd 7f ff
Aug 11 11:28:28 boke kernel: [  141.592324] RIP: __slab_free+0x18a/0x300 RSP: ffffb44380a57dd0
Aug 11 11:28:28 boke kernel: [  141.594641] ---[ end trace 6ee2f89117f24b05 ]---

I had this issue several times, but the way to reproduce is not clear
to me yet. It seems it fails especially when initiator is up before
server, but it is not strictly required either.

What can I try to help debug this further ?

Side notes:
Of the 3 out-of-tree modules, 2 are actually from-tree (but not build
in default debian sid kernels): gpio_keys_polled gpio_f7188x, and one is
actually out-of-tree (qnap_tsx51), although it should be trivially
valid (static data structure describing a few gpios, with attached leds
and buttons, as firmware does not describe these):
  https://github.com/vpelletier/linux/blob/4fc287fee9846bbfbb356ea161578342f5672a12/drivers/platform/x86/qnap-tsx51.c

Regards,
-- 
Vincent Pelletier

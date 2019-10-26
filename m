From: Thomas <wolverine6218@gmail.com>
Date: Sat, 26 Oct 2019 02:03:43 +0000
Subject: Possible LIO crash under heavy ESXi 6.7U3 load with iSCSI
Message-Id: <CAHTmSeTfOjVDMMtG6mVPKJyRWeMgvnCowq5Uyze=vMzPiQ4S5Q@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi All,

First post so thank you for welcoming me to the LIO community.

My test environment consists of an Ubuntu 19.04 system 100Gb Mellanox
NICs and with 8 SSDs using ZoL 0.8.2. For LIO, I've included all of
the fixes from linux-stable 5.0.x, plus selected patches from 5.2.x
(on top of what Ubuntu 19.04 ships).

The specific patches from 5.2.x are:

    scsi: target/iblock: Fix overrun in WRITE SAME emulation
        5676234f20fef02f6ca9bd66c63a8860fce62645

    scsi: target/iscsi: Make sure PDU processing continues if parsing
a command fails
        4b3766ec0e1840f45bc9238e7e749922bdcb7016

    scsi: target/iscsi: Detect conn_cmd_list corruption early
        b0055acaedf56a2717a6e2a4b700f1959a1b60df

    scsi: target/core: Fix a race condition in the LUN lookup code
        63f7479439c95bcd49b7dd4af809862c316c71a3

    scsi: target: alua: fix the tg_pt_gps_count
        82129697df9d90afd22736acd89d24f98bde2522

I create an iSCSI target using a ZVOL and provide access to 8 ESXi
nodes (6.7 U3) using iSCSI over 100GbE. Each ESXi host has 1 VM on it
(Ubuntu 19.04, installed on local SSD storage on the host, not iSCSI).
Each VM also has a dedicated 1000 GB VMDK stored on the LIO iSCSI
target. A number of VMware specific optimizations are configured in
VMware, including:

- Configure all storage device multipathing as Round Robin
- For iSCSI Initiator, change LoginTimeout (in Advanced Settings) from
5 to 30 (seconds)
- Disable OnRetryErrors
- Disallows systems to delay acknowledgment of received data packets.
- Increase the iSCSI/MaxIOSize from 128 KB to 512 KB
- Decrease Disk/DiskMaxIOSize from 32767 to 4096 in order to avoid
Windows EFI boot issues

On each VM, I kick off fio to run a sequence of 4K and 16K random
writes with fairly high thread count. After about an hour, LIO will
crash (from what I can tell). Snippet is below. Can you please share
your thoughts on this issue? Thank you so much in advance!

2019-10-24-10:09:41 hwub1904 kernel: [ 6852.321773] ABORT_TASK: Found
referenced iSCSI task_tag: 4314390
2019-10-24-10:09:41 hwub1904 kernel: [ 6852.321776] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4314390
2019-10-24-10:09:42 hwub1904 kernel: [ 6853.319473] ABORT_TASK: Found
referenced iSCSI task_tag: 4314414
2019-10-24-10:09:45 hwub1904 kernel: [ 6856.243200] ABORT_TASK: Found
referenced iSCSI task_tag: 4273070
2019-10-24-10:09:45 hwub1904 kernel: [ 6856.299526] ABORT_TASK:
Sending TMR_FUNCTION_COMPLETE for ref_tag: 4273070
2019-10-24-10:09:45 hwub1904 kernel: [ 6856.304012] ABORT_TASK: Found
referenced iSCSI task_tag: 4273071
2019-10-24-10:09:46 hwub1904 kernel: [ 6856.901479] ABORT_TASK:
Sending TMR_FUNCTION_COMPLETE for ref_tag: 4273071
2019-10-24-10:09:46 hwub1904 kernel: [ 6856.901609] ABORT_TASK: Found
referenced iSCSI task_tag: 4273072
2019-10-24-10:09:46 hwub1904 kernel: [ 6857.399495] ABORT_TASK:
Sending TMR_FUNCTION_COMPLETE for ref_tag: 4273072
2019-10-24-10:09:46 hwub1904 kernel: [ 6857.399625] ABORT_TASK: Found
referenced iSCSI task_tag: 4273073
2019-10-24-10:09:46 hwub1904 kernel: [ 6857.699773] ABORT_TASK:
Sending TMR_FUNCTION_COMPLETE for ref_tag: 4273073
2019-10-24-10:09:46 hwub1904 kernel: [ 6857.699902] ABORT_TASK: Found
referenced iSCSI task_tag: 4273074
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.197744] ABORT_TASK: Found
referenced iSCSI task_tag: 4386793
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.302888] ABORT_TASK: Found
referenced iSCSI task_tag: 4544843
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.305024] ABORT_TASK:
Sending TMR_FUNCTION_COMPLETE for ref_tag: 4386793
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.305365] ABORT_TASK: Found
referenced iSCSI task_tag: 4386926
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.305367] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4386926
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.307177] ABORT_TASK: Found
referenced iSCSI task_tag: 4320448
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.307179] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4320448
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.307934] ABORT_TASK: Found
referenced iSCSI task_tag: 4320449
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.307936] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4320449
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.308008] ABORT_TASK: Found
referenced iSCSI task_tag: 4320450
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.308009] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4320450
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.308061] ABORT_TASK: Found
referenced iSCSI task_tag: 4320451
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.308061] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4320451
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.308119] ABORT_TASK: Found
referenced iSCSI task_tag: 4320452
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.308120] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4320452
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.308194] ABORT_TASK: Found
referenced iSCSI task_tag: 4320453
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.313034] BUG: unable to
handle kernel NULL pointer dereference at 0000000000000008
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.320990] #PF error: [normal
kernel read fault]
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.322038] ABORT_TASK: Found
referenced iSCSI task_tag: 4386794
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.325767] PGD 0 P4D 0
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.331883] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4386794
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.334441] Oops: 0000 [#1] SMP PTI
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.334444] CPU: 5 PID: 5641
Comm: target_completi Tainted: P           O      5.0.0-25-7-nd
#21-ND.30
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.353164] ABORT_TASK: Found
referenced iSCSI task_tag: 4386795
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.354591] Hardware name: HW2221
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.360722] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4386795
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.368471] Workqueue:
   (null) (target_completion)
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.375828] ABORT_TASK: Found
referenced iSCSI task_tag: 4386796
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.381375] RIP:
0010:process_one_work+0x2e/0x410
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.381377] Code: 00 55 48 89
e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 48 8b 06 48 8b 5f 40 49 89
c4 45 30 e4 a8 04 b8 00 00 00 00 4c 0f 44 e0 <49> 8b 44 24 08 44 8b a8
00 01 00 00 41 83 e5 20 44 89 6d d4 f6 43
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.387544] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4386796
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.392247] RSP:
0018:ffffb4d28f89be70 EFLAGS: 00010046
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.392249] RAX:
0000000000000000 RBX: ffff89c140b62700 RCX: ffffd4a280752560
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.392250] RDX:
ffffd4a280752560 RSI: ffff89c140b62718 RDI: ffff89f1389835c0
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.392251] RBP:
ffffb4d28f89bea0 R08: ffff89f08c379e00 R09: ffff89c131195a98
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.392253] R10:
0000000000000069 R11: 0000000000000001 R12: 0000000000000000
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.422652] ABORT_TASK: Found
referenced iSCSI task_tag: 4386797
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.423742] R13:
ffff89c140b62720 R14: ffffd4a280752580 R15: ffff89f1389835e8
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.430996] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4386797
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.438238] FS:
0000000000000000(0000) GS:ffff89c140b40000(0000)
knlGS:0000000000000000
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.438239] CS:  0010 DS: 0000
ES: 0000 CR0: 0000000080050033
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.438240] CR2:
00000000000000b0 CR3: 0000002ec533a003 CR4: 00000000007606e0
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.445663] ABORT_TASK: Found
referenced iSCSI task_tag: 4386798
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.452722] DR0:
0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.458927] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4386798
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.466058] DR3:
0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.466059] PKRU: 55555554
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.466059] Call Trace:
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.466067]  rescuer_thread+0x2d5/0x3a0
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.473372] ABORT_TASK: Found
referenced iSCSI task_tag: 4386799
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.481428]  kthread+0x120/0x140
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.487361] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4386799
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.494493]  ? worker_thread+0x400/0x400
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.494495]  ?
__kthread_parkme+0x70/0x70
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.501017] ABORT_TASK: Found
referenced iSCSI task_tag: 4386800
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.507835]  ret_from_fork+0x35/0x40
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.512970] ABORT_TASK:
Sending TMR_FUNCTION_COMPLETE for ref_tag: 4314414
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.513096] ABORT_TASK: Found
referenced iSCSI task_tag: 4314415
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.514997] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4386800
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.522235] Modules linked in:
nvmet(O) target_core_user target_core_pscsi target_core_file
target_core_iblock iscsi_target_mod mst_pciconf(O) tcm_qla2xxx
target_core_mod ntb_netdev ntb_transport rdma_ucm(O) ib_ucm(O)
ib_ipoib(O) ib_umad(O) mlx4_en(O) mlx4_ib(O) mlx4_core(O) eraraid(O)
nls_iso8859_1 sch_fq_codel ib_iser(O) intel_rapl rdma_cm(O) iw_cm(O)
skx_edac nfit ib_cm(O) iscsi_tcp libiscsi_tcp x86_pkg_temp_thermal
libiscsi intel_powerclamp scsi_transport_iscsi coretemp kvm_intel kvm
irqbypass ipmi_ssif crct10dif_pclmul crc32_pclmul ghash_clmulni_intel
aesni_intel aes_x86_64 crypto_simd cryptd glue_helper intel_cstate
intel_rapl_perf zfs(PO) zunicode(PO) zavl(PO) zlua(PO) icp(PO) joydev
input_leds mei_me mei ioatdma dca wmi ipmi_si ipmi_devintf
ipmi_msghandler acpi_power_meter acpi_pad zcommon(PO) znvpair(PO)
spl(O) qat_api(O) intel_qat(O) uio authenc bcache crc64 bonding 8021q
garp mrp stp llc xfs nfsd auth_rpcgss nfs_acl lockd grace sunrpc
ip_tables x_tables autofs4 btrfs
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.522295]  zstd_compress
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.525366] ABORT_TASK: Found
referenced iSCSI task_tag: 4386801
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.527476]  raid10 raid456
async_raid6_recov async_memcpy async_pq async_xor async_tx xor
raid6_pq libcrc32c raid1 raid0 multipath linear mlx5_ib(O) hid_generic
usbhid hid ib_uverbs(O) ib_core(O) ntb_hw_switchtec(O) ntb qla2xxx
mlx5_core(O) pci_stub nvme_fc(O) devlink nvme_fabrics(O)
scsi_transport_fc cls(O) nvme(O) i40e nvme_core(O) ahci i2c_i801
lpc_ich mlx_compat(O) libahci [last unloaded: mst_pci]
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.534787] ABORT_TASK:
Sending TMR_TASK_DOES_NOT_EXIST for ref_tag: 4386801
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.544082] CR2: 0000000000000008
2019-10-24-10:09:48 hwub1904 kernel: [ 6859.544084] ---[ end trace
3bad5cf525ebcd7c ]---


Thank you for your comments.

From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Date: Mon, 06 Jan 2020 18:23:42 +0000
Subject: Recent trace observed in target code during iSer testing
Message-Id: <MWHPR1101MB2271A83D246FAE4710E47BB2863C0@MWHPR1101MB2271.namprd11.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>
Cc: "bvanassche@acm.org" <bvanassche@acm.org>

Seeing the following trace in some target testing for IB ulps:

[28630.870878] ------------[ cut here ]------------
[28630.876936] percpu_ref_kill_and_confirm called more than once on target_release_sess_cmd_refcnt [target_core_mod]!
[28630.876962] WARNING: CPU: 1 PID: 65172 at lib/percpu-refcount.c:346 percpu_ref_kill_and_confirm+0x7e/0xa0
[28630.900627] Modules linked in: target_core_user uio tcm_fc libfc scsi_transport_fc tcm_loop target_core_pscsi target_core_iblock target_core_file tcp_diag udp_diag inet_diag rfkill ib_isert iscsi_target_mod dm_mirror dm_region_hash target_core_mod dm_log dm_mod rpcrdma sunrpc rdma_ucm ib_iser opa_vnic rdma_cm ib_umad iw_cm ib_ipoib libiscsi ib_cm scsi_transport_iscsi intel_rapl_msr intel_rapl_common sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp hfi1 kvm rdmavt iTCO_wdt irqbypass iTCO_vendor_support crct10dif_pclmul ib_uverbs mxm_wmi crc32_pclmul ghash_clmulni_intel ib_core aesni_intel crypto_simd ipmi_si cryptd mei_me glue_helper ipmi_devintf pcspkr joydev i2c_i801 ipmi_msghandler sg mei wmi lpc_ich ioatdma acpi_power_meter acpi_pad ip_tables ext4 mbcache jbd2 sr_mod cdrom sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm_vram_helper drm_ttm_helper ttm drm igb ahci crc32c_intel libahci ptp libata pps_core dca i2c_algo_bit
[28631.002240] CPU: 1 PID: 65172 Comm: iscsi_ttx Kdump: loaded Not tainted 5.5.0-rc2+ #1
[28631.011900] Hardware name: Intel Corporation S2600CWR/S2600CW, BIOS SE5C610.86B.01.01.0014.121820151719 12/18/2015
[28631.024409] RIP: 0010:percpu_ref_kill_and_confirm+0x7e/0xa0
[28631.031580] Code: 00 80 3d 0b 3b 1b 01 00 75 c4 48 8b 53 10 48 c7 c6 80 a8 6a 85 48 c7 c7 e0 5d 93 85 31 c0 c6 05 ee 3a 1b 01 01 e8 72 68 c7 ff <0f> 0b 48 8b 53 08 eb 9c f0 48 83 2b 01 74 02 eb b3 48 8b 43 10 48
[28631.054539] RSP: 0018:ffffb590c7f17df0 EFLAGS: 00010086
[28631.061385] RAX: 0000000000000000 RBX: ffff9a83915d9830 RCX: 0000000000000000
[28631.070377] RDX: 0000000000000066 RSI: ffffffff8646ec06 RDI: 0000000000000046
[28631.079367] RBP: 0000000000000246 R08: ffffffff8646eba0 R09: ffff17c7871af6ce
[28631.088355] R10: 000000000000fe94 R11: 0000000000000375 R12: 0000000000000000
[28631.097348] R13: ffff9a7bc3f2c100 R14: ffffb590c7f17e38 R15: ffffb590c7f17c58
[28631.106344] FS:  0000000000000000(0000) GS:ffff9a7b9f440000(0000) knlGS:0000000000000000
[28631.116424] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[28631.123880] CR2: 00007fedd7c63080 CR3: 0000000912e0a001 CR4: 00000000001606e0
[28631.132902] Call Trace:
[28631.136683]  iscsit_close_connection+0x275/0x8e0 [iscsi_target_mod]
[28631.144727]  ? __schedule+0x2d2/0x6e0
[28631.149870]  iscsit_take_action_for_connection_exit+0xf4/0x100 [iscsi_target_mod]
[28631.159310]  iscsi_target_tx_thread+0x15f/0x1f0 [iscsi_target_mod]
[28631.167306]  ? remove_wait_queue+0x60/0x60
[28631.172953]  kthread+0xf8/0x130
[28631.177544]  ? iscsit_thread_get_cpumask+0xa0/0xa0 [iscsi_target_mod]
[28631.185841]  ? kthread_bind+0x10/0x10
[28631.191041]  ret_from_fork+0x35/0x40
[28631.196122] ---[ end trace 61d20478f457d4ab ]---

It appears that a call has been added to target_sess_cmd_list_set_waiting() in:

e9d3009b936 ("scsi: target: iscsi: Wait for all commands to finish before freeing a session")

Perhaps the kill has already been called?

Mike

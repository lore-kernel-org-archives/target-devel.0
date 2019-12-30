From: Rahul Kundu <rahul.kundu@chelsio.com>
Date: Mon, 30 Dec 2019 07:21:34 +0000
Subject: Trace seen on target during iSER login
Message-Id: <BYAPR12MB3080466CC0D6B968D3525F5BEF270@BYAPR12MB3080.namprd12.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "bvanassche@acm.org" <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc: Potnuri Bharat Teja <bharat@chelsio.com>, Nirranjan Kirubaharan <nirranjan@chelsio.com>

Hi,

I am trying to setup and run iSER with tot linux kernel installed(5.5.0-rc3) on both target and initiator.
Followed below steps:
        1. Created 1 targets having ramdisk LUN of 1GB size.
        2. Did discovery and login from the Initiator

Observed that everything worked fine at initiator and successfully logins.
But, after login, below warning was seen at Target:

target dmesg
-------------------
[  237.850090] Rounding down aligned max_sectors from 4294967295 to 4294967288 
[  244.517357] iwpm_register_pid_cb: Down level iwpmd/pid 3060.  Continuing...
[  324.876992] ------------[ cut here ]------------ 
[  324.877024] percpu_ref_kill_and_confirm called more than once on target_release_sess_cmd_refcnt [target_core_mod]!
[  324.877047] WARNING: CPU: 0 PID: 3167 at lib/percpu-refcount.c:346 percpu_ref_kill_and_confirm+0x7e/0xa0
[  324.877048] Modules linked in: target_core_user uio target_core_pscsi target_core_file target_core_iblock rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm dm_mirror dm_region_hash ib_umad dm_log iw_cxgb4 ib_uverbs snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio intel_powerclamp snd_hda_intel rdma_cm coretemp snd_intel_dspcfg iw_cm snd_hda_codec ib_cm ib_core snd_hda_core kvm snd_hwdep snd_seq libcxgb snd_seq_device snd_pcm irqbypass ipmi_si iTCO_wdt snd_timer iTCO_vendor_support gpio_ich ipmi_devintf pcspkr snd ipmi_msghandler sg ioatdma soundcore i2c_i801 lpc_ich i7core_edac acpi_cpufreq nfsd auth_rpcgss nfs_acl lockd grace sunrpc dm_multipath dm_mod ip_tables ext4 mbcache jbd2 sr_mod cdrom sd_mod mgag200 drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops drm_vram_helper drm_ttm_helper ttm drm ata_generic pata_acpi cxgb4 igb ata_piix pata_jmicron firewire_ohci libata 
[  324.877096]  firewire_core dca crc32c_intel serio_raw i2c_algo_bit i2c_core ptp crc_itu_t pps_core 
[  324.877104] CPU: 0 PID: 3167 Comm: iscsi_ttx Kdump: loaded Not tainted 5.5.0-rc3+ #45
[  324.877106] Hardware name: Supermicro X8DAH/X8DAH, BIOS 2.1        12/30/2011
[  324.877109] RIP: 0010:percpu_ref_kill_and_confirm+0x7e/0xa0
[  324.877114] Code: 00 80 3d bc 04 1e 01 00 75 c4 48 8b 53 10 48 c7 c6 80 fb 0a a4 48 c7 c7 78 ae 33 a4 31 c0 c6 05 9f 04 1e 01 01 e8 72 47 ca ff <0f> 0b 48 8b 53 08 eb 9c f0 48 83 2b 01 74 02 eb b3 48 89 df ff 53 
[  324.877115] RSP: 0018:ffffa1780d14bdf0 EFLAGS: 00010086 
[  324.877116] RAX: 0000000000000000 RBX: ffff947e1eb17430 RCX: 0000000000000000 
[  324.877116] RDX: 0000000000000006 RSI: ffffffffa4e49c06 RDI: 0000000000000046 
[  324.877117] RBP: 0000000000000246 R08: ffffffffa4e49ba0 R09: ffffffeb3fcd255c 
[  324.877117] R10: 0000000000000c5f R11: 0000000000000373 R12: 0000000000000000 
[  324.877118] R13: ffff947e10d12100 R14: ffffa1780d14be38 R15: ffffa1780d14bc58 
[  324.877119] FS:  0000000000000000(0000) GS:ffff94661fa00000(0000) knlGS:0000000000000000 
[  324.877119] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 
[  324.877120] CR2: 00007fe88152e140 CR3: 0000002e8b00a003 CR4: 00000000000206f0 
[  324.877121] Call Trace:
[  324.877137]  iscsit_close_connection+0x272/0x8d0 [iscsi_target_mod]
[  324.877141]  ? __schedule+0x2d2/0x6c0
[  324.877146]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_target_mod]
[  324.877151]  iscsi_target_tx_thread+0x153/0x1f0 [iscsi_target_mod]
[  324.877155]  ? remove_wait_queue+0x60/0x60
[  324.877159]  kthread+0xf5/0x130
[  324.877164]  ? iscsit_thread_get_cpumask+0xa0/0xa0 [iscsi_target_mod]
[  324.877165]  ? kthread_bind+0x10/0x10
[  324.877168]  ret_from_fork+0x1f/0x30
[  324.877170] ---[ end trace bcc25f7aa321d702 ]---

The above error is seen from kernel 5.4.0-rc1 onwards.
Bisect points to the following commit:
----------------------------------------------------------------------------------------------------------------------------
e9d3009cb936bd0faf0719f68d98ad8afb1e613b is the first bad commit commit e9d3009cb936bd0faf0719f68d98ad8afb1e613b
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Wed Nov 13 14:05:08 2019 -0800
    scsi: target: iscsi: Wait for all commands to finish before freeing a session
----------------------------------------------------------------------------------------------------------------------------

iscsit_close_connection() already calls target_sess_cmd_list_set_waiting() and
target_wait_for_sess_cmds() functions through iscsit_wait_conn() function.

Below is the patch diff which removes redundant function calls added by the above commit, but I am not sure whether this is the ideal fix:
=================================================================================================================
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 7251a87bb576..503a76e9cc62 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4234,8 +4234,6 @@ int iscsit_close_connection(
         * must wait until they have completed.
         */
        iscsit_check_conn_usage_count(conn);
-       target_sess_cmd_list_set_waiting(sess->se_sess);
-       target_wait_for_sess_cmds(sess->se_sess);

        ahash_request_free(conn->conn_tx_hash);
        if (conn->conn_rx_hash) {

---
Please kindly let me know your thoughts on this subject. Any help appreciated.

Thanks,
Rahul Kundu

From: Maurizio Lombardi <mlombard@redhat.com>
Date: Tue, 27 Oct 2020 13:49:28 +0000
Subject: Re: [PATCH 2/2] target: iscsi: fix a race condition when aborting a task
Message-Id: <1852a8bd-3edc-5c49-fa51-9afe52f125a8@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-3-mlombard@redhat.com>
 <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
In-Reply-To: <20daa17d-08e7-a412-4d33-bcf75587eca6@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org

Hello Mike,

Dne 22. 10. 20 v 4:42 Mike Christie napsal(a):
> If we free the cmd from the abort path, then for your conn stop plus abort race case, could we do:
> 
> 1. thread1 runs iscsit_release_commands_from_conn and sets CMD_T_FABRIC_STOP.
> 2. thread2 runs iscsit_aborted_task and then does __iscsit_free_cmd. It then returns from the aborted_task callout and we finish target_handle_abort and do:
> 
> target_handle_abort -> transport_cmd_check_stop_to_fabric -> lio_check_stop_free -> target_put_sess_cmd
> 
> The cmd is now freed.
> 3. thread1 now finishes iscsit_release_commands_from_conn and runs iscsit_free_cmd while accessing a command we just released.
> 
> 

Thanks for the review!

There are definitely some problems with task aborts and commands' refcounting *
but this is a different bug than the one this patch is trying to solve (a race to list_del_init());
unless you are saying that abort tasks should never be executed when the connection 
is going down and we have to prevent such cases from happening at all.

* I did a test a few days ago: 
1) blocked the backstore device on the target
2) issued a write command on the initiator
3) waited for abort task and connection shutdown
4) switched the target backstore device to state "running"

I triggered the following warnings in target_handle_abort():

        } else {
                /*
                 * Allow the fabric driver to unmap any resources before
                 * releasing the descriptor via TFO->release_cmd().
                 */
                cmd->se_tfo->aborted_task(cmd);
                if (ack_kref)
                        WARN_ON_ONCE(target_put_sess_cmd(cmd) != 0); <-----------------------
                /*
                 * To do: establish a unit attention condition on the I_T
                 * nexus associated with cmd. See also the paragraph "Aborting
                 * commands" in SAM.
                 */
        }

        WARN_ON_ONCE(kref_read(&cmd->cmd_kref) = 0); <----------------------

        transport_lun_remove_cmd(cmd);

        transport_cmd_check_stop_to_fabric(cmd);
}

target_handle_abort() is executed against a command which has already been released.

[  240.883865] iSCSI/iqn.1994-05.com.redhat:9489e049fb5e: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  353.848593] ABORT_TASK: Found referenced iSCSI task_tag: 101
[  386.521582] iSCSI Login timeout on Network Portal 0.0.0.0:3260
[  396.537133] WARNING: CPU: 1 PID: 2936 at drivers/target/target_core_transport.c:805 target_handle_abort+0xce/0x180 [target_core_mod]
[  396.537139] Modules linked in: iscsi_target_mod target_core_user uio target_core_pscsi target_core_file target_core_iblock target_core_mod uinput nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc bochs_drm drm_vram_helper drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ppdev drm joydev pcspkr i2c_piix4 parport_pc parport xfs libcrc32c sr_mod cdrom sd_mod sg ata_generic ata_piix libata virtio_net net_failover failover serio_raw fuse [last unloaded: ip_tables]
[  396.537302] CPU: 1 PID: 2936 Comm: kworker/1:2 Kdump: loaded Not tainted 4.18.0-240.7.el8.x86_64 #1
[  396.537306] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
[  396.537353] Workqueue: target_completion target_abort_work [target_core_mod]
[  396.537394] RIP: 0010:target_handle_abort+0xce/0x180 [target_core_mod]
[  396.537399] Code: 00 e8 e6 db 00 f1 41 81 e4 00 00 40 00 74 9d 48 8d bb 0c 01 00 00 f0 ff 8b 0c 01 00 00 0f 88 ed cd 00 00 75 87 e8 32 ed ff ff <0f> 0b e9 7b ff ff ff c6 03 40 0f 1f 44 00 00 0f 1f 44 00 00 48 8b
[  396.537402] RSP: 0018:ffffac1b818bbe80 EFLAGS: 00010286
[  396.537407] RAX: 0000312f0022d690 RBX: ffff9aec21595350 RCX: 0000000000000000
[  396.537410] RDX: 0000000000000000 RSI: 0000000000000282 RDI: 0000000000000282
[  396.537413] RBP: 0000000000000000 R08: ffff9aebf4d65a00 R09: ffff9aebf4c12d98
[  396.537416] R10: 0000000000000082 R11: 000000000000002e R12: 0000000000400000
[  396.537418] R13: 0000000000000000 R14: ffff9aec02cd9c00 R15: ffff9aec21595488
[  396.537423] FS:  0000000000000000(0000) GS:ffff9aec7fa80000(0000) knlGS:0000000000000000
[  396.537427] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  396.537430] CR2: 000055bfa25e9110 CR3: 00000000614c6000 CR4: 00000000000006e0
[  396.537444] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  396.537447] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  396.537449] Call Trace:
[  396.537504]  process_one_work+0x1a7/0x360
[  396.537525]  worker_thread+0x30/0x390
[  396.537532]  ? create_worker+0x1a0/0x1a0
[  396.537536]  kthread+0x112/0x130
[  396.537542]  ? kthread_flush_work_fn+0x10/0x10
[  396.537550]  ret_from_fork+0x35/0x40
[  396.537570] ---[ end trace d6b5bf9aea218e55 ]---
[  396.537734] WARNING: CPU: 1 PID: 2936 at drivers/target/target_core_transport.c:813 target_handle_abort+0x178/0x180 [target_core_mod]
[  396.537737] Modules linked in: iscsi_target_mod target_core_user uio target_core_pscsi target_core_file target_core_iblock target_core_mod uinput nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink sunrpc bochs_drm drm_vram_helper drm_ttm_helper ttm drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ppdev drm joydev pcspkr i2c_piix4 parport_pc parport xfs libcrc32c sr_mod cdrom sd_mod sg ata_generic ata_piix libata virtio_net net_failover failover serio_raw fuse [last unloaded: ip_tables]
[  396.537811] CPU: 1 PID: 2936 Comm: kworker/1:2 Kdump: loaded Tainted: G        W        --------- -  - 4.18.0-240.7.el8.x86_64 #1
[  396.537814] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-2.fc32 04/01/2014
[  396.537860] Workqueue: target_completion target_abort_work [target_core_mod]
[  396.537903] RIP: 0010:target_handle_abort+0x178/0x180 [target_core_mod]
[  396.537909] Code: 67 03 00 48 85 ed 74 1d 48 8b 45 00 48 8b 7d 08 48 83 c5 18 48 89 de e8 26 db 00 f1 48 8b 45 00 48 85 c0 75 e7 e9 6a ff ff ff <0f> 0b e9 df fe ff ff 90 0f 1f 44 00 00 55 48 8d af 08 01 00 00 53
[  396.537912] RSP: 0018:ffffac1b818bbe80 EFLAGS: 00010246
[  396.537916] RAX: 0000000000000000 RBX: ffff9aec21595350 RCX: 0000000000000000
[  396.537919] RDX: 0000000000000000 RSI: 0000000000000282 RDI: 0000000000000282
[  396.537922] RBP: 0000000000000000 R08: ffff9aebf4d65a00 R09: ffff9aebf4c12d98
[  396.537925] R10: 0000000000000082 R11: 000000000000002e R12: 0000000000400000
[  396.537928] R13: 0000000000000000 R14: ffff9aec02cd9c00 R15: ffff9aec21595488
[  396.537933] FS:  0000000000000000(0000) GS:ffff9aec7fa80000(0000) knlGS:0000000000000000
[  396.537936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  396.537939] CR2: 000055bfa25e9110 CR3: 00000000614c6000 CR4: 00000000000006e0
[  396.537951] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  396.537954] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  396.537956] Call Trace:
[  396.537971]  process_one_work+0x1a7/0x360
[  396.537979]  worker_thread+0x30/0x390
[  396.537985]  ? create_worker+0x1a0/0x1a0
[  396.537989]  kthread+0x112/0x130
[  396.537994]  ? kthread_flush_work_fn+0x10/0x10
[  396.538009]  ret_from_fork+0x35/0x40
[  396.538016] ---[ end trace d6b5bf9aea218e56 ]---
[  396.538221] ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: 101

Maurizio

From: Potnuri Bharat Teja <bharat@chelsio.com>
Date: Thu, 27 Feb 2020 14:12:51 +0000
Subject: Re: Connection errors with ISER IO
Message-Id: <20200227140045.GA2029@chelsio.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="6TrnltStXW4iwmi0"
List-Id: <target-devel.vger.kernel.org>
References: <20200226155241.GA28594@chelsio.com>
In-Reply-To: <20200226155241.GA28594@chelsio.com>
To: target-devel@vger.kernel.org


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wednesday, February 02/26/20, 2020 at 10:22:03 -0800, Sagi Grimberg wrote:
> 
> >Hi All,
> >I observe connection errors almost immediately after I start iozone over iser
> >luns. Atached are the connection error and hung task traces on initator and
> >target respecively.
> >Interestingly, I see connection errors only if LUN size is less than 512MB.
> >In my case I could consistently reproduce the issue with 511MB LUN and 300MB
> >lun size. Connections errors are not seen if I create 512MB or greated LUN.
> 
> Can you share log output on the target to before hung tasks?

Sure, Attached are the target and initiator dmesg logs.
> 
> >Further, after the connection errors, I noticed that the poll work queue is
> >stuck and never processes drain CQE resulting in hung tasks on the target side.
> 
> Is the drain CQE actually generated?
> 

Yes it is generated. I was able to track it with prints until queue_work() in
ib_cq_completion_workqueue(). Work Function ib_cq_poll_work() is never getting
scheduled. Therefore, I see drain CQE unpolled and hung task due to
__ib_drain_sq() waiting forever for complete() to be called from drain CQE
done() handler.

> >I tried changing the CQ poll workqueue to be UNBOUND but it did not fix the issue.
> >
> >Here is what my test does:
> >Create 8 targets with 511MB lun each, login and format disks to ext3, mount the
> >disks and run iozone over them.
> >#iozone -a -I -+d -g 256m
> 
> Does it happen specifically with iozone? or can dd/fio also
> reproduce this issue? on which I/O pattern do you see the issue?
>
I see it with iozone. I am trying with fio, shall soon update.
I see issue with at iosizes around 128k/256k block sizes of iozone. Its not 
consistent.
> >I am not sure how LUN size could cause the connection errors. I appreciate any
> >inputs on this.
> 
> I imagine that a single LUN is enough to reproduce the issue?
> 

yes, attached is the target conf.
> btw, I tried reproducing the issue with rxe (couldn't setup an iser
> listener with siw) in 2 VMs on my laptop using lio to a file backend but
> I cannot reproduce the issue..
I see the issue quickly with 40G/25G links. I have not seen the issue on a 100G 
link. BTW i a trying iwarp(T6/t5)

Thanks for looking into it.


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg_target.txt"


################################ instance 1 ####################################################################
[  565.017867] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  566.272672] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  567.604472] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  569.079390] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  570.495877] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  572.164414] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  573.781992] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  575.401893] Rounding down aligned max_sectors from 4294967295 to 4294967288
[  611.563586] iSCSI/iqn.1994-05.com.redhat:ac43382b2495: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  612.612316] iSCSI/iqn.1994-05.com.redhat:ac43382b2495: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  613.666468] iSCSI/iqn.1994-05.com.redhat:ac43382b2495: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  614.728169] iSCSI/iqn.1994-05.com.redhat:ac43382b2495: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  615.795149] iSCSI/iqn.1994-05.com.redhat:ac43382b2495: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  616.880035] iSCSI/iqn.1994-05.com.redhat:ac43382b2495: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  617.964017] iSCSI/iqn.1994-05.com.redhat:ac43382b2495: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  619.058387] iSCSI/iqn.1994-05.com.redhat:ac43382b2495: Unsupported SCSI Opcode 0xa3, sending CHECK_CONDITION.
[  810.389042] perf: interrupt took too long (2514 > 2500), lowering kernel.perf_event_max_sample_rate to 79000
[  918.231361] perf: interrupt took too long (3155 > 3142), lowering kernel.perf_event_max_sample_rate to 63000
[  978.745219] iSCSI Login timeout on Network Portal 10.0.2.2:3260
[ 1108.284624] INFO: task iscsi_np:10868 blocked for more than 122 seconds.
[ 1108.285623]       Not tainted 5.4.0+ #1
[ 1108.286358] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1108.287202] iscsi_np        D    0 10868      2 0x80004004
[ 1108.288091] Call Trace:
[ 1108.289004]  ? __schedule+0x2cd/0x8c0
[ 1108.289858]  schedule+0x40/0xc0
[ 1108.290746]  schedule_timeout+0x1e4/0x310
[ 1108.291630]  ? find_held_lock+0x38/0xa0
[ 1108.292392]  ? wait_for_completion+0x126/0x190
[ 1108.293121]  wait_for_completion+0x12e/0x190
[ 1108.293986]  ? wake_up_q+0x70/0x70
[ 1108.294884]  iscsi_check_for_session_reinstatement+0x1dd/0x270 [iscsi_target_mod]
[ 1108.295720]  iscsi_target_do_login+0xe8/0x5d0 [iscsi_target_mod]
[ 1108.296520]  iscsi_target_start_negotiation+0x51/0xa0 [iscsi_target_mod]
[ 1108.297285]  iscsi_target_login_thread+0x93d/0x1100 [iscsi_target_mod]
[ 1108.298114]  kthread+0x106/0x140
[ 1108.298974]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[ 1108.299825]  ? kthread_bind+0x10/0x10
[ 1108.300670]  ret_from_fork+0x3a/0x50
[ 1108.301385] INFO: task iscsi_trx:11133 blocked for more than 122 seconds.
[ 1108.302152]       Not tainted 5.4.0+ #1
[ 1108.302985] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1108.303832] iscsi_trx       D    0 11133      2 0x80004004
[ 1108.304687] Call Trace:
[ 1108.305413]  ? __schedule+0x2cd/0x8c0
[ 1108.306192]  schedule+0x40/0xc0
[ 1108.307022]  schedule_timeout+0x1e4/0x310
[ 1108.307857]  ? find_held_lock+0x38/0xa0
[ 1108.308611]  ? wait_for_completion+0x126/0x190
[ 1108.309321]  wait_for_completion+0x12e/0x190
[ 1108.310067]  ? wake_up_q+0x70/0x70
[ 1108.310892]  __ib_drain_sq+0x196/0x1d0 [ib_core]
[ 1108.311596]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[ 1108.312275]  ? wait_for_completion+0x49/0x190
[ 1108.312941]  ib_drain_qp+0xe/0x30 [ib_core]
[ 1108.313633]  isert_wait_conn+0x5e/0x330 [ib_isert]
[ 1108.314298]  ? __local_bh_enable_ip+0x80/0xf0
[ 1108.315040]  iscsit_close_connection+0x156/0x8f0 [iscsi_target_mod]
[ 1108.315827]  ? __local_bh_enable_ip+0x80/0xf0
[ 1108.316513]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_target_mod]
[ 1108.317191]  iscsi_target_rx_thread+0xdf/0xf0 [iscsi_target_mod]
[ 1108.317903]  kthread+0x106/0x140
[ 1108.318572]  ? iscsi_target_tx_thread+0x210/0x210 [iscsi_target_mod]
[ 1108.319209]  ? kthread_bind+0x10/0x10
[ 1108.319893]  ret_from_fork+0x3a/0x50
[ 1108.320658] 
Showing all locks held in the system:
[ 1108.321889] 1 lock held by khungtaskd/137:
[ 1108.322536]  #0: ffffffff91289ae0 (rcu_read_lock){....}, at: debug_show_all_locks+0xe/0x1a0
[ 1108.323187] 2 locks held by bash/1640:
[ 1108.323849]  #0: ffff9f538f2b30a0 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
[ 1108.324618]  #1: ffffb2a50cd532f0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xdb/0x940
[ 1108.325288] 1 lock held by dmesg/11123:
[ 1108.325984] 2 locks held by kworker/u53:5/11156:
[ 1108.326746]  #0: ffff9f3b95b39d48 ((wq_completion)ib-comp-unb-wq){+.+.}, at: process_one_work+0x18c/0x590
[ 1108.327432]  #1: ffffb2a50cd67e50 ((work_completion)(&cq->work)){+.+.}, at: process_one_work+0x18c/0x590

[ 1108.328962] =============================================
[ 1231.168185] INFO: task iscsi_np:10868 blocked for more than 245 seconds.
[ 1231.169019]       Not tainted 5.4.0+ #1
[ 1231.169937] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1231.170700] iscsi_np        D    0 10868      2 0x80004004
[ 1231.171584] Call Trace:
[ 1231.172475]  ? __schedule+0x2cd/0x8c0
[ 1231.173322]  schedule+0x40/0xc0
[ 1231.174204]  schedule_timeout+0x1e4/0x310
[ 1231.174946]  ? find_held_lock+0x38/0xa0
[ 1231.175761]  ? wait_for_completion+0x126/0x190
[ 1231.176631]  wait_for_completion+0x12e/0x190
[ 1231.177435]  ? wake_up_q+0x70/0x70
[ 1231.178190]  iscsi_check_for_session_reinstatement+0x1dd/0x270 [iscsi_target_mod]
[ 1231.178929]  iscsi_target_do_login+0xe8/0x5d0 [iscsi_target_mod]
[ 1231.179729]  iscsi_target_start_negotiation+0x51/0xa0 [iscsi_target_mod]
[ 1231.180564]  iscsi_target_login_thread+0x93d/0x1100 [iscsi_target_mod]
[ 1231.181383]  kthread+0x106/0x140
[ 1231.182238]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[ 1231.182963]  ? kthread_bind+0x10/0x10
[ 1231.183728]  ret_from_fork+0x3a/0x50
[ 1231.184539] INFO: task iscsi_trx:11133 blocked for more than 245 seconds.
[ 1231.185285]       Not tainted 5.4.0+ #1
[ 1231.185973] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1231.186675] iscsi_trx       D    0 11133      2 0x80004004
[ 1231.187464] Call Trace:
[ 1231.188260]  ? __schedule+0x2cd/0x8c0
[ 1231.188959]  schedule+0x40/0xc0
[ 1231.189750]  schedule_timeout+0x1e4/0x310
[ 1231.190468]  ? find_held_lock+0x38/0xa0
[ 1231.191248]  ? wait_for_completion+0x126/0x190
[ 1231.191923]  wait_for_completion+0x12e/0x190
[ 1231.192655]  ? wake_up_q+0x70/0x70
[ 1231.193425]  __ib_drain_sq+0x196/0x1d0 [ib_core]
[ 1231.194121]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[ 1231.194750]  ? wait_for_completion+0x49/0x190
[ 1231.195514]  ib_drain_qp+0xe/0x30 [ib_core]
[ 1231.196253]  isert_wait_conn+0x5e/0x330 [ib_isert]
[ 1231.196891]  ? __local_bh_enable_ip+0x80/0xf0
[ 1231.197628]  iscsit_close_connection+0x156/0x8f0 [iscsi_target_mod]
[ 1231.198282]  ? __local_bh_enable_ip+0x80/0xf0
[ 1231.198922]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_target_mod]
[ 1231.199653]  iscsi_target_rx_thread+0xdf/0xf0 [iscsi_target_mod]
[ 1231.200392]  kthread+0x106/0x140
[ 1231.200992]  ? iscsi_target_tx_thread+0x210/0x210 [iscsi_target_mod]
[ 1231.201696]  ? kthread_bind+0x10/0x10
[ 1231.202326]  ret_from_fork+0x3a/0x50
[ 1231.202937] 
Showing all locks held in the system:
[ 1231.204191] 1 lock held by khungtaskd/137:
[ 1231.204781]  #0: ffffffff91289ae0 (rcu_read_lock){....}, at: debug_show_all_locks+0xe/0x1a0
[ 1231.205479] 2 locks held by bash/1640:
[ 1231.206080]  #0: ffff9f538f2b30a0 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
[ 1231.206691]  #1: ffffb2a50cd532f0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xdb/0x940
[ 1231.207398] 2 locks held by bash/1705:
[ 1231.208013]  #0: ffff9f3b81afd0a0 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
[ 1231.208766]  #1: ffffb2a50d3432f0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xdb/0x940
[ 1231.209463] 2 locks held by kworker/u53:5/11156:
[ 1231.210125]  #0: ffff9f3b95b39d48 ((wq_completion)ib-comp-unb-wq){+.+.}, at: process_one_work+0x18c/0x590
[ 1231.210816]  #1: ffffb2a50cd67e50 ((work_completion)(&cq->work)){+.+.}, at: process_one_work+0x18c/0x590
[ 1231.211508] 1 lock held by updatedb/11300:
[ 1231.212291]  #0: ffff9f3a2b3f8cc8 (&type->i_mutex_dir_key#6){++++}, at: lookup_slow+0x27/0x50

[ 1231.213765] =============================================

[ 1354.051832] INFO: task iscsi_np:10868 blocked for more than 368 seconds.
[ 1354.052700]       Not tainted 5.4.0+ #1
[ 1354.053427] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1354.054176] iscsi_np        D    0 10868      2 0x80004004
[ 1354.054925] Call Trace:
[ 1354.055811]  ? __schedule+0x2cd/0x8c0
[ 1354.056544]  schedule+0x40/0xc0
[ 1354.057393]  schedule_timeout+0x1e4/0x310
[ 1354.058140]  ? find_held_lock+0x38/0xa0
[ 1354.058867]  ? wait_for_completion+0x126/0x190
[ 1354.059589]  wait_for_completion+0x12e/0x190
[ 1354.060406]  ? wake_up_q+0x70/0x70
[ 1354.061237]  iscsi_check_for_session_reinstatement+0x1dd/0x270 [iscsi_target_mod]
[ 1354.061977]  iscsi_target_do_login+0xe8/0x5d0 [iscsi_target_mod]
[ 1354.062712]  iscsi_target_start_negotiation+0x51/0xa0 [iscsi_target_mod]
[ 1354.063424]  iscsi_target_login_thread+0x93d/0x1100 [iscsi_target_mod]
[ 1354.064244]  kthread+0x106/0x140
[ 1354.065071]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[ 1354.065786]  ? kthread_bind+0x10/0x10
[ 1354.066481]  ret_from_fork+0x3a/0x50
[ 1354.067184] INFO: task iscsi_trx:11133 blocked for more than 368 seconds.
[ 1354.068010]       Not tainted 5.4.0+ #1
[ 1354.068834] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1354.069558] iscsi_trx       D    0 11133      2 0x80004004
[ 1354.070267] Call Trace:
[ 1354.070956]  ? __schedule+0x2cd/0x8c0
[ 1354.071621]  schedule+0x40/0xc0
[ 1354.072375]  schedule_timeout+0x1e4/0x310
[ 1354.073130]  ? find_held_lock+0x38/0xa0
[ 1354.073802]  ? wait_for_completion+0x126/0x190
[ 1354.074463]  wait_for_completion+0x12e/0x190
[ 1354.075115]  ? wake_up_q+0x70/0x70
[ 1354.075892]  __ib_drain_sq+0x196/0x1d0 [ib_core]
[ 1354.076545]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[ 1354.077288]  ? wait_for_completion+0x49/0x190
[ 1354.077951]  ib_drain_qp+0xe/0x30 [ib_core]
[ 1354.078568]  isert_wait_conn+0x5e/0x330 [ib_isert]
[ 1354.079195]  ? __local_bh_enable_ip+0x80/0xf0
[ 1354.079948]  iscsit_close_connection+0x156/0x8f0 [iscsi_target_mod]
[ 1354.080555]  ? __local_bh_enable_ip+0x80/0xf0
[ 1354.081280]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_target_mod]
[ 1354.081922]  iscsi_target_rx_thread+0xdf/0xf0 [iscsi_target_mod]
[ 1354.082544]  kthread+0x106/0x140
[ 1354.083162]  ? iscsi_target_tx_thread+0x210/0x210 [iscsi_target_mod]
[ 1354.083907]  ? kthread_bind+0x10/0x10
[ 1354.084526]  ret_from_fork+0x3a/0x50
[ 1354.085248] 
Showing all locks held in the system:
[ 1354.086393] 1 lock held by khungtaskd/137:
[ 1354.086995]  #0: ffffffff91289ae0 (rcu_read_lock){....}, at: debug_show_all_locks+0xe/0x1a0
[ 1354.087609] 2 locks held by bash/1640:
[ 1354.088287]  #0: ffff9f538f2b30a0 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
[ 1354.089034]  #1: ffffb2a50cd532f0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xdb/0x940
[ 1354.089689] 2 locks held by bash/1705:
[ 1354.090302]  #0: ffff9f3b81afd0a0 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
[ 1354.090950]  #1: ffffb2a50d3432f0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xdb/0x940
[ 1354.091606] 2 locks held by kworker/u53:5/11156:
[ 1354.092345]  #0: ffff9f3b95b39d48 ((wq_completion)ib-comp-unb-wq){+.+.}, at: process_one_work+0x18c/0x590
[ 1354.093148]  #1: ffffb2a50cd67e50 ((work_completion)(&cq->work)){+.+.}, at: process_one_work+0x18c/0x590

[ 1354.094523] =============================================









###################################### instance 2 ############################################################
[166230.450405] iSCSI Login timeout on Network Portal 10.0.2.2:3260


[166380.978409] INFO: task iscsi_np:11196 blocked for more than 122 seconds.
[166380.979855]       Not tainted 5.4.0 #21
[166380.980927] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[166380.982365] iscsi_np        D    0 11196      2 0x80004084
[166380.983525] Call Trace:
[166380.984770]  ? __schedule+0x39b/0x970
[166380.986038]  schedule+0x40/0xc0
[166380.987049]  schedule_timeout+0x1e4/0x310
[166380.988299]  ? find_held_lock+0x38/0xa0
[166380.989411]  ? sched_clock+0x5/0x10
[166380.990435]  ? sched_clock_cpu+0xc/0xa0
[166380.991564]  wait_for_completion+0x12e/0x190
[166380.992543]  ? wake_up_q+0x70/0x70
[166380.993704]  iscsi_check_for_session_reinstatement+0x1dd/0x270 [iscsi_target_mod]
[166380.994650]  iscsi_target_do_login+0xe8/0x5d0 [iscsi_target_mod]
[166380.995779]  iscsi_target_start_negotiation+0x51/0xa0 [iscsi_target_mod]
[166380.996729]  iscsi_target_login_thread+0x93d/0x1100 [iscsi_target_mod]
[166380.997883]  kthread+0x106/0x140
[166380.998824]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[166380.999819]  ? kthread_bind+0x10/0x10
[166381.000708]  ret_from_fork+0x3a/0x50
[166381.001782] INFO: task iscsi_ttx:11567 blocked for more than 122 seconds.
[166381.002715]       Not tainted 5.4.0 #21
[166381.003729] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[166381.004798] iscsi_ttx       D    0 11567      2 0x80004084
[166381.005800] Call Trace:
[166381.006902]  ? __schedule+0x39b/0x970
[166381.007747]  schedule+0x40/0xc0
[166381.008826]  schedule_timeout+0x1e4/0x310
[166381.009666]  ? find_held_lock+0x38/0xa0
[166381.010741]  ? sched_clock+0x5/0x10
[166381.011542]  ? sched_clock_cpu+0xc/0xa0
[166381.012536]  wait_for_completion+0x12e/0x190
[166381.013364]  ? wake_up_q+0x70/0x70
[166381.014225]  __ib_drain_sq+0x155/0x180 [ib_core]
[166381.015029]  ? __lock_acquire+0x283/0x10f0
[166381.015891]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[166381.016740]  ? wait_for_completion+0x49/0x190
[166381.017648]  ib_drain_qp+0xe/0x20 [ib_core]
[166381.018446]  isert_wait_conn+0x5e/0x330 [ib_isert]
[166381.019174]  ? __local_bh_enable_ip+0x80/0xf0
[166381.020077]  iscsit_close_connection+0x156/0x8f0 [iscsi_target_mod]
[166381.020903]  ? sched_clock_cpu+0xc/0xa0
[166381.021924]  ? __local_bh_enable_ip+0x80/0xf0
[166381.022723]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_target_mod]
[166381.023760]  iscsi_target_tx_thread+0x170/0x210 [iscsi_target_mod]
[166381.024536]  ? remove_wait_queue+0x60/0x60
[166381.025537]  kthread+0x106/0x140
[166381.026424]  ? iscsit_thread_get_cpumask+0xa0/0xa0 [iscsi_target_mod]
[166381.027417]  ? kthread_bind+0x10/0x10
[166381.028178]  ret_from_fork+0x3a/0x50
[166381.029014] INFO: task iscsi_ttx:11571 blocked for more than 122 seconds.
[166381.029948]       Not tainted 5.4.0 #21
[166381.030835] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[166381.031823] iscsi_ttx       D    0 11571      2 0x80004084
[166381.032828] Call Trace:
[166381.033743]  ? __schedule+0x39b/0x970
[166381.034666]  schedule+0x40/0xc0
[166381.035645]  schedule_timeout+0x1e4/0x310
[166381.036676]  ? find_held_lock+0x38/0xa0
[166381.037585]  ? sched_clock+0x5/0x10
[166381.038502]  ? sched_clock_cpu+0xc/0xa0
[166381.039407]  wait_for_completion+0x12e/0x190
[166381.040255]  ? wake_up_q+0x70/0x70
[166381.041261]  __ib_drain_sq+0x155/0x180 [ib_core]
[166381.042117]  ? __lock_acquire+0x283/0x10f0
[166381.043126]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[166381.044017]  ? wait_for_completion+0x49/0x190
[166381.044961]  ib_drain_qp+0xe/0x20 [ib_core]
[166381.045791]  isert_wait_conn+0x5e/0x330 [ib_isert]
[166381.046716]  ? __local_bh_enable_ip+0x80/0xf0
[166381.047610]  iscsit_close_connection+0x156/0x8f0 [iscsi_target_mod]
[166381.048494]  ? sched_clock_cpu+0xc/0xa0
[166381.049207]  ? __local_bh_enable_ip+0x80/0xf0
[166381.050091]  iscsit_take_action_for_connection_exit+0x7e/0x100 [iscsi_target_mod]
[166381.050885]  iscsi_target_tx_thread+0x170/0x210 [iscsi_target_mod]
[166381.051887]  ? remove_wait_queue+0x60/0x60
[166381.052754]  kthread+0x106/0x140
[166381.053730]  ? iscsit_thread_get_cpumask+0xa0/0xa0 [iscsi_target_mod]
[166381.054666]  ? kthread_bind+0x10/0x10
[166381.055685]  ret_from_fork+0x3a/0x50
[166381.056501]
Showing all locks held in the system:
[166381.058151] 1 lock held by khungtaskd/93:
[166381.058951]  #0: ffffffff9d28a160 (rcu_read_lock){....}, at: debug_show_all_locks+0xe/0x1a0
[166381.059945] 3 locks held by kworker/2:1H/633:
[166381.060810]  #0: ffff892bdade8298 (&rq->lock){-.-.}, at: __schedule+0xea/0x970
[166381.061918]  #1: ffffffff9d28a160 (rcu_read_lock){....}, at: __update_idle_core+0x5/0x200
[166381.062875]  #2: ffff892bc1144098 (&sess->cmdsn_mutex){+.+.}, at: iscsit_sequence_cmd+0x2a/0x190 [iscsi_target_mod]
[166381.063926] 2 locks held by kworker/1:1H/724:
[166381.064790]  #0: ffff892bda7e8298 (&rq->lock){-.-.}, at: __schedule+0xea/0x970
[166381.065915]  #1: ffffffff9d28a160 (rcu_read_lock){....}, at: __update_idle_core+0x5/0x200
[166381.066852] 2 locks held by kworker/4:1H/736:
[166381.067903]  #0: ffff892bc4506d48 ((wq_completion)ib-comp-wq){+.+.}, at: process_one_work+0x18c/0x590
[166381.068827]  #1: ffffa47c00687e50 ((work_completion)(&cq->work)){+.+.}, at: process_one_work+0x18c/0x590
[166381.069968] 2 locks held by kworker/6:1H/754:
[166381.070962]  #0: ffff892bc4506d48 ((wq_completion)ib-comp-wq){+.+.}, at: process_one_work+0x18c/0x590
[166381.072017]  #1: ffffa47c0066fe50 ((work_completion)(&cq->work)){+.+.}, at: process_one_work+0x18c/0x590
[166381.073256] 2 locks held by agetty/1991:
[166381.074257]  #0: ffff892bd09628a0 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
[166381.075445]  #1: ffffa47c00ee32f0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xdb/0x940
[166381.076406] 2 locks held by bash/8001:
[166381.077546]  #0: ffff892bd09620a0 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
[166381.078682]  #1: ffffa47c004572f0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xdb/0x940
[166381.079899] 2 locks held by kworker/7:2/8348:
[166381.081088]  #0: ffff892bdcbe8298 (&rq->lock){-.-.}, at: __schedule+0xea/0x970
[166381.082153]  #1: ffffffff9d28a160 (rcu_read_lock){....}, at: process_one_work+0x18c/0x590
[166381.083400] 1 lock held by dmesg/11581:

[166381.085703] =============================================


--6TrnltStXW4iwmi0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg_initiator.txt"

[59518.768637] iwpm_register_pid: Unable to send a nlmsg (client = 2)
[59519.769002] scsi host6: iSCSI Initiator over iSER
[59523.250297] scsi host6: iSCSI Initiator over iSER
[59523.272850] scsi 6:0:0:0: Direct-Access     LIO-ORG  ram100           4.0  PQ: 0 ANSI: 5
[59523.274224] scsi 6:0:0:0: alua: supports implicit and explicit TPGS
[59523.274319] scsi 6:0:0:0: alua: device naa.600140561f7536635924f219092d7b59 port group 0 rel port 1
[59523.275628] sd 6:0:0:0: Attached scsi generic sg3 type 0
[59523.276990] sd 6:0:0:0: [sdc] 1046528 512-byte logical blocks: (536 MB/511 MiB)
[59523.277229] sd 6:0:0:0: [sdc] Write Protect is off
[59523.277242] sd 6:0:0:0: [sdc] Mode Sense: 43 00 00 08
[59523.277738] sd 6:0:0:0: [sdc] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[59523.279158] sd 6:0:0:0: [sdc] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
[59523.286201] sd 6:0:0:0: alua: transition timeout set to 60 seconds
[59523.286271] sd 6:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
[59523.294653] sd 6:0:0:0: [sdc] Attached SCSI disk
[59524.299600] scsi host7: iSCSI Initiator over iSER
[59524.322907] scsi 7:0:0:0: Direct-Access     LIO-ORG  ram110           4.0  PQ: 0 ANSI: 5
[59524.323836] scsi 7:0:0:0: alua: supports implicit and explicit TPGS
[59524.323851] scsi 7:0:0:0: alua: device naa.60014050736b720653b43ef891c59afb port group 0 rel port 1
[59524.325090] sd 7:0:0:0: Attached scsi generic sg4 type 0
[59524.325938] sd 7:0:0:0: [sdd] 1046528 512-byte logical blocks: (536 MB/511 MiB)
[59524.326143] sd 7:0:0:0: [sdd] Write Protect is off
[59524.326151] sd 7:0:0:0: [sdd] Mode Sense: 43 00 00 08
[59524.326548] sd 7:0:0:0: [sdd] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[59524.328176] sd 7:0:0:0: [sdd] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
[59524.344624] sd 7:0:0:0: alua: transition timeout set to 60 seconds
[59524.344640] sd 7:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
[59524.351825] sd 7:0:0:0: [sdd] Attached SCSI disk
[59525.355487] scsi host8: iSCSI Initiator over iSER
[59525.375729] scsi 8:0:0:0: Direct-Access     LIO-ORG  ram120           4.0  PQ: 0 ANSI: 5
[59525.376749] scsi 8:0:0:0: alua: supports implicit and explicit TPGS
[59525.376764] scsi 8:0:0:0: alua: device naa.6001405bbca925d2b6143d2be6dbd5b2 port group 0 rel port 1
[59525.377508] sd 8:0:0:0: Attached scsi generic sg5 type 0
[59525.379742] sd 8:0:0:0: [sde] 1046528 512-byte logical blocks: (536 MB/511 MiB)
[59525.380178] sd 8:0:0:0: [sde] Write Protect is off
[59525.380191] sd 8:0:0:0: [sde] Mode Sense: 43 00 00 08
[59525.380665] sd 8:0:0:0: [sde] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[59525.382187] sd 8:0:0:0: [sde] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
[59525.392159] sd 8:0:0:0: alua: transition timeout set to 60 seconds
[59525.392171] sd 8:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
[59525.402816] sd 8:0:0:0: [sde] Attached SCSI disk
[59526.417541] scsi host9: iSCSI Initiator over iSER
[59526.439020] scsi 9:0:0:0: Direct-Access     LIO-ORG  ram130           4.0  PQ: 0 ANSI: 5
[59526.440168] scsi 9:0:0:0: alua: supports implicit and explicit TPGS
[59526.440191] scsi 9:0:0:0: alua: device naa.6001405e3ff21dc19e9402582107192a port group 0 rel port 1
[59526.441123] sd 9:0:0:0: Attached scsi generic sg6 type 0
[59526.442103] sd 9:0:0:0: [sdf] 1046528 512-byte logical blocks: (536 MB/511 MiB)
[59526.442268] sd 9:0:0:0: [sdf] Write Protect is off
[59526.442275] sd 9:0:0:0: [sdf] Mode Sense: 43 00 00 08
[59526.442497] sd 9:0:0:0: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[59526.443902] sd 9:0:0:0: [sdf] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
[59526.467826] sd 9:0:0:0: alua: transition timeout set to 60 seconds
[59526.467844] sd 9:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
[59526.475946] sd 9:0:0:0: [sdf] Attached SCSI disk
[59527.484769] scsi host10: iSCSI Initiator over iSER
[59527.505089] scsi 10:0:0:0: Direct-Access     LIO-ORG  ram140           4.0  PQ: 0 ANSI: 5
[59527.506193] scsi 10:0:0:0: alua: supports implicit and explicit TPGS
[59527.506216] scsi 10:0:0:0: alua: device naa.60014059f2a5bca5f124793b925bf787 port group 0 rel port 1
[59527.507254] sd 10:0:0:0: Attached scsi generic sg7 type 0
[59527.508651] sd 10:0:0:0: [sdg] 1046528 512-byte logical blocks: (536 MB/511 MiB)
[59527.508951] sd 10:0:0:0: [sdg] Write Protect is off
[59527.508959] sd 10:0:0:0: [sdg] Mode Sense: 43 00 00 08
[59527.509439] sd 10:0:0:0: [sdg] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[59527.510993] sd 10:0:0:0: [sdg] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
[59527.519293] sd 10:0:0:0: alua: transition timeout set to 60 seconds
[59527.519304] sd 10:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
[59527.530751] sd 10:0:0:0: [sdg] Attached SCSI disk
[59528.567803] scsi host11: iSCSI Initiator over iSER
[59528.589890] scsi 11:0:0:0: Direct-Access     LIO-ORG  ram150           4.0  PQ: 0 ANSI: 5
[59528.590968] scsi 11:0:0:0: alua: supports implicit and explicit TPGS
[59528.590994] scsi 11:0:0:0: alua: device naa.60014059d41e4a6d7264f6082b27cd0f port group 0 rel port 1
[59528.591825] sd 11:0:0:0: Attached scsi generic sg8 type 0
[59528.593304] sd 11:0:0:0: [sdh] 1046528 512-byte logical blocks: (536 MB/511 MiB)
[59528.593600] sd 11:0:0:0: [sdh] Write Protect is off
[59528.593613] sd 11:0:0:0: [sdh] Mode Sense: 43 00 00 08
[59528.594260] sd 11:0:0:0: [sdh] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[59528.596022] sd 11:0:0:0: [sdh] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
[59528.620020] sd 11:0:0:0: [sdh] Attached SCSI disk
[59528.623927] sd 11:0:0:0: alua: transition timeout set to 60 seconds
[59528.623941] sd 11:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
[59529.652880] scsi host12: iSCSI Initiator over iSER
[59529.674840] scsi 12:0:0:0: Direct-Access     LIO-ORG  ram160           4.0  PQ: 0 ANSI: 5
[59529.675898] scsi 12:0:0:0: alua: supports implicit and explicit TPGS
[59529.675914] scsi 12:0:0:0: alua: device naa.6001405e46113e4ede84e77927dee873 port group 0 rel port 1
[59529.676917] sd 12:0:0:0: Attached scsi generic sg9 type 0
[59529.677879] sd 12:0:0:0: [sdi] 1046528 512-byte logical blocks: (536 MB/511 MiB)
[59529.678060] sd 12:0:0:0: [sdi] Write Protect is off
[59529.678073] sd 12:0:0:0: [sdi] Mode Sense: 43 00 00 08
[59529.678380] sd 12:0:0:0: [sdi] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[59529.679872] sd 12:0:0:0: [sdi] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
[59529.690378] sd 12:0:0:0: alua: transition timeout set to 60 seconds
[59529.690390] sd 12:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
[59529.699708] sd 12:0:0:0: [sdi] Attached SCSI disk
[59530.746940] scsi host13: iSCSI Initiator over iSER
[59530.769261] scsi 13:0:0:0: Direct-Access     LIO-ORG  ram170           4.0  PQ: 0 ANSI: 5
[59530.770229] scsi 13:0:0:0: alua: supports implicit and explicit TPGS
[59530.770247] scsi 13:0:0:0: alua: device naa.6001405fb71bdbe73804b149d8dc6495 port group 0 rel port 1
[59530.771224] sd 13:0:0:0: Attached scsi generic sg10 type 0
[59530.772461] sd 13:0:0:0: [sdj] 1046528 512-byte logical blocks: (536 MB/511 MiB)
[59530.772546] sd 13:0:0:0: [sdj] Write Protect is off
[59530.772554] sd 13:0:0:0: [sdj] Mode Sense: 43 00 00 08
[59530.772743] sd 13:0:0:0: [sdj] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA
[59530.774184] sd 13:0:0:0: [sdj] Optimal transfer size 4294967288 logical blocks > dev_max (65535 logical blocks)
[59530.783430] sd 13:0:0:0: alua: transition timeout set to 60 seconds
[59530.783447] sd 13:0:0:0: alua: port group 00 state A non-preferred supports TOlUSNA
[59530.793068] sd 13:0:0:0: [sdj] Attached SCSI disk
[59550.860954] EXT4-fs (sdc): mounting ext3 file system using the ext4 subsystem
[59550.875188] EXT4-fs (sdc): mounted filesystem with ordered data mode. Opts: (null)
[59550.875216] ext3 filesystem being mounted at /mount/iscsi0 supports timestamps until 2038 (0x7fffffff)
[59550.950274] EXT4-fs (sdd): mounting ext3 file system using the ext4 subsystem
[59550.962063] EXT4-fs (sdd): mounted filesystem with ordered data mode. Opts: (null)
[59550.962083] ext3 filesystem being mounted at /mount/iscsi1 supports timestamps until 2038 (0x7fffffff)
[59550.989372] EXT4-fs (sde): mounting ext3 file system using the ext4 subsystem
[59551.003358] EXT4-fs (sde): mounted filesystem with ordered data mode. Opts: (null)
[59551.003379] ext3 filesystem being mounted at /mount/iscsi2 supports timestamps until 2038 (0x7fffffff)
[59551.031349] EXT4-fs (sdf): mounting ext3 file system using the ext4 subsystem
[59551.047403] EXT4-fs (sdf): mounted filesystem with ordered data mode. Opts: (null)
[59551.047423] ext3 filesystem being mounted at /mount/iscsi3 supports timestamps until 2038 (0x7fffffff)
[59551.074807] EXT4-fs (sdg): mounting ext3 file system using the ext4 subsystem
[59551.090428] EXT4-fs (sdg): mounted filesystem with ordered data mode. Opts: (null)
[59551.090449] ext3 filesystem being mounted at /mount/iscsi4 supports timestamps until 2038 (0x7fffffff)
[59551.118820] EXT4-fs (sdh): mounting ext3 file system using the ext4 subsystem
[59551.135108] EXT4-fs (sdh): mounted filesystem with ordered data mode. Opts: (null)
[59551.135128] ext3 filesystem being mounted at /mount/iscsi5 supports timestamps until 2038 (0x7fffffff)
[59551.162711] EXT4-fs (sdi): mounting ext3 file system using the ext4 subsystem
[59551.175810] EXT4-fs (sdi): mounted filesystem with ordered data mode. Opts: (null)
[59551.175830] ext3 filesystem being mounted at /mount/iscsi6 supports timestamps until 2038 (0x7fffffff)
[59551.201090] EXT4-fs (sdj): mounting ext3 file system using the ext4 subsystem
[59551.216756] EXT4-fs (sdj): mounted filesystem with ordered data mode. Opts: (null)
[59551.216776] ext3 filesystem being mounted at /mount/iscsi7 supports timestamps until 2038 (0x7fffffff)
[59873.320290]  connection3:0: ping timeout of 5 secs expired, recv timeout 5, last rx 4354526811, last ping 4354531840, now 4354536960
[59873.320781]  connection3:0: detected conn error (1022)
[59994.670540]  session3: session recovery timed out after 120 secs
[59994.679237] sd 7:0:0:0: rejecting I/O to offline device
[59994.679339] blk_update_request: I/O error, dev sdd, sector 499184 op 0x1:(WRITE) flags 0x800 phys_seg 9 prio class 0
[59994.679363] sd 7:0:0:0: rejecting I/O to offline device
[59994.679370] blk_update_request: I/O error, dev sdd, sector 499630 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[59994.679380] sd 7:0:0:0: rejecting I/O to offline device
[59994.679386] blk_update_request: I/O error, dev sdd, sector 499612 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[59994.679395] sd 7:0:0:0: rejecting I/O to offline device
[59994.679402] blk_update_request: I/O error, dev sdd, sector 499516 op 0x1:(WRITE) flags 0x800 phys_seg 21 prio class 0
[59994.679435] sd 7:0:0:0: rejecting I/O to offline device
[59994.679442] blk_update_request: I/O error, dev sdd, sector 499606 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[59994.679450] sd 7:0:0:0: rejecting I/O to offline device
[59994.679457] blk_update_request: I/O error, dev sdd, sector 499618 op 0x1:(WRITE) flags 0x800 phys_seg 5 prio class 0
[59994.679469] sd 7:0:0:0: rejecting I/O to offline device
[59994.679475] blk_update_request: I/O error, dev sdd, sector 499608 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[59994.679483] sd 7:0:0:0: rejecting I/O to offline device
[59994.679490] blk_update_request: I/O error, dev sdd, sector 499616 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[59994.679498] sd 7:0:0:0: rejecting I/O to offline device
[59994.679505] blk_update_request: I/O error, dev sdd, sector 488986 op 0x1:(WRITE) flags 0xc800 phys_seg 2 prio class 0
[59994.679518] sd 7:0:0:0: rejecting I/O to offline device
[59994.679524] blk_update_request: I/O error, dev sdd, sector 499564 op 0x1:(WRITE) flags 0x800 phys_seg 1 prio class 0
[59994.679533] sd 7:0:0:0: rejecting I/O to offline device
[59994.679549] sd 7:0:0:0: rejecting I/O to offline device
[59994.679558] sd 7:0:0:0: rejecting I/O to offline device
[59994.679568] sd 7:0:0:0: rejecting I/O to offline device
[59994.679590] sd 7:0:0:0: rejecting I/O to offline device
[59994.679610] sd 7:0:0:0: rejecting I/O to offline device
[59994.679634] sd 7:0:0:0: rejecting I/O to offline device
[59994.679653] sd 7:0:0:0: rejecting I/O to offline device
[59994.679669] sd 7:0:0:0: rejecting I/O to offline device
[59994.679678] sd 7:0:0:0: rejecting I/O to offline device
[59994.679687] sd 7:0:0:0: rejecting I/O to offline device
[59994.679703] sd 7:0:0:0: rejecting I/O to offline device
[59994.679712] sd 7:0:0:0: rejecting I/O to offline device
[59994.679721] sd 7:0:0:0: rejecting I/O to offline device
[59994.679737] sd 7:0:0:0: rejecting I/O to offline device
[59994.679758] sd 7:0:0:0: rejecting I/O to offline device
[59994.679767] sd 7:0:0:0: rejecting I/O to offline device
[59994.679776] sd 7:0:0:0: rejecting I/O to offline device
[59994.679785] sd 7:0:0:0: rejecting I/O to offline device
[59994.679794] sd 7:0:0:0: rejecting I/O to offline device
[59994.679803] sd 7:0:0:0: rejecting I/O to offline device
[59994.679811] sd 7:0:0:0: rejecting I/O to offline device
[59994.679822] sd 7:0:0:0: rejecting I/O to offline device
[59994.679847] sd 7:0:0:0: rejecting I/O to offline device
[59994.680110] sd 7:0:0:0: rejecting I/O to offline device
[59994.680120] sd 7:0:0:0: rejecting I/O to offline device
[59994.680318] sd 7:0:0:0: rejecting I/O to offline device
[59994.680331] sd 7:0:0:0: rejecting I/O to offline device
[59994.680340] sd 7:0:0:0: rejecting I/O to offline device
[59994.680396] sd 7:0:0:0: rejecting I/O to offline device
[59994.680743] Aborting journal on device sdd-8.
[59994.680792] sd 7:0:0:0: rejecting I/O to offline device
[59994.680842] sd 7:0:0:0: rejecting I/O to offline device
[59994.680871] Buffer I/O error on dev sdd, logical block 246019, lost sync page write
[59994.680890] sd 7:0:0:0: rejecting I/O to offline device
[59994.680903] Buffer I/O error on dev sdd, logical block 1, lost sync page write
[59994.680932] EXT4-fs (sdd): I/O error while writing superblock
[59994.680939] JBD2: Error -5 detected when updating journal superblock for sdd-8.
[59994.680977] EXT4-fs error (device sdd): ext4_journal_check_start:61: Detected aborted journal
[59994.680985] EXT4-fs (sdd): Remounting filesystem read-only
[59994.681044] sd 7:0:0:0: rejecting I/O to offline device
[59994.681060] Buffer I/O error on dev sdd, logical block 1, lost sync page write
[59994.681090] EXT4-fs (sdd): I/O error while writing superblock
[59994.681122] sd 7:0:0:0: rejecting I/O to offline device

--6TrnltStXW4iwmi0
Content-Type: application/json
Content-Disposition: attachment; filename="8tgt_1lun_each.json"
Content-Transfer-Encoding: quoted-printable

{=0A  "fabric_modules": [], =0A  "storage_objects": [=0A    {=0A      "attr=
ibutes": {=0A        "block_size": 512, =0A        "emulate_3pc": 1, =0A   =
     "emulate_caw": 1, =0A        "emulate_dpo": 1, =0A        "emulate_fua=
_read": 1, =0A        "emulate_fua_write": 1, =0A        "emulate_model_ali=
as": 1, =0A        "emulate_pr": 1, =0A        "emulate_rest_reord": 0, =0A=
        "emulate_tas": 1, =0A        "emulate_tpu": 0, =0A        "emulate_=
tpws": 0, =0A        "emulate_ua_intlck_ctrl": 0, =0A        "emulate_write=
_cache": 0, =0A        "enforce_pr_isids": 1, =0A        "force_pr_aptpl": =
0, =0A        "is_nonrot": 1, =0A        "max_unmap_block_desc_count": 0, =
=0A        "max_unmap_lba_count": 0, =0A        "max_write_same_len": 0, =
=0A        "optimal_sectors": 4294967288, =0A        "pi_prot_format": 0, =
=0A        "pi_prot_type": 0, =0A        "pi_prot_verify": 0, =0A        "q=
ueue_depth": 128, =0A        "unmap_granularity": 0, =0A        "unmap_gran=
ularity_alignment": 0, =0A        "unmap_zeroes_data": 0=0A      }, =0A    =
  "name": "ram170", =0A      "plugin": "ramdisk", =0A      "size": 53582233=
6, =0A      "wwn": "fb71bdbe-7380-4b14-9d8d-c6495a4adb20"=0A    }, =0A    {=
=0A      "attributes": {=0A        "block_size": 512, =0A        "emulate_3=
pc": 1, =0A        "emulate_caw": 1, =0A        "emulate_dpo": 1, =0A      =
  "emulate_fua_read": 1, =0A        "emulate_fua_write": 1, =0A        "emu=
late_model_alias": 1, =0A        "emulate_pr": 1, =0A        "emulate_rest_=
reord": 0, =0A        "emulate_tas": 1, =0A        "emulate_tpu": 0, =0A   =
     "emulate_tpws": 0, =0A        "emulate_ua_intlck_ctrl": 0, =0A        =
"emulate_write_cache": 0, =0A        "enforce_pr_isids": 1, =0A        "for=
ce_pr_aptpl": 0, =0A        "is_nonrot": 1, =0A        "max_unmap_block_des=
c_count": 0, =0A        "max_unmap_lba_count": 0, =0A        "max_write_sam=
e_len": 0, =0A        "optimal_sectors": 4294967288, =0A        "pi_prot_fo=
rmat": 0, =0A        "pi_prot_type": 0, =0A        "pi_prot_verify": 0, =0A=
        "queue_depth": 128, =0A        "unmap_granularity": 0, =0A        "=
unmap_granularity_alignment": 0, =0A        "unmap_zeroes_data": 0=0A      =
}, =0A      "name": "ram160", =0A      "plugin": "ramdisk", =0A      "size"=
: 535822336, =0A      "wwn": "e46113e4-ede8-4e77-927d-ee873d6fd4b6"=0A    }=
, =0A    {=0A      "attributes": {=0A        "block_size": 512, =0A        =
"emulate_3pc": 1, =0A        "emulate_caw": 1, =0A        "emulate_dpo": 1,=
 =0A        "emulate_fua_read": 1, =0A        "emulate_fua_write": 1, =0A  =
      "emulate_model_alias": 1, =0A        "emulate_pr": 1, =0A        "emu=
late_rest_reord": 0, =0A        "emulate_tas": 1, =0A        "emulate_tpu":=
 0, =0A        "emulate_tpws": 0, =0A        "emulate_ua_intlck_ctrl": 0, =
=0A        "emulate_write_cache": 0, =0A        "enforce_pr_isids": 1, =0A =
       "force_pr_aptpl": 0, =0A        "is_nonrot": 1, =0A        "max_unma=
p_block_desc_count": 0, =0A        "max_unmap_lba_count": 0, =0A        "ma=
x_write_same_len": 0, =0A        "optimal_sectors": 4294967288, =0A        =
"pi_prot_format": 0, =0A        "pi_prot_type": 0, =0A        "pi_prot_veri=
fy": 0, =0A        "queue_depth": 128, =0A        "unmap_granularity": 0, =
=0A        "unmap_granularity_alignment": 0, =0A        "unmap_zeroes_data"=
: 0=0A      }, =0A      "name": "ram150", =0A      "plugin": "ramdisk", =0A=
      "size": 535822336, =0A      "wwn": "9d41e4a6-d726-4f60-82b2-7cd0f3b9e=
e77"=0A    }, =0A    {=0A      "attributes": {=0A        "block_size": 512,=
 =0A        "emulate_3pc": 1, =0A        "emulate_caw": 1, =0A        "emul=
ate_dpo": 1, =0A        "emulate_fua_read": 1, =0A        "emulate_fua_writ=
e": 1, =0A        "emulate_model_alias": 1, =0A        "emulate_pr": 1, =0A=
        "emulate_rest_reord": 0, =0A        "emulate_tas": 1, =0A        "e=
mulate_tpu": 0, =0A        "emulate_tpws": 0, =0A        "emulate_ua_intlck=
_ctrl": 0, =0A        "emulate_write_cache": 0, =0A        "enforce_pr_isid=
s": 1, =0A        "force_pr_aptpl": 0, =0A        "is_nonrot": 1, =0A      =
  "max_unmap_block_desc_count": 0, =0A        "max_unmap_lba_count": 0, =0A=
        "max_write_same_len": 0, =0A        "optimal_sectors": 4294967288, =
=0A        "pi_prot_format": 0, =0A        "pi_prot_type": 0, =0A        "p=
i_prot_verify": 0, =0A        "queue_depth": 128, =0A        "unmap_granula=
rity": 0, =0A        "unmap_granularity_alignment": 0, =0A        "unmap_ze=
roes_data": 0=0A      }, =0A      "name": "ram140", =0A      "plugin": "ram=
disk", =0A      "size": 535822336, =0A      "wwn": "9f2a5bca-5f12-4793-b925=
-bf78724fb7e9"=0A    }, =0A    {=0A      "attributes": {=0A        "block_s=
ize": 512, =0A        "emulate_3pc": 1, =0A        "emulate_caw": 1, =0A   =
     "emulate_dpo": 1, =0A        "emulate_fua_read": 1, =0A        "emulat=
e_fua_write": 1, =0A        "emulate_model_alias": 1, =0A        "emulate_p=
r": 1, =0A        "emulate_rest_reord": 0, =0A        "emulate_tas": 1, =0A=
        "emulate_tpu": 0, =0A        "emulate_tpws": 0, =0A        "emulate=
_ua_intlck_ctrl": 0, =0A        "emulate_write_cache": 0, =0A        "enfor=
ce_pr_isids": 1, =0A        "force_pr_aptpl": 0, =0A        "is_nonrot": 1,=
 =0A        "max_unmap_block_desc_count": 0, =0A        "max_unmap_lba_coun=
t": 0, =0A        "max_write_same_len": 0, =0A        "optimal_sectors": 42=
94967288, =0A        "pi_prot_format": 0, =0A        "pi_prot_type": 0, =0A=
        "pi_prot_verify": 0, =0A        "queue_depth": 128, =0A        "unm=
ap_granularity": 0, =0A        "unmap_granularity_alignment": 0, =0A       =
 "unmap_zeroes_data": 0=0A      }, =0A      "name": "ram130", =0A      "plu=
gin": "ramdisk", =0A      "size": 535822336, =0A      "wwn": "e3ff21dc-19e9=
-4025-8210-7192a6add650"=0A    }, =0A    {=0A      "attributes": {=0A      =
  "block_size": 512, =0A        "emulate_3pc": 1, =0A        "emulate_caw":=
 1, =0A        "emulate_dpo": 1, =0A        "emulate_fua_read": 1, =0A     =
   "emulate_fua_write": 1, =0A        "emulate_model_alias": 1, =0A        =
"emulate_pr": 1, =0A        "emulate_rest_reord": 0, =0A        "emulate_ta=
s": 1, =0A        "emulate_tpu": 0, =0A        "emulate_tpws": 0, =0A      =
  "emulate_ua_intlck_ctrl": 0, =0A        "emulate_write_cache": 0, =0A    =
    "enforce_pr_isids": 1, =0A        "force_pr_aptpl": 0, =0A        "is_n=
onrot": 1, =0A        "max_unmap_block_desc_count": 0, =0A        "max_unma=
p_lba_count": 0, =0A        "max_write_same_len": 0, =0A        "optimal_se=
ctors": 4294967288, =0A        "pi_prot_format": 0, =0A        "pi_prot_typ=
e": 0, =0A        "pi_prot_verify": 0, =0A        "queue_depth": 128, =0A  =
      "unmap_granularity": 0, =0A        "unmap_granularity_alignment": 0, =
=0A        "unmap_zeroes_data": 0=0A      }, =0A      "name": "ram120", =0A=
      "plugin": "ramdisk", =0A      "size": 535822336, =0A      "wwn": "bbc=
a925d-2b61-43d2-be6d-bd5b280d5125"=0A    }, =0A    {=0A      "attributes": =
{=0A        "block_size": 512, =0A        "emulate_3pc": 1, =0A        "emu=
late_caw": 1, =0A        "emulate_dpo": 1, =0A        "emulate_fua_read": 1=
, =0A        "emulate_fua_write": 1, =0A        "emulate_model_alias": 1, =
=0A        "emulate_pr": 1, =0A        "emulate_rest_reord": 0, =0A        =
"emulate_tas": 1, =0A        "emulate_tpu": 0, =0A        "emulate_tpws": 0=
, =0A        "emulate_ua_intlck_ctrl": 0, =0A        "emulate_write_cache":=
 0, =0A        "enforce_pr_isids": 1, =0A        "force_pr_aptpl": 0, =0A  =
      "is_nonrot": 1, =0A        "max_unmap_block_desc_count": 0, =0A      =
  "max_unmap_lba_count": 0, =0A        "max_write_same_len": 0, =0A        =
"optimal_sectors": 4294967288, =0A        "pi_prot_format": 0, =0A        "=
pi_prot_type": 0, =0A        "pi_prot_verify": 0, =0A        "queue_depth":=
 128, =0A        "unmap_granularity": 0, =0A        "unmap_granularity_alig=
nment": 0, =0A        "unmap_zeroes_data": 0=0A      }, =0A      "name": "r=
am110", =0A      "plugin": "ramdisk", =0A      "size": 535822336, =0A      =
"wwn": "0736b720-653b-43ef-891c-59afbb3f2a45"=0A    }, =0A    {=0A      "at=
tributes": {=0A        "block_size": 512, =0A        "emulate_3pc": 1, =0A =
       "emulate_caw": 1, =0A        "emulate_dpo": 1, =0A        "emulate_f=
ua_read": 1, =0A        "emulate_fua_write": 1, =0A        "emulate_model_a=
lias": 1, =0A        "emulate_pr": 1, =0A        "emulate_rest_reord": 0, =
=0A        "emulate_tas": 1, =0A        "emulate_tpu": 0, =0A        "emula=
te_tpws": 0, =0A        "emulate_ua_intlck_ctrl": 0, =0A        "emulate_wr=
ite_cache": 0, =0A        "enforce_pr_isids": 1, =0A        "force_pr_aptpl=
": 0, =0A        "is_nonrot": 1, =0A        "max_unmap_block_desc_count": 0=
, =0A        "max_unmap_lba_count": 0, =0A        "max_write_same_len": 0, =
=0A        "optimal_sectors": 4294967288, =0A        "pi_prot_format": 0, =
=0A        "pi_prot_type": 0, =0A        "pi_prot_verify": 0, =0A        "q=
ueue_depth": 128, =0A        "unmap_granularity": 0, =0A        "unmap_gran=
ularity_alignment": 0, =0A        "unmap_zeroes_data": 0=0A      }, =0A    =
  "name": "ram100", =0A      "plugin": "ramdisk", =0A      "size": 53582233=
6, =0A      "wwn": "61f75366-3592-4f21-9092-d7b596acd420"=0A    }=0A  ], =
=0A  "targets": [=0A    {=0A      "fabric": "iscsi", =0A      "tpgs": [=0A =
       {=0A          "attributes": {=0A            "authentication": 0, =0A=
            "cache_dynamic_acls": 1, =0A            "default_cmdsn_depth": =
64, =0A            "default_erl": 0, =0A            "demo_mode_discovery": =
1, =0A            "demo_mode_write_protect": 0, =0A            "fabric_prot=
_type": 0, =0A            "generate_node_acls": 1, =0A            "login_ke=
ys_workaround": 1, =0A            "login_timeout": 15, =0A            "neti=
f_timeout": 2, =0A            "prod_mode_write_protect": 0, =0A            =
"t10_pi": 0, =0A            "tpg_enabled_sendtargets": 1=0A          }, =0A=
          "enable": true, =0A          "luns": [=0A            {=0A        =
      "index": 0, =0A              "storage_object": "/backstores/ramdisk/r=
am170"=0A            }=0A          ], =0A          "node_acls": [], =0A    =
      "parameters": {=0A            "AuthMethod": "CHAP,None", =0A         =
   "DataDigest": "CRC32C,None", =0A            "DataPDUInOrder": "Yes", =0A=
            "DataSequenceInOrder": "Yes", =0A            "DefaultTime2Retai=
n": "20", =0A            "DefaultTime2Wait": "2", =0A            "ErrorReco=
veryLevel": "0", =0A            "FirstBurstLength": "65536", =0A           =
 "HeaderDigest": "CRC32C,None", =0A            "IFMarkInt": "Reject", =0A  =
          "IFMarker": "No", =0A            "ImmediateData": "Yes", =0A     =
       "InitialR2T": "Yes", =0A            "MaxBurstLength": "262144", =0A =
           "MaxConnections": "1", =0A            "MaxOutstandingR2T": "1", =
=0A            "MaxRecvDataSegmentLength": "8192", =0A            "MaxXmitD=
ataSegmentLength": "262144", =0A            "OFMarkInt": "Reject", =0A     =
       "OFMarker": "No", =0A            "TargetAlias": "LIO Target"=0A     =
     }, =0A          "portals": [=0A            {=0A              "ip_addre=
ss": "10.0.2.2", =0A              "iser": true, =0A              "port": 32=
60=0A            }=0A          ], =0A          "tag": 1=0A        }=0A     =
 ], =0A      "wwn": "iqn.2016-17.chelsio.org7"=0A    }, =0A    {=0A      "f=
abric": "iscsi", =0A      "tpgs": [=0A        {=0A          "attributes": {=
=0A            "authentication": 0, =0A            "cache_dynamic_acls": 1,=
 =0A            "default_cmdsn_depth": 64, =0A            "default_erl": 0,=
 =0A            "demo_mode_discovery": 1, =0A            "demo_mode_write_p=
rotect": 0, =0A            "fabric_prot_type": 0, =0A            "generate_=
node_acls": 1, =0A            "login_keys_workaround": 1, =0A            "l=
ogin_timeout": 15, =0A            "netif_timeout": 2, =0A            "prod_=
mode_write_protect": 0, =0A            "t10_pi": 0, =0A            "tpg_ena=
bled_sendtargets": 1=0A          }, =0A          "enable": true, =0A       =
   "luns": [=0A            {=0A              "index": 0, =0A              "=
storage_object": "/backstores/ramdisk/ram160"=0A            }=0A          ]=
, =0A          "node_acls": [], =0A          "parameters": {=0A            =
"AuthMethod": "CHAP,None", =0A            "DataDigest": "CRC32C,None", =0A =
           "DataPDUInOrder": "Yes", =0A            "DataSequenceInOrder": "=
Yes", =0A            "DefaultTime2Retain": "20", =0A            "DefaultTim=
e2Wait": "2", =0A            "ErrorRecoveryLevel": "0", =0A            "Fir=
stBurstLength": "65536", =0A            "HeaderDigest": "CRC32C,None", =0A =
           "IFMarkInt": "Reject", =0A            "IFMarker": "No", =0A     =
       "ImmediateData": "Yes", =0A            "InitialR2T": "Yes", =0A     =
       "MaxBurstLength": "262144", =0A            "MaxConnections": "1", =
=0A            "MaxOutstandingR2T": "1", =0A            "MaxRecvDataSegment=
Length": "8192", =0A            "MaxXmitDataSegmentLength": "262144", =0A  =
          "OFMarkInt": "Reject", =0A            "OFMarker": "No", =0A      =
      "TargetAlias": "LIO Target"=0A          }, =0A          "portals": [=
=0A            {=0A              "ip_address": "10.0.2.2", =0A             =
 "iser": true, =0A              "port": 3260=0A            }=0A          ],=
 =0A          "tag": 1=0A        }=0A      ], =0A      "wwn": "iqn.2016-17.=
chelsio.org6"=0A    }, =0A    {=0A      "fabric": "iscsi", =0A      "tpgs":=
 [=0A        {=0A          "attributes": {=0A            "authentication": =
0, =0A            "cache_dynamic_acls": 1, =0A            "default_cmdsn_de=
pth": 64, =0A            "default_erl": 0, =0A            "demo_mode_discov=
ery": 1, =0A            "demo_mode_write_protect": 0, =0A            "fabri=
c_prot_type": 0, =0A            "generate_node_acls": 1, =0A            "lo=
gin_keys_workaround": 1, =0A            "login_timeout": 15, =0A           =
 "netif_timeout": 2, =0A            "prod_mode_write_protect": 0, =0A      =
      "t10_pi": 0, =0A            "tpg_enabled_sendtargets": 1=0A          =
}, =0A          "enable": true, =0A          "luns": [=0A            {=0A  =
            "index": 0, =0A              "storage_object": "/backstores/ram=
disk/ram150"=0A            }=0A          ], =0A          "node_acls": [], =
=0A          "parameters": {=0A            "AuthMethod": "CHAP,None", =0A  =
          "DataDigest": "CRC32C,None", =0A            "DataPDUInOrder": "Ye=
s", =0A            "DataSequenceInOrder": "Yes", =0A            "DefaultTim=
e2Retain": "20", =0A            "DefaultTime2Wait": "2", =0A            "Er=
rorRecoveryLevel": "0", =0A            "FirstBurstLength": "65536", =0A    =
        "HeaderDigest": "CRC32C,None", =0A            "IFMarkInt": "Reject"=
, =0A            "IFMarker": "No", =0A            "ImmediateData": "Yes", =
=0A            "InitialR2T": "Yes", =0A            "MaxBurstLength": "26214=
4", =0A            "MaxConnections": "1", =0A            "MaxOutstandingR2T=
": "1", =0A            "MaxRecvDataSegmentLength": "8192", =0A            "=
MaxXmitDataSegmentLength": "262144", =0A            "OFMarkInt": "Reject", =
=0A            "OFMarker": "No", =0A            "TargetAlias": "LIO Target"=
=0A          }, =0A          "portals": [=0A            {=0A              "=
ip_address": "10.0.2.2", =0A              "iser": true, =0A              "p=
ort": 3260=0A            }=0A          ], =0A          "tag": 1=0A        }=
=0A      ], =0A      "wwn": "iqn.2016-17.chelsio.org5"=0A    }, =0A    {=0A=
      "fabric": "iscsi", =0A      "tpgs": [=0A        {=0A          "attrib=
utes": {=0A            "authentication": 0, =0A            "cache_dynamic_a=
cls": 1, =0A            "default_cmdsn_depth": 64, =0A            "default_=
erl": 0, =0A            "demo_mode_discovery": 1, =0A            "demo_mode=
_write_protect": 0, =0A            "fabric_prot_type": 0, =0A            "g=
enerate_node_acls": 1, =0A            "login_keys_workaround": 1, =0A      =
      "login_timeout": 15, =0A            "netif_timeout": 2, =0A          =
  "prod_mode_write_protect": 0, =0A            "t10_pi": 0, =0A            =
"tpg_enabled_sendtargets": 1=0A          }, =0A          "enable": true, =
=0A          "luns": [=0A            {=0A              "index": 0, =0A     =
         "storage_object": "/backstores/ramdisk/ram140"=0A            }=0A =
         ], =0A          "node_acls": [], =0A          "parameters": {=0A  =
          "AuthMethod": "CHAP,None", =0A            "DataDigest": "CRC32C,N=
one", =0A            "DataPDUInOrder": "Yes", =0A            "DataSequenceI=
nOrder": "Yes", =0A            "DefaultTime2Retain": "20", =0A            "=
DefaultTime2Wait": "2", =0A            "ErrorRecoveryLevel": "0", =0A      =
      "FirstBurstLength": "65536", =0A            "HeaderDigest": "CRC32C,N=
one", =0A            "IFMarkInt": "Reject", =0A            "IFMarker": "No"=
, =0A            "ImmediateData": "Yes", =0A            "InitialR2T": "Yes"=
, =0A            "MaxBurstLength": "262144", =0A            "MaxConnections=
": "1", =0A            "MaxOutstandingR2T": "1", =0A            "MaxRecvDat=
aSegmentLength": "8192", =0A            "MaxXmitDataSegmentLength": "262144=
", =0A            "OFMarkInt": "Reject", =0A            "OFMarker": "No", =
=0A            "TargetAlias": "LIO Target"=0A          }, =0A          "por=
tals": [=0A            {=0A              "ip_address": "10.0.2.2", =0A     =
         "iser": true, =0A              "port": 3260=0A            }=0A    =
      ], =0A          "tag": 1=0A        }=0A      ], =0A      "wwn": "iqn.=
2016-17.chelsio.org4"=0A    }, =0A    {=0A      "fabric": "iscsi", =0A     =
 "tpgs": [=0A        {=0A          "attributes": {=0A            "authentic=
ation": 0, =0A            "cache_dynamic_acls": 1, =0A            "default_=
cmdsn_depth": 64, =0A            "default_erl": 0, =0A            "demo_mod=
e_discovery": 1, =0A            "demo_mode_write_protect": 0, =0A          =
  "fabric_prot_type": 0, =0A            "generate_node_acls": 1, =0A       =
     "login_keys_workaround": 1, =0A            "login_timeout": 15, =0A   =
         "netif_timeout": 2, =0A            "prod_mode_write_protect": 0, =
=0A            "t10_pi": 0, =0A            "tpg_enabled_sendtargets": 1=0A =
         }, =0A          "enable": true, =0A          "luns": [=0A         =
   {=0A              "index": 0, =0A              "storage_object": "/backs=
tores/ramdisk/ram130"=0A            }=0A          ], =0A          "node_acl=
s": [], =0A          "parameters": {=0A            "AuthMethod": "CHAP,None=
", =0A            "DataDigest": "CRC32C,None", =0A            "DataPDUInOrd=
er": "Yes", =0A            "DataSequenceInOrder": "Yes", =0A            "De=
faultTime2Retain": "20", =0A            "DefaultTime2Wait": "2", =0A       =
     "ErrorRecoveryLevel": "0", =0A            "FirstBurstLength": "65536",=
 =0A            "HeaderDigest": "CRC32C,None", =0A            "IFMarkInt": =
"Reject", =0A            "IFMarker": "No", =0A            "ImmediateData": =
"Yes", =0A            "InitialR2T": "Yes", =0A            "MaxBurstLength":=
 "262144", =0A            "MaxConnections": "1", =0A            "MaxOutstan=
dingR2T": "1", =0A            "MaxRecvDataSegmentLength": "8192", =0A      =
      "MaxXmitDataSegmentLength": "262144", =0A            "OFMarkInt": "Re=
ject", =0A            "OFMarker": "No", =0A            "TargetAlias": "LIO =
Target"=0A          }, =0A          "portals": [=0A            {=0A        =
      "ip_address": "10.0.2.2", =0A              "iser": true, =0A         =
     "port": 3260=0A            }=0A          ], =0A          "tag": 1=0A  =
      }=0A      ], =0A      "wwn": "iqn.2016-17.chelsio.org3"=0A    }, =0A =
   {=0A      "fabric": "iscsi", =0A      "tpgs": [=0A        {=0A          =
"attributes": {=0A            "authentication": 0, =0A            "cache_dy=
namic_acls": 1, =0A            "default_cmdsn_depth": 64, =0A            "d=
efault_erl": 0, =0A            "demo_mode_discovery": 1, =0A            "de=
mo_mode_write_protect": 0, =0A            "fabric_prot_type": 0, =0A       =
     "generate_node_acls": 1, =0A            "login_keys_workaround": 1, =
=0A            "login_timeout": 15, =0A            "netif_timeout": 2, =0A =
           "prod_mode_write_protect": 0, =0A            "t10_pi": 0, =0A   =
         "tpg_enabled_sendtargets": 1=0A          }, =0A          "enable":=
 true, =0A          "luns": [=0A            {=0A              "index": 0, =
=0A              "storage_object": "/backstores/ramdisk/ram120"=0A         =
   }=0A          ], =0A          "node_acls": [], =0A          "parameters"=
: {=0A            "AuthMethod": "CHAP,None", =0A            "DataDigest": "=
CRC32C,None", =0A            "DataPDUInOrder": "Yes", =0A            "DataS=
equenceInOrder": "Yes", =0A            "DefaultTime2Retain": "20", =0A     =
       "DefaultTime2Wait": "2", =0A            "ErrorRecoveryLevel": "0", =
=0A            "FirstBurstLength": "65536", =0A            "HeaderDigest": =
"CRC32C,None", =0A            "IFMarkInt": "Reject", =0A            "IFMark=
er": "No", =0A            "ImmediateData": "Yes", =0A            "InitialR2=
T": "Yes", =0A            "MaxBurstLength": "262144", =0A            "MaxCo=
nnections": "1", =0A            "MaxOutstandingR2T": "1", =0A            "M=
axRecvDataSegmentLength": "8192", =0A            "MaxXmitDataSegmentLength"=
: "262144", =0A            "OFMarkInt": "Reject", =0A            "OFMarker"=
: "No", =0A            "TargetAlias": "LIO Target"=0A          }, =0A      =
    "portals": [=0A            {=0A              "ip_address": "10.0.2.2", =
=0A              "iser": true, =0A              "port": 3260=0A            =
}=0A          ], =0A          "tag": 1=0A        }=0A      ], =0A      "wwn=
": "iqn.2016-17.chelsio.org2"=0A    }, =0A    {=0A      "fabric": "iscsi", =
=0A      "tpgs": [=0A        {=0A          "attributes": {=0A            "a=
uthentication": 0, =0A            "cache_dynamic_acls": 1, =0A            "=
default_cmdsn_depth": 64, =0A            "default_erl": 0, =0A            "=
demo_mode_discovery": 1, =0A            "demo_mode_write_protect": 0, =0A  =
          "fabric_prot_type": 0, =0A            "generate_node_acls": 1, =
=0A            "login_keys_workaround": 1, =0A            "login_timeout": =
15, =0A            "netif_timeout": 2, =0A            "prod_mode_write_prot=
ect": 0, =0A            "t10_pi": 0, =0A            "tpg_enabled_sendtarget=
s": 1=0A          }, =0A          "enable": true, =0A          "luns": [=0A=
            {=0A              "index": 0, =0A              "storage_object"=
: "/backstores/ramdisk/ram110"=0A            }=0A          ], =0A          =
"node_acls": [], =0A          "parameters": {=0A            "AuthMethod": "=
CHAP,None", =0A            "DataDigest": "CRC32C,None", =0A            "Dat=
aPDUInOrder": "Yes", =0A            "DataSequenceInOrder": "Yes", =0A      =
      "DefaultTime2Retain": "20", =0A            "DefaultTime2Wait": "2", =
=0A            "ErrorRecoveryLevel": "0", =0A            "FirstBurstLength"=
: "65536", =0A            "HeaderDigest": "CRC32C,None", =0A            "IF=
MarkInt": "Reject", =0A            "IFMarker": "No", =0A            "Immedi=
ateData": "Yes", =0A            "InitialR2T": "Yes", =0A            "MaxBur=
stLength": "262144", =0A            "MaxConnections": "1", =0A            "=
MaxOutstandingR2T": "1", =0A            "MaxRecvDataSegmentLength": "8192",=
 =0A            "MaxXmitDataSegmentLength": "262144", =0A            "OFMar=
kInt": "Reject", =0A            "OFMarker": "No", =0A            "TargetAli=
as": "LIO Target"=0A          }, =0A          "portals": [=0A            {=
=0A              "ip_address": "10.0.2.2", =0A              "iser": true, =
=0A              "port": 3260=0A            }=0A          ], =0A          "=
tag": 1=0A        }=0A      ], =0A      "wwn": "iqn.2016-17.chelsio.org1"=
=0A    }, =0A    {=0A      "fabric": "iscsi", =0A      "tpgs": [=0A        =
{=0A          "attributes": {=0A            "authentication": 0, =0A       =
     "cache_dynamic_acls": 1, =0A            "default_cmdsn_depth": 64, =0A=
            "default_erl": 0, =0A            "demo_mode_discovery": 1, =0A =
           "demo_mode_write_protect": 0, =0A            "fabric_prot_type":=
 0, =0A            "generate_node_acls": 1, =0A            "login_keys_work=
around": 1, =0A            "login_timeout": 15, =0A            "netif_timeo=
ut": 2, =0A            "prod_mode_write_protect": 0, =0A            "t10_pi=
": 0, =0A            "tpg_enabled_sendtargets": 1=0A          }, =0A       =
   "enable": true, =0A          "luns": [=0A            {=0A              "=
index": 0, =0A              "storage_object": "/backstores/ramdisk/ram100"=
=0A            }=0A          ], =0A          "node_acls": [], =0A          =
"parameters": {=0A            "AuthMethod": "CHAP,None", =0A            "Da=
taDigest": "CRC32C,None", =0A            "DataPDUInOrder": "Yes", =0A      =
      "DataSequenceInOrder": "Yes", =0A            "DefaultTime2Retain": "2=
0", =0A            "DefaultTime2Wait": "2", =0A            "ErrorRecoveryLe=
vel": "0", =0A            "FirstBurstLength": "65536", =0A            "Head=
erDigest": "CRC32C,None", =0A            "IFMarkInt": "Reject", =0A        =
    "IFMarker": "No", =0A            "ImmediateData": "Yes", =0A           =
 "InitialR2T": "Yes", =0A            "MaxBurstLength": "262144", =0A       =
     "MaxConnections": "1", =0A            "MaxOutstandingR2T": "1", =0A   =
         "MaxRecvDataSegmentLength": "8192", =0A            "MaxXmitDataSeg=
mentLength": "262144", =0A            "OFMarkInt": "Reject", =0A           =
 "OFMarker": "No", =0A            "TargetAlias": "LIO Target"=0A          }=
, =0A          "portals": [=0A            {=0A              "ip_address": "=
10.0.2.2", =0A              "iser": true, =0A              "port": 3260=0A =
           }=0A          ], =0A          "tag": 1=0A        }=0A      ], =
=0A      "wwn": "iqn.2016-17.chelsio.org0"=0A    }=0A  ]=0A}=0A
--6TrnltStXW4iwmi0--

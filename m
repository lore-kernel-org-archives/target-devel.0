From: Potnuri Bharat Teja <bharat@chelsio.com>
Date: Fri, 20 Mar 2020 06:15:34 +0000
Subject: Re: Connection errors with ISER IO
Message-Id: <20200320060330.GB16482@chelsio.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
List-Id: <target-devel.vger.kernel.org>
References: <20200226155241.GA28594@chelsio.com>
In-Reply-To: <20200226155241.GA28594@chelsio.com>
To: target-devel@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Friday, March 03/20/20, 2020 at 02:35:25 +0530, Sagi Grimberg wrote:
> 
> 
> On 3/19/20 10:45 AM, Potnuri Bharat Teja wrote:
> > On Tuesday, March 03/10/20, 2020 at 17:31:51 +0530, Potnuri Bharat Teja wrote:
> >> On Wednesday, March 03/04/20, 2020 at 23:56:12 +0530, Potnuri Bharat Teja wrote:
> >>> On Friday, February 02/28/20, 2020 at 05:12:32 +0530, Sagi Grimberg wrote:
> >>>>
> >>>>>>> Hi All,
> >>>>>>> I observe connection errors almost immediately after I start iozone over iser
> >>>>>>> luns. Atached are the connection error and hung task traces on initator and
> >>>>>>> target respecively.
> >>>>>>> Interestingly, I see connection errors only if LUN size is less than 512MB.
> >>>>>>> In my case I could consistently reproduce the issue with 511MB LUN and 300MB
> >>>>>>> lun size. Connections errors are not seen if I create 512MB or greated LUN.
> >>>>>>
> >>>>>> Can you share log output on the target to before hung tasks?
> >>>>>
> >>>>> Sure, Attached are the target and initiator dmesg logs.
> >>>>>>
> >>>>>>> Further, after the connection errors, I noticed that the poll work queue is
> >>>>>>> stuck and never processes drain CQE resulting in hung tasks on the target side.
> >>>>>>
> >>>>>> Is the drain CQE actually generated?
> >>>>>>
> >>>>>
> >>>>> Yes it is generated. I was able to track it with prints until queue_work() in
> >>>>> ib_cq_completion_workqueue(). Work Function ib_cq_poll_work() is never getting
> >>>>> scheduled. Therefore, I see drain CQE unpolled and hung task due to
> >>>>> __ib_drain_sq() waiting forever for complete() to be called from drain CQE
> >>>>> done() handler.
> >>>>
> >>>> Hmm, that is interesting. This tells me that cq->work is probably
> >>>> blocked by another completion invokation (which hangs), which means that
> >>>> queuing the cq->work did not happen as workqueues are not re-entrant.
> >>>>
> >>>> Looking at the code, nothing should be blocking in the isert ->done()
> >>>> handlers, so its not clear to me how this can happen.
> >>>>
> >>>> Would it be possible to run:
> >>>> echo t > /proc/sysrq-trigger when this happens? I'd like to see where
> >>>> that cq->work is blocking.
> >>>>
> >>> Attached file t_sysrq-trigger_and_dmesg.txt is the triggered output. Please let
> >>> me know if that is timed correctly as I triggered it a little after login timeout.
> >>> I'll try getting a better one meanwhile.
> >>>> I'd also enable pr_debug on iscsi_traget.c
> >>>>
> >>> Attached files are with debug enabled:
> >>> tgt_discovery_and_login_dmesg.txt -> dmesg just after login for reference
> >>> tgt_IO_511MB_8target_1lun_each_iozone_dmesg_untill_hang.txt -> dmesg untill connection error.
> >>>
> >>> Please let me know if there is anything that I could check.
> >>
> > Hi All,
> > any suggestions on what to check?
> > 
> > I tried limiting max_data_sg_nnets to 32 as T6 has relatively lower resources
> > and I dont see the issue with the patch.
> > 
> > Though the visible effect is at the workqueue, I think there is something to do
> > iscsi/iser flow control mechanism, which is failing and overwhelming the target.
> > I am not sure how to verify this exactly. I appreciate any suggestions on the debug.
> 
> Can you check what threads are blocking on?
> 
> When the hang happens, run echo t > /proc/sysrq-trigger. I'd like to
> understand what is preventing the workqueue from running...
Attached is the output of 'echo t > /proc/sysrq-trigger'

[11371.191652] workqueue ib-comp-wq: flags=0x58
[11371.192311]   pwq 11: cpus=5 node=0 flags=0x0 nice=-20 active=1/256
[11371.192966]     in-flight: 768:ib_cq_poll_work [ib_core]
[11371.193643] pool 11: cpus=5 node=0 flags=0x0 nice=-20 hung=75s workers=2 idle: 38

                                                ^^^^^^^^^^^^^^^^^^^
Does this confirm that the workqueue is blocked?

[11429.199506] INFO: task iscsi_ttx:6432 blocked for more than 122 seconds.
[11429.200197]       Tainted: G           OE     5.4.0+ #24
[11429.200744] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11429.201607] iscsi_ttx       D    0  6432      2 0x80004084
[11429.202310] Call Trace:
[11429.202890]  ? __schedule+0x31a/0x850
[11429.203844]  ? __lock_acquire+0x26c/0x1480
[11429.204457]  ? wait_for_completion+0x112/0x1a0


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="t_sysrq-trigger_and_dmesg.txt"

[11314.087442] sysrq: HELP : loglevel(0-9) reboot(b) crash(c) show-all-locks(d) terminate-all-tasks(e) memory-full-oom-kill(f) kill-all-tasks(i) thaw-filesystems(j) sak(k) show-backtrace-all-active-cpus(l) show-memory-usage(m) nice-all-RT-tasks(n) poweroff(o) show-registers(p) show-all-timers(q) unraw(r) sync(s) show-task-states(t) unmount(u) force-fb(V) show-blocked-tasks(w) dump-ftrace-buffer(z) 
[11323.215472] iSCSI Login timeout on Network Portal 10.0.2.2:3260
[11354.084939] sysrq: HELP : loglevel(0-9) reboot(b) crash(c) show-all-locks(d) terminate-all-tasks(e) memory-full-oom-kill(f) kill-all-tasks(i) thaw-filesystems(j) sak(k) show-backtrace-all-active-cpus(l) show-memory-usage(m) nice-all-RT-tasks(n) poweroff(o) show-registers(p) show-all-timers(q) unraw(r) sync(s) show-task-states(t) unmount(u) force-fb(V) show-blocked-tasks(w) dump-ftrace-buffer(z) 
[11367.047165] sysrq: Show State
[11367.047876]   task                        PC stack   pid father
[11367.048644] systemd         S    0     1      0 0x00000000
[11367.049676] Call Trace:
[11367.050483]  ? __schedule+0x31a/0x850
[11367.051505]  ? __ia32_sys_epoll_ctl+0x580/0x580
[11367.052390]  ? ep_poll+0x2c9/0x5b0
[11367.053180]  schedule+0x36/0xc0
[11367.054091]  schedule_hrtimeout_range_clock+0x104/0x110
[11367.054939]  ? lockdep_hardirqs_on+0xf0/0x180
[11367.055919]  ep_poll+0x2a9/0x5b0
[11367.056888]  ? wake_up_q+0x80/0x80
[11367.057857]  do_epoll_wait+0xd7/0xf0
[11367.058758]  __x64_sys_epoll_wait+0x1a/0x20
[11367.059690]  do_syscall_64+0x5a/0x240
[11367.060510]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.061463] RIP: 0033:0x7f556a1cc483
[11367.062293] Code: Bad RIP value.
[11367.063027] RSP: 002b:00007ffec7bdaf40 EFLAGS: 00000293 ORIG_RAX: 00000000000000e8
[11367.063931] RAX: ffffffffffffffda RBX: 00007ffec7bdaf50 RCX: 00007f556a1cc483
[11367.064786] RDX: 0000000000000046 RSI: 00007ffec7bdaf50 RDI: 0000000000000004
[11367.065758] RBP: 00007ffec7bdb390 R08: 000000000007ead8 R09: 0000000000000000
[11367.066594] R10: 00000000ffffffff R11: 0000000000000293 R12: 0000000000000001
[11367.067460] R13: ffffffffffffffff R14: 000000000000472c R15: 000055949c3e1cb0
[11367.068208] kthreadd        S    0     2      0 0x80004000
[11367.068928] Call Trace:
[11367.069926]  ? __schedule+0x31a/0x850
[11367.070763]  ? kthreadd+0x2a6/0x390
[11367.071589]  ? kthreadd+0x26a/0x390
[11367.072246]  schedule+0x36/0xc0
[11367.072899]  kthreadd+0x368/0x390
[11367.073687]  ? kthread_create_on_cpu+0x90/0x90
[11367.074277]  ret_from_fork+0x24/0x30
[11367.074935] rcu_gp          I    0     3      2 0x80004000
[11367.075727] Call Trace:
[11367.076598]  ? __schedule+0x31a/0x850
[11367.077359]  schedule+0x36/0xc0
[11367.078035]  rescuer_thread+0x2fd/0x360
[11367.078790]  ? cancel_delayed_work+0xb0/0xb0
[11367.079542]  kthread+0x11f/0x140
[11367.080266]  ? kthread_park+0x90/0x90
[11367.080896]  ret_from_fork+0x24/0x30
[11367.081654] rcu_par_gp      I    0     4      2 0x80004000
[11367.082249] Call Trace:
[11367.082807]  ? __schedule+0x31a/0x850
[11367.083562]  schedule+0x36/0xc0
[11367.084146]  rescuer_thread+0x2fd/0x360
[11367.084650]  ? cancel_delayed_work+0xb0/0xb0
[11367.085226]  kthread+0x11f/0x140
[11367.085715]  ? kthread_park+0x90/0x90
[11367.086243]  ret_from_fork+0x24/0x30
[11367.086717] kworker/0:0H    I    0     6      2 0x80004000
[11367.087255] Workqueue:  0x0 (kblockd)
[11367.087746] Call Trace:
[11367.088286]  ? __schedule+0x31a/0x850
[11367.088786]  schedule+0x36/0xc0
[11367.089325]  worker_thread+0xc6/0x390
[11367.089941]  ? process_one_work+0x5d0/0x5d0
[11367.090562]  kthread+0x11f/0x140
[11367.091142]  ? kthread_park+0x90/0x90
[11367.091616]  ret_from_fork+0x24/0x30
[11367.092245] mm_percpu_wq    I    0     8      2 0x80004000
[11367.092799] Call Trace:
[11367.093368]  ? __schedule+0x31a/0x850
[11367.093895]  schedule+0x36/0xc0
[11367.094461]  rescuer_thread+0x2fd/0x360
[11367.094975]  ? cancel_delayed_work+0xb0/0xb0
[11367.095490]  kthread+0x11f/0x140
[11367.096041]  ? kthread_park+0x90/0x90
[11367.096519]  ret_from_fork+0x24/0x30
[11367.097054] ksoftirqd/0     S    0     9      2 0x80004000
[11367.097517] Call Trace:
[11367.098048]  ? __schedule+0x31a/0x850
[11367.098481]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.098988]  ? smpboot_thread_fn+0x74/0x1d0
[11367.099431]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.099948]  schedule+0x36/0xc0
[11367.100500]  smpboot_thread_fn+0x1c6/0x1d0
[11367.101006]  ? sort_range+0x20/0x20
[11367.101452]  kthread+0x11f/0x140
[11367.101937]  ? kthread_park+0x90/0x90
[11367.102349]  ret_from_fork+0x24/0x30
[11367.102803] rcu_sched       I    0    10      2 0x80004000
[11367.103344] Call Trace:
[11367.103841]  ? __schedule+0x31a/0x850
[11367.104532]  schedule+0x36/0xc0
[11367.105011]  schedule_timeout+0x1ba/0x3b0
[11367.105425]  ? __next_timer_interrupt+0xc0/0xc0
[11367.105933]  rcu_gp_kthread+0x54e/0xa10
[11367.106387]  ? rcu_eqs_exit.constprop.76+0xb0/0xb0
[11367.106841]  kthread+0x11f/0x140
[11367.107342]  ? kthread_park+0x90/0x90
[11367.107828]  ret_from_fork+0x24/0x30
[11367.108378] migration/0     S    0    11      2 0x80004000
[11367.108906] Call Trace:
[11367.109460]  ? __schedule+0x31a/0x850
[11367.109934]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.110320]  ? smpboot_thread_fn+0x74/0x1d0
[11367.110781]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.111296]  schedule+0x36/0xc0
[11367.111755]  smpboot_thread_fn+0x1c6/0x1d0
[11367.112295]  ? sort_range+0x20/0x20
[11367.112752]  kthread+0x11f/0x140
[11367.113258]  ? kthread_park+0x90/0x90
[11367.113681]  ret_from_fork+0x24/0x30
[11367.114215] cpuhp/0         S    0    13      2 0x80004000
[11367.114696] Call Trace:
[11367.115192]  ? __schedule+0x31a/0x850
[11367.115636]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.116166]  ? smpboot_thread_fn+0x74/0x1d0
[11367.116652]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.117152]  schedule+0x36/0xc0
[11367.117576]  smpboot_thread_fn+0x1c6/0x1d0
[11367.118056]  ? sort_range+0x20/0x20
[11367.118483]  kthread+0x11f/0x140
[11367.118947]  ? kthread_park+0x90/0x90
[11367.119337]  ret_from_fork+0x24/0x30
[11367.119840] cpuhp/1         S    0    14      2 0x80004000
[11367.120373] Call Trace:
[11367.120964]  ? __schedule+0x31a/0x850
[11367.121489]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.121931]  ? smpboot_thread_fn+0x74/0x1d0
[11367.122336]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.122758]  schedule+0x36/0xc0
[11367.123199]  smpboot_thread_fn+0x1c6/0x1d0
[11367.123659]  ? sort_range+0x20/0x20
[11367.124153]  kthread+0x11f/0x140
[11367.124699]  ? kthread_park+0x90/0x90
[11367.125132]  ret_from_fork+0x24/0x30
[11367.125576] migration/1     S    0    15      2 0x80004000
[11367.126004] Call Trace:
[11367.126437]  ? __schedule+0x31a/0x850
[11367.126883]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.127288]  ? smpboot_thread_fn+0x74/0x1d0
[11367.127706]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.128220]  schedule+0x36/0xc0
[11367.128669]  smpboot_thread_fn+0x1c6/0x1d0
[11367.129160]  ? sort_range+0x20/0x20
[11367.129580]  kthread+0x11f/0x140
[11367.130077]  ? kthread_park+0x90/0x90
[11367.130490]  ret_from_fork+0x24/0x30
[11367.130943] ksoftirqd/1     S    0    16      2 0x80004000
[11367.131323] Call Trace:
[11367.131715]  ? __schedule+0x31a/0x850
[11367.132176]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.132727]  ? smpboot_thread_fn+0x74/0x1d0
[11367.133217]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.133719]  schedule+0x36/0xc0
[11367.134254]  smpboot_thread_fn+0x1c6/0x1d0
[11367.134648]  ? sort_range+0x20/0x20
[11367.135129]  kthread+0x11f/0x140
[11367.135536]  ? kthread_park+0x90/0x90
[11367.135982]  ret_from_fork+0x24/0x30
[11367.136387] kworker/1:0H    I    0    18      2 0x80004000
[11367.136809] Workqueue:  0x0 (kblockd)
[11367.137255] Call Trace:
[11367.137768]  ? __schedule+0x31a/0x850
[11367.138262]  schedule+0x36/0xc0
[11367.138678]  worker_thread+0xc6/0x390
[11367.139186]  ? process_one_work+0x5d0/0x5d0
[11367.139661]  kthread+0x11f/0x140
[11367.140200]  ? kthread_park+0x90/0x90
[11367.140673]  ret_from_fork+0x24/0x30
[11367.141192] cpuhp/2         S    0    19      2 0x80004000
[11367.141622] Call Trace:
[11367.142098]  ? __schedule+0x31a/0x850
[11367.142554]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.143057]  ? smpboot_thread_fn+0x74/0x1d0
[11367.143473]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.143935]  schedule+0x36/0xc0
[11367.144342]  smpboot_thread_fn+0x1c6/0x1d0
[11367.144768]  ? sort_range+0x20/0x20
[11367.145223]  kthread+0x11f/0x140
[11367.145673]  ? kthread_park+0x90/0x90
[11367.146202]  ret_from_fork+0x24/0x30
[11367.146665] migration/2     S    0    20      2 0x80004000
[11367.147208] Call Trace:
[11367.147685]  ? __schedule+0x31a/0x850
[11367.148210]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.148668]  ? smpboot_thread_fn+0x74/0x1d0
[11367.149156]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.149570]  schedule+0x36/0xc0
[11367.150084]  smpboot_thread_fn+0x1c6/0x1d0
[11367.150493]  ? sort_range+0x20/0x20
[11367.150973]  kthread+0x11f/0x140
[11367.151355]  ? kthread_park+0x90/0x90
[11367.151802]  ret_from_fork+0x24/0x30
[11367.152340] ksoftirqd/2     S    0    21      2 0x80004000
[11367.152896] Call Trace:
[11367.153388]  ? __schedule+0x31a/0x850
[11367.153838]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.154280]  ? smpboot_thread_fn+0x74/0x1d0
[11367.154692]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.155130]  schedule+0x36/0xc0
[11367.155549]  smpboot_thread_fn+0x1c6/0x1d0
[11367.156048]  ? sort_range+0x20/0x20
[11367.156487]  kthread+0x11f/0x140
[11367.157009]  ? kthread_park+0x90/0x90
[11367.157429]  ret_from_fork+0x24/0x30
[11367.157879] kworker/2:0H    I    0    23      2 0x80004000
[11367.158303] Call Trace:
[11367.158759]  ? __schedule+0x31a/0x850
[11367.159219]  schedule+0x36/0xc0
[11367.159648]  worker_thread+0xc6/0x390
[11367.160122]  ? process_one_work+0x5d0/0x5d0
[11367.160638]  kthread+0x11f/0x140
[11367.161113]  ? kthread_park+0x90/0x90
[11367.161526]  ret_from_fork+0x24/0x30
[11367.161980] cpuhp/3         S    0    24      2 0x80004000
[11367.162396] Call Trace:
[11367.162799]  ? __schedule+0x31a/0x850
[11367.163277]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.163714]  ? smpboot_thread_fn+0x74/0x1d0
[11367.164196]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.164660]  schedule+0x36/0xc0
[11367.165155]  smpboot_thread_fn+0x1c6/0x1d0
[11367.165589]  ? sort_range+0x20/0x20
[11367.166139]  kthread+0x11f/0x140
[11367.166534]  ? kthread_park+0x90/0x90
[11367.167043]  ret_from_fork+0x24/0x30
[11367.167490] migration/3     S    0    25      2 0x80004000
[11367.167948] Call Trace:
[11367.168359]  ? __schedule+0x31a/0x850
[11367.168825]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.169279]  ? smpboot_thread_fn+0x74/0x1d0
[11367.169777]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.170265]  schedule+0x36/0xc0
[11367.170854]  smpboot_thread_fn+0x1c6/0x1d0
[11367.171310]  ? sort_range+0x20/0x20
[11367.171724]  kthread+0x11f/0x140
[11367.172187]  ? kthread_park+0x90/0x90
[11367.172658]  ret_from_fork+0x24/0x30
[11367.173170] ksoftirqd/3     S    0    26      2 0x80004000
[11367.173594] Call Trace:
[11367.174037]  ? __schedule+0x31a/0x850
[11367.174460]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.174935]  ? smpboot_thread_fn+0x74/0x1d0
[11367.175380]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.175792]  schedule+0x36/0xc0
[11367.176291]  smpboot_thread_fn+0x1c6/0x1d0
[11367.176779]  ? sort_range+0x20/0x20
[11367.177230]  kthread+0x11f/0x140
[11367.177646]  ? kthread_park+0x90/0x90
[11367.178096]  ret_from_fork+0x24/0x30
[11367.178558] kworker/3:0H    I    0    28      2 0x80004000
[11367.179011] Workqueue:  0x0 (kblockd)
[11367.179418] Call Trace:
[11367.179927]  ? __schedule+0x31a/0x850
[11367.180328]  schedule+0x36/0xc0
[11367.180794]  worker_thread+0xc6/0x390
[11367.181286]  ? process_one_work+0x5d0/0x5d0
[11367.181726]  kthread+0x11f/0x140
[11367.182180]  ? kthread_park+0x90/0x90
[11367.182685]  ret_from_fork+0x24/0x30
[11367.183227] cpuhp/4         S    0    29      2 0x80004000
[11367.183677] Call Trace:
[11367.184198]  ? __schedule+0x31a/0x850
[11367.184695]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.185183]  ? smpboot_thread_fn+0x74/0x1d0
[11367.185596]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.186041]  schedule+0x36/0xc0
[11367.186465]  smpboot_thread_fn+0x1c6/0x1d0
[11367.186946]  ? sort_range+0x20/0x20
[11367.187331]  kthread+0x11f/0x140
[11367.187770]  ? kthread_park+0x90/0x90
[11367.188298]  ret_from_fork+0x24/0x30
[11367.188803] migration/4     S    0    30      2 0x80004000
[11367.189267] Call Trace:
[11367.189698]  ? __schedule+0x31a/0x850
[11367.190141]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.190558]  ? smpboot_thread_fn+0x74/0x1d0
[11367.191029]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.191429]  schedule+0x36/0xc0
[11367.191946]  smpboot_thread_fn+0x1c6/0x1d0
[11367.192346]  ? sort_range+0x20/0x20
[11367.192832]  kthread+0x11f/0x140
[11367.193306]  ? kthread_park+0x90/0x90
[11367.193829]  ret_from_fork+0x24/0x30
[11367.194305] ksoftirqd/4     S    0    31      2 0x80004000
[11367.194750] Call Trace:
[11367.195201]  ? __schedule+0x31a/0x850
[11367.195624]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.196161]  ? smpboot_thread_fn+0x74/0x1d0
[11367.196618]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.197088]  schedule+0x36/0xc0
[11367.197489]  smpboot_thread_fn+0x1c6/0x1d0
[11367.198036]  ? sort_range+0x20/0x20
[11367.198570]  kthread+0x11f/0x140
[11367.199039]  ? kthread_park+0x90/0x90
[11367.199470]  ret_from_fork+0x24/0x30
[11367.199976] kworker/4:0H    I    0    33      2 0x80004000
[11367.200386] Workqueue:  0x0 (kblockd)
[11367.200869] Call Trace:
[11367.201344]  ? __schedule+0x31a/0x850
[11367.201835]  schedule+0x36/0xc0
[11367.202301]  worker_thread+0xc6/0x390
[11367.202737]  ? process_one_work+0x5d0/0x5d0
[11367.203236]  kthread+0x11f/0x140
[11367.203686]  ? kthread_park+0x90/0x90
[11367.204157]  ret_from_fork+0x24/0x30
[11367.204583] cpuhp/5         S    0    34      2 0x80004000
[11367.205067] Call Trace:
[11367.205465]  ? __schedule+0x31a/0x850
[11367.205981]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.206367]  ? smpboot_thread_fn+0x74/0x1d0
[11367.206819]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.207321]  schedule+0x36/0xc0
[11367.207808]  smpboot_thread_fn+0x1c6/0x1d0
[11367.208303]  ? sort_range+0x20/0x20
[11367.208737]  kthread+0x11f/0x140
[11367.209173]  ? kthread_park+0x90/0x90
[11367.209592]  ret_from_fork+0x24/0x30
[11367.210045] migration/5     S    0    35      2 0x80004000
[11367.210482] Call Trace:
[11367.210958]  ? __schedule+0x31a/0x850
[11367.211345]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.211789]  ? smpboot_thread_fn+0x74/0x1d0
[11367.212277]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.212798]  schedule+0x36/0xc0
[11367.213287]  smpboot_thread_fn+0x1c6/0x1d0
[11367.213691]  ? sort_range+0x20/0x20
[11367.214144]  kthread+0x11f/0x140
[11367.214607]  ? kthread_park+0x90/0x90
[11367.215126]  ret_from_fork+0x24/0x30
[11367.215601] ksoftirqd/5     S    0    36      2 0x80004000
[11367.216059] Call Trace:
[11367.216526]  ? __schedule+0x31a/0x850
[11367.216983]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.217357]  ? smpboot_thread_fn+0x74/0x1d0
[11367.217802]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.218278]  schedule+0x36/0xc0
[11367.218769]  smpboot_thread_fn+0x1c6/0x1d0
[11367.219285]  ? sort_range+0x20/0x20
[11367.219709]  kthread+0x11f/0x140
[11367.220249]  ? kthread_park+0x90/0x90
[11367.220763]  ret_from_fork+0x24/0x30
[11367.221261] kworker/5:0H    I    0    38      2 0x80004000
[11367.221756] Workqueue:  0x0 (kblockd)
[11367.222229] Call Trace:
[11367.222676]  ? __schedule+0x31a/0x850
[11367.223208]  schedule+0x36/0xc0
[11367.223637]  worker_thread+0xc6/0x390
[11367.224178]  ? process_one_work+0x5d0/0x5d0
[11367.224615]  kthread+0x11f/0x140
[11367.225057]  ? kthread_park+0x90/0x90
[11367.225472]  ret_from_fork+0x24/0x30
[11367.225962] cpuhp/6         S    0    39      2 0x80004000
[11367.226382] Call Trace:
[11367.226779]  ? __schedule+0x31a/0x850
[11367.227237]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.227725]  ? smpboot_thread_fn+0x74/0x1d0
[11367.228273]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.228689]  schedule+0x36/0xc0
[11367.229142]  smpboot_thread_fn+0x1c6/0x1d0
[11367.229612]  ? sort_range+0x20/0x20
[11367.230071]  kthread+0x11f/0x140
[11367.230518]  ? kthread_park+0x90/0x90
[11367.231025]  ret_from_fork+0x24/0x30
[11367.231469] migration/6     S    0    40      2 0x80004000
[11367.231936] Call Trace:
[11367.232320]  ? __schedule+0x31a/0x850
[11367.232783]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.233299]  ? smpboot_thread_fn+0x74/0x1d0
[11367.233725]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.234234]  schedule+0x36/0xc0
[11367.234666]  smpboot_thread_fn+0x1c6/0x1d0
[11367.235169]  ? sort_range+0x20/0x20
[11367.235631]  kthread+0x11f/0x140
[11367.236086]  ? kthread_park+0x90/0x90
[11367.236527]  ret_from_fork+0x24/0x30
[11367.237029] ksoftirqd/6     S    0    41      2 0x80004000
[11367.237454] Call Trace:
[11367.237939]  ? __schedule+0x31a/0x850
[11367.238351]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.238751]  ? smpboot_thread_fn+0x74/0x1d0
[11367.239291]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.239782]  schedule+0x36/0xc0
[11367.240277]  smpboot_thread_fn+0x1c6/0x1d0
[11367.240719]  ? sort_range+0x20/0x20
[11367.241201]  kthread+0x11f/0x140
[11367.241616]  ? kthread_park+0x90/0x90
[11367.242109]  ret_from_fork+0x24/0x30
[11367.242608] kworker/6:0H    I    0    43      2 0x80004000
[11367.243107] Workqueue:  0x0 (kblockd)
[11367.243530] Call Trace:
[11367.244037]  ? __schedule+0x31a/0x850
[11367.244479]  schedule+0x36/0xc0
[11367.244965]  worker_thread+0xc6/0x390
[11367.245367]  ? process_one_work+0x5d0/0x5d0
[11367.245825]  kthread+0x11f/0x140
[11367.246305]  ? kthread_park+0x90/0x90
[11367.246793]  ret_from_fork+0x24/0x30
[11367.247299] cpuhp/7         S    0    44      2 0x80004000
[11367.247747] Call Trace:
[11367.248219]  ? __schedule+0x31a/0x850
[11367.248709]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.249193]  ? smpboot_thread_fn+0x74/0x1d0
[11367.249668]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.250126]  schedule+0x36/0xc0
[11367.250556]  smpboot_thread_fn+0x1c6/0x1d0
[11367.251021]  ? sort_range+0x20/0x20
[11367.251453]  kthread+0x11f/0x140
[11367.251963]  ? kthread_park+0x90/0x90
[11367.252381]  ret_from_fork+0x24/0x30
[11367.252843] migration/7     S    0    45      2 0x80004000
[11367.253336] Call Trace:
[11367.253747]  ? __schedule+0x31a/0x850
[11367.254233]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.254656]  ? smpboot_thread_fn+0x74/0x1d0
[11367.255200]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.255623]  schedule+0x36/0xc0
[11367.256123]  smpboot_thread_fn+0x1c6/0x1d0
[11367.256614]  ? sort_range+0x20/0x20
[11367.257092]  kthread+0x11f/0x140
[11367.257525]  ? kthread_park+0x90/0x90
[11367.257950]  ret_from_fork+0x24/0x30
[11367.258373] ksoftirqd/7     S    0    46      2 0x80004000
[11367.258848] Call Trace:
[11367.259352]  ? __schedule+0x31a/0x850
[11367.259789]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.260265]  ? smpboot_thread_fn+0x74/0x1d0
[11367.260718]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.261198]  schedule+0x36/0xc0
[11367.261612]  smpboot_thread_fn+0x1c6/0x1d0
[11367.262102]  ? sort_range+0x20/0x20
[11367.262524]  kthread+0x11f/0x140
[11367.263040]  ? kthread_park+0x90/0x90
[11367.263481]  ret_from_fork+0x24/0x30
[11367.263993] kworker/7:0H    I    0    48      2 0x80004000
[11367.264447] Workqueue:  0x0 (kblockd)
[11367.264969] Call Trace:
[11367.265350]  ? __schedule+0x31a/0x850
[11367.265793]  schedule+0x36/0xc0
[11367.266275]  worker_thread+0xc6/0x390
[11367.266767]  ? process_one_work+0x5d0/0x5d0
[11367.267265]  kthread+0x11f/0x140
[11367.267680]  ? kthread_park+0x90/0x90
[11367.268190]  ret_from_fork+0x24/0x30
[11367.268637] cpuhp/8         S    0    49      2 0x80004000
[11367.269240] Call Trace:
[11367.269661]  ? __schedule+0x31a/0x850
[11367.270149]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.270562]  ? smpboot_thread_fn+0x74/0x1d0
[11367.271049]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.271463]  schedule+0x36/0xc0
[11367.271961]  smpboot_thread_fn+0x1c6/0x1d0
[11367.272363]  ? sort_range+0x20/0x20
[11367.272837]  kthread+0x11f/0x140
[11367.273374]  ? kthread_park+0x90/0x90
[11367.273829]  ret_from_fork+0x24/0x30
[11367.274319] migration/8     R  running task        0    50      2 0x80004000
[11367.274752] Call Trace:
[11367.275241]  ? __schedule+0x31a/0x850
[11367.275697]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.276240]  ? smpboot_thread_fn+0x74/0x1d0
[11367.276677]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.277168]  schedule+0x36/0xc0
[11367.277609]  smpboot_thread_fn+0x1c6/0x1d0
[11367.278078]  ? sort_range+0x20/0x20
[11367.278523]  kthread+0x11f/0x140
[11367.279013]  ? kthread_park+0x90/0x90
[11367.279439]  ret_from_fork+0x24/0x30
[11367.279950] ksoftirqd/8     S    0    51      2 0x80004000
[11367.280366] Call Trace:
[11367.280809]  ? __schedule+0x31a/0x850
[11367.281349]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.281768]  ? smpboot_thread_fn+0x74/0x1d0
[11367.282251]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.282669]  schedule+0x36/0xc0
[11367.283161]  smpboot_thread_fn+0x1c6/0x1d0
[11367.283591]  ? sort_range+0x20/0x20
[11367.284132]  kthread+0x11f/0x140
[11367.284571]  ? kthread_park+0x90/0x90
[11367.285068]  ret_from_fork+0x24/0x30
[11367.285496] kworker/8:0H    I    0    53      2 0x80004000
[11367.286009] Workqueue:  0x0 (kblockd)
[11367.286450] Call Trace:
[11367.286969]  ? __schedule+0x31a/0x850
[11367.287364]  schedule+0x36/0xc0
[11367.287800]  worker_thread+0xc6/0x390
[11367.288309]  ? process_one_work+0x5d0/0x5d0
[11367.288753]  kthread+0x11f/0x140
[11367.289240]  ? kthread_park+0x90/0x90
[11367.289667]  ret_from_fork+0x24/0x30
[11367.290174] cpuhp/9         S    0    54      2 0x80004000
[11367.290634] Call Trace:
[11367.291170]  ? __schedule+0x31a/0x850
[11367.291603]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.292114]  ? smpboot_thread_fn+0x74/0x1d0
[11367.292549]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.293039]  schedule+0x36/0xc0
[11367.293458]  smpboot_thread_fn+0x1c6/0x1d0
[11367.293955]  ? sort_range+0x20/0x20
[11367.294375]  kthread+0x11f/0x140
[11367.294816]  ? kthread_park+0x90/0x90
[11367.295340]  ret_from_fork+0x24/0x30
[11367.295829] migration/9     S    0    55      2 0x80004000
[11367.296331] Call Trace:
[11367.296766]  ? __schedule+0x31a/0x850
[11367.297249]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.297665]  ? smpboot_thread_fn+0x74/0x1d0
[11367.298148]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.298570]  schedule+0x36/0xc0
[11367.299130]  smpboot_thread_fn+0x1c6/0x1d0
[11367.299557]  ? sort_range+0x20/0x20
[11367.300053]  kthread+0x11f/0x140
[11367.300489]  ? kthread_park+0x90/0x90
[11367.300980]  ret_from_fork+0x24/0x30
[11367.301387] ksoftirqd/9     S    0    56      2 0x80004000
[11367.301811] Call Trace:
[11367.302294]  ? __schedule+0x31a/0x850
[11367.302748]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.303232]  ? smpboot_thread_fn+0x74/0x1d0
[11367.303650]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.304151]  schedule+0x36/0xc0
[11367.304615]  smpboot_thread_fn+0x1c6/0x1d0
[11367.305155]  ? sort_range+0x20/0x20
[11367.305613]  kthread+0x11f/0x140
[11367.306128]  ? kthread_park+0x90/0x90
[11367.306544]  ret_from_fork+0x24/0x30
[11367.307047] kworker/9:0H    I    0    58      2 0x80004000
[11367.307481] Workqueue:  0x0 (kblockd)
[11367.308003] Call Trace:
[11367.308456]  ? __schedule+0x31a/0x850
[11367.308969]  schedule+0x36/0xc0
[11367.309354]  worker_thread+0xc6/0x390
[11367.309755]  ? process_one_work+0x5d0/0x5d0
[11367.310244]  kthread+0x11f/0x140
[11367.310731]  ? kthread_park+0x90/0x90
[11367.311284]  ret_from_fork+0x24/0x30
[11367.311728] cpuhp/10        S    0    59      2 0x80004000
[11367.312229] Call Trace:
[11367.312670]  ? __schedule+0x31a/0x850
[11367.313222]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.313644]  ? smpboot_thread_fn+0x74/0x1d0
[11367.314129]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.314581]  schedule+0x36/0xc0
[11367.315173]  smpboot_thread_fn+0x1c6/0x1d0
[11367.315616]  ? sort_range+0x20/0x20
[11367.316087]  kthread+0x11f/0x140
[11367.316550]  ? kthread_park+0x90/0x90
[11367.317047]  ret_from_fork+0x24/0x30
[11367.317471] migration/10    S    0    60      2 0x80004000
[11367.317969] Call Trace:
[11367.318370]  ? __schedule+0x31a/0x850
[11367.318799]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.319326]  ? smpboot_thread_fn+0x74/0x1d0
[11367.319876]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.320433]  schedule+0x36/0xc0
[11367.320864]  smpboot_thread_fn+0x1c6/0x1d0
[11367.321255]  ? sort_range+0x20/0x20
[11367.321701]  kthread+0x11f/0x140
[11367.322225]  ? kthread_park+0x90/0x90
[11367.322663]  ret_from_fork+0x24/0x30
[11367.323220] ksoftirqd/10    S    0    61      2 0x80004000
[11367.323657] Call Trace:
[11367.324168]  ? __schedule+0x31a/0x850
[11367.324687]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.325179]  ? smpboot_thread_fn+0x74/0x1d0
[11367.325648]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.326179]  schedule+0x36/0xc0
[11367.326596]  smpboot_thread_fn+0x1c6/0x1d0
[11367.327088]  ? sort_range+0x20/0x20
[11367.327506]  kthread+0x11f/0x140
[11367.328005]  ? kthread_park+0x90/0x90
[11367.328434]  ret_from_fork+0x24/0x30
[11367.328948] kworker/10:0H   I    0    63      2 0x80004000
[11367.329462] Workqueue:  0x0 (kblockd)
[11367.329961] Call Trace:
[11367.330360]  ? __schedule+0x31a/0x850
[11367.330793]  schedule+0x36/0xc0
[11367.331315]  worker_thread+0xc6/0x390
[11367.331751]  ? process_one_work+0x5d0/0x5d0
[11367.332249]  kthread+0x11f/0x140
[11367.332683]  ? kthread_park+0x90/0x90
[11367.333172]  ret_from_fork+0x24/0x30
[11367.333595] cpuhp/11        S    0    64      2 0x80004000
[11367.334094] Call Trace:
[11367.334519]  ? __schedule+0x31a/0x850
[11367.335041]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.335461]  ? smpboot_thread_fn+0x74/0x1d0
[11367.335957]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.336357]  schedule+0x36/0xc0
[11367.336795]  smpboot_thread_fn+0x1c6/0x1d0
[11367.337288]  ? sort_range+0x20/0x20
[11367.337702]  kthread+0x11f/0x140
[11367.338184]  ? kthread_park+0x90/0x90
[11367.338611]  ret_from_fork+0x24/0x30
[11367.339202] migration/11    S    0    65      2 0x80004000
[11367.339666] Call Trace:
[11367.340209]  ? __schedule+0x31a/0x850
[11367.340647]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.341137]  ? smpboot_thread_fn+0x74/0x1d0
[11367.341549]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.342035]  schedule+0x36/0xc0
[11367.342466]  smpboot_thread_fn+0x1c6/0x1d0
[11367.342985]  ? sort_range+0x20/0x20
[11367.343493]  kthread+0x11f/0x140
[11367.344018]  ? kthread_park+0x90/0x90
[11367.344452]  ret_from_fork+0x24/0x30
[11367.344961] ksoftirqd/11    S    0    66      2 0x80004000
[11367.345372] Call Trace:
[11367.345785]  ? __schedule+0x31a/0x850
[11367.346271]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.346698]  ? smpboot_thread_fn+0x74/0x1d0
[11367.347206]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.347708]  schedule+0x36/0xc0
[11367.348242]  smpboot_thread_fn+0x1c6/0x1d0
[11367.348682]  ? sort_range+0x20/0x20
[11367.349167]  kthread+0x11f/0x140
[11367.349597]  ? kthread_park+0x90/0x90
[11367.350060]  ret_from_fork+0x24/0x30
[11367.350516] kworker/11:0H   I    0    68      2 0x80004000
[11367.351016] Workqueue:  0x0 (kblockd)
[11367.351437] Call Trace:
[11367.351927]  ? __schedule+0x31a/0x850
[11367.352345]  schedule+0x36/0xc0
[11367.352806]  worker_thread+0xc6/0x390
[11367.353288]  ? process_one_work+0x5d0/0x5d0
[11367.353706]  kthread+0x11f/0x140
[11367.354195]  ? kthread_park+0x90/0x90
[11367.354622]  ret_from_fork+0x24/0x30
[11367.355179] cpuhp/12        S    0    69      2 0x80004000
[11367.355589] Call Trace:
[11367.356126]  ? __schedule+0x31a/0x850
[11367.356594]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.357129]  ? smpboot_thread_fn+0x74/0x1d0
[11367.357579]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.358066]  schedule+0x36/0xc0
[11367.358494]  smpboot_thread_fn+0x1c6/0x1d0
[11367.359005]  ? sort_range+0x20/0x20
[11367.359419]  kthread+0x11f/0x140
[11367.359989]  ? kthread_park+0x90/0x90
[11367.360433]  ret_from_fork+0x24/0x30
[11367.360921] migration/12    S    0    70      2 0x80004000
[11367.361330] Call Trace:
[11367.361741]  ? __schedule+0x31a/0x850
[11367.362231]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.362718]  ? smpboot_thread_fn+0x74/0x1d0
[11367.363196]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.363611]  schedule+0x36/0xc0
[11367.364108]  smpboot_thread_fn+0x1c6/0x1d0
[11367.364565]  ? sort_range+0x20/0x20
[11367.365077]  kthread+0x11f/0x140
[11367.365473]  ? kthread_park+0x90/0x90
[11367.365981]  ret_from_fork+0x24/0x30
[11367.366387] ksoftirqd/12    S    0    71      2 0x80004000
[11367.366819] Call Trace:
[11367.367323]  ? __schedule+0x31a/0x850
[11367.367797]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.368297]  ? smpboot_thread_fn+0x74/0x1d0
[11367.368767]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.369249]  schedule+0x36/0xc0
[11367.369661]  smpboot_thread_fn+0x1c6/0x1d0
[11367.370151]  ? sort_range+0x20/0x20
[11367.370598]  kthread+0x11f/0x140
[11367.371083]  ? kthread_park+0x90/0x90
[11367.371501]  ret_from_fork+0x24/0x30
[11367.372015] kworker/12:0H   I    0    73      2 0x80004000
[11367.372462] Workqueue:  0x0 (kblockd)
[11367.372952] Call Trace:
[11367.373347]  ? __schedule+0x31a/0x850
[11367.373764]  schedule+0x36/0xc0
[11367.374242]  worker_thread+0xc6/0x390
[11367.374669]  ? process_one_work+0x5d0/0x5d0
[11367.375206]  kthread+0x11f/0x140
[11367.375646]  ? kthread_park+0x90/0x90
[11367.376186]  ret_from_fork+0x24/0x30
[11367.376626] cpuhp/13        S    0    74      2 0x80004000
[11367.377145] Call Trace:
[11367.377558]  ? __schedule+0x31a/0x850
[11367.378001]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.378414]  ? smpboot_thread_fn+0x74/0x1d0
[11367.378944]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.379340]  schedule+0x36/0xc0
[11367.379754]  smpboot_thread_fn+0x1c6/0x1d0
[11367.380256]  ? sort_range+0x20/0x20
[11367.380762]  kthread+0x11f/0x140
[11367.381240]  ? kthread_park+0x90/0x90
[11367.381654]  ret_from_fork+0x24/0x30
[11367.382152] migration/13    S    0    75      2 0x80004000
[11367.382594] Call Trace:
[11367.383122]  ? __schedule+0x31a/0x850
[11367.383528]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.384049]  ? smpboot_thread_fn+0x74/0x1d0
[11367.384481]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.384970]  schedule+0x36/0xc0
[11367.385421]  smpboot_thread_fn+0x1c6/0x1d0
[11367.385904]  ? sort_range+0x20/0x20
[11367.386319]  kthread+0x11f/0x140
[11367.386758]  ? kthread_park+0x90/0x90
[11367.387242]  ret_from_fork+0x24/0x30
[11367.387673] ksoftirqd/13    S    0    76      2 0x80004000
[11367.388189] Call Trace:
[11367.388641]  ? __schedule+0x31a/0x850
[11367.389205]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.389622]  ? smpboot_thread_fn+0x74/0x1d0
[11367.390138]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.390550]  schedule+0x36/0xc0
[11367.391035]  smpboot_thread_fn+0x1c6/0x1d0
[11367.391458]  ? sort_range+0x20/0x20
[11367.391943]  kthread+0x11f/0x140
[11367.392356]  ? kthread_park+0x90/0x90
[11367.392819]  ret_from_fork+0x24/0x30
[11367.393310] kworker/13:0H   I    0    78      2 0x80004000
[11367.393739] Workqueue:  0x0 (kblockd)
[11367.394225] Call Trace:
[11367.394675]  ? __schedule+0x31a/0x850
[11367.395168]  schedule+0x36/0xc0
[11367.395583]  worker_thread+0xc6/0x390
[11367.396088]  ? process_one_work+0x5d0/0x5d0
[11367.396525]  kthread+0x11f/0x140
[11367.397011]  ? kthread_park+0x90/0x90
[11367.397426]  ret_from_fork+0x24/0x30
[11367.397908] cpuhp/14        S    0    79      2 0x80004000
[11367.398336] Call Trace:
[11367.398777]  ? __schedule+0x31a/0x850
[11367.399263]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.399747]  ? smpboot_thread_fn+0x74/0x1d0
[11367.400219]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.400690]  schedule+0x36/0xc0
[11367.401179]  smpboot_thread_fn+0x1c6/0x1d0
[11367.401599]  ? sort_range+0x20/0x20
[11367.402085]  kthread+0x11f/0x140
[11367.402497]  ? kthread_park+0x90/0x90
[11367.402992]  ret_from_fork+0x24/0x30
[11367.403417] migration/14    S    0    80      2 0x80004000
[11367.403932] Call Trace:
[11367.404348]  ? __schedule+0x31a/0x850
[11367.404815]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.405306]  ? smpboot_thread_fn+0x74/0x1d0
[11367.405716]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.406197]  schedule+0x36/0xc0
[11367.406628]  smpboot_thread_fn+0x1c6/0x1d0
[11367.407179]  ? sort_range+0x20/0x20
[11367.407620]  kthread+0x11f/0x140
[11367.408154]  ? kthread_park+0x90/0x90
[11367.408716]  ret_from_fork+0x24/0x30
[11367.409207] ksoftirqd/14    S    0    81      2 0x80004000
[11367.409631] Call Trace:
[11367.410113]  ? __schedule+0x31a/0x850
[11367.410546]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.411056]  ? smpboot_thread_fn+0x74/0x1d0
[11367.411470]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.411964]  schedule+0x36/0xc0
[11367.412379]  smpboot_thread_fn+0x1c6/0x1d0
[11367.412845]  ? sort_range+0x20/0x20
[11367.413331]  kthread+0x11f/0x140
[11367.413793]  ? kthread_park+0x90/0x90
[11367.414252]  ret_from_fork+0x24/0x30
[11367.414690] kworker/14:0H   I    0    83      2 0x80004000
[11367.415167] Workqueue:  0x0 (kblockd)
[11367.415604] Call Trace:
[11367.416077]  ? __schedule+0x31a/0x850
[11367.416534]  schedule+0x36/0xc0
[11367.416991]  worker_thread+0xc6/0x390
[11367.417428]  ? process_one_work+0x5d0/0x5d0
[11367.417894]  kthread+0x11f/0x140
[11367.418308]  ? kthread_park+0x90/0x90
[11367.418750]  ret_from_fork+0x24/0x30
[11367.419240] cpuhp/15        S    0    84      2 0x80004000
[11367.419666] Call Trace:
[11367.420178]  ? __schedule+0x31a/0x850
[11367.420615]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.421145]  ? smpboot_thread_fn+0x74/0x1d0
[11367.421557]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.422031]  schedule+0x36/0xc0
[11367.422458]  smpboot_thread_fn+0x1c6/0x1d0
[11367.422933]  ? sort_range+0x20/0x20
[11367.423330]  kthread+0x11f/0x140
[11367.423743]  ? kthread_park+0x90/0x90
[11367.424240]  ret_from_fork+0x24/0x30
[11367.424681] migration/15    S    0    85      2 0x80004000
[11367.425223] Call Trace:
[11367.425638]  ? __schedule+0x31a/0x850
[11367.426159]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.426575]  ? smpboot_thread_fn+0x74/0x1d0
[11367.427057]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.427472]  schedule+0x36/0xc0
[11367.427966]  smpboot_thread_fn+0x1c6/0x1d0
[11367.428385]  ? sort_range+0x20/0x20
[11367.428851]  kthread+0x11f/0x140
[11367.429335]  ? kthread_park+0x90/0x90
[11367.429749]  ret_from_fork+0x24/0x30
[11367.430240] ksoftirqd/15    S    0    86      2 0x80004000
[11367.430666] Call Trace:
[11367.431165]  ? __schedule+0x31a/0x850
[11367.431667]  ? smpboot_thread_fn+0x2f/0x1d0
[11367.432195]  ? smpboot_thread_fn+0x74/0x1d0
[11367.432631]  ? smpboot_thread_fn+0x13c/0x1d0
[11367.433122]  schedule+0x36/0xc0
[11367.433538]  smpboot_thread_fn+0x1c6/0x1d0
[11367.434024]  ? sort_range+0x20/0x20
[11367.434455]  kthread+0x11f/0x140
[11367.434927]  ? kthread_park+0x90/0x90
[11367.435329]  ret_from_fork+0x24/0x30
[11367.435764] kworker/15:0H   I    0    88      2 0x80004000
[11367.436275] Workqueue:  0x0 (kblockd)
[11367.436753] Call Trace:
[11367.437234]  ? __schedule+0x31a/0x850
[11367.437654]  schedule+0x36/0xc0
[11367.438129]  worker_thread+0xc6/0x390
[11367.438563]  ? process_one_work+0x5d0/0x5d0
[11367.439037]  kthread+0x11f/0x140
[11367.439454]  ? kthread_park+0x90/0x90
[11367.439952]  ret_from_fork+0x24/0x30
[11367.440377] kdevtmpfs       S    0    90      2 0x80004000
[11367.440852] Call Trace:
[11367.441336]  ? __schedule+0x31a/0x850
[11367.441806]  schedule+0x36/0xc0
[11367.442264]  devtmpfsd+0x319/0x330
[11367.442704]  ? public_dev_mount+0x40/0x40
[11367.443205]  kthread+0x11f/0x140
[11367.443648]  ? kthread_park+0x90/0x90
[11367.444132]  ret_from_fork+0x24/0x30
[11367.444597] netns           I    0    91      2 0x80004000
[11367.445093] Call Trace:
[11367.445553]  ? __schedule+0x31a/0x850
[11367.446050]  schedule+0x36/0xc0
[11367.446493]  rescuer_thread+0x2fd/0x360
[11367.446982]  ? cancel_delayed_work+0xb0/0xb0
[11367.447391]  kthread+0x11f/0x140
[11367.447857]  ? kthread_park+0x90/0x90
[11367.448365]  ret_from_fork+0x24/0x30
[11367.448837] kauditd         S    0    92      2 0x80004000
[11367.449376] Call Trace:
[11367.449873]  ? __schedule+0x31a/0x850
[11367.450426]  ? kauditd_thread+0x46/0x540
[11367.450935]  ? kauditd_thread+0xc1/0x540
[11367.451353]  schedule+0x36/0xc0
[11367.451785]  kauditd_thread+0x2cc/0x540
[11367.452309]  ? finish_wait+0x80/0x80
[11367.452776]  ? auditd_reset+0xe0/0xe0
[11367.453299]  kthread+0x11f/0x140
[11367.453723]  ? kthread_park+0x90/0x90
[11367.454216]  ret_from_fork+0x24/0x30
[11367.454689] khungtaskd      S    0    93      2 0x80004000
[11367.455207] Call Trace:
[11367.455646]  ? __schedule+0x31a/0x850
[11367.456160]  schedule+0x36/0xc0
[11367.456634]  schedule_timeout+0x1ba/0x3b0
[11367.457134]  ? __next_timer_interrupt+0xc0/0xc0
[11367.457582]  watchdog+0x57/0x640
[11367.458094]  ? hungtask_pm_notify+0x40/0x40
[11367.458531]  kthread+0x11f/0x140
[11367.459045]  ? kthread_park+0x90/0x90
[11367.459503]  ret_from_fork+0x24/0x30
[11367.460011] oom_reaper      S    0    94      2 0x80004000
[11367.460476] Call Trace:
[11367.460995]  ? __schedule+0x31a/0x850
[11367.461419]  ? __oom_reap_task_mm+0x200/0x200
[11367.461947]  schedule+0x36/0xc0
[11367.462369]  oom_reaper+0x3ad/0x5f0
[11367.462823]  ? finish_wait+0x80/0x80
[11367.463396]  ? __oom_reap_task_mm+0x200/0x200
[11367.463874]  kthread+0x11f/0x140
[11367.464388]  ? kthread_park+0x90/0x90
[11367.464928]  ret_from_fork+0x24/0x30
[11367.465453] writeback       I    0    95      2 0x80004000
[11367.465889] Call Trace:
[11367.466313]  ? __schedule+0x31a/0x850
[11367.466769]  schedule+0x36/0xc0
[11367.467317]  rescuer_thread+0x2fd/0x360
[11367.467751]  ? cancel_delayed_work+0xb0/0xb0
[11367.468291]  kthread+0x11f/0x140
[11367.468742]  ? kthread_park+0x90/0x90
[11367.469312]  ret_from_fork+0x24/0x30
[11367.469862] kcompactd0      S    0    96      2 0x80004000
[11367.470431] Call Trace:
[11367.470929]  ? __schedule+0x31a/0x850
[11367.471344]  ? kcompactd_do_work+0x380/0x380
[11367.471771]  schedule+0x36/0xc0
[11367.472328]  kcompactd+0x1c7/0x290
[11367.472767]  ? finish_wait+0x80/0x80
[11367.473309]  ? kcompactd_do_work+0x380/0x380
[11367.473759]  kthread+0x11f/0x140
[11367.474293]  ? kthread_park+0x90/0x90
[11367.474755]  ret_from_fork+0x24/0x30
[11367.475303] ksmd            S    0    97      2 0x80004000
[11367.475753] Call Trace:
[11367.476279]  ? __schedule+0x31a/0x850
[11367.476751]  ? ksm_do_scan+0x1830/0x1830
[11367.477305]  schedule+0x36/0xc0
[11367.477750]  ksm_scan_thread+0x257/0x320
[11367.478255]  ? finish_wait+0x80/0x80
[11367.478717]  kthread+0x11f/0x140
[11367.479286]  ? kthread_park+0x90/0x90
[11367.479770]  ret_from_fork+0x24/0x30
[11367.480292] khugepaged      S    0    98      2 0x80004000
[11367.480784] Call Trace:
[11367.481313]  ? __schedule+0x31a/0x850
[11367.481769]  schedule+0x36/0xc0
[11367.482283]  schedule_timeout+0x1ba/0x3b0
[11367.482728]  ? __next_timer_interrupt+0xc0/0xc0
[11367.483264]  khugepaged+0x47b/0x1790
[11367.483707]  ? finish_wait+0x80/0x80
[11367.484248]  ? collapse_pte_mapped_thp+0x390/0x390
[11367.484748]  kthread+0x11f/0x140
[11367.485257]  ? kthread_park+0x90/0x90
[11367.485701]  ret_from_fork+0x24/0x30
[11367.486219] kworker/7:1     I    0   100      2 0x80004000
[11367.486677] Workqueue:  0x0 (events_power_efficient)
[11367.487207] Call Trace:
[11367.487662]  ? __schedule+0x31a/0x850
[11367.488195]  schedule+0x36/0xc0
[11367.488684]  worker_thread+0xc6/0x390
[11367.489190]  ? process_one_work+0x5d0/0x5d0
[11367.489670]  kthread+0x11f/0x140
[11367.490176]  ? kthread_park+0x90/0x90
[11367.490644]  ret_from_fork+0x24/0x30
[11367.491157] kworker/11:1    I    0   117      2 0x80004000
[11367.491622] Workqueue:  0x0 (infiniband)
[11367.492159] Call Trace:
[11367.492634]  ? __schedule+0x31a/0x850
[11367.493204]  schedule+0x36/0xc0
[11367.493654]  worker_thread+0xc6/0x390
[11367.494181]  ? process_one_work+0x5d0/0x5d0
[11367.494665]  kthread+0x11f/0x140
[11367.495183]  ? kthread_park+0x90/0x90
[11367.495637]  ret_from_fork+0x24/0x30
[11367.496210] kworker/4:1     I    0   134      2 0x80004000
[11367.496700] Workqueue:  0x0 (cgroup_destroy)
[11367.497242] Call Trace:
[11367.497719]  ? __schedule+0x31a/0x850
[11367.498265]  schedule+0x36/0xc0
[11367.498721]  worker_thread+0xc6/0x390
[11367.499246]  ? process_one_work+0x5d0/0x5d0
[11367.499703]  kthread+0x11f/0x140
[11367.500248]  ? kthread_park+0x90/0x90
[11367.500727]  ret_from_fork+0x24/0x30
[11367.501270] kworker/15:1    I    0   136      2 0x80004000
[11367.501782] Workqueue:  0x0 (mm_percpu_wq)
[11367.502329] Call Trace:
[11367.502807]  ? __schedule+0x31a/0x850
[11367.503372]  schedule+0x36/0xc0
[11367.503876]  worker_thread+0xc6/0x390
[11367.504470]  ? process_one_work+0x5d0/0x5d0
[11367.504987]  kthread+0x11f/0x140
[11367.505445]  ? kthread_park+0x90/0x90
[11367.505985]  ret_from_fork+0x24/0x30
[11367.506454] kintegrityd     I    0   204      2 0x80004000
[11367.507011] Call Trace:
[11367.507462]  ? __schedule+0x31a/0x850
[11367.508033]  schedule+0x36/0xc0
[11367.508516]  rescuer_thread+0x2fd/0x360
[11367.509067]  ? cancel_delayed_work+0xb0/0xb0
[11367.509515]  kthread+0x11f/0x140
[11367.510108]  ? kthread_park+0x90/0x90
[11367.510572]  ret_from_fork+0x24/0x30
[11367.511115] kblockd         I    0   205      2 0x80004000
[11367.511597] Call Trace:
[11367.512171]  ? __schedule+0x31a/0x850
[11367.512656]  schedule+0x36/0xc0
[11367.513195]  rescuer_thread+0x2fd/0x360
[11367.513703]  ? cancel_delayed_work+0xb0/0xb0
[11367.514258]  kthread+0x11f/0x140
[11367.514735]  ? kthread_park+0x90/0x90
[11367.515291]  ret_from_fork+0x24/0x30
[11367.515747] blkcg_punt_bio  I    0   206      2 0x80004000
[11367.516307] Call Trace:
[11367.516782]  ? __schedule+0x31a/0x850
[11367.517324]  schedule+0x36/0xc0
[11367.517827]  rescuer_thread+0x2fd/0x360
[11367.518375]  ? cancel_delayed_work+0xb0/0xb0
[11367.518833]  kthread+0x11f/0x140
[11367.519371]  ? kthread_park+0x90/0x90
[11367.519856]  ret_from_fork+0x24/0x30
[11367.520452] tpm_dev_wq      I    0   208      2 0x80004000
[11367.520908] Call Trace:
[11367.521348]  ? __schedule+0x31a/0x850
[11367.521807]  schedule+0x36/0xc0
[11367.522327]  rescuer_thread+0x2fd/0x360
[11367.522787]  ? cancel_delayed_work+0xb0/0xb0
[11367.523326]  kthread+0x11f/0x140
[11367.523765]  ? kthread_park+0x90/0x90
[11367.524319]  ret_from_fork+0x24/0x30
[11367.524801] md              I    0   209      2 0x80004000
[11367.525338] Call Trace:
[11367.525792]  ? __schedule+0x31a/0x850
[11367.526318]  schedule+0x36/0xc0
[11367.526764]  rescuer_thread+0x2fd/0x360
[11367.527287]  ? cancel_delayed_work+0xb0/0xb0
[11367.527743]  kthread+0x11f/0x140
[11367.528278]  ? kthread_park+0x90/0x90
[11367.528754]  ret_from_fork+0x24/0x30
[11367.529295] edac-poller     I    0   210      2 0x80004000
[11367.529803] Call Trace:
[11367.530341]  ? __schedule+0x31a/0x850
[11367.530834]  schedule+0x36/0xc0
[11367.531350]  rescuer_thread+0x2fd/0x360
[11367.531882]  ? cancel_delayed_work+0xb0/0xb0
[11367.532448]  kthread+0x11f/0x140
[11367.532967]  ? kthread_park+0x90/0x90
[11367.533420]  ret_from_fork+0x24/0x30
[11367.533949] devfreq_wq      I    0   211      2 0x80004000
[11367.534399] Call Trace:
[11367.534954]  ? __schedule+0x31a/0x850
[11367.535551]  schedule+0x36/0xc0
[11367.536098]  rescuer_thread+0x2fd/0x360
[11367.536575]  ? cancel_delayed_work+0xb0/0xb0
[11367.537111]  kthread+0x11f/0x140
[11367.537545]  ? kthread_park+0x90/0x90
[11367.538090]  ret_from_fork+0x24/0x30
[11367.538549] watchdogd       S    0   212      2 0x80004000
[11367.539095] Call Trace:
[11367.539537]  ? __schedule+0x31a/0x850
[11367.540098]  ? kthread_worker_fn+0x112/0x200
[11367.540608]  ? kthread_worker_fn+0x94/0x200
[11367.541167]  ? __kthread_init_worker+0x80/0x80
[11367.541651]  schedule+0x36/0xc0
[11367.542196]  kthread_worker_fn+0x18b/0x200
[11367.542667]  kthread+0x11f/0x140
[11367.543216]  ? kthread_park+0x90/0x90
[11367.543671]  ret_from_fork+0x24/0x30
[11367.544233] kswapd0         S    0   233      2 0x80004000
[11367.544729] Call Trace:
[11367.545231]  ? __schedule+0x31a/0x850
[11367.545724]  schedule+0x36/0xc0
[11367.546233]  kswapd+0x459/0x500
[11367.546696]  ? finish_wait+0x80/0x80
[11367.547202]  ? balance_pgdat+0x580/0x580
[11367.547648]  kthread+0x11f/0x140
[11367.548186]  ? kthread_park+0x90/0x90
[11367.548715]  ret_from_fork+0x24/0x30
[11367.549266] kthrotld        I    0   236      2 0x80004000
[11367.549715] Call Trace:
[11367.550225]  ? __schedule+0x31a/0x850
[11367.550675]  schedule+0x36/0xc0
[11367.551189]  rescuer_thread+0x2fd/0x360
[11367.551644]  ? cancel_delayed_work+0xb0/0xb0
[11367.552171]  kthread+0x11f/0x140
[11367.552631]  ? kthread_park+0x90/0x90
[11367.553190]  ret_from_fork+0x24/0x30
[11367.553654] irq/25-aerdrv   S    0   237      2 0x80004000
[11367.554194] Call Trace:
[11367.554635]  ? __schedule+0x31a/0x850
[11367.555201]  ? irq_forced_thread_fn+0x70/0x70
[11367.555743]  ? irq_thread+0xa1/0x1a0
[11367.556282]  schedule+0x36/0xc0
[11367.556807]  irq_thread+0xa1/0x1a0
[11367.557317]  ? wake_threads_waitq+0x30/0x30
[11367.557834]  ? irq_thread_dtor+0x90/0x90
[11367.558331]  kthread+0x11f/0x140
[11367.558826]  ? kthread_park+0x90/0x90
[11367.559349]  ret_from_fork+0x24/0x30
[11367.559871] irq/27-aerdrv   S    0   241      2 0x80004000
[11367.560383] Call Trace:
[11367.560919]  ? __schedule+0x31a/0x850
[11367.561470]  ? irq_forced_thread_fn+0x70/0x70
[11367.561928]  ? irq_thread+0xa1/0x1a0
[11367.562391]  schedule+0x36/0xc0
[11367.562845]  irq_thread+0xa1/0x1a0
[11367.563337]  ? wake_threads_waitq+0x30/0x30
[11367.563782]  ? irq_thread_dtor+0x90/0x90
[11367.564308]  kthread+0x11f/0x140
[11367.564770]  ? kthread_park+0x90/0x90
[11367.565293]  ret_from_fork+0x24/0x30
[11367.565796] irq/29-aerdrv   S    0   242      2 0x80004000
[11367.566328] Call Trace:
[11367.566770]  ? __schedule+0x31a/0x850
[11367.567302]  ? irq_forced_thread_fn+0x70/0x70
[11367.567738]  ? irq_thread+0xa1/0x1a0
[11367.568275]  schedule+0x36/0xc0
[11367.568734]  irq_thread+0xa1/0x1a0
[11367.569258]  ? wake_threads_waitq+0x30/0x30
[11367.569686]  ? irq_thread_dtor+0x90/0x90
[11367.570211]  kthread+0x11f/0x140
[11367.570689]  ? kthread_park+0x90/0x90
[11367.571204]  ret_from_fork+0x24/0x30
[11367.571665] acpi_thermal_pm I    0   243      2 0x80004000
[11367.572205] Call Trace:
[11367.572674]  ? __schedule+0x31a/0x850
[11367.573239]  schedule+0x36/0xc0
[11367.573682]  rescuer_thread+0x2fd/0x360
[11367.574204]  ? cancel_delayed_work+0xb0/0xb0
[11367.574653]  kthread+0x11f/0x140
[11367.575187]  ? kthread_park+0x90/0x90
[11367.575675]  ret_from_fork+0x24/0x30
[11367.576291] kmpath_rdacd    I    0   244      2 0x80004000
[11367.576772] Call Trace:
[11367.577299]  ? __schedule+0x31a/0x850
[11367.577747]  schedule+0x36/0xc0
[11367.578258]  rescuer_thread+0x2fd/0x360
[11367.578714]  ? cancel_delayed_work+0xb0/0xb0
[11367.579243]  kthread+0x11f/0x140
[11367.579710]  ? kthread_park+0x90/0x90
[11367.580257]  ret_from_fork+0x24/0x30
[11367.580814] kaluad          I    0   245      2 0x80004000
[11367.581342] Call Trace:
[11367.581790]  ? __schedule+0x31a/0x850
[11367.582352]  schedule+0x36/0xc0
[11367.582838]  rescuer_thread+0x2fd/0x360
[11367.583370]  ? cancel_delayed_work+0xb0/0xb0
[11367.583821]  kthread+0x11f/0x140
[11367.584345]  ? kthread_park+0x90/0x90
[11367.584816]  ret_from_fork+0x24/0x30
[11367.585351] ipv6_addrconf   I    0   251      2 0x80004000
[11367.585907] Call Trace:
[11367.586460]  ? __schedule+0x31a/0x850
[11367.587022]  schedule+0x36/0xc0
[11367.587493]  rescuer_thread+0x2fd/0x360
[11367.588048]  ? cancel_delayed_work+0xb0/0xb0
[11367.588528]  kthread+0x11f/0x140
[11367.589050]  ? kthread_park+0x90/0x90
[11367.589507]  ret_from_fork+0x24/0x30
[11367.590034] kstrp           I    0   252      2 0x80004000
[11367.590496] Call Trace:
[11367.591022]  ? __schedule+0x31a/0x850
[11367.591491]  schedule+0x36/0xc0
[11367.592049]  rescuer_thread+0x2fd/0x360
[11367.592510]  ? cancel_delayed_work+0xb0/0xb0
[11367.593066]  kthread+0x11f/0x140
[11367.593500]  ? kthread_park+0x90/0x90
[11367.594056]  ret_from_fork+0x24/0x30
[11367.594525] kworker/13:2    I    0   305      2 0x80004000
[11367.595063] Workqueue:  0x0 (mm_percpu_wq)
[11367.595527] Call Trace:
[11367.596074]  ? __schedule+0x31a/0x850
[11367.596555]  schedule+0x36/0xc0
[11367.597084]  worker_thread+0xc6/0x390
[11367.597545]  ? process_one_work+0x5d0/0x5d0
[11367.598104]  kthread+0x11f/0x140
[11367.598575]  ? kthread_park+0x90/0x90
[11367.599106]  ret_from_fork+0x24/0x30
[11367.599597] ata_sff         I    0   515      2 0x80004000
[11367.600160] Call Trace:
[11367.600672]  ? __schedule+0x31a/0x850
[11367.601191]  schedule+0x36/0xc0
[11367.601647]  rescuer_thread+0x2fd/0x360
[11367.602202]  ? cancel_delayed_work+0xb0/0xb0
[11367.602661]  kthread+0x11f/0x140
[11367.603193]  ? kthread_park+0x90/0x90
[11367.603688]  ret_from_fork+0x24/0x30
[11367.604289] scsi_eh_0       S    0   519      2 0x80004000
[11367.604776] Call Trace:
[11367.605299]  ? __schedule+0x31a/0x850
[11367.605839]  ? scsi_error_handler+0x9a/0x630
[11367.606354]  ? scsi_try_target_reset+0x90/0x90
[11367.606835]  ? scsi_error_handler+0x3b/0x630
[11367.607352]  schedule+0x36/0xc0
[11367.607809]  scsi_error_handler+0x1f5/0x630
[11367.608381]  ? scsi_eh_get_sense+0x240/0x240
[11367.608882]  kthread+0x11f/0x140
[11367.609397]  ? kthread_park+0x90/0x90
[11367.609852]  ret_from_fork+0x24/0x30
[11367.610379] scsi_tmf_0      I    0   520      2 0x80004000
[11367.610846] Call Trace:
[11367.611388]  ? __schedule+0x31a/0x850
[11367.611839]  schedule+0x36/0xc0
[11367.612392]  rescuer_thread+0x2fd/0x360
[11367.612877]  ? cancel_delayed_work+0xb0/0xb0
[11367.613400]  kthread+0x11f/0x140
[11367.613979]  ? kthread_park+0x90/0x90
[11367.614421]  ret_from_fork+0x24/0x30
[11367.614972] scsi_eh_1       S    0   522      2 0x80004000
[11367.615419] Call Trace:
[11367.615986]  ? __schedule+0x31a/0x850
[11367.616523]  ? scsi_error_handler+0x9a/0x630
[11367.617054]  ? scsi_try_target_reset+0x90/0x90
[11367.617522]  ? scsi_error_handler+0x3b/0x630
[11367.618085]  schedule+0x36/0xc0
[11367.618528]  scsi_error_handler+0x1f5/0x630
[11367.619099]  ? scsi_eh_get_sense+0x240/0x240
[11367.619538]  kthread+0x11f/0x140
[11367.620100]  ? kthread_park+0x90/0x90
[11367.620594]  ret_from_fork+0x24/0x30
[11367.621125] scsi_tmf_1      I    0   523      2 0x80004000
[11367.621591] Call Trace:
[11367.622116]  ? __schedule+0x31a/0x850
[11367.622585]  schedule+0x36/0xc0
[11367.623115]  rescuer_thread+0x2fd/0x360
[11367.623593]  ? cancel_delayed_work+0xb0/0xb0
[11367.624158]  kthread+0x11f/0x140
[11367.624645]  ? kthread_park+0x90/0x90
[11367.625174]  ret_from_fork+0x24/0x30
[11367.625641] scsi_eh_2       S    0   525      2 0x80004000
[11367.626230] Call Trace:
[11367.626746]  ? __schedule+0x31a/0x850
[11367.627255]  ? scsi_error_handler+0x9a/0x630
[11367.627734]  ? scsi_try_target_reset+0x90/0x90
[11367.628260]  ? scsi_error_handler+0x3b/0x630
[11367.628756]  schedule+0x36/0xc0
[11367.629265]  scsi_error_handler+0x1f5/0x630
[11367.629724]  ? scsi_eh_get_sense+0x240/0x240
[11367.630247]  kthread+0x11f/0x140
[11367.630702]  ? kthread_park+0x90/0x90
[11367.631230]  ret_from_fork+0x24/0x30
[11367.631779] scsi_tmf_2      I    0   526      2 0x80004000
[11367.632332] Call Trace:
[11367.632809]  ? __schedule+0x31a/0x850
[11367.633355]  schedule+0x36/0xc0
[11367.633792]  rescuer_thread+0x2fd/0x360
[11367.634338]  ? cancel_delayed_work+0xb0/0xb0
[11367.634795]  kthread+0x11f/0x140
[11367.635332]  ? kthread_park+0x90/0x90
[11367.635772]  ret_from_fork+0x24/0x30
[11367.636323] scsi_eh_3       S    0   527      2 0x80004000
[11367.636884] Call Trace:
[11367.637419]  ? __schedule+0x31a/0x850
[11367.637897]  ? scsi_error_handler+0x9a/0x630
[11367.638341]  ? scsi_try_target_reset+0x90/0x90
[11367.638804]  ? scsi_error_handler+0x3b/0x630
[11367.639346]  schedule+0x36/0xc0
[11367.639782]  scsi_error_handler+0x1f5/0x630
[11367.640340]  ? scsi_eh_get_sense+0x240/0x240
[11367.640815]  kthread+0x11f/0x140
[11367.641384]  ? kthread_park+0x90/0x90
[11367.641863]  ret_from_fork+0x24/0x30
[11367.642436] scsi_tmf_3      I    0   528      2 0x80004000
[11367.642925] Call Trace:
[11367.643374]  ? __schedule+0x31a/0x850
[11367.643823]  schedule+0x36/0xc0
[11367.644383]  rescuer_thread+0x2fd/0x360
[11367.644865]  ? cancel_delayed_work+0xb0/0xb0
[11367.645400]  kthread+0x11f/0x140
[11367.645973]  ? kthread_park+0x90/0x90
[11367.646445]  ret_from_fork+0x24/0x30
[11367.646982] scsi_eh_4       S    0   535      2 0x80004000
[11367.647459] Call Trace:
[11367.648029]  ? __schedule+0x31a/0x850
[11367.648515]  ? scsi_error_handler+0x9a/0x630
[11367.649048]  ? scsi_try_target_reset+0x90/0x90
[11367.649510]  ? scsi_error_handler+0x3b/0x630
[11367.650044]  schedule+0x36/0xc0
[11367.650498]  scsi_error_handler+0x1f5/0x630
[11367.651037]  ? scsi_eh_get_sense+0x240/0x240
[11367.651504]  kthread+0x11f/0x140
[11367.652056]  ? kthread_park+0x90/0x90
[11367.652590]  ret_from_fork+0x24/0x30
[11367.653159] scsi_tmf_4      I    0   536      2 0x80004000
[11367.653609] Call Trace:
[11367.654174]  ? __schedule+0x31a/0x850
[11367.654657]  schedule+0x36/0xc0
[11367.655216]  rescuer_thread+0x2fd/0x360
[11367.655684]  ? cancel_delayed_work+0xb0/0xb0
[11367.656224]  kthread+0x11f/0x140
[11367.656727]  ? kthread_park+0x90/0x90
[11367.657248]  ret_from_fork+0x24/0x30
[11367.657712] scsi_eh_5       S    0   537      2 0x80004000
[11367.658243] Call Trace:
[11367.658739]  ? __schedule+0x31a/0x850
[11367.659270]  ? scsi_error_handler+0x9a/0x630
[11367.659728]  ? scsi_try_target_reset+0x90/0x90
[11367.660278]  ? scsi_error_handler+0x3b/0x630
[11367.660755]  schedule+0x36/0xc0
[11367.661287]  scsi_error_handler+0x1f5/0x630
[11367.661808]  ? scsi_eh_get_sense+0x240/0x240
[11367.662346]  kthread+0x11f/0x140
[11367.662801]  ? kthread_park+0x90/0x90
[11367.663342]  ret_from_fork+0x24/0x30
[11367.663857] scsi_tmf_5      I    0   538      2 0x80004000
[11367.664395] Call Trace:
[11367.664871]  ? __schedule+0x31a/0x850
[11367.665424]  schedule+0x36/0xc0
[11367.665976]  rescuer_thread+0x2fd/0x360
[11367.666445]  ? cancel_delayed_work+0xb0/0xb0
[11367.666973]  kthread+0x11f/0x140
[11367.667468]  ? kthread_park+0x90/0x90
[11367.668010]  ret_from_fork+0x24/0x30
[11367.668492] scsi_eh_6       S    0   539      2 0x80004000
[11367.669026] Call Trace:
[11367.669489]  ? __schedule+0x31a/0x850
[11367.670051]  ? scsi_error_handler+0x9a/0x630
[11367.670495]  ? scsi_try_target_reset+0x90/0x90
[11367.671065]  ? scsi_error_handler+0x3b/0x630
[11367.671523]  schedule+0x36/0xc0
[11367.672071]  scsi_error_handler+0x1f5/0x630
[11367.672608]  ? scsi_eh_get_sense+0x240/0x240
[11367.673142]  kthread+0x11f/0x140
[11367.673594]  ? kthread_park+0x90/0x90
[11367.674208]  ret_from_fork+0x24/0x30
[11367.674712] scsi_tmf_6      I    0   540      2 0x80004000
[11367.675223] Call Trace:
[11367.675704]  ? __schedule+0x31a/0x850
[11367.676252]  schedule+0x36/0xc0
[11367.676728]  rescuer_thread+0x2fd/0x360
[11367.677258]  ? cancel_delayed_work+0xb0/0xb0
[11367.677763]  kthread+0x11f/0x140
[11367.678301]  ? kthread_park+0x90/0x90
[11367.678755]  ret_from_fork+0x24/0x30
[11367.679286] scsi_eh_7       S    0   541      2 0x80004000
[11367.679753] Call Trace:
[11367.680331]  ? __schedule+0x31a/0x850
[11367.680811]  ? scsi_error_handler+0x9a/0x630
[11367.681337]  ? scsi_try_target_reset+0x90/0x90
[11367.681797]  ? scsi_error_handler+0x3b/0x630
[11367.682317]  schedule+0x36/0xc0
[11367.682806]  scsi_error_handler+0x1f5/0x630
[11367.683341]  ? scsi_eh_get_sense+0x240/0x240
[11367.683795]  kthread+0x11f/0x140
[11367.684326]  ? kthread_park+0x90/0x90
[11367.684802]  ret_from_fork+0x24/0x30
[11367.685345] scsi_tmf_7      I    0   542      2 0x80004000
[11367.685790] Call Trace:
[11367.686326]  ? __schedule+0x31a/0x850
[11367.686791]  schedule+0x36/0xc0
[11367.687311]  rescuer_thread+0x2fd/0x360
[11367.687884]  ? cancel_delayed_work+0xb0/0xb0
[11367.688461]  kthread+0x11f/0x140
[11367.689009]  ? kthread_park+0x90/0x90
[11367.689475]  ret_from_fork+0x24/0x30
[11367.690039] scsi_eh_8       S    0   543      2 0x80004000
[11367.690506] Call Trace:
[11367.691039]  ? __schedule+0x31a/0x850
[11367.691502]  ? scsi_error_handler+0x9a/0x630
[11367.692048]  ? scsi_try_target_reset+0x90/0x90
[11367.692530]  ? scsi_error_handler+0x3b/0x630
[11367.693056]  schedule+0x36/0xc0
[11367.693513]  scsi_error_handler+0x1f5/0x630
[11367.694075]  ? scsi_eh_get_sense+0x240/0x240
[11367.694514]  kthread+0x11f/0x140
[11367.695073]  ? kthread_park+0x90/0x90
[11367.695516]  ret_from_fork+0x24/0x30
[11367.696086] scsi_tmf_8      I    0   544      2 0x80004000
[11367.696577] Call Trace:
[11367.697104]  ? __schedule+0x31a/0x850
[11367.697563]  schedule+0x36/0xc0
[11367.698090]  rescuer_thread+0x2fd/0x360
[11367.698579]  ? cancel_delayed_work+0xb0/0xb0
[11367.699092]  kthread+0x11f/0x140
[11367.699551]  ? kthread_park+0x90/0x90
[11367.700118]  ret_from_fork+0x24/0x30
[11367.700579] scsi_eh_9       S    0   545      2 0x80004000
[11367.701143] Call Trace:
[11367.701585]  ? __schedule+0x31a/0x850
[11367.702146]  ? scsi_error_handler+0x9a/0x630
[11367.702616]  ? scsi_try_target_reset+0x90/0x90
[11367.703155]  ? scsi_error_handler+0x3b/0x630
[11367.703610]  schedule+0x36/0xc0
[11367.704147]  scsi_error_handler+0x1f5/0x630
[11367.704629]  ? scsi_eh_get_sense+0x240/0x240
[11367.705156]  kthread+0x11f/0x140
[11367.705619]  ? kthread_park+0x90/0x90
[11367.706242]  ret_from_fork+0x24/0x30
[11367.706739] scsi_tmf_9      I    0   546      2 0x80004000
[11367.707273] Call Trace:
[11367.707733]  ? __schedule+0x31a/0x850
[11367.708275]  schedule+0x36/0xc0
[11367.708750]  rescuer_thread+0x2fd/0x360
[11367.709279]  ? cancel_delayed_work+0xb0/0xb0
[11367.709738]  kthread+0x11f/0x140
[11367.710301]  ? kthread_park+0x90/0x90
[11367.710757]  ret_from_fork+0x24/0x30
[11367.711288] ttm_swap        I    0   554      2 0x80004000
[11367.711756] Call Trace:
[11367.712287]  ? __schedule+0x31a/0x850
[11367.712807]  schedule+0x36/0xc0
[11367.713335]  rescuer_thread+0x2fd/0x360
[11367.713795]  ? cancel_delayed_work+0xb0/0xb0
[11367.714318]  kthread+0x11f/0x140
[11367.714798]  ? kthread_park+0x90/0x90
[11367.715299]  ret_from_fork+0x24/0x30
[11367.715788] kworker/8:1H    I    0   568      2 0x80004000
[11367.716321] Workqueue:  0x0 (kblockd)
[11367.716798] Call Trace:
[11367.717333]  ? __schedule+0x31a/0x850
[11367.717813]  schedule+0x36/0xc0
[11367.718374]  worker_thread+0xc6/0x390
[11367.718831]  ? process_one_work+0x5d0/0x5d0
[11367.719357]  kthread+0x11f/0x140
[11367.719845]  ? kthread_park+0x90/0x90
[11367.720392]  ret_from_fork+0x24/0x30
[11367.720888] kworker/10:1H   I    0   652      2 0x80004000
[11367.721429] Workqueue:  0x0 (ib-comp-wq)
[11367.721955] Call Trace:
[11367.722395]  ? __schedule+0x31a/0x850
[11367.722861]  schedule+0x36/0xc0
[11367.723385]  worker_thread+0xc6/0x390
[11367.723925]  ? process_one_work+0x5d0/0x5d0
[11367.724543]  kthread+0x11f/0x140
[11367.725089]  ? kthread_park+0x90/0x90
[11367.725539]  ret_from_fork+0x24/0x30
[11367.726067] kworker/4:1H    I    0   655      2 0x80004000
[11367.726533] Workqueue:  0x0 (ib-comp-wq)
[11367.727065] Call Trace:
[11367.727536]  ? __schedule+0x31a/0x850
[11367.728107]  schedule+0x36/0xc0
[11367.728631]  worker_thread+0xc6/0x390
[11367.729193]  ? process_one_work+0x5d0/0x5d0
[11367.729653]  kthread+0x11f/0x140
[11367.730238]  ? kthread_park+0x90/0x90
[11367.730705]  ret_from_fork+0x24/0x30
[11367.731234] kdmflush        I    0   656      2 0x80004000
[11367.731699] Call Trace:
[11367.732228]  ? __schedule+0x31a/0x850
[11367.732707]  schedule+0x36/0xc0
[11367.733228]  rescuer_thread+0x2fd/0x360
[11367.733696]  ? cancel_delayed_work+0xb0/0xb0
[11367.734297]  kthread+0x11f/0x140
[11367.734754]  ? kthread_park+0x90/0x90
[11367.735286]  ret_from_fork+0x24/0x30
[11367.735755] kworker/0:1H    I    0   665      2 0x80004000
[11367.736294] Workqueue:  0x0 (ib-comp-wq)
[11367.736770] Call Trace:
[11367.737296]  ? __schedule+0x31a/0x850
[11367.737760]  schedule+0x36/0xc0
[11367.738359]  worker_thread+0xc6/0x390
[11367.738876]  ? process_one_work+0x5d0/0x5d0
[11367.739421]  kthread+0x11f/0x140
[11367.739975]  ? kthread_park+0x90/0x90
[11367.740398]  ret_from_fork+0x24/0x30
[11367.740858] kworker/3:1H    I    0   666      2 0x80004000
[11367.741454] Workqueue:  0x0 (ib-comp-wq)
[11367.741908] Call Trace:
[11367.742331]  ? __schedule+0x31a/0x850
[11367.742785]  schedule+0x36/0xc0
[11367.743344]  worker_thread+0xc6/0x390
[11367.743868]  ? process_one_work+0x5d0/0x5d0
[11367.744463]  kthread+0x11f/0x140
[11367.744992]  ? kthread_park+0x90/0x90
[11367.745465]  ret_from_fork+0x24/0x30
[11367.746013] kdmflush        I    0   667      2 0x80004000
[11367.746477] Call Trace:
[11367.747005]  ? __schedule+0x31a/0x850
[11367.747485]  schedule+0x36/0xc0
[11367.748050]  rescuer_thread+0x2fd/0x360
[11367.748531]  ? cancel_delayed_work+0xb0/0xb0
[11367.749073]  kthread+0x11f/0x140
[11367.749514]  ? kthread_park+0x90/0x90
[11367.750071]  ret_from_fork+0x24/0x30
[11367.750542] kworker/7:1H    I    0   679      2 0x80004000
[11367.751076] Workqueue:  0x0 (ib-comp-wq)
[11367.751534] Call Trace:
[11367.752073]  ? __schedule+0x31a/0x850
[11367.752556]  schedule+0x36/0xc0
[11367.753083]  worker_thread+0xc6/0x390
[11367.753572]  ? process_one_work+0x5d0/0x5d0
[11367.754109]  kthread+0x11f/0x140
[11367.754582]  ? kthread_park+0x90/0x90
[11367.755145]  ret_from_fork+0x24/0x30
[11367.755620] kworker/12:1H   I    0   688      2 0x80004000
[11367.756173] Workqueue:  0x0 (kblockd)
[11367.756658] Call Trace:
[11367.757190]  ? __schedule+0x31a/0x850
[11367.757665]  schedule+0x36/0xc0
[11367.758194]  worker_thread+0xc6/0x390
[11367.758693]  ? process_one_work+0x5d0/0x5d0
[11367.759225]  kthread+0x11f/0x140
[11367.759683]  ? kthread_park+0x90/0x90
[11367.760219]  ret_from_fork+0x24/0x30
[11367.760698] jbd2/dm-0-8     S    0   689      2 0x80004000
[11367.761223] Call Trace:
[11367.761713]  ? __schedule+0x31a/0x850
[11367.762270]  schedule+0x36/0xc0
[11367.762742]  kjournald2+0x222/0x2b0 [jbd2]
[11367.763269]  ? finish_wait+0x80/0x80
[11367.763735]  ? commit_timeout+0x10/0x10 [jbd2]
[11367.764269]  kthread+0x11f/0x140
[11367.764747]  ? kthread_park+0x90/0x90
[11367.765271]  ret_from_fork+0x24/0x30
[11367.765737] ext4-rsv-conver I    0   690      2 0x80004000
[11367.766296] Call Trace:
[11367.766758]  ? __schedule+0x31a/0x850
[11367.767291]  schedule+0x36/0xc0
[11367.767792]  rescuer_thread+0x2fd/0x360
[11367.768336]  ? cancel_delayed_work+0xb0/0xb0
[11367.768814]  kthread+0x11f/0x140
[11367.769343]  ? kthread_park+0x90/0x90
[11367.769802]  ret_from_fork+0x24/0x30
[11367.770360] kworker/1:1H    I    0   747      2 0x80004000
[11367.770869] Workqueue:  0x0 (ib-comp-wq)
[11367.771498] Call Trace:
[11367.772073]  ? __schedule+0x31a/0x850
[11367.772578]  schedule+0x36/0xc0
[11367.773084]  worker_thread+0xc6/0x390
[11367.773580]  ? process_one_work+0x5d0/0x5d0
[11367.774113]  kthread+0x11f/0x140
[11367.774576]  ? kthread_park+0x90/0x90
[11367.775114]  ret_from_fork+0x24/0x30
[11367.775586] kworker/13:1H   I    0   751      2 0x80004000
[11367.776136] Workqueue:  0x0 (kblockd)
[11367.776635] Call Trace:
[11367.777228]  ? __schedule+0x31a/0x850
[11367.777693]  schedule+0x36/0xc0
[11367.778219]  worker_thread+0xc6/0x390
[11367.778684]  ? process_one_work+0x5d0/0x5d0
[11367.779222]  kthread+0x11f/0x140
[11367.779715]  ? kthread_park+0x90/0x90
[11367.780252]  ret_from_fork+0x24/0x30
[11367.780770] kworker/15:1H   I    0   762      2 0x80004000
[11367.781285] Workqueue:  0x0 (kblockd)
[11367.781772] Call Trace:
[11367.782298]  ? __schedule+0x31a/0x850
[11367.782769]  schedule+0x36/0xc0
[11367.783299]  worker_thread+0xc6/0x390
[11367.783773]  ? process_one_work+0x5d0/0x5d0
[11367.784337]  kthread+0x11f/0x140
[11367.784905]  ? kthread_park+0x90/0x90
[11367.785451]  ret_from_fork+0x24/0x30
[11367.785938] kworker/5:1H    S    0   768      2 0x80004000
[11367.786401] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
[11367.786958] Call Trace:
[11367.787446]  ? __schedule+0x31a/0x850
[11367.787988]  schedule+0x36/0xc0
[11367.788488]  iscsit_allocate_cmd+0x246/0x2c0 [iscsi_target_mod]
[11367.789042]  ? finish_wait+0x80/0x80
[11367.789564]  isert_allocate_cmd+0x1d/0x60 [ib_isert]
[11367.790120]  isert_recv_done+0x282/0xa30 [ib_isert]
[11367.790620]  __ib_process_cq+0x76/0xc0 [ib_core]
[11367.791181]  ib_cq_poll_work+0x26/0x80 [ib_core]
[11367.791697]  process_one_work+0x235/0x5d0
[11367.792300]  worker_thread+0x3c/0x390
[11367.792818]  ? process_one_work+0x5d0/0x5d0
[11367.793366]  kthread+0x11f/0x140
[11367.793850]  ? kthread_park+0x90/0x90
[11367.794440]  ret_from_fork+0x24/0x30
[11367.795010] kworker/14:1H   I    0   769      2 0x80004000
[11367.795498] Workqueue:  0x0 (ib-comp-wq)
[11367.796072] Call Trace:
[11367.796555]  ? __schedule+0x31a/0x850
[11367.797134]  schedule+0x36/0xc0
[11367.797591]  worker_thread+0xc6/0x390
[11367.798186]  ? process_one_work+0x5d0/0x5d0
[11367.798696]  kthread+0x11f/0x140
[11367.799278]  ? kthread_park+0x90/0x90
[11367.799758]  ret_from_fork+0x24/0x30
[11367.800318] kworker/9:1H    I    0   771      2 0x80004000
[11367.800859] Workqueue:  0x0 (ib-comp-wq)
[11367.801381] Call Trace:
[11367.801878]  ? __schedule+0x31a/0x850
[11367.802446]  schedule+0x36/0xc0
[11367.802984]  worker_thread+0xc6/0x390
[11367.803485]  ? process_one_work+0x5d0/0x5d0
[11367.804033]  kthread+0x11f/0x140
[11367.804532]  ? kthread_park+0x90/0x90
[11367.805114]  ret_from_fork+0x24/0x30
[11367.805635] kworker/2:1H    I    0   777      2 0x80004000
[11367.806205] Workqueue:  0x0 (ib-comp-wq)
[11367.806681] Call Trace:
[11367.807230]  ? __schedule+0x31a/0x850
[11367.807726]  schedule+0x36/0xc0
[11367.808299]  worker_thread+0xc6/0x390
[11367.808807]  ? process_one_work+0x5d0/0x5d0
[11367.809354]  kthread+0x11f/0x140
[11367.809827]  ? kthread_park+0x90/0x90
[11367.810372]  ret_from_fork+0x24/0x30
[11367.810898] systemd-journal R  running task        0   780      1 0x00000000
[11367.811474] Call Trace:
[11367.811986]  ? __schedule+0x31a/0x850
[11367.812487]  ? __ia32_sys_epoll_ctl+0x580/0x580
[11367.813031]  ? ep_poll+0x2c9/0x5b0
[11367.813510]  ? sched_clock+0x5/0x10
[11367.814072]  schedule+0x36/0xc0
[11367.814518]  ? sched_clock+0x5/0x10
[11367.815084]  schedule_hrtimeout_range_clock+0x104/0x110
[11367.815546]  ? fs_reclaim_acquire.part.101+0x5/0x30
[11367.816130]  ? lockdep_hardirqs_on+0xf0/0x180
[11367.816630]  ? kmem_cache_alloc+0x141/0x2d0
[11367.817189]  ? wake_up_q+0x80/0x80
[11367.817659]  ? vfs_read+0x9e/0x170
[11367.818195]  ? do_epoll_wait+0xd7/0xf0
[11367.818664]  ? do_syscall_64+0x5a/0x240
[11367.819204]  ? entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.819737] systemd-udevd   S    0   796      1 0x00000000
[11367.820299] Call Trace:
[11367.820801]  ? __schedule+0x31a/0x850
[11367.821334]  ? __ia32_sys_epoll_ctl+0x580/0x580
[11367.821873]  ? ep_poll+0x2c9/0x5b0
[11367.822428]  schedule+0x36/0xc0
[11367.822882]  schedule_hrtimeout_range_clock+0x104/0x110
[11367.823341]  ? lockdep_hardirqs_on+0xf0/0x180
[11367.823826]  ep_poll+0x2a9/0x5b0
[11367.824450]  ? do_unlinkat+0x92/0x330
[11367.824987]  ? wake_up_q+0x80/0x80
[11367.825455]  do_epoll_wait+0xd7/0xf0
[11367.825999]  __x64_sys_epoll_wait+0x1a/0x20
[11367.826447]  do_syscall_64+0x5a/0x240
[11367.827008]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.827481] RIP: 0033:0x7ffa9a209463
[11367.828045] Code: Bad RIP value.
[11367.828516] RSP: 002b:00007fff0d28d538 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[11367.829114] RAX: ffffffffffffffda RBX: 000055e35fc67010 RCX: 00007ffa9a209463
[11367.829596] RDX: 0000000000000008 RSI: 00007fff0d28d650 RDI: 000000000000000b
[11367.830215] RBP: 00000000ffffffff R08: 0000000000000001 R09: 00007ffa9b58d8c0
[11367.830734] R10: 00000000ffffffff R11: 0000000000000246 R12: 00000000ffffffff
[11367.831341] R13: 0000000000000004 R14: 0000000000000000 R15: 0000000000000000
[11367.831885] kworker/11:1H   I    0   798      2 0x80004000
[11367.832534] Workqueue:  0x0 (events_highpri)
[11367.833162] Call Trace:
[11367.833669]  ? __schedule+0x31a/0x850
[11367.834290]  schedule+0x36/0xc0
[11367.834797]  worker_thread+0xc6/0x390
[11367.835381]  ? process_one_work+0x5d0/0x5d0
[11367.835901]  kthread+0x11f/0x140
[11367.836551]  ? kthread_park+0x90/0x90
[11367.837168]  ret_from_fork+0x24/0x30
[11367.837670] lvmetad         S    0   801      1 0x00004000
[11367.838281] Call Trace:
[11367.838877]  ? __schedule+0x31a/0x850
[11367.839491]  schedule+0x36/0xc0
[11367.840074]  schedule_hrtimeout_range_clock+0x104/0x110
[11367.840633]  ? lockdep_hardirqs_on+0xf0/0x180
[11367.841196]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11367.841742]  do_select+0x634/0x8b0
[11367.842330]  ? set_fd_set.part.2+0x40/0x40
[11367.842864]  ? __lock_acquire+0x26c/0x1480
[11367.843463]  ? __lock_acquire+0x26c/0x1480
[11367.844004]  ? sched_clock+0x5/0x10
[11367.844531]  ? sched_clock+0x5/0x10
[11367.845102]  ? sched_clock_cpu+0xc/0xc0
[11367.845635]  ? core_sys_select+0x213/0x410
[11367.846257]  core_sys_select+0x213/0x410
[11367.846760]  ? wake_up_new_task+0x204/0x350
[11367.847320]  ? _do_fork+0x102/0x660
[11367.847822]  kern_select+0xb5/0x100
[11367.848381]  __x64_sys_select+0x20/0x30
[11367.848892]  do_syscall_64+0x5a/0x240
[11367.849464]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.849975] RIP: 0033:0x7f7d2d007f73
[11367.850461] Code: Bad RIP value.
[11367.850978] RSP: 002b:00007ffc24a08c70 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11367.851490] RAX: ffffffffffffffda RBX: 00007ffc24a08da0 RCX: 00007f7d2d007f73
[11367.852114] RDX: 0000000000000000 RSI: 00007ffc24a08da0 RDI: 0000000000000400
[11367.852640] RBP: 0000000000000006 R08: 0000000000000000 R09: 00007f7d2a5f1700
[11367.853300] R10: 0000000000000000 R11: 0000000000000293 R12: 00007f7d2d9467b0
[11367.853842] R13: 0000000000000000 R14: 00007ffc24a08ee0 R15: 0000000000000000
[11367.854532] kmpathd         I    0   819      2 0x80004000
[11367.855064] Call Trace:
[11367.855574]  ? __schedule+0x31a/0x850
[11367.856155]  schedule+0x36/0xc0
[11367.856669]  rescuer_thread+0x2fd/0x360
[11367.857240]  ? cancel_delayed_work+0xb0/0xb0
[11367.857742]  kthread+0x11f/0x140
[11367.858325]  ? kthread_park+0x90/0x90
[11367.858806]  ret_from_fork+0x24/0x30
[11367.859356] kmpath_handlerd I    0   820      2 0x80004000
[11367.859879] Call Trace:
[11367.860469]  ? __schedule+0x31a/0x850
[11367.861047]  schedule+0x36/0xc0
[11367.861540]  rescuer_thread+0x2fd/0x360
[11367.862077]  ? cancel_delayed_work+0xb0/0xb0
[11367.862555]  kthread+0x11f/0x140
[11367.863101]  ? kthread_park+0x90/0x90
[11367.863605]  ret_from_fork+0x24/0x30
[11367.864155] kworker/6:1H    I    0   826      2 0x80004000
[11367.864699] Workqueue:  0x0 (ib-comp-wq)
[11367.865253] Call Trace:
[11367.865766]  ? __schedule+0x31a/0x850
[11367.866315]  schedule+0x36/0xc0
[11367.866790]  worker_thread+0xc6/0x390
[11367.867336]  ? process_one_work+0x5d0/0x5d0
[11367.867814]  kthread+0x11f/0x140
[11367.868392]  ? kthread_park+0x90/0x90
[11367.868937]  ret_from_fork+0x24/0x30
[11367.869501] multipathd      S    0   831      1 0x00004000
[11367.869968] Call Trace:
[11367.870455]  ? __schedule+0x31a/0x850
[11367.871022]  schedule+0x36/0xc0
[11367.871548]  futex_wait_queue_me+0xbf/0x150
[11367.872122]  futex_wait+0xe2/0x240
[11367.872639]  ? __lock_acquire+0x26c/0x1480
[11367.873245]  do_futex+0x599/0x930
[11367.873733]  ? sched_clock+0x5/0x10
[11367.874285]  ? sched_clock+0x5/0x10
[11367.874764]  ? sched_clock_cpu+0xc/0xc0
[11367.875315]  __x64_sys_futex+0x134/0x180
[11367.875829]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11367.876383]  do_syscall_64+0x5a/0x240
[11367.876870]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.877417] RIP: 0033:0x7f62c360badb
[11367.877955] Code: Bad RIP value.
[11367.878389] RSP: 002b:00007ffc875e4290 EFLAGS: 00000282 ORIG_RAX: 00000000000000ca
[11367.878867] RAX: ffffffffffffffda RBX: 00000000000000ca RCX: 00007f62c360badb
[11367.879446] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 000055b8f95ca060
[11367.879968] RBP: 000055b8f95ca060 R08: 0000000000000000 R09: 00007f62c214f14d
[11367.880470] R10: 0000000000000000 R11: 0000000000000282 R12: fffffffeffffffff
[11367.881042] R13: 000055b8f9bfaaf0 R14: 00007ffc875e43b0 R15: 00007ffc875e43f0
[11367.881543] multipathd      S    0   832      1 0x00004000
[11367.882118] Call Trace:
[11367.882623]  ? __schedule+0x31a/0x850
[11367.883244]  schedule+0x36/0xc0
[11367.883745]  futex_wait_queue_me+0xbf/0x150
[11367.884349]  futex_wait+0xe2/0x240
[11367.884865]  ? unix_dgram_sendmsg+0x350/0x720
[11367.885452]  do_futex+0x599/0x930
[11367.886006]  ? __sys_connect+0x98/0xf0
[11367.886500]  __x64_sys_futex+0x134/0x180
[11367.887062]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11367.887559]  do_syscall_64+0x5a/0x240
[11367.888134]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.888668] RIP: 0033:0x7f62c3609965
[11367.889291] Code: Bad RIP value.
[11367.889759] RSP: 002b:00007f62c3a38dc0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11367.890375] RAX: ffffffffffffffda RBX: 00007f62c2d46a20 RCX: 00007f62c3609965
[11367.890943] RDX: 0000000000000005 RSI: 0000000000000080 RDI: 00007f62c2d46a64
[11367.891588] RBP: 0000000000000001 R08: 00007f62c2d46a00 R09: 0000000000000002
[11367.892251] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f62c2d469c8
[11367.892787] R13: 00007f62c2d46a60 R14: 0000000000000000 R15: 00007f62c3a39700
[11367.893438] multipathd      S    0   833      1 0x00004000
[11367.894065] Call Trace:
[11367.894594]  ? __schedule+0x31a/0x850
[11367.895236]  schedule+0x36/0xc0
[11367.895777]  schedule_hrtimeout_range_clock+0x104/0x110
[11367.896441]  ? __fget+0x124/0x210
[11367.897077]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11367.897616]  do_sys_poll+0x3af/0x570
[11367.898258]  ? __lock_acquire+0x26c/0x1480
[11367.898865]  ? set_fd_set.part.2+0x40/0x40
[11367.899550]  ? plist_add+0xae/0x110
[11367.900220]  ? sched_clock+0x5/0x10
[11367.900758]  ? sched_clock+0x5/0x10
[11367.901389]  ? sched_clock_cpu+0xc/0xc0
[11367.901908]  ? lockdep_hardirqs_on+0xf0/0x180
[11367.902575]  ? try_to_wake_up+0x297/0x6e0
[11367.903218]  ? wake_up_q+0x3f/0x80
[11367.903771]  ? do_futex+0x328/0x930
[11367.904462]  ? __x64_sys_poll+0x37/0x130
[11367.905004]  __x64_sys_poll+0x37/0x130
[11367.905549]  do_syscall_64+0x5a/0x240
[11367.906179]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.906694] RIP: 0033:0x7f62c21f520d
[11367.907314] Code: Bad RIP value.
[11367.907817] RSP: 002b:00007f62c3a09d70 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11367.908466] RAX: ffffffffffffffda RBX: 00007f62c3a0a660 RCX: 00007f62c21f520d
[11367.909151] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f62c3a09dc0
[11367.909707] RBP: 000000000000001b R08: 0000000000000000 R09: 0000000004000001
[11367.910310] R10: 0000000000000001 R11: 0000000000000293 R12: 0000000000000000
[11367.910954] R13: 00007f62b8004d90 R14: 00007f62b8004280 R15: 000000000000001b
[11367.911590] multipathd      S    0   834      1 0x00000000
[11367.912107] Call Trace:
[11367.912658]  ? __schedule+0x31a/0x850
[11367.913246]  ? hrtimer_start_range_ns+0x1d9/0x320
[11367.913797]  schedule+0x36/0xc0
[11367.914424]  schedule_hrtimeout_range_clock+0x8d/0x110
[11367.915058]  ? hrtimer_init_sleeper+0x100/0x100
[11367.915621]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11367.916231]  do_sys_poll+0x3af/0x570
[11367.916839]  ? __lock_acquire+0x26c/0x1480
[11367.917461]  ? __lock_acquire+0x26c/0x1480
[11367.918060]  ? mark_held_locks+0x50/0x80
[11367.918577]  ? free_unref_page_list+0x212/0x290
[11367.919169]  ? set_fd_set.part.2+0x40/0x40
[11367.919686]  ? mark_held_locks+0x50/0x80
[11367.920273]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11367.920813]  ? lockdep_hardirqs_on+0xf0/0x180
[11367.921428]  ? __lock_acquire+0x26c/0x1480
[11367.922018]  ? __lock_acquire+0x26c/0x1480
[11367.922516]  ? find_held_lock+0x34/0xa0
[11367.923071]  ? sched_clock+0x5/0x10
[11367.923555]  ? sched_clock+0x5/0x10
[11367.924116]  ? sched_clock_cpu+0xc/0xc0
[11367.924601]  ? __x64_sys_ppoll+0xa5/0xe0
[11367.925157]  __x64_sys_ppoll+0xa5/0xe0
[11367.925621]  do_syscall_64+0x5a/0x240
[11367.926161]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.926612] RIP: 0033:0x7f62c21f52cf
[11367.927205] Code: Bad RIP value.
[11367.927700] RSP: 002b:00007f62c3a27c60 EFLAGS: 00000293 ORIG_RAX: 000000000000010f
[11367.928278] RAX: ffffffffffffffda RBX: 00007f62c3a27d30 RCX: 00007f62c21f52cf
[11367.928810] RDX: 00007f62c3a27c80 RSI: 0000000000000001 RDI: 00007f62b00020f0
[11367.929394] RBP: 000055b8f93c26c0 R08: 0000000000000008 R09: 0000000000000000
[11367.929923] R10: 00007f62c3a27d30 R11: 0000000000000293 R12: 0000000000000000
[11367.930549] R13: 0000000000011000 R14: 000055b8f95ca0f8 R15: 00007f62c3a27d00
[11367.931087] multipathd      S    0   835      1 0x00000000
[11367.931630] Call Trace:
[11367.932270]  ? __schedule+0x31a/0x850
[11367.932816]  ? hrtimer_start_range_ns+0x1d9/0x320
[11367.933424]  ? do_nanosleep+0x5b/0x1c0
[11367.934011]  schedule+0x36/0xc0
[11367.934527]  do_nanosleep+0xad/0x1c0
[11367.935113]  hrtimer_nanosleep+0xba/0x150
[11367.935616]  ? hrtimer_init_sleeper+0x100/0x100
[11367.936230]  __x64_sys_nanosleep+0x70/0xa0
[11367.936769]  do_syscall_64+0x5a/0x240
[11367.937356]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.937869] RIP: 0033:0x7f62c21c6e2d
[11367.938465] Code: Bad RIP value.
[11367.938959] RSP: 002b:00007f62c39e8be0 EFLAGS: 00000293 ORIG_RAX: 0000000000000023
[11367.939488] RAX: ffffffffffffffda RBX: 00007f62c39e8c00 RCX: 00007f62c21c6e2d
[11367.940079] RDX: 0000000000000000 RSI: 00007f62c39e8bf0 RDI: 00007f62c39e8bf0
[11367.940620] RBP: 00000000ffffffff R08: 00007f62c39e8d00 R09: 00007f62c39e8b40
[11367.941256] R10: 0000000000000008 R11: 0000000000000293 R12: 00007f62c39e8c80
[11367.941771] R13: 000055b8f9bfb090 R14: 0000000000000001 R15: 000055b8f9bfaaf0
[11367.942374] multipathd      S    0   836      1 0x00004000
[11367.942867] Call Trace:
[11367.943492]  ? __schedule+0x31a/0x850
[11367.944178]  schedule+0x36/0xc0
[11367.944728]  futex_wait_queue_me+0xbf/0x150
[11367.945340]  futex_wait+0xe2/0x240
[11367.945880]  do_futex+0x599/0x930
[11367.946531]  ? dm_ctl_ioctl+0xa/0x10 [dm_mod]
[11367.947026]  ? do_vfs_ioctl+0xa2/0x6e0
[11367.947521]  __x64_sys_futex+0x134/0x180
[11367.948145]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11367.948674]  do_syscall_64+0x5a/0x240
[11367.949312]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11367.949837] RIP: 0033:0x7f62c3609965
[11367.950480] Code: Bad RIP value.
[11367.951112] RSP: 002b:00007f62c39d7d90 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11367.951671] RAX: ffffffffffffffda RBX: 00007f62c2d45710 RCX: 00007f62c3609965
[11367.952316] RDX: 0000000000000015 RSI: 0000000000000080 RDI: 00007f62c2d45f04
[11367.952912] RBP: 00007f62c39d7dc0 R08: 00007f62c2d45f00 R09: 000000000000000a
[11367.953571] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f62c2d45708
[11367.954254] R13: 00007f62c2d469a0 R14: 00007f62c2d46990 R15: 00007f62c39d8700
[11367.954851] kipmi0          S    0  1011      2 0x80004000
[11367.955507] Call Trace:
[11367.956171]  ? __schedule+0x31a/0x850
[11367.956831]  schedule+0x36/0xc0
[11367.957462]  ipmi_thread+0x23d/0x250 [ipmi_si]
[11367.958122]  ? set_run_to_completion+0x20/0x20 [ipmi_si]
[11367.958679]  kthread+0x11f/0x140
[11367.959297]  ? kthread_park+0x90/0x90
[11367.959844]  ret_from_fork+0x24/0x30
[11367.960542] cryptd          I    0  1113      2 0x80004000
[11367.961082] Call Trace:
[11367.961603]  ? __schedule+0x31a/0x850
[11367.962290]  schedule+0x36/0xc0
[11367.962931]  rescuer_thread+0x2fd/0x360
[11367.963590]  ? cancel_delayed_work+0xb0/0xb0
[11367.964239]  kthread+0x11f/0x140
[11367.964803]  ? kthread_park+0x90/0x90
[11367.965431]  ret_from_fork+0x24/0x30
[11367.966046] ib-comp-wq      I    0  1314      2 0x80004000
[11367.966596] Call Trace:
[11367.967210]  ? __schedule+0x31a/0x850
[11367.967751]  schedule+0x36/0xc0
[11367.968352]  rescuer_thread+0x2fd/0x360
[11367.969004]  ? cancel_delayed_work+0xb0/0xb0
[11367.969665]  kthread+0x11f/0x140
[11367.970305]  ? kthread_park+0x90/0x90
[11367.970805]  ret_from_fork+0x24/0x30
[11367.971454] kworker/u33:0   I    0  1315      2 0x80004000
[11367.971966] Workqueue:  0x0 (isert_comp_wq)
[11367.972515] Call Trace:
[11367.973113]  ? __schedule+0x31a/0x850
[11367.973641]  schedule+0x36/0xc0
[11367.974299]  worker_thread+0xc6/0x390
[11367.974916]  ? process_one_work+0x5d0/0x5d0
[11367.975515]  kthread+0x11f/0x140
[11367.976174]  ? kthread_park+0x90/0x90
[11367.976715]  ret_from_fork+0x24/0x30
[11367.977302] ib-comp-unb-wq  I    0  1316      2 0x80004000
[11367.977824] Call Trace:
[11367.978416]  ? __schedule+0x31a/0x850
[11367.979014]  schedule+0x36/0xc0
[11367.979522]  rescuer_thread+0x2fd/0x360
[11367.980123]  ? cancel_delayed_work+0xb0/0xb0
[11367.980690]  kthread+0x11f/0x140
[11367.981297]  ? kthread_park+0x90/0x90
[11367.981782]  ret_from_fork+0x24/0x30
[11367.982380] ib_mcast        I    0  1317      2 0x80004000
[11367.982862] Call Trace:
[11367.983396]  ? __schedule+0x31a/0x850
[11367.983868]  schedule+0x36/0xc0
[11367.984422]  rescuer_thread+0x2fd/0x360
[11367.984962]  ? cancel_delayed_work+0xb0/0xb0
[11367.985426]  kthread+0x11f/0x140
[11367.985963]  ? kthread_park+0x90/0x90
[11367.986433]  ret_from_fork+0x24/0x30
[11367.987010] ib_nl_sa_wq     I    0  1318      2 0x80004000
[11367.987482] Call Trace:
[11367.988033]  ? __schedule+0x31a/0x850
[11367.988504]  schedule+0x36/0xc0
[11367.989048]  rescuer_thread+0x2fd/0x360
[11367.989510]  ? cancel_delayed_work+0xb0/0xb0
[11367.990051]  kthread+0x11f/0x140
[11367.990529]  ? kthread_park+0x90/0x90
[11367.991108]  ret_from_fork+0x24/0x30
[11367.991603] rdma_cm         I    0  1352      2 0x80004000
[11367.992133] Call Trace:
[11367.992617]  ? __schedule+0x31a/0x850
[11367.993195]  schedule+0x36/0xc0
[11367.993647]  rescuer_thread+0x2fd/0x360
[11367.994217]  ? cancel_delayed_work+0xb0/0xb0
[11367.994677]  kthread+0x11f/0x140
[11367.995213]  ? kthread_park+0x90/0x90
[11367.995674]  ret_from_fork+0x24/0x30
[11367.996236] rpciod          I    0  1479      2 0x80004000
[11367.996712] Call Trace:
[11367.997252]  ? __schedule+0x31a/0x850
[11367.997708]  schedule+0x36/0xc0
[11367.998239]  rescuer_thread+0x2fd/0x360
[11367.998686]  ? cancel_delayed_work+0xb0/0xb0
[11367.999228]  kthread+0x11f/0x140
[11367.999681]  ? kthread_park+0x90/0x90
[11368.000233]  ret_from_fork+0x24/0x30
[11368.000737] xprtiod         I    0  1481      2 0x80004000
[11368.001287] Call Trace:
[11368.001745]  ? __schedule+0x31a/0x850
[11368.002285]  schedule+0x36/0xc0
[11368.002784]  rescuer_thread+0x2fd/0x360
[11368.003330]  ? cancel_delayed_work+0xb0/0xb0
[11368.003786]  kthread+0x11f/0x140
[11368.004333]  ? kthread_park+0x90/0x90
[11368.004795]  ret_from_fork+0x24/0x30
[11368.005339] jbd2/sda1-8     S    0  1579      2 0x80004000
[11368.005798] Call Trace:
[11368.006334]  ? __schedule+0x31a/0x850
[11368.006783]  schedule+0x36/0xc0
[11368.007320]  kjournald2+0x222/0x2b0 [jbd2]
[11368.007778]  ? finish_wait+0x80/0x80
[11368.008368]  ? commit_timeout+0x10/0x10 [jbd2]
[11368.008876]  kthread+0x11f/0x140
[11368.009440]  ? kthread_park+0x90/0x90
[11368.009962]  ret_from_fork+0x24/0x30
[11368.010433] ext4-rsv-conver I    0  1580      2 0x80004000
[11368.010974] Call Trace:
[11368.011471]  ? __schedule+0x31a/0x850
[11368.012018]  schedule+0x36/0xc0
[11368.012497]  rescuer_thread+0x2fd/0x360
[11368.013034]  ? cancel_delayed_work+0xb0/0xb0
[11368.013495]  kthread+0x11f/0x140
[11368.014045]  ? kthread_park+0x90/0x90
[11368.014490]  ret_from_fork+0x24/0x30
[11368.015076] target_completi I    0  1591      2 0x80004000
[11368.015549] Call Trace:
[11368.016087]  ? __schedule+0x31a/0x850
[11368.016578]  schedule+0x36/0xc0
[11368.017103]  rescuer_thread+0x2fd/0x360
[11368.017566]  ? cancel_delayed_work+0xb0/0xb0
[11368.018117]  kthread+0x11f/0x140
[11368.018630]  ? kthread_park+0x90/0x90
[11368.019217]  ret_from_fork+0x24/0x30
[11368.019714] xcopy_wq        I    0  1593      2 0x80004000
[11368.020280] Call Trace:
[11368.020766]  ? __schedule+0x31a/0x850
[11368.021296]  schedule+0x36/0xc0
[11368.021826]  rescuer_thread+0x2fd/0x360
[11368.022360]  ? cancel_delayed_work+0xb0/0xb0
[11368.022822]  kthread+0x11f/0x140
[11368.023352]  ? kthread_park+0x90/0x90
[11368.023814]  ret_from_fork+0x24/0x30
[11368.024369] kdmflush        I    0  1618      2 0x80004000
[11368.024878] Call Trace:
[11368.025435]  ? __schedule+0x31a/0x850
[11368.025962]  schedule+0x36/0xc0
[11368.026400]  rescuer_thread+0x2fd/0x360
[11368.026989]  ? cancel_delayed_work+0xb0/0xb0
[11368.027510]  kthread+0x11f/0x140
[11368.028081]  ? kthread_park+0x90/0x90
[11368.028547]  ret_from_fork+0x24/0x30
[11368.029114] kdmflush        I    0  1619      2 0x80004000
[11368.029600] Call Trace:
[11368.030127]  ? __schedule+0x31a/0x850
[11368.030595]  schedule+0x36/0xc0
[11368.031122]  rescuer_thread+0x2fd/0x360
[11368.031620]  ? cancel_delayed_work+0xb0/0xb0
[11368.032155]  kthread+0x11f/0x140
[11368.032633]  ? kthread_park+0x90/0x90
[11368.033223]  ret_from_fork+0x24/0x30
[11368.033701] jbd2/dm-2-8     S    0  1646      2 0x80004000
[11368.034225] Call Trace:
[11368.034720]  ? __schedule+0x31a/0x850
[11368.035270]  schedule+0x36/0xc0
[11368.035744]  kjournald2+0x222/0x2b0 [jbd2]
[11368.036262]  ? finish_wait+0x80/0x80
[11368.036748]  ? commit_timeout+0x10/0x10 [jbd2]
[11368.037273]  kthread+0x11f/0x140
[11368.037726]  ? kthread_park+0x90/0x90
[11368.038263]  ret_from_fork+0x24/0x30
[11368.038714] ext4-rsv-conver I    0  1647      2 0x80004000
[11368.039269] Call Trace:
[11368.039730]  ? __schedule+0x31a/0x850
[11368.040320]  schedule+0x36/0xc0
[11368.040780]  rescuer_thread+0x2fd/0x360
[11368.041324]  ? cancel_delayed_work+0xb0/0xb0
[11368.041781]  kthread+0x11f/0x140
[11368.042306]  ? kthread_park+0x90/0x90
[11368.042784]  ret_from_fork+0x24/0x30
[11368.043361] jbd2/dm-3-8     S    0  1650      2 0x80004000
[11368.043867] Call Trace:
[11368.044426]  ? __schedule+0x31a/0x850
[11368.044967]  schedule+0x36/0xc0
[11368.045446]  kjournald2+0x222/0x2b0 [jbd2]
[11368.045954]  ? finish_wait+0x80/0x80
[11368.046446]  ? commit_timeout+0x10/0x10 [jbd2]
[11368.046979]  kthread+0x11f/0x140
[11368.047503]  ? kthread_park+0x90/0x90
[11368.048025]  ret_from_fork+0x24/0x30
[11368.048567] ext4-rsv-conver I    0  1651      2 0x80004000
[11368.049125] Call Trace:
[11368.049617]  ? __schedule+0x31a/0x850
[11368.050154]  schedule+0x36/0xc0
[11368.050632]  rescuer_thread+0x2fd/0x360
[11368.051145]  ? cancel_delayed_work+0xb0/0xb0
[11368.051627]  kthread+0x11f/0x140
[11368.052152]  ? kthread_park+0x90/0x90
[11368.052641]  ret_from_fork+0x24/0x30
[11368.053219] auditd          S    0  1674      1 0x00000000
[11368.053704] Call Trace:
[11368.054220]  ? __schedule+0x31a/0x850
[11368.054683]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.055217]  ? ep_poll+0x2c9/0x5b0
[11368.055682]  schedule+0x36/0xc0
[11368.056334]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.056867]  ? hrtimer_init_sleeper+0x100/0x100
[11368.057460]  ep_poll+0x2a9/0x5b0
[11368.057938]  ? wake_up_q+0x80/0x80
[11368.058434]  do_epoll_wait+0xd7/0xf0
[11368.058977]  __x64_sys_epoll_wait+0x1a/0x20
[11368.059442]  do_syscall_64+0x5a/0x240
[11368.059995]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.060497] RIP: 0033:0x7fb8e793a483
[11368.061067] Code: Bad RIP value.
[11368.061513] RSP: 002b:00007fff93131190 EFLAGS: 00000293 ORIG_RAX: 00000000000000e8
[11368.062111] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb8e793a483
[11368.062694] RDX: 0000000000000040 RSI: 000055c9f71d9de0 RDI: 000000000000000b
[11368.063369] RBP: 0000000000000000 R08: 0000000000002c54 R09: 00007fff93131210
[11368.063869] R10: 000000000000e95f R11: 0000000000000293 R12: 000055c9f7174e00
[11368.064487] R13: 0000000000000000 R14: 0000000000000000 R15: 000055c9f7174e00
[11368.065100] auditd          S    0  1675      1 0x00000000
[11368.065603] Call Trace:
[11368.066204]  ? __schedule+0x31a/0x850
[11368.066693]  schedule+0x36/0xc0
[11368.067301]  futex_wait_queue_me+0xbf/0x150
[11368.067806]  futex_wait+0xe2/0x240
[11368.068384]  ? __lock_acquire+0x26c/0x1480
[11368.068908]  do_futex+0x599/0x930
[11368.069486]  ? _raw_read_unlock+0x24/0x30
[11368.070082]  ? jbd2_log_wait_commit+0x169/0x1a0 [jbd2]
[11368.070594]  __x64_sys_futex+0x134/0x180
[11368.071169]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.071684]  do_syscall_64+0x5a/0x240
[11368.072277]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.072819] RIP: 0033:0x7fb8e8653965
[11368.073539] Code: Bad RIP value.
[11368.074197] RSP: 002b:00007fb8e6538d10 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.074726] RAX: ffffffffffffffda RBX: 000055c9f7171080 RCX: 00007fb8e8653965
[11368.075332] RDX: 0000000000000011 RSI: 0000000000000080 RDI: 000055c9f7172244
[11368.075870] RBP: 0000000000000000 R08: 000055c9f7172200 R09: 0000000000000008
[11368.076539] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[11368.077219] R13: 0000000000801000 R14: 0000000000000000 R15: 00007fb8e6539700
[11368.077777] audispd         S    0  1676   1674 0x00000000
[11368.078388] Call Trace:
[11368.078926]  ? __schedule+0x31a/0x850
[11368.079563]  schedule+0x36/0xc0
[11368.080199]  futex_wait_queue_me+0xbf/0x150
[11368.080857]  futex_wait+0xe2/0x240
[11368.081471]  ? unix_stream_sendmsg+0x34f/0x3a0
[11368.082104]  do_futex+0x599/0x930
[11368.082665]  ? new_sync_write+0x12a/0x1c0
[11368.083280]  __x64_sys_futex+0x134/0x180
[11368.083819]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.084479]  do_syscall_64+0x5a/0x240
[11368.085134]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.085681] RIP: 0033:0x7fc0b2fdc965
[11368.086294] Code: Bad RIP value.
[11368.086865] RSP: 002b:00007fffa2662ed0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.087514] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fc0b2fdc965
[11368.088178] RDX: 0000000000000321 RSI: 0000000000000080 RDI: 000055f131896144
[11368.088782] RBP: 00007fc0ac0008c0 R08: 000055f131896100 R09: 0000000000000190
[11368.089437] R10: 0000000000000000 R11: 0000000000000246 R12: 00007fffa2662f30
[11368.090152] R13: 0000000000000137 R14: 00007fffa2662f50 R15: 000055f1324471b0
[11368.090730] audispd         S    0  1678   1674 0x00000000
[11368.091355] Call Trace:
[11368.091908]  ? __schedule+0x31a/0x850
[11368.092627]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.093266]  schedule+0x36/0xc0
[11368.093793]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.094483]  ? hrtimer_init_sleeper+0x100/0x100
[11368.095115]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.095693]  do_sys_poll+0x3af/0x570
[11368.096336]  ? __mutex_unlock_slowpath+0x4b/0x2b0
[11368.096929]  ? rcu_read_lock_sched_held+0x52/0x80
[11368.097576]  ? __update_load_avg_se+0x11c/0x350
[11368.098238]  ? __update_load_avg_se+0x2b1/0x350
[11368.098807]  ? set_fd_set.part.2+0x40/0x40
[11368.099466]  ? enqueue_entity+0x109/0x750
[11368.100048]  ? sched_clock+0x5/0x10
[11368.100624]  ? sched_clock+0x5/0x10
[11368.101296]  ? sched_clock_cpu+0xc/0xc0
[11368.101854]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.102484]  ? __lock_acquire+0x26c/0x1480
[11368.103126]  ? sched_clock+0x5/0x10
[11368.103647]  ? sched_clock+0x5/0x10
[11368.104273]  ? sched_clock_cpu+0xc/0xc0
[11368.104838]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.105443]  ? ktime_get_ts64+0xae/0x170
[11368.105997]  ? __x64_sys_poll+0x9e/0x130
[11368.106521]  __x64_sys_poll+0x9e/0x130
[11368.107129]  do_syscall_64+0x5a/0x240
[11368.107638]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.108197] RIP: 0033:0x7fc0b28c820d
[11368.108727] Code: Bad RIP value.
[11368.109279] RSP: 002b:00007fc0b27d3eb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.109795] RAX: ffffffffffffffda RBX: 000055f131896080 RCX: 00007fc0b28c820d
[11368.110418] RDX: 0000000000004e20 RSI: 0000000000000001 RDI: 000055f131896080
[11368.111047] RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000004000001
[11368.111558] R10: 0000000000000001 R11: 0000000000000293 R12: 000055f131896086
[11368.112238] R13: 0000000000801000 R14: 0000000000000000 R15: 00007fc0b27d4700
[11368.112776] sedispatch      S    0  1677   1676 0x00000000
[11368.113389] Call Trace:
[11368.113890]  ? __schedule+0x31a/0x850
[11368.114599]  schedule+0x36/0xc0
[11368.115120]  schedule_timeout+0x204/0x3b0
[11368.115614]  ? sched_clock+0x5/0x10
[11368.116260]  ? sched_clock+0x5/0x10
[11368.116816]  ? sched_clock_cpu+0xc/0xc0
[11368.117386]  unix_stream_read_generic+0x577/0x8a0
[11368.117882]  ? finish_wait+0x80/0x80
[11368.118460]  unix_stream_recvmsg+0x53/0x70
[11368.119011]  ? unix_state_double_unlock+0x30/0x30
[11368.119506]  sock_read_iter+0x97/0xf0
[11368.120088]  new_sync_read+0x127/0x1b0
[11368.120603]  vfs_read+0x9e/0x170
[11368.121135]  ksys_read+0xa7/0xe0
[11368.121611]  do_syscall_64+0x5a/0x240
[11368.122144]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.122606] RIP: 0033:0x7f10f7566f70
[11368.123140] Code: Bad RIP value.
[11368.123589] RSP: 002b:00007ffc88a46018 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[11368.124157] RAX: ffffffffffffffda RBX: 00007f10f783f640 RCX: 00007f10f7566f70
[11368.124673] RDX: 0000000000001000 RSI: 00007f10f8300000 RDI: 0000000000000000
[11368.125293] RBP: 00007f10f783b3a0 R08: 0000000000000001 R09: 0000000000000000
[11368.125803] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f10f783a858
[11368.126374] R13: 0000000000000d70 R14: 0000000000000d70 R15: 00007f10f783a858
[11368.126923] rpcbind         S    0  1702      1 0x00000080
[11368.127502] Call Trace:
[11368.128128]  ? __schedule+0x31a/0x850
[11368.128679]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.129257]  schedule+0x36/0xc0
[11368.129760]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.130366]  ? hrtimer_init_sleeper+0x100/0x100
[11368.130876]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.131509]  do_sys_poll+0x3af/0x570
[11368.132159]  ? __lock_acquire+0x26c/0x1480
[11368.132719]  ? set_fd_set.part.2+0x40/0x40
[11368.133317]  ? set_fd_set.part.2+0x40/0x40
[11368.133884]  ? set_fd_set.part.2+0x40/0x40
[11368.134488]  ? set_fd_set.part.2+0x40/0x40
[11368.135067]  ? set_fd_set.part.2+0x40/0x40
[11368.135572]  ? set_fd_set.part.2+0x40/0x40
[11368.136136]  ? set_fd_set.part.2+0x40/0x40
[11368.136631]  ? sched_clock+0x5/0x10
[11368.137218]  ? sched_clock+0x5/0x10
[11368.137673]  ? sched_clock_cpu+0xc/0xc0
[11368.138202]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.138725]  ? ktime_get_ts64+0xae/0x170
[11368.139237]  ? __x64_sys_poll+0x9e/0x130
[11368.139696]  __x64_sys_poll+0x9e/0x130
[11368.140192]  do_syscall_64+0x5a/0x240
[11368.140670]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.141258] RIP: 0033:0x7fe09248d1f0
[11368.141725] Code: Bad RIP value.
[11368.142215] RSP: 002b:00007fff6ada17c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
[11368.142713] RAX: ffffffffffffffda RBX: 0000000000000007 RCX: 00007fe09248d1f0
[11368.143267] RDX: 0000000000007530 RSI: 0000000000000007 RDI: 00007fff6ada1a10
[11368.143783] RBP: 000000000000000c R08: 000000005e5feed2 R09: 00007fff6ada1710
[11368.144342] R10: 00000000000000c3 R11: 0000000000000246 R12: 0000557baad4e110
[11368.144842] R13: 00007fe092fe94e0 R14: 00007fe092fe893c R15: 0000000000000000
[11368.145419] gssproxy        S    0  1704      1 0x00004080
[11368.145977] Call Trace:
[11368.146508]  ? __schedule+0x31a/0x850
[11368.147050]  ? ep_poll+0x2c9/0x5b0
[11368.147516]  schedule+0x36/0xc0
[11368.148112]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.148603]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.149187]  ep_poll+0x2a9/0x5b0
[11368.149676]  ? wake_up_q+0x80/0x80
[11368.150214]  do_epoll_wait+0xd7/0xf0
[11368.150674]  __x64_sys_epoll_wait+0x1a/0x20
[11368.151222]  do_syscall_64+0x5a/0x240
[11368.151677]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.152222] RIP: 0033:0x7f0172362483
[11368.152730] Code: Bad RIP value.
[11368.153277] RSP: 002b:00007fff6d7c47f0 EFLAGS: 00000293 ORIG_RAX: 00000000000000e8
[11368.153766] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f0172362483
[11368.154326] RDX: 0000000000000020 RSI: 000055cd5c9240a0 RDI: 0000000000000005
[11368.154810] RBP: 000055cd5c923830 R08: 000000005e5fc282 R09: 00007fff6d7c47c0
[11368.155372] R10: 00000000ffffffff R11: 0000000000000293 R12: 000055cd5c92918c
[11368.155898] R13: 000055cd5c929180 R14: 000055cd5c9240a0 R15: 00000000ffffffff
[11368.156519] gssproxy        S    0  1705      1 0x00004080
[11368.157025] Call Trace:
[11368.157526]  ? __schedule+0x31a/0x850
[11368.158071]  schedule+0x36/0xc0
[11368.158566]  futex_wait_queue_me+0xbf/0x150
[11368.159170]  futex_wait+0xe2/0x240
[11368.159709]  do_futex+0x599/0x930
[11368.160297]  ? sched_clock+0x5/0x10
[11368.160808]  ? sched_clock+0x5/0x10
[11368.161416]  ? sched_clock_cpu+0xc/0xc0
[11368.162023]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.162559]  __x64_sys_futex+0x134/0x180
[11368.163210]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.163755]  do_syscall_64+0x5a/0x240
[11368.164347]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.164900] RIP: 0033:0x7f017263c965
[11368.165506] Code: Bad RIP value.
[11368.166131] RSP: 002b:00007f016ac58910 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.166682] RAX: ffffffffffffffda RBX: 000055cd5c925438 RCX: 00007f017263c965
[11368.167307] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 000055cd5c925464
[11368.167870] RBP: 000055cd5c925460 R08: 000055cd5c925400 R09: 0000000000000000
[11368.168556] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f016ac5895f
[11368.169223] R13: 000055cd5c925410 R14: 0000000000000000 R15: 00007f016ac58968
[11368.169802] gssproxy        S    0  1706      1 0x00004080
[11368.170434] Call Trace:
[11368.171058]  ? __schedule+0x31a/0x850
[11368.171611]  schedule+0x36/0xc0
[11368.172249]  futex_wait_queue_me+0xbf/0x150
[11368.172807]  futex_wait+0xe2/0x240
[11368.173436]  do_futex+0x599/0x930
[11368.174067]  ? sched_clock+0x5/0x10
[11368.174598]  ? sched_clock+0x5/0x10
[11368.175201]  ? sched_clock_cpu+0xc/0xc0
[11368.175786]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.176438]  __x64_sys_futex+0x134/0x180
[11368.177029]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.177560]  do_syscall_64+0x5a/0x240
[11368.178196]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.178727] RIP: 0033:0x7f017263c965
[11368.179325] Code: Bad RIP value.
[11368.179842] RSP: 002b:00007f016a457910 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.180513] RAX: ffffffffffffffda RBX: 000055cd5c925738 RCX: 00007f017263c965
[11368.181177] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 000055cd5c925764
[11368.181724] RBP: 000055cd5c925760 R08: 000055cd5c925700 R09: 0000000000000000
[11368.182334] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f016a45795f
[11368.182877] R13: 000055cd5c925710 R14: 0000000000000000 R15: 00007f016a457968
[11368.183517] gssproxy        S    0  1707      1 0x00004080
[11368.184037] Call Trace:
[11368.184595]  ? __schedule+0x31a/0x850
[11368.185228]  schedule+0x36/0xc0
[11368.185760]  futex_wait_queue_me+0xbf/0x150
[11368.186374]  futex_wait+0xe2/0x240
[11368.186875]  ? __lock_acquire+0x26c/0x1480
[11368.187541]  do_futex+0x599/0x930
[11368.188050]  ? sched_clock+0x5/0x10
[11368.188601]  ? sched_clock+0x5/0x10
[11368.189243]  ? sched_clock_cpu+0xc/0xc0
[11368.189776]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.190367]  __x64_sys_futex+0x134/0x180
[11368.190893]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.191511]  do_syscall_64+0x5a/0x240
[11368.192143]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.192690] RIP: 0033:0x7f017263c965
[11368.193271] Code: Bad RIP value.
[11368.193817] RSP: 002b:00007f0169c56910 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.194471] RAX: ffffffffffffffda RBX: 000055cd5c9294c8 RCX: 00007f017263c965
[11368.195025] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 000055cd5c9294f4
[11368.195560] RBP: 000055cd5c9294f0 R08: 000055cd5c929400 R09: 0000000000000000
[11368.196182] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0169c5695f
[11368.196741] R13: 000055cd5c9294a0 R14: 0000000000000000 R15: 00007f0169c56968
[11368.197388] gssproxy        S    0  1708      1 0x00004080
[11368.197918] Call Trace:
[11368.198526]  ? __schedule+0x31a/0x850
[11368.199149]  schedule+0x36/0xc0
[11368.199699]  futex_wait_queue_me+0xbf/0x150
[11368.200322]  futex_wait+0xe2/0x240
[11368.200980]  do_futex+0x599/0x930
[11368.201559]  ? sched_clock+0x5/0x10
[11368.202161]  ? sched_clock+0x5/0x10
[11368.202705]  ? sched_clock_cpu+0xc/0xc0
[11368.203302]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.203831]  __x64_sys_futex+0x134/0x180
[11368.204504]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.205133]  do_syscall_64+0x5a/0x240
[11368.205657]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.206293] RIP: 0033:0x7f017263c965
[11368.206847] Code: Bad RIP value.
[11368.207451] RSP: 002b:00007f0169455910 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.208060] RAX: ffffffffffffffda RBX: 000055cd5c9297c8 RCX: 00007f017263c965
[11368.208653] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 000055cd5c9297f4
[11368.209326] RBP: 000055cd5c9297f0 R08: 000055cd5c929700 R09: 0000000000000000
[11368.209883] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f016945595f
[11368.210502] R13: 000055cd5c9297a0 R14: 0000000000000000 R15: 00007f0169455968
[11368.211158] gssproxy        S    0  1709      1 0x00004080
[11368.211687] Call Trace:
[11368.212285]  ? __schedule+0x31a/0x850
[11368.212865]  schedule+0x36/0xc0
[11368.213468]  futex_wait_queue_me+0xbf/0x150
[11368.214097]  futex_wait+0xe2/0x240
[11368.214674]  do_futex+0x599/0x930
[11368.215300]  ? sched_clock+0x5/0x10
[11368.215821]  ? sched_clock+0x5/0x10
[11368.216436]  ? sched_clock_cpu+0xc/0xc0
[11368.217031]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.217561]  __x64_sys_futex+0x134/0x180
[11368.218157]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.218757]  do_syscall_64+0x5a/0x240
[11368.219356]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.219882] RIP: 0033:0x7f017263c965
[11368.220543] Code: Bad RIP value.
[11368.221173] RSP: 002b:00007f0168c54910 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.221720] RAX: ffffffffffffffda RBX: 000055cd5c929ac8 RCX: 00007f017263c965
[11368.222335] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 000055cd5c929af4
[11368.222871] RBP: 000055cd5c929af0 R08: 000055cd5c929a00 R09: 0000000000000000
[11368.223494] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f0168c5495f
[11368.224167] R13: 000055cd5c929aa0 R14: 0000000000000000 R15: 00007f0168c54968
[11368.224765] accounts-daemon S    0  1712      1 0x00000080
[11368.225365] Call Trace:
[11368.225886]  ? __schedule+0x31a/0x850
[11368.226500]  schedule+0x36/0xc0
[11368.227114]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.227649]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.228270]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.228834]  do_sys_poll+0x3af/0x570
[11368.229509]  ? __lock_acquire+0x26c/0x1480
[11368.230134]  ? __lock_acquire+0x26c/0x1480
[11368.230733]  ? set_fd_set.part.2+0x40/0x40
[11368.231370]  ? __lock_acquire+0x26c/0x1480
[11368.231940]  ? __lock_acquire+0x26c/0x1480
[11368.232633]  ? __lock_acquire+0x26c/0x1480
[11368.233217]  ? sched_clock+0x5/0x10
[11368.233739]  ? sched_clock+0x5/0x10
[11368.234320]  ? sched_clock+0x5/0x10
[11368.234828]  ? sched_clock_cpu+0xc/0xc0
[11368.235451]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.236086]  ? __x64_sys_poll+0x37/0x130
[11368.236605]  __x64_sys_poll+0x37/0x130
[11368.237211]  do_syscall_64+0x5a/0x240
[11368.237683]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.238273] RIP: 0033:0x7fda4e65c20d
[11368.238725] Code: Bad RIP value.
[11368.239283] RSP: 002b:00007ffe198dd670 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.239771] RAX: ffffffffffffffda RBX: 00005618ab210430 RCX: 00007fda4e65c20d
[11368.240341] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00005618ab21cbe0
[11368.240857] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[11368.241474] R10: 00005618ab2104b8 R11: 0000000000000293 R12: 00005618ab21cbe0
[11368.242039] R13: 00000000ffffffff R14: 00007fda4e9908f0 R15: 0000000000000001
[11368.242604] gmain           S    0  1717      1 0x00004080
[11368.243209] Call Trace:
[11368.243723]  ? __schedule+0x31a/0x850
[11368.244322]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.244873]  schedule+0x36/0xc0
[11368.245498]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.246149]  ? hrtimer_init_sleeper+0x100/0x100
[11368.246680]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.247376]  do_sys_poll+0x3af/0x570
[11368.247999]  ? rcu_read_lock_held+0x52/0x60
[11368.248661]  ? __d_lookup_rcu+0x1a1/0x1d0
[11368.249273]  ? rcu_read_lock_held+0x52/0x60
[11368.249804]  ? __d_lookup_rcu+0x1a1/0x1d0
[11368.250359]  ? set_fd_set.part.2+0x40/0x40
[11368.250877]  ? set_fd_set.part.2+0x40/0x40
[11368.251428]  ? __lock_acquire+0x26c/0x1480
[11368.251971]  ? find_held_lock+0x34/0xa0
[11368.252513]  ? __lock_acquire+0x26c/0x1480
[11368.253025]  ? sched_clock+0x5/0x10
[11368.253514]  ? sched_clock+0x5/0x10
[11368.254028]  ? sched_clock_cpu+0xc/0xc0
[11368.254514]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.255034]  ? ktime_get_ts64+0xae/0x170
[11368.255494]  ? __x64_sys_poll+0x9e/0x130
[11368.256022]  __x64_sys_poll+0x9e/0x130
[11368.256493]  do_syscall_64+0x5a/0x240
[11368.257026]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.257469] RIP: 0033:0x7fda4e65c20d
[11368.258024] Code: Bad RIP value.
[11368.258486] RSP: 002b:00007fda44c3ccf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.259061] RAX: ffffffffffffffda RBX: 00005618ab213150 RCX: 00007fda4e65c20d
[11368.259565] RDX: 0000000000000064 RSI: 0000000000000002 RDI: 00007fda400008e0
[11368.260163] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.260721] R10: 00005618ab227d60 R11: 0000000000000293 R12: 00007fda400008e0
[11368.261341] R13: 0000000000000064 R14: 00007fda4e9908f0 R15: 0000000000000002
[11368.261896] gdbus           S    0  1769      1 0x00000080
[11368.262516] Call Trace:
[11368.263153]  ? __schedule+0x31a/0x850
[11368.263697]  schedule+0x36/0xc0
[11368.264299]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.264872]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.265504]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.266022]  do_sys_poll+0x3af/0x570
[11368.266562]  ? rcu_read_lock_sched_held+0x52/0x80
[11368.267163]  ? __update_load_avg_se+0x11c/0x350
[11368.267696]  ? set_fd_set.part.2+0x40/0x40
[11368.268377]  ? set_fd_set.part.2+0x40/0x40
[11368.268928]  ? sched_clock+0x5/0x10
[11368.269525]  ? sched_clock_cpu+0xc/0xc0
[11368.270062]  ? _raw_spin_unlock_irqrestore+0x55/0x60
[11368.270564]  ? __lock_acquire+0x26c/0x1480
[11368.271139]  ? sched_clock+0x5/0x10
[11368.271684]  ? sched_clock_cpu+0xc/0xc0
[11368.272251]  ? sched_clock+0x5/0x10
[11368.272764]  ? sched_clock+0x5/0x10
[11368.273330]  ? sched_clock_cpu+0xc/0xc0
[11368.273800]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.274336]  ? __x64_sys_poll+0x37/0x130
[11368.274874]  __x64_sys_poll+0x37/0x130
[11368.275446]  do_syscall_64+0x5a/0x240
[11368.275954]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.276454] RIP: 0033:0x7fda4e65c20d
[11368.277009] Code: Bad RIP value.
[11368.277492] RSP: 002b:00007fda3f7fdce0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.278040] RAX: ffffffffffffffda RBX: 00007fda3800a350 RCX: 00007fda4e65c20d
[11368.278563] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007fda300010c0
[11368.279133] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.279645] R10: 00007fda3800a3d8 R11: 0000000000000293 R12: 00007fda300010c0
[11368.280251] R13: 00000000ffffffff R14: 00007fda4e9908f0 R15: 0000000000000002
[11368.280841] rngd            S    0  1713      1 0x00004080
[11368.281449] Call Trace:
[11368.282036]  ? __schedule+0x31a/0x850
[11368.282590]  schedule+0x36/0xc0
[11368.283169]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.283707]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.284315]  do_sys_poll+0x3af/0x570
[11368.284877]  ? mark_held_locks+0x50/0x80
[11368.285501]  ? get_page_from_freelist+0x43f/0x1910
[11368.286141]  ? rcu_read_lock_sched_held+0x52/0x80
[11368.286665]  ? __update_load_avg_se+0x11c/0x350
[11368.287309]  ? __update_load_avg_se+0x2b1/0x350
[11368.287821]  ? set_fd_set.part.2+0x40/0x40
[11368.288391]  ? set_fd_set.part.2+0x40/0x40
[11368.288893]  ? sched_clock+0x5/0x10
[11368.289450]  ? sched_clock_cpu+0xc/0xc0
[11368.290063]  ? sched_clock+0x5/0x10
[11368.290551]  ? sched_clock+0x5/0x10
[11368.291082]  ? __lock_acquire+0x26c/0x1480
[11368.291575]  ? sched_clock+0x5/0x10
[11368.292090]  ? sched_clock+0x5/0x10
[11368.292555]  ? sched_clock_cpu+0xc/0xc0
[11368.293082]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.293558]  ? __x64_sys_poll+0x37/0x130
[11368.294087]  __x64_sys_poll+0x37/0x130
[11368.294536]  do_syscall_64+0x5a/0x240
[11368.295060]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.295517] RIP: 0033:0x7f85372141f0
[11368.296047] Code: Bad RIP value.
[11368.296510] RSP: 002b:00007fffe9489bb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
[11368.297054] RAX: ffffffffffffffda RBX: 0000000000605280 RCX: 00007f85372141f0
[11368.297544] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fffe9489bc0
[11368.298112] RBP: 00007fffe948a2a0 R08: 00007fffe948a260 R09: 0000000000000000
[11368.298615] R10: 00007fffe9489620 R11: 0000000000000246 R12: 0000000000000040
[11368.299210] R13: 0000000000000000 R14: 00007fffe948a5a4 R15: 00007fffe9489c20
[11368.299740] ModemManager    S    0  1714      1 0x00000080
[11368.300339] Call Trace:
[11368.300887]  ? __schedule+0x31a/0x850
[11368.301537]  schedule+0x36/0xc0
[11368.302103]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.302617]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.303290]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.303839]  do_sys_poll+0x3af/0x570
[11368.304442]  ? sched_clock+0x5/0x10
[11368.305004]  ? sched_clock+0x5/0x10
[11368.305488]  ? sched_clock+0x5/0x10
[11368.306035]  ? sched_clock_cpu+0xc/0xc0
[11368.306511]  ? _raw_read_unlock_irqrestore+0x55/0x60
[11368.307057]  ? ep_poll_callback+0x375/0x5e0
[11368.307533]  ? set_fd_set.part.2+0x40/0x40
[11368.308070]  ? set_fd_set.part.2+0x40/0x40
[11368.308551]  ? __lock_acquire+0x26c/0x1480
[11368.309089]  ? __lock_acquire+0x26c/0x1480
[11368.309522]  ? sched_clock+0x5/0x10
[11368.310091]  ? sched_clock+0x5/0x10
[11368.310524]  ? sched_clock+0x5/0x10
[11368.311021]  ? sched_clock_cpu+0xc/0xc0
[11368.311447]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.311951]  ? __x64_sys_poll+0x37/0x130
[11368.312359]  __x64_sys_poll+0x37/0x130
[11368.312803]  do_syscall_64+0x5a/0x240
[11368.313311]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.313815] RIP: 0033:0x7fa59bb0a20d
[11368.314324] Code: Bad RIP value.
[11368.314758] RSP: 002b:00007ffec697a640 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.315304] RAX: ffffffffffffffda RBX: 000055fff8a6bdd0 RCX: 00007fa59bb0a20d
[11368.315784] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 000055fff8a71840
[11368.316353] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.316873] R10: 000055fff8a747e0 R11: 0000000000000293 R12: 000055fff8a71840
[11368.317476] R13: 00000000ffffffff R14: 00007fa59c05a8f0 R15: 0000000000000002
[11368.318032] gmain           S    0  1720      1 0x00004080
[11368.318538] Call Trace:
[11368.319128]  ? __schedule+0x31a/0x850
[11368.319622]  schedule+0x36/0xc0
[11368.320252]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.320811]  ? __fget+0x124/0x210
[11368.321483]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.322063]  do_sys_poll+0x3af/0x570
[11368.322567]  ? mark_held_locks+0x50/0x80
[11368.323156]  ? get_page_from_freelist+0x43f/0x1910
[11368.323742]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.324355]  ? prep_new_page+0x7c/0x120
[11368.324855]  ? get_page_from_freelist+0x5b4/0x1910
[11368.325428]  ? set_fd_set.part.2+0x40/0x40
[11368.325989]  ? __lock_acquire+0x26c/0x1480
[11368.326487]  ? mark_held_locks+0x50/0x80
[11368.327024]  ? __lock_acquire+0x26c/0x1480
[11368.327508]  ? __lock_acquire+0x26c/0x1480
[11368.328032]  ? sched_clock+0x5/0x10
[11368.328510]  ? sched_clock+0x5/0x10
[11368.329035]  ? sched_clock+0x5/0x10
[11368.329458]  ? sched_clock_cpu+0xc/0xc0
[11368.329996]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.330464]  ? __x64_sys_poll+0x37/0x130
[11368.330987]  __x64_sys_poll+0x37/0x130
[11368.331427]  do_syscall_64+0x5a/0x240
[11368.331983]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.332458] RIP: 0033:0x7fa59bb0a20d
[11368.333006] Code: Bad RIP value.
[11368.333483] RSP: 002b:00007fa5990ead30 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.334075] RAX: ffffffffffffffda RBX: 000055fff8a6ca20 RCX: 00007fa59bb0a20d
[11368.334577] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fa5940008e0
[11368.335177] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[11368.335709] R10: 000055fff8a6caa8 R11: 0000000000000293 R12: 00007fa5940008e0
[11368.336336] R13: 00000000ffffffff R14: 00007fa59c05a8f0 R15: 0000000000000001
[11368.336908] gdbus           S    0  1768      1 0x00000080
[11368.337575] Call Trace:
[11368.338216]  ? __schedule+0x31a/0x850
[11368.338768]  schedule+0x36/0xc0
[11368.339394]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.340053]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.340715]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.341330]  do_sys_poll+0x3af/0x570
[11368.341901]  ? rcu_read_lock_sched_held+0x52/0x80
[11368.342497]  ? __update_load_avg_se+0x11c/0x350
[11368.343166]  ? set_fd_set.part.2+0x40/0x40
[11368.343684]  ? set_fd_set.part.2+0x40/0x40
[11368.344256]  ? sched_clock+0x5/0x10
[11368.344783]  ? sched_clock_cpu+0xc/0xc0
[11368.345354]  ? _raw_spin_unlock_irqrestore+0x55/0x60
[11368.345945]  ? __lock_acquire+0x26c/0x1480
[11368.346503]  ? sched_clock+0x5/0x10
[11368.347038]  ? sched_clock_cpu+0xc/0xc0
[11368.347540]  ? sched_clock+0x5/0x10
[11368.348073]  ? sched_clock+0x5/0x10
[11368.348571]  ? sched_clock_cpu+0xc/0xc0
[11368.349090]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.349558]  ? __x64_sys_poll+0x37/0x130
[11368.350091]  __x64_sys_poll+0x37/0x130
[11368.350552]  do_syscall_64+0x5a/0x240
[11368.351090]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.351533] RIP: 0033:0x7fa59bb0a20d
[11368.352091] Code: Bad RIP value.
[11368.352565] RSP: 002b:00007fa5937fdd20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.353127] RAX: ffffffffffffffda RBX: 00007fa58c00a310 RCX: 00007fa59bb0a20d
[11368.353621] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007fa5800010c0
[11368.354274] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.354821] R10: 00007fa58c00a398 R11: 0000000000000293 R12: 00007fa5800010c0
[11368.355459] R13: 00000000ffffffff R14: 00007fa59c05a8f0 R15: 0000000000000002
[11368.356113] smartd          S    0  1715      1 0x00000080
[11368.356680] Call Trace:
[11368.357280]  ? __schedule+0x31a/0x850
[11368.357785]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.358427]  ? do_nanosleep+0x5b/0x1c0
[11368.359049]  schedule+0x36/0xc0
[11368.359549]  do_nanosleep+0xad/0x1c0
[11368.360173]  hrtimer_nanosleep+0xba/0x150
[11368.360707]  ? hrtimer_init_sleeper+0x100/0x100
[11368.361291]  __x64_sys_nanosleep+0x70/0xa0
[11368.361813]  do_syscall_64+0x5a/0x240
[11368.362433]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.363035] RIP: 0033:0x7fd1d8326e10
[11368.363514] Code: Bad RIP value.
[11368.364107] RSP: 002b:00007fff70381bd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000023
[11368.364641] RAX: ffffffffffffffda RBX: 00007fff70381bf0 RCX: 00007fd1d8326e10
[11368.365238] RDX: 0000000000000000 RSI: 00007fff70381be0 RDI: 00007fff70381be0
[11368.365741] RBP: 00000000ffffffff R08: 00007fff70381cf0 R09: 00007fff70381b30
[11368.366360] R10: 0000000000000008 R11: 0000000000000246 R12: 00007fff70381c70
[11368.366894] R13: 000000005e5ff3bb R14: 0000000000000014 R15: 000000005e5ff3bb
[11368.367552] alsactl         S    0  1716      1 0x00000080
[11368.368179] Call Trace:
[11368.368722]  ? __schedule+0x31a/0x850
[11368.369335]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.369882]  schedule+0x36/0xc0
[11368.370558]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.371213]  ? hrtimer_init_sleeper+0x100/0x100
[11368.371746]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.372524]  do_sys_poll+0x3af/0x570
[11368.373206]  ? __lock_acquire+0x26c/0x1480
[11368.373733]  ? set_fd_set.part.2+0x40/0x40
[11368.374351]  ? mntput_no_expire+0xb1/0x460
[11368.374951]  ? terminate_walk+0x108/0x150
[11368.375604]  ? task_work_add+0x43/0x50
[11368.376271]  ? fput_many+0x47/0x90
[11368.376833]  ? path_openat+0xbfc/0xc90
[11368.377545]  ? __lock_acquire+0x26c/0x1480
[11368.378189]  ? sched_clock+0x5/0x10
[11368.378730]  ? sched_clock+0x5/0x10
[11368.379335]  ? sched_clock_cpu+0xc/0xc0
[11368.379905]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.380551]  ? ktime_get_ts64+0xae/0x170
[11368.381175]  ? __x64_sys_poll+0x9e/0x130
[11368.381718]  __x64_sys_poll+0x9e/0x130
[11368.382294]  do_syscall_64+0x5a/0x240
[11368.382796]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.383386] RIP: 0033:0x7faa1763d1f0
[11368.383865] Code: Bad RIP value.
[11368.384536] RSP: 002b:00007ffd047dc668 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
[11368.385169] RAX: ffffffffffffffda RBX: 0000000000651440 RCX: 00007faa1763d1f0
[11368.385671] RDX: 00000000000249f0 RSI: 0000000000000001 RDI: 0000000000651440
[11368.386321] RBP: 0000000000000008 R08: 0000000000000000 R09: 0000000000000001
[11368.386933] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000412368
[11368.387589] R13: 0000000000000001 R14: 0000000000000001 R15: 0000000000000001
[11368.388254] udisksd         S    0  1719      1 0x00000080
[11368.388799] Call Trace:
[11368.389392]  ? __schedule+0x31a/0x850
[11368.389929]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.390570]  schedule+0x36/0xc0
[11368.391204]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.391709]  ? hrtimer_init_sleeper+0x100/0x100
[11368.392324]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.392901]  do_sys_poll+0x3af/0x570
[11368.393540]  ? __lock_acquire+0x26c/0x1480
[11368.394041]  ? set_fd_set.part.2+0x40/0x40
[11368.394571]  ? set_fd_set.part.2+0x40/0x40
[11368.395150]  ? set_fd_set.part.2+0x40/0x40
[11368.395644]  ? set_fd_set.part.2+0x40/0x40
[11368.396237]  ? __lock_acquire+0x26c/0x1480
[11368.396754]  ? sched_clock+0x5/0x10
[11368.397276]  ? sched_clock+0x5/0x10
[11368.397773]  ? sched_clock_cpu+0xc/0xc0
[11368.398297]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.398775]  ? ktime_get_ts64+0xae/0x170
[11368.399292]  ? __x64_sys_poll+0x9e/0x130
[11368.399742]  __x64_sys_poll+0x9e/0x130
[11368.400255]  do_syscall_64+0x5a/0x240
[11368.400740]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.401244] RIP: 0033:0x7eff1f2aa20d
[11368.401693] Code: Bad RIP value.
[11368.402210] RSP: 002b:00007ffea8f15890 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.402719] RAX: ffffffffffffffda RBX: 00005635172221c0 RCX: 00007eff1f2aa20d
[11368.403277] RDX: 000000000004d531 RSI: 0000000000000004 RDI: 0000563517273870
[11368.403767] RBP: 0000000000000004 R08: 0000000000000004 R09: 0000000000000000
[11368.404335] R10: 000056351724d860 R11: 0000000000000293 R12: 0000563517273870
[11368.404849] R13: 000000000004d531 R14: 00007eff1f7fa8f0 R15: 0000000000000004
[11368.405483] gmain           S    0  1732      1 0x00000080
[11368.405983] Call Trace:
[11368.406492]  ? __schedule+0x31a/0x850
[11368.407076]  schedule+0x36/0xc0
[11368.407581]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.408217]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.408778]  do_sys_poll+0x3af/0x570
[11368.409395]  ? mark_held_locks+0x50/0x80
[11368.409905]  ? get_page_from_freelist+0x43f/0x1910
[11368.410510]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.411119]  ? prep_new_page+0x7c/0x120
[11368.411615]  ? get_page_from_freelist+0x5b4/0x1910
[11368.412221]  ? set_fd_set.part.2+0x40/0x40
[11368.412739]  ? set_fd_set.part.2+0x40/0x40
[11368.413317]  ? __lock_acquire+0x26c/0x1480
[11368.413878]  ? __lock_acquire+0x26c/0x1480
[11368.414534]  ? sched_clock+0x5/0x10
[11368.415107]  ? sched_clock+0x5/0x10
[11368.415572]  ? sched_clock+0x5/0x10
[11368.416139]  ? sched_clock_cpu+0xc/0xc0
[11368.416612]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.417141]  ? __x64_sys_poll+0x37/0x130
[11368.417590]  __x64_sys_poll+0x37/0x130
[11368.418108]  do_syscall_64+0x5a/0x240
[11368.418550]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.419080] RIP: 0033:0x7eff1f2aa20d
[11368.419507] Code: Bad RIP value.
[11368.420082] RSP: 002b:00007eff1c1efcf0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.420582] RAX: ffffffffffffffda RBX: 00005635172222d0 RCX: 00007eff1f2aa20d
[11368.421148] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007eff140008e0
[11368.421648] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.422225] R10: 00005635172496b0 R11: 0000000000000293 R12: 00007eff140008e0
[11368.422734] R13: 00000000ffffffff R14: 00007eff1f7fa8f0 R15: 0000000000000002
[11368.423344] gdbus           S    0  1767      1 0x00000080
[11368.423884] Call Trace:
[11368.424587]  ? __schedule+0x31a/0x850
[11368.425215]  schedule+0x36/0xc0
[11368.425727]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.426324]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.426845]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.427485]  do_sys_poll+0x3af/0x570
[11368.428108]  ? __lock_acquire+0x26c/0x1480
[11368.428660]  ? unix_stream_read_generic+0x1f5/0x8a0
[11368.429245]  ? set_fd_set.part.2+0x40/0x40
[11368.429785]  ? set_fd_set.part.2+0x40/0x40
[11368.430340]  ? sched_clock+0x5/0x10
[11368.430847]  ? sched_clock_cpu+0xc/0xc0
[11368.431393]  ? _raw_spin_unlock_irqrestore+0x55/0x60
[11368.431881]  ? __lock_acquire+0x26c/0x1480
[11368.432469]  ? sched_clock+0x5/0x10
[11368.433014]  ? sched_clock_cpu+0xc/0xc0
[11368.433492]  ? sched_clock+0x5/0x10
[11368.434040]  ? sched_clock+0x5/0x10
[11368.434497]  ? sched_clock_cpu+0xc/0xc0
[11368.435053]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.435711]  ? __x64_sys_poll+0x37/0x130
[11368.436268]  __x64_sys_poll+0x37/0x130
[11368.436737]  do_syscall_64+0x5a/0x240
[11368.437262]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.437697] RIP: 0033:0x7eff1f2aa20d
[11368.438233] Code: Bad RIP value.
[11368.438682] RSP: 002b:00007eff1b1edce0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.439247] RAX: ffffffffffffffda RBX: 00007eff0c00a310 RCX: 00007eff1f2aa20d
[11368.439722] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007eff100010c0
[11368.440312] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.440873] R10: 00007eff0c00a398 R11: 0000000000000293 R12: 00007eff100010c0
[11368.441553] R13: 00000000ffffffff R14: 00007eff1f7fa8f0 R15: 0000000000000002
[11368.442090] probing-thread  S    0  1791      1 0x00000080
[11368.442631] Call Trace:
[11368.443256]  ? __schedule+0x31a/0x850
[11368.443786]  schedule+0x36/0xc0
[11368.444378]  futex_wait_queue_me+0xbf/0x150
[11368.444919]  futex_wait+0xe2/0x240
[11368.445557]  ? _raw_spin_unlock_irqrestore+0x55/0x60
[11368.446213]  do_futex+0x599/0x930
[11368.446719]  ? sched_clock+0x5/0x10
[11368.447289]  ? sched_clock+0x5/0x10
[11368.447775]  ? sched_clock_cpu+0xc/0xc0
[11368.448339]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.448846]  __x64_sys_futex+0x134/0x180
[11368.449443]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.450004]  do_syscall_64+0x5a/0x240
[11368.450461]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.451049] RIP: 0033:0x7eff1f2af1c9
[11368.451546] Code: Bad RIP value.
[11368.452152] RSP: 002b:00007eff0aa34cf8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.452674] RAX: ffffffffffffffda RBX: 000056351724d8f0 RCX: 00007eff1f2af1c9
[11368.453249] RDX: 000000000000000a RSI: 0000000000000080 RDI: 000056351724d900
[11368.453752] RBP: 000000000000000a R08: 0000000000000000 R09: 000056351724d908
[11368.454325] R10: 0000000000000000 R11: 0000000000000246 R12: 000056351724d900
[11368.454822] R13: 0000000000000001 R14: 000056351724d8f8 R15: 00007eff0aa35700
[11368.455458] cleanup         S    0  1792      1 0x00004080
[11368.455960] Call Trace:
[11368.456459]  ? __schedule+0x31a/0x850
[11368.457093]  schedule+0x36/0xc0
[11368.457656]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.458273]  ? __fget+0x124/0x210
[11368.458818]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.459426]  do_sys_poll+0x3af/0x570
[11368.460040]  ? __lock_acquire+0x26c/0x1480
[11368.460598]  ? set_fd_set.part.2+0x40/0x40
[11368.461212]  ? mntput_no_expire+0xb1/0x460
[11368.461730]  ? terminate_walk+0x108/0x150
[11368.462342]  ? task_work_add+0x43/0x50
[11368.462870]  ? fput_many+0x47/0x90
[11368.463487]  ? path_openat+0xbfc/0xc90
[11368.464098]  ? __lock_acquire+0x26c/0x1480
[11368.464643]  ? __lock_acquire+0x26c/0x1480
[11368.465264]  ? sched_clock+0x5/0x10
[11368.465769]  ? sched_clock+0x5/0x10
[11368.466327]  ? sched_clock_cpu+0xc/0xc0
[11368.466815]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.467383]  ? __x64_sys_poll+0x37/0x130
[11368.467846]  __x64_sys_poll+0x37/0x130
[11368.468453]  do_syscall_64+0x5a/0x240
[11368.468974]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.469453] RIP: 0033:0x7eff1f2aa20d
[11368.470038] Code: Bad RIP value.
[11368.470521] RSP: 002b:00007eff0a233ce0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.471091] RAX: ffffffffffffffda RBX: 000056351725e2a0 RCX: 00007eff1f2aa20d
[11368.471594] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007eff040008c0
[11368.472181] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[11368.472705] R10: 000056351725e328 R11: 0000000000000293 R12: 00007eff040008c0
[11368.473291] R13: 00000000ffffffff R14: 00007eff1f7fa8f0 R15: 0000000000000001
[11368.473935] rtkit-daemon    S    0  1722      1 0x00004080
[11368.474576] Call Trace:
[11368.475195]  ? __schedule+0x31a/0x850
[11368.475755]  schedule+0x36/0xc0
[11368.476433]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.477010]  ? __fget+0x124/0x210
[11368.477554]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.478150]  do_sys_poll+0x3af/0x570
[11368.478715]  ? __lock_acquire+0x26c/0x1480
[11368.479298]  ? __lock_acquire+0x26c/0x1480
[11368.479841]  ? find_held_lock+0x34/0xa0
[11368.480395]  ? set_fd_set.part.2+0x40/0x40
[11368.480926]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.481497]  ? __lock_acquire+0x26c/0x1480
[11368.482092]  ? __lock_acquire+0x26c/0x1480
[11368.482612]  ? __lock_acquire+0x26c/0x1480
[11368.483172]  ? __lock_acquire+0x26c/0x1480
[11368.483658]  ? sched_clock+0x5/0x10
[11368.484170]  ? sched_clock+0x5/0x10
[11368.484659]  ? sched_clock_cpu+0xc/0xc0
[11368.485154]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.485701]  ? __x64_sys_poll+0x37/0x130
[11368.486233]  __x64_sys_poll+0x37/0x130
[11368.486694]  do_syscall_64+0x5a/0x240
[11368.487195]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.487641] RIP: 0033:0x7f3c8bfd220d
[11368.488167] Code: Bad RIP value.
[11368.488629] RSP: 002b:00007ffc40064860 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.489223] RAX: ffffffffffffffda RBX: 000055d6dd86d710 RCX: 00007f3c8bfd220d
[11368.489719] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007ffc40064880
[11368.490290] RBP: 00000000ffffffff R08: 0000000000000000 R09: 000055d6dd871540
[11368.490843] R10: 0000000000000003 R11: 0000000000000293 R12: 00007ffc40064880
[11368.491424] R13: 000055d6dd86d710 R14: 0000000000000006 R15: 0000000000000004
[11368.492021] rtkit-daemon    S    0  1772      1 0x00000080
[11368.492550] Call Trace:
[11368.493127]  ? __schedule+0x31a/0x850
[11368.493638]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.494271]  schedule+0x36/0xc0
[11368.494757]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.495366]  ? hrtimer_init_sleeper+0x100/0x100
[11368.495899]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.496542]  do_sys_poll+0x3af/0x570
[11368.497146]  ? __lock_acquire+0x26c/0x1480
[11368.497650]  ? __lock_acquire+0x26c/0x1480
[11368.498221]  ? sched_clock_cpu+0xc/0xc0
[11368.498709]  ? find_held_lock+0x34/0xa0
[11368.499273]  ? set_fd_set.part.2+0x40/0x40
[11368.499735]  ? plist_add+0xae/0x110
[11368.500290]  ? sched_clock+0x5/0x10
[11368.500768]  ? sched_clock+0x5/0x10
[11368.501302]  ? sched_clock_cpu+0xc/0xc0
[11368.501783]  ? _raw_spin_unlock_irqrestore+0x55/0x60
[11368.502335]  ? __lock_acquire+0x26c/0x1480
[11368.502799]  ? sched_clock+0x5/0x10
[11368.503329]  ? sched_clock+0x5/0x10
[11368.503749]  ? sched_clock_cpu+0xc/0xc0
[11368.504279]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.504740]  ? ktime_get_ts64+0xae/0x170
[11368.505264]  ? __x64_sys_poll+0x9e/0x130
[11368.505752]  __x64_sys_poll+0x9e/0x130
[11368.506276]  do_syscall_64+0x5a/0x240
[11368.506816]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.507337] RIP: 0033:0x7f3c8bfd220d
[11368.507793] Code: Bad RIP value.
[11368.508365] RSP: 002b:00007f3c89986d50 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.508892] RAX: ffffffffffffffda RBX: 431bde82d7b634db RCX: 00007f3c8bfd220d
[11368.509463] RDX: 0000000000001388 RSI: 0000000000000001 RDI: 00007f3c89986d70
[11368.510078] RBP: 0000000036fc70ba R08: 0000000000ad5ae8 R09: 0000000000ad5ae8
[11368.510592] R10: 00007f3c89986d30 R11: 0000000000000293 R12: 0000000000002c61
[11368.511183] R13: 00007f3c89986d80 R14: 0000000000ad5e82 R15: 0000000000000000
[11368.511789] rtkit-daemon    S    0  1773      1 0x00000080
[11368.512391] Call Trace:
[11368.512919]  ? __schedule+0x31a/0x850
[11368.513523]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.514209]  schedule+0x36/0xc0
[11368.514725]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.515298]  ? hrtimer_init_sleeper+0x100/0x100
[11368.515799]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.516378]  do_sys_poll+0x3af/0x570
[11368.516904]  ? find_held_lock+0x34/0xa0
[11368.517543]  ? sched_clock+0x5/0x10
[11368.518129]  ? sched_clock+0x5/0x10
[11368.518622]  ? sched_clock_cpu+0xc/0xc0
[11368.519208]  ? _raw_read_unlock_irqrestore+0x55/0x60
[11368.519690]  ? ep_poll_callback+0x375/0x5e0
[11368.520249]  ? set_fd_set.part.2+0x40/0x40
[11368.520747]  ? set_fd_set.part.2+0x40/0x40
[11368.521301]  ? __lock_acquire+0x26c/0x1480
[11368.521758]  ? __lock_acquire+0x26c/0x1480
[11368.522297]  ? sched_clock+0x5/0x10
[11368.522745]  ? sched_clock+0x5/0x10
[11368.523308]  ? sched_clock_cpu+0xc/0xc0
[11368.523785]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.524330]  ? ktime_get_ts64+0xae/0x170
[11368.524800]  ? __x64_sys_poll+0x9e/0x130
[11368.525328]  __x64_sys_poll+0x9e/0x130
[11368.525765]  do_syscall_64+0x5a/0x240
[11368.526304]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.526804] RIP: 0033:0x7f3c8bfd220d
[11368.527337] Code: Bad RIP value.
[11368.527803] RSP: 002b:00007f3c89185d30 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.528362] RAX: ffffffffffffffda RBX: 0000000036fd2e19 RCX: 00007f3c8bfd220d
[11368.528880] RDX: 0000000000002710 RSI: 0000000000000002 RDI: 00007f3c89185d80
[11368.529477] RBP: 431bde82d7b634db R08: 0000000000002c61 R09: 00007f3c89185d70
[11368.530111] R10: 00007f3c89185d10 R11: 0000000000000293 R12: 0000000000ad5e82
[11368.530633] R13: 0000000000000001 R14: 0000000000002c61 R15: 00007f3c89185d70
[11368.531249] lsmd            S    0  1723      1 0x00000080
[11368.531769] Call Trace:
[11368.532359]  ? __schedule+0x31a/0x850
[11368.532891]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.533522]  schedule+0x36/0xc0
[11368.534059]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.534558]  ? hrtimer_init_sleeper+0x100/0x100
[11368.535171]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.535658]  do_select+0x634/0x8b0
[11368.536324]  ? set_fd_set.part.2+0x40/0x40
[11368.536844]  ? set_fd_set.part.2+0x40/0x40
[11368.537425]  ? mark_held_locks+0x50/0x80
[11368.537981]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11368.538466]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.539024]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11368.539551]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.540122]  ? __lock_acquire+0x26c/0x1480
[11368.540625]  ? __lock_acquire+0x26c/0x1480
[11368.541168]  ? sched_clock+0x5/0x10
[11368.541645]  ? sched_clock+0x5/0x10
[11368.542272]  ? sched_clock_cpu+0xc/0xc0
[11368.542745]  ? core_sys_select+0x213/0x410
[11368.543264]  core_sys_select+0x213/0x410
[11368.543742]  ? sched_clock+0x5/0x10
[11368.544271]  ? sched_clock+0x5/0x10
[11368.544775]  ? sched_clock_cpu+0xc/0xc0
[11368.545293]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.545784]  ? ktime_get_ts64+0xae/0x170
[11368.546330]  kern_select+0xb5/0x100
[11368.546812]  __x64_sys_select+0x20/0x30
[11368.547331]  do_syscall_64+0x5a/0x240
[11368.547794]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.548438] RIP: 0033:0x7f625bbb6f53
[11368.548961] Code: Bad RIP value.
[11368.549467] RSP: 002b:00007ffdf9a09e78 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[11368.550043] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f625bbb6f53
[11368.550553] RDX: 0000000000000000 RSI: 00007ffdf9a09e90 RDI: 0000000000000006
[11368.551144] RBP: 00007ffdf9a09e90 R08: 00007ffdf9a09e80 R09: 0000000000000000
[11368.551662] R10: 0000000000000000 R11: 0000000000000246 R12: 000055e6cf2fd0f8
[11368.552342] R13: 00007ffdf9a09e80 R14: 0000000000000001 R15: 0000000000000006
[11368.552892] systemd-logind  S    0  1729      1 0x00000080
[11368.553496] Call Trace:
[11368.554103]  ? __schedule+0x31a/0x850
[11368.554626]  ? __ia32_sys_epoll_ctl+0x580/0x580
[11368.555176]  ? ep_poll+0x2c9/0x5b0
[11368.555688]  schedule+0x36/0xc0
[11368.556266]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.556801]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.557343]  ep_poll+0x2a9/0x5b0
[11368.557831]  ? wake_up_q+0x80/0x80
[11368.558381]  do_epoll_wait+0xd7/0xf0
[11368.558859]  __x64_sys_epoll_wait+0x1a/0x20
[11368.559432]  do_syscall_64+0x5a/0x240
[11368.560001]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.560499] RIP: 0033:0x7f237fd6f463
[11368.561044] Code: Bad RIP value.
[11368.561508] RSP: 002b:00007ffcc0ca0128 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[11368.562082] RAX: ffffffffffffffda RBX: 00007ffcc0ca0130 RCX: 00007f237fd6f463
[11368.562589] RDX: 0000000000000011 RSI: 00007ffcc0ca0130 RDI: 0000000000000004
[11368.563179] RBP: 00007ffcc0ca02f0 R08: 0000000000000000 R09: 00000000c0ca0100
[11368.563696] R10: 00000000ffffffff R11: 0000000000000246 R12: 0000000000000001
[11368.564315] R13: ffffffffffffffff R14: 0000000000000000 R15: 000055c590d38210
[11368.564871] avahi-daemon    S    0  1735      1 0x00000080
[11368.565468] Call Trace:
[11368.566047]  ? __schedule+0x31a/0x850
[11368.566567]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.567168]  schedule+0x36/0xc0
[11368.567698]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.568354]  ? hrtimer_init_sleeper+0x100/0x100
[11368.568955]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.569584]  do_sys_poll+0x3af/0x570
[11368.570231]  ? __mutex_unlock_slowpath+0x4b/0x2b0
[11368.570798]  ? __lock_acquire+0x26c/0x1480
[11368.571459]  ? set_fd_set.part.2+0x40/0x40
[11368.572119]  ? set_fd_set.part.2+0x40/0x40
[11368.572703]  ? set_fd_set.part.2+0x40/0x40
[11368.573376]  ? set_fd_set.part.2+0x40/0x40
[11368.573939]  ? set_fd_set.part.2+0x40/0x40
[11368.574614]  ? set_fd_set.part.2+0x40/0x40
[11368.575232]  ? set_fd_set.part.2+0x40/0x40
[11368.575748]  ? set_fd_set.part.2+0x40/0x40
[11368.576330]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.576847]  ? ktime_get_ts64+0xae/0x170
[11368.577452]  ? __x64_sys_poll+0x9e/0x130
[11368.577970]  __x64_sys_poll+0x9e/0x130
[11368.578434]  do_syscall_64+0x5a/0x240
[11368.579012]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.579472] RIP: 0033:0x7f725f6f21f0
[11368.580049] Code: Bad RIP value.
[11368.580533] RSP: 002b:00007ffcbf58b2b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
[11368.581098] RAX: ffffffffffffffda RBX: 000055e74f665140 RCX: 00007f725f6f21f0
[11368.581594] RDX: 0000000000023a68 RSI: 0000000000000008 RDI: 000055e74f686230
[11368.582174] RBP: 00007f7260ca47f0 R08: 000000005e5fee4f R09: 00007ffcbf58b250
[11368.582680] R10: 00007ffcbf58b250 R11: 0000000000000246 R12: 000055e74f6665a0
[11368.583265] R13: 000055e74f665140 R14: 000055e74f6651f0 R15: 0000000000000000
[11368.583837] polkitd         S    0  1737      1 0x00000080
[11368.584511] Call Trace:
[11368.585120]  ? __schedule+0x31a/0x850
[11368.585638]  schedule+0x36/0xc0
[11368.586280]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.586838]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.587432]  do_sys_poll+0x3af/0x570
[11368.588035]  ? __lock_acquire+0x26c/0x1480
[11368.588579]  ? set_fd_set.part.2+0x40/0x40
[11368.589152]  ? set_fd_set.part.2+0x40/0x40
[11368.589680]  ? __lock_acquire+0x26c/0x1480
[11368.590300]  ? __lock_acquire+0x26c/0x1480
[11368.590795]  ? __lock_acquire+0x26c/0x1480
[11368.591329]  ? sched_clock+0x5/0x10
[11368.591788]  ? sched_clock+0x5/0x10
[11368.592305]  ? sched_clock+0x5/0x10
[11368.592755]  ? sched_clock_cpu+0xc/0xc0
[11368.593256]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.593708]  ? __x64_sys_poll+0x37/0x130
[11368.594240]  __x64_sys_poll+0x37/0x130
[11368.594729]  do_syscall_64+0x5a/0x240
[11368.595252]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.595700] RIP: 0033:0x7f7cb75d720d
[11368.596224] Code: Bad RIP value.
[11368.596668] RSP: 002b:00007ffee48ca930 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.597214] RAX: ffffffffffffffda RBX: 000055e7e987d970 RCX: 00007f7cb75d720d
[11368.597663] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 000055e7e98b9aa0
[11368.598204] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.598674] R10: 000055e7e988fe10 R11: 0000000000000293 R12: 000055e7e98b9aa0
[11368.599233] R13: 00000000ffffffff R14: 00007f7cb85678f0 R15: 0000000000000002
[11368.599809] gmain           S    0  1766      1 0x00004080
[11368.600378] Call Trace:
[11368.600897]  ? __schedule+0x31a/0x850
[11368.601512]  schedule+0x36/0xc0
[11368.602138]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.602667]  ? __fget+0x124/0x210
[11368.603252]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.603775]  do_sys_poll+0x3af/0x570
[11368.604385]  ? mark_held_locks+0x50/0x80
[11368.604923]  ? get_page_from_freelist+0x43f/0x1910
[11368.605539]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.606185]  ? prep_new_page+0x7c/0x120
[11368.606703]  ? get_page_from_freelist+0x5b4/0x1910
[11368.607364]  ? set_fd_set.part.2+0x40/0x40
[11368.607904]  ? set_fd_set.part.2+0x40/0x40
[11368.608501]  ? mark_held_locks+0x50/0x80
[11368.609082]  ? __lock_acquire+0x26c/0x1480
[11368.609570]  ? __lock_acquire+0x26c/0x1480
[11368.610143]  ? sched_clock+0x5/0x10
[11368.610630]  ? sched_clock+0x5/0x10
[11368.611169]  ? sched_clock+0x5/0x10
[11368.611631]  ? sched_clock_cpu+0xc/0xc0
[11368.612132]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.612619]  ? __x64_sys_poll+0x37/0x130
[11368.613102]  __x64_sys_poll+0x37/0x130
[11368.613569]  do_syscall_64+0x5a/0x240
[11368.614081]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.614530] RIP: 0033:0x7f7cb75d720d
[11368.615054] Code: Bad RIP value.
[11368.615513] RSP: 002b:00007f7cb37c4cb0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.616110] RAX: ffffffffffffffda RBX: 000055e7e987bec0 RCX: 00007f7cb75d720d
[11368.616619] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f7cac0008e0
[11368.617207] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.617724] R10: 000055e7e987bf48 R11: 0000000000000293 R12: 00007f7cac0008e0
[11368.618315] R13: 00000000ffffffff R14: 00007f7cb85678f0 R15: 0000000000000002
[11368.618854] gdbus           S    0  1770      1 0x00000080
[11368.619461] Call Trace:
[11368.620065]  ? __schedule+0x31a/0x850
[11368.620609]  schedule+0x36/0xc0
[11368.621194]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.621791]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.622381]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.622901]  do_sys_poll+0x3af/0x570
[11368.623556]  ? rcu_read_lock_sched_held+0x52/0x80
[11368.624048]  ? __update_load_avg_cfs_rq+0x12b/0x330
[11368.624568]  ? set_fd_set.part.2+0x40/0x40
[11368.625180]  ? set_fd_set.part.2+0x40/0x40
[11368.625660]  ? sched_clock+0x5/0x10
[11368.626276]  ? sched_clock_cpu+0xc/0xc0
[11368.626773]  ? _raw_spin_unlock_irqrestore+0x55/0x60
[11368.627329]  ? __lock_acquire+0x26c/0x1480
[11368.627817]  ? sched_clock+0x5/0x10
[11368.628373]  ? sched_clock_cpu+0xc/0xc0
[11368.628870]  ? sched_clock+0x5/0x10
[11368.629419]  ? sched_clock+0x5/0x10
[11368.629956]  ? sched_clock_cpu+0xc/0xc0
[11368.630397]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.630864]  ? __x64_sys_poll+0x37/0x130
[11368.631383]  __x64_sys_poll+0x37/0x130
[11368.631885]  do_syscall_64+0x5a/0x240
[11368.632492]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.633014] RIP: 0033:0x7f7cb75d720d
[11368.633474] Code: Bad RIP value.
[11368.634004] RSP: 002b:00007f7cb2fc3ca0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.634490] RAX: ffffffffffffffda RBX: 000055e7e9873fa0 RCX: 00007f7cb75d720d
[11368.635066] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007f7ca40010c0
[11368.635586] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.636206] R10: 000055e7e9874028 R11: 0000000000000293 R12: 00007f7ca40010c0
[11368.636727] R13: 00000000ffffffff R14: 00007f7cb85678f0 R15: 0000000000000002
[11368.637357] JS GC Helper    S    0  1771      1 0x00004080
[11368.637950] Call Trace:
[11368.638577]  ? __schedule+0x31a/0x850
[11368.639198]  schedule+0x36/0xc0
[11368.639728]  futex_wait_queue_me+0xbf/0x150
[11368.640396]  futex_wait+0xe2/0x240
[11368.640943]  ? mem_cgroup_commit_charge+0x68/0x4b0
[11368.641555]  ? sched_clock+0x5/0x10
[11368.642053]  ? sched_clock+0x5/0x10
[11368.642547]  ? sched_clock_cpu+0xc/0xc0
[11368.643126]  do_futex+0x599/0x930
[11368.643628]  ? sched_clock+0x5/0x10
[11368.644246]  ? sched_clock+0x5/0x10
[11368.644740]  ? sched_clock_cpu+0xc/0xc0
[11368.645270]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.645737]  __x64_sys_futex+0x134/0x180
[11368.646269]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.646740]  do_syscall_64+0x5a/0x240
[11368.647274]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.647750] RIP: 0033:0x7f7cb78bc965
[11368.648313] Code: Bad RIP value.
[11368.648866] RSP: 002b:00007f7cb27c2c90 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.649426] RAX: ffffffffffffffda RBX: 000055e7e989b410 RCX: 00007f7cb78bc965
[11368.649992] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 000055e7e989b37c
[11368.650481] RBP: 000055e7e989b370 R08: 000055e7e989b200 R09: 0000000000000000
[11368.651059] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
[11368.651579] R13: 00007f7cb7dfa738 R14: 00007f7cb91de010 R15: 00007f7cb27c3700
[11368.652251] JS Sour~ Thread S    0  1774      1 0x00004080
[11368.652765] Call Trace:
[11368.653398]  ? __schedule+0x31a/0x850
[11368.654088]  schedule+0x36/0xc0
[11368.654580]  futex_wait_queue_me+0xbf/0x150
[11368.655237]  futex_wait+0xe2/0x240
[11368.655740]  ? mem_cgroup_commit_charge+0x68/0x4b0
[11368.656368]  ? get_futex_key+0x505/0x6e0
[11368.656930]  ? sched_clock_cpu+0xc/0xc0
[11368.657553]  do_futex+0x599/0x930
[11368.658171]  ? sched_clock+0x5/0x10
[11368.658712]  ? sched_clock+0x5/0x10
[11368.659278]  ? sched_clock_cpu+0xc/0xc0
[11368.659814]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.660382]  __x64_sys_futex+0x134/0x180
[11368.660928]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.661494]  do_syscall_64+0x5a/0x240
[11368.662069]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.662568] RIP: 0033:0x7f7cb78bc965
[11368.663136] Code: Bad RIP value.
[11368.663637] RSP: 002b:00007f7cb1bc1cc0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.664281] RAX: ffffffffffffffda RBX: 000055e7e98a56e0 RCX: 00007f7cb78bc965
[11368.664822] RDX: 0000000000000013 RSI: 0000000000000080 RDI: 000055e7e98a564c
[11368.665421] RBP: 000055e7e98a5640 R08: 000055e7e98a5500 R09: 0000000000000009
[11368.666066] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
[11368.666592] R13: 00000000000006ee R14: 00007f7cb1bc2700 R15: 00007f7cb1bc2700
[11368.667215] polkitd         S    0  1777      1 0x00000080
[11368.667757] Call Trace:
[11368.668392]  ? __schedule+0x31a/0x850
[11368.668950]  schedule+0x36/0xc0
[11368.669566]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.670211]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.670774]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.671383]  do_sys_poll+0x3af/0x570
[11368.671974]  ? __lock_acquire+0x26c/0x1480
[11368.672626]  ? update_load_avg+0x8c/0x770
[11368.673225]  ? update_load_avg+0x8c/0x770
[11368.673799]  ? update_curr+0x112/0x400
[11368.674470]  ? account_entity_enqueue+0x9c/0xd0
[11368.675126]  ? set_fd_set.part.2+0x40/0x40
[11368.675717]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.676321]  ? get_futex_key+0x505/0x6e0
[11368.676872]  ? __lock_acquire+0x26c/0x1480
[11368.677482]  ? __lock_acquire+0x26c/0x1480
[11368.678021]  ? sched_clock+0x5/0x10
[11368.678505]  ? sched_clock+0x5/0x10
[11368.679103]  ? sched_clock_cpu+0xc/0xc0
[11368.679578]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.680169]  ? __x64_sys_poll+0x37/0x130
[11368.680699]  __x64_sys_poll+0x37/0x130
[11368.681244]  do_syscall_64+0x5a/0x240
[11368.681721]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.682272] RIP: 0033:0x7f7cb75d720d
[11368.682785] Code: Bad RIP value.
[11368.683308] RSP: 002b:00007f7cb10fec90 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.683836] RAX: ffffffffffffffda RBX: 00007f7ca00008c0 RCX: 00007f7cb75d720d
[11368.684460] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007f7ca0001220
[11368.685066] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[11368.685617] R10: 00007f7ca0000948 R11: 0000000000000293 R12: 00007f7ca0001220
[11368.686246] R13: 00000000ffffffff R14: 00007f7cb85678f0 R15: 0000000000000001
[11368.686795] abrtd           S    0  1739      1 0x00000080
[11368.687395] Call Trace:
[11368.687927]  ? __schedule+0x31a/0x850
[11368.688608]  schedule+0x36/0xc0
[11368.689226]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.689756]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.690352]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.690884]  do_sys_poll+0x3af/0x570
[11368.691502]  ? ep_poll_callback+0x375/0x5e0
[11368.692121]  ? _raw_spin_unlock_irqrestore+0x32/0x60
[11368.692652]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.693265]  ? __wake_up_common_lock+0x87/0xc0
[11368.693769]  ? sched_clock+0x5/0x10
[11368.694339]  ? sched_clock+0x5/0x10
[11368.694857]  ? sched_clock_cpu+0xc/0xc0
[11368.695394]  ? set_fd_set.part.2+0x40/0x40
[11368.695905]  ? set_fd_set.part.2+0x40/0x40
[11368.696486]  ? set_fd_set.part.2+0x40/0x40
[11368.697048]  ? set_fd_set.part.2+0x40/0x40
[11368.697532]  ? __lock_acquire+0x26c/0x1480
[11368.698041]  ? cp_new_stat+0x15a/0x190
[11368.698492]  ? sched_clock+0x5/0x10
[11368.698998]  ? sched_clock+0x5/0x10
[11368.699453]  ? sched_clock_cpu+0xc/0xc0
[11368.699972]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.700436]  ? __x64_sys_poll+0x37/0x130
[11368.700956]  __x64_sys_poll+0x37/0x130
[11368.701384]  do_syscall_64+0x5a/0x240
[11368.701839]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.702376] RIP: 0033:0x7fe51a3d31f0
[11368.702842] Code: Bad RIP value.
[11368.703364] RSP: 002b:00007fff1ccdbeb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
[11368.703875] RAX: ffffffffffffffda RBX: 0000000000000014 RCX: 00007fe51a3d31f0
[11368.704477] RDX: 00000000ffffffff RSI: 0000000000000004 RDI: 000055a276609840
[11368.705067] RBP: 000055a276609840 R08: 0000000000000014 R09: 0000000000000000
[11368.705586] R10: 00007fff1ccdb920 R11: 0000000000000246 R12: 000055a276622070
[11368.706145] R13: 00007fff1ccdbf1c R14: 0000000000000005 R15: 0000000000000004
[11368.706686] abrt-watch-log  S    0  1746      1 0x00004080
[11368.707240] Call Trace:
[11368.707770]  ? __schedule+0x31a/0x850
[11368.708346]  schedule+0x36/0xc0
[11368.708859]  schedule_timeout+0x204/0x3b0
[11368.709475]  ? sched_clock+0x5/0x10
[11368.710018]  ? sched_clock+0x5/0x10
[11368.710479]  ? sched_clock_cpu+0xc/0xc0
[11368.711026]  wait_woken+0x59/0xa0
[11368.711487]  inotify_read+0x29c/0x3c0
[11368.712026]  ? sched_clock+0x5/0x10
[11368.712476]  ? do_wait_intr_irq+0xb0/0xb0
[11368.713012]  vfs_read+0x9e/0x170
[11368.713457]  ksys_read+0xa7/0xe0
[11368.713980]  do_syscall_64+0x5a/0x240
[11368.714386]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.714857] RIP: 0033:0x7f80a06ecf70
[11368.715418] Code: Bad RIP value.
[11368.715949] RSP: 002b:00007ffc3739b6c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[11368.716372] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f80a06ecf70
[11368.716833] RDX: 0000000000001000 RSI: 00007ffc3739b840 RDI: 0000000000000003
[11368.717381] RBP: 00007ffc3739cf57 R08: 0000000000000001 R09: 00005639ab5b0e84
[11368.717865] R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000001
[11368.718456] R13: 00007ffc3739b710 R14: 0000000000000003 R15: 00007ffc3739b840
[11368.719073] abrt-watch-log  S    0  1747      1 0x00000080
[11368.719559] Call Trace:
[11368.720118]  ? __schedule+0x31a/0x850
[11368.720774]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.721320]  ? do_nanosleep+0x5b/0x1c0
[11368.721854]  schedule+0x36/0xc0
[11368.722445]  do_nanosleep+0xad/0x1c0
[11368.723016]  hrtimer_nanosleep+0xba/0x150
[11368.723547]  ? hrtimer_init_sleeper+0x100/0x100
[11368.724128]  __x64_sys_nanosleep+0x70/0xa0
[11368.724701]  do_syscall_64+0x5a/0x240
[11368.725284]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.725822] RIP: 0033:0x7f9942d32e10
[11368.726481] Code: Bad RIP value.
[11368.727007] RSP: 002b:00007fffd9a68c68 EFLAGS: 00000246 ORIG_RAX: 0000000000000023
[11368.727553] RAX: ffffffffffffffda RBX: 00007fffd9a68c80 RCX: 00007f9942d32e10
[11368.728196] RDX: 0000000000000000 RSI: 00007fffd9a68c70 RDI: 00007fffd9a68c70
[11368.728786] RBP: 00000000ffffffff R08: 00007fffd9a68d80 R09: 00007fffd9a68bc0
[11368.729434] R10: 0000000000000008 R11: 0000000000000246 R12: 00007fffd9a68d00
[11368.730067] R13: 00007fffd9a68e90 R14: 0000000000000003 R15: 00007fffd9a68fc0
[11368.730619] dbus-daemon     S    0  1749      1 0x00000080
[11368.731257] Call Trace:
[11368.731825]  ? __schedule+0x31a/0x850
[11368.732496]  ? ep_poll+0x2c9/0x5b0
[11368.733127]  schedule+0x36/0xc0
[11368.733637]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.734262]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.734764]  ep_poll+0x2a9/0x5b0
[11368.735383]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.735888]  ? wake_up_q+0x80/0x80
[11368.736552]  do_epoll_wait+0xd7/0xf0
[11368.737201]  __x64_sys_epoll_wait+0x1a/0x20
[11368.737747]  do_syscall_64+0x5a/0x240
[11368.738444]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.739062] RIP: 0033:0x7f3501fba463
[11368.739603] Code: Bad RIP value.
[11368.740228] RSP: 002b:00007ffc1614baa8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[11368.740793] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f3501fba463
[11368.741476] RDX: 0000000000000040 RSI: 00007ffc1614bab0 RDI: 0000000000000004
[11368.742060] RBP: 00007ffc1614be60 R08: 0000000000002be4 R09: 00007ffc1614bda0
[11368.742619] R10: 00000000ffffffff R11: 0000000000000246 R12: 000055f15562d520
[11368.743304] R13: 00007ffc1614be24 R14: 0000000000000001 R15: 000055f155694e30
[11368.743937] avahi-daemon    S    0  1765   1735 0x00004080
[11368.744690] Call Trace:
[11368.745301]  ? __schedule+0x31a/0x850
[11368.745860]  schedule+0x36/0xc0
[11368.746489]  schedule_timeout+0x204/0x3b0
[11368.747135]  ? sched_clock+0x5/0x10
[11368.747709]  ? sched_clock+0x5/0x10
[11368.748311]  ? sched_clock_cpu+0xc/0xc0
[11368.748858]  unix_stream_read_generic+0x577/0x8a0
[11368.749502]  ? finish_wait+0x80/0x80
[11368.750154]  unix_stream_recvmsg+0x53/0x70
[11368.750680]  ? unix_state_double_unlock+0x30/0x30
[11368.751320]  sock_read_iter+0x97/0xf0
[11368.751858]  new_sync_read+0x127/0x1b0
[11368.752501]  vfs_read+0x9e/0x170
[11368.753117]  ksys_read+0xa7/0xe0
[11368.753665]  do_syscall_64+0x5a/0x240
[11368.754273]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.754796] RIP: 0033:0x7f725f9da6e0
[11368.755389] Code: Bad RIP value.
[11368.755904] RSP: 002b:00007ffcbf58b208 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[11368.756567] RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00007f725f9da6e0
[11368.757210] RDX: 0000000000000001 RSI: 00007ffcbf58b22e RDI: 0000000000000006
[11368.757761] RBP: 00007ffcbf58b22e R08: 0000000000000000 R09: 00007f725f64c14d
[11368.758399] R10: 6f6320746f672072 R11: 0000000000000246 R12: 00007ffcbf58b250
[11368.759052] R13: 00007ffcbf58b290 R14: 0000000000000005 R15: 00007ffcbf58b240
[11368.759624] NetworkManager  S    0  1776      1 0x00000080
[11368.760255] Call Trace:
[11368.760824]  ? __schedule+0x31a/0x850
[11368.761470]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.762141]  schedule+0x36/0xc0
[11368.762712]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.763425]  ? hrtimer_init_sleeper+0x100/0x100
[11368.764049]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.764616]  do_sys_poll+0x3af/0x570
[11368.765280]  ? __lock_acquire+0x26c/0x1480
[11368.765852]  ? set_fd_set.part.2+0x40/0x40
[11368.766576]  ? set_fd_set.part.2+0x40/0x40
[11368.767201]  ? set_fd_set.part.2+0x40/0x40
[11368.767734]  ? set_fd_set.part.2+0x40/0x40
[11368.768338]  ? set_fd_set.part.2+0x40/0x40
[11368.768981]  ? set_fd_set.part.2+0x40/0x40
[11368.769563]  ? set_fd_set.part.2+0x40/0x40
[11368.770142]  ? set_fd_set.part.2+0x40/0x40
[11368.770617]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.771181]  ? ktime_get_ts64+0xae/0x170
[11368.771667]  ? __x64_sys_poll+0x9e/0x130
[11368.772186]  __x64_sys_poll+0x9e/0x130
[11368.772658]  do_syscall_64+0x5a/0x240
[11368.773211]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.773748] RIP: 0033:0x7eff69fa920d
[11368.774342] Code: Bad RIP value.
[11368.774906] RSP: 002b:00007ffc2bd0b000 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.775548] RAX: ffffffffffffffda RBX: 000055b09fdca9f0 RCX: 00007eff69fa920d
[11368.776094] RDX: 00000000000493cf RSI: 0000000000000008 RDI: 000055b09fee1b60
[11368.776667] RBP: 0000000000000008 R08: 0000000000000008 R09: 0000000000000000
[11368.777286] R10: 000055b09fee7ee0 R11: 0000000000000293 R12: 000055b09fee1b60
[11368.777851] R13: 00000000000493cf R14: 00007eff6b61e8f0 R15: 0000000000000008
[11368.778594] gmain           S    0  1805      1 0x00004080
[11368.779156] Call Trace:
[11368.779712]  ? __schedule+0x31a/0x850
[11368.780273]  schedule+0x36/0xc0
[11368.780882]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.781484]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.782032]  do_sys_poll+0x3af/0x570
[11368.782616]  ? sched_clock+0x5/0x10
[11368.783234]  ? sched_clock+0x5/0x10
[11368.783751]  ? sched_clock_cpu+0xc/0xc0
[11368.784307]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.784848]  ? _raw_spin_unlock_irq+0x29/0x40
[11368.785396]  ? finish_task_switch+0x95/0x2b0
[11368.785936]  ? finish_task_switch+0x68/0x2b0
[11368.786562]  ? set_fd_set.part.2+0x40/0x40
[11368.787112]  ? set_fd_set.part.2+0x40/0x40
[11368.787594]  ? futex_wait+0x20e/0x240
[11368.788113]  ? get_futex_key+0x505/0x6e0
[11368.788611]  ? __lock_acquire+0x26c/0x1480
[11368.789122]  ? __lock_acquire+0x26c/0x1480
[11368.789624]  ? sched_clock+0x5/0x10
[11368.790156]  ? sched_clock+0x5/0x10
[11368.790621]  ? sched_clock_cpu+0xc/0xc0
[11368.791109]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.791569]  ? __x64_sys_poll+0x37/0x130
[11368.792061]  __x64_sys_poll+0x37/0x130
[11368.792516]  do_syscall_64+0x5a/0x240
[11368.793012]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.793461] RIP: 0033:0x7eff69fa920d
[11368.793995] Code: Bad RIP value.
[11368.794396] RSP: 002b:00007eff5e62ac30 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.794954] RAX: ffffffffffffffda RBX: 000055b09fddb900 RCX: 00007eff69fa920d
[11368.795585] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007eff580008e0
[11368.796122] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11368.796670] R10: 000055b09fe01b80 R11: 0000000000000293 R12: 00007eff580008e0
[11368.797262] R13: 00000000ffffffff R14: 00007eff6b61e8f0 R15: 0000000000000002
[11368.797850] gdbus           S    0  1807      1 0x00000080
[11368.798493] Call Trace:
[11368.799112]  ? __schedule+0x31a/0x850
[11368.799664]  schedule+0x36/0xc0
[11368.800242]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.800813]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.801512]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.802047]  do_sys_poll+0x3af/0x570
[11368.802608]  ? __lock_acquire+0x26c/0x1480
[11368.803164]  ? unix_stream_read_generic+0x1f5/0x8a0
[11368.803721]  ? set_fd_set.part.2+0x40/0x40
[11368.804265]  ? set_fd_set.part.2+0x40/0x40
[11368.804795]  ? set_fd_set.part.2+0x40/0x40
[11368.805314]  ? _raw_spin_unlock_irqrestore+0x55/0x60
[11368.805800]  ? __lock_acquire+0x26c/0x1480
[11368.806319]  ? sched_clock+0x5/0x10
[11368.806818]  ? sched_clock_cpu+0xc/0xc0
[11368.807338]  ? sched_clock+0x5/0x10
[11368.807848]  ? sched_clock+0x5/0x10
[11368.808346]  ? sched_clock_cpu+0xc/0xc0
[11368.808856]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.809378]  ? __x64_sys_poll+0x37/0x130
[11368.809884]  __x64_sys_poll+0x37/0x130
[11368.810397]  do_syscall_64+0x5a/0x240
[11368.810912]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.811471] RIP: 0033:0x7eff69fa920d
[11368.811965] Code: Bad RIP value.
[11368.812480] RSP: 002b:00007eff5d628c20 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.813047] RAX: ffffffffffffffda RBX: 00007eff50009990 RCX: 00007eff69fa920d
[11368.813579] RDX: 00000000ffffffff RSI: 0000000000000003 RDI: 00007eff540010c0
[11368.814169] RBP: 0000000000000003 R08: 0000000000000003 R09: 0000000000000000
[11368.814717] R10: 00007eff54002f20 R11: 0000000000000293 R12: 00007eff540010c0
[11368.815300] R13: 00000000ffffffff R14: 00007eff6b61e8f0 R15: 0000000000000003
[11368.815882] chronyd         S    0  1785      1 0x00000080
[11368.816556] Call Trace:
[11368.817205]  ? __schedule+0x31a/0x850
[11368.817748]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.818331]  schedule+0x36/0xc0
[11368.818916]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.819594]  ? hrtimer_init_sleeper+0x100/0x100
[11368.820229]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.820854]  do_select+0x634/0x8b0
[11368.821542]  ? set_fd_set.part.2+0x40/0x40
[11368.822084]  ? set_fd_set.part.2+0x40/0x40
[11368.822630]  ? set_fd_set.part.2+0x40/0x40
[11368.823249]  ? udp_recvmsg+0x143/0x4c0
[11368.823772]  ? __lock_acquire+0x26c/0x1480
[11368.824318]  ? __lock_acquire+0x26c/0x1480
[11368.824864]  ? sched_clock+0x5/0x10
[11368.825396]  ? sched_clock+0x5/0x10
[11368.825923]  ? sched_clock_cpu+0xc/0xc0
[11368.826529]  ? core_sys_select+0x213/0x410
[11368.827016]  core_sys_select+0x213/0x410
[11368.827541]  ? sched_clock+0x5/0x10
[11368.828064]  ? sched_clock+0x5/0x10
[11368.828558]  ? sched_clock_cpu+0xc/0xc0
[11368.829074]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.829548]  ? ktime_get_ts64+0xae/0x170
[11368.830075]  kern_select+0xb5/0x100
[11368.830561]  __x64_sys_select+0x20/0x30
[11368.831085]  do_syscall_64+0x5a/0x240
[11368.831567]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.832108] RIP: 0033:0x7f6f3fe79f73
[11368.832608] Code: Bad RIP value.
[11368.833139] RSP: 002b:00007ffdb1c63b20 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11368.833661] RAX: ffffffffffffffda RBX: 00007ffdb1c63c30 RCX: 00007f6f3fe79f73
[11368.834250] RDX: 0000000000000000 RSI: 00007ffdb1c63c30 RDI: 0000000000000006
[11368.834854] RBP: 00007ffdb1c63b88 R08: 00007ffdb1c63b90 R09: 0000555d3f2c9410
[11368.835455] R10: 0000000000000000 R11: 0000000000000293 R12: 00007ffdb1c63c30
[11368.836045] R13: 0000000000000000 R14: 0000000000000000 R15: 00007ffdb1c63bc0
[11368.836624] ksmtuned        S    0  1789      1 0x00000080
[11368.837238] Call Trace:
[11368.837794]  ? __schedule+0x31a/0x850
[11368.838336]  ? do_wait+0xd8/0x2c0
[11368.838850]  schedule+0x36/0xc0
[11368.839381]  do_wait+0x1f9/0x2c0
[11368.839878]  kernel_wait4+0x8d/0x150
[11368.840444]  ? __list_del_entry+0x20/0x20
[11368.841022]  __do_sys_wait4+0x95/0xa0
[11368.841522]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.842062]  ? syscall_trace_enter+0x175/0x320
[11368.842583]  ? do_syscall_64+0x5a/0x240
[11368.843096]  do_syscall_64+0x5a/0x240
[11368.843589]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.844136] RIP: 0033:0x7f569ed62a3c
[11368.844674] Code: Bad RIP value.
[11368.845219] RSP: 002b:00007ffd7674fce8 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
[11368.845774] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f569ed62a3c
[11368.846308] RDX: 0000000000000000 RSI: 00007ffd7674fd10 RDI: ffffffffffffffff
[11368.846831] RBP: 0000000000dfde10 R08: 0000000000dfde10 R09: 0000000000000000
[11368.847448] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000e01f10
[11368.848015] R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000000
[11368.848584] cupsd           S    0  2018      1 0x00000080
[11368.849155] Call Trace:
[11368.849688]  ? __schedule+0x31a/0x850
[11368.850263]  ? ep_poll+0x2c9/0x5b0
[11368.850803]  schedule+0x36/0xc0
[11368.851365]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.851906]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.852608]  ep_poll+0x2a9/0x5b0
[11368.853243]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.853778]  ? wake_up_q+0x80/0x80
[11368.854346]  do_epoll_wait+0xd7/0xf0
[11368.854892]  __x64_sys_epoll_wait+0x1a/0x20
[11368.855537]  do_syscall_64+0x5a/0x240
[11368.856174]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.856747] RIP: 0033:0x7f16ad459463
[11368.857323] Code: Bad RIP value.
[11368.857922] RSP: 002b:00007ffe192ca3f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[11368.858633] RAX: ffffffffffffffda RBX: 00005571b90da9a8 RCX: 00007f16ad459463
[11368.859327] RDX: 0000000000001000 RSI: 00005571ba11c5c0 RDI: 0000000000000005
[11368.859911] RBP: 00005571b8ec7509 R08: 00005571b8ec7509 R09: 000000005e5fc287
[11368.860679] R10: 00000000ffffffff R11: 0000000000000246 R12: 000000005e611408
[11368.861322] R13: 0000000000015180 R14: 00005571b90da590 R15: 0000000000000000
[11368.861956] sshd            S    0  2019      1 0x00000080
[11368.862641] Call Trace:
[11368.863331]  ? __schedule+0x31a/0x850
[11368.863980]  ? sched_clock+0x5/0x10
[11368.864709]  schedule+0x36/0xc0
[11368.865240]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.865836]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.866494]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.867074]  do_select+0x634/0x8b0
[11368.867743]  ? set_fd_set.part.2+0x40/0x40
[11368.868345]  ? set_fd_set.part.2+0x40/0x40
[11368.868939]  ? set_fd_set.part.2+0x40/0x40
[11368.869601]  ? __lock_acquire+0x26c/0x1480
[11368.870182]  ? __lock_acquire+0x26c/0x1480
[11368.870737]  ? __lock_acquire+0x26c/0x1480
[11368.871312]  ? sched_clock+0x5/0x10
[11368.871852]  ? sched_clock+0x5/0x10
[11368.872488]  ? sched_clock_cpu+0xc/0xc0
[11368.873095]  ? core_sys_select+0x213/0x410
[11368.873634]  core_sys_select+0x213/0x410
[11368.874247]  ? __lock_acquire+0x26c/0x1480
[11368.874799]  ? sched_clock+0x5/0x10
[11368.875327]  ? sched_clock+0x5/0x10
[11368.875876]  ? sched_clock_cpu+0xc/0xc0
[11368.876447]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.876961]  kern_select+0xb5/0x100
[11368.877447]  __x64_sys_select+0x20/0x30
[11368.877990]  do_syscall_64+0x5a/0x240
[11368.878485]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.879069] RIP: 0033:0x7fe7cec95f53
[11368.879580] Code: Bad RIP value.
[11368.880131] RSP: 002b:00007fff8f5434e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[11368.880682] RAX: ffffffffffffffda RBX: 0000557d8620ec50 RCX: 00007fe7cec95f53
[11368.881268] RDX: 0000000000000000 RSI: 0000557d8620ec50 RDI: 0000000000000007
[11368.881779] RBP: 0000000000000064 R08: 0000000000000000 R09: 0000000000000008
[11368.882330] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000005
[11368.882881] R13: 0000000000000000 R14: 0000000000000006 R15: 0000557d84c6be08
[11368.883570] rsyslogd        S    0  2024      1 0x00000080
[11368.884087] Call Trace:
[11368.884631]  ? __schedule+0x31a/0x850
[11368.885219]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.885727]  schedule+0x36/0xc0
[11368.886251]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.886792]  ? hrtimer_init_sleeper+0x100/0x100
[11368.887324]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.887817]  do_select+0x634/0x8b0
[11368.888348]  ? __lock_acquire+0x26c/0x1480
[11368.888893]  ? sched_clock+0x5/0x10
[11368.889400]  ? sched_clock_cpu+0xc/0xc0
[11368.889959]  ? _raw_read_unlock_irqrestore+0x55/0x60
[11368.890460]  ? ep_poll_callback+0x375/0x5e0
[11368.891009]  ? __lock_acquire+0x26c/0x1480
[11368.891511]  ? __lock_acquire+0x26c/0x1480
[11368.892055]  ? __lock_acquire+0x26c/0x1480
[11368.892564]  ? mark_held_locks+0x50/0x80
[11368.893070]  ? sched_clock+0x5/0x10
[11368.893554]  ? sched_clock+0x5/0x10
[11368.894052]  ? sched_clock_cpu+0xc/0xc0
[11368.894526]  ? core_sys_select+0x213/0x410
[11368.895067]  core_sys_select+0x213/0x410
[11368.895558]  ? sched_clock+0x5/0x10
[11368.896077]  ? sched_clock+0x5/0x10
[11368.896572]  ? sched_clock_cpu+0xc/0xc0
[11368.897100]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.897598]  ? ktime_get_ts64+0xae/0x170
[11368.898129]  kern_select+0xb5/0x100
[11368.898628]  __x64_sys_select+0x20/0x30
[11368.899149]  do_syscall_64+0x5a/0x240
[11368.899667]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.900220] RIP: 0033:0x7fc02d482f73
[11368.900719] Code: Bad RIP value.
[11368.901223] RSP: 002b:00007ffedb611090 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11368.901726] RAX: ffffffffffffffda RBX: 000000000000003c RCX: 00007fc02d482f73
[11368.902313] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000001
[11368.902849] RBP: 000055ea9a20abec R08: 00007ffedb6110c0 R09: 00007ffedb611040
[11368.903450] R10: 0000000000000000 R11: 0000000000000293 R12: 00007ffedb6110c0
[11368.904038] R13: 00007ffedb6110b8 R14: 0000000000000000 R15: 0000000000000000
[11368.904612] in:imjournal    S    0  2037      1 0x00000080
[11368.905218] Call Trace:
[11368.905722]  ? __schedule+0x31a/0x850
[11368.906257]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.906790]  schedule+0x36/0xc0
[11368.907329]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.907900]  ? hrtimer_init_sleeper+0x100/0x100
[11368.908574]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.909167]  do_sys_poll+0x3af/0x570
[11368.909746]  ? __lock_acquire+0x26c/0x1480
[11368.910282]  ? rcu_read_lock_held+0x52/0x60
[11368.910792]  ? sched_clock+0x5/0x10
[11368.911319]  ? sched_clock+0x5/0x10
[11368.911808]  ? sched_clock_cpu+0xc/0xc0
[11368.912337]  ? sched_clock+0x5/0x10
[11368.912872]  ? set_fd_set.part.2+0x40/0x40
[11368.913395]  ? __lock_acquire+0x26c/0x1480
[11368.913885]  ? __lock_acquire+0x26c/0x1480
[11368.914393]  ? sched_clock+0x5/0x10
[11368.914885]  ? sched_clock+0x5/0x10
[11368.915391]  ? sched_clock_cpu+0xc/0xc0
[11368.915853]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.916356]  ? ktime_get_ts64+0xae/0x170
[11368.916899]  ? __x64_sys_ppoll+0xa5/0xe0
[11368.917441]  __x64_sys_ppoll+0xa5/0xe0
[11368.917961]  do_syscall_64+0x5a/0x240
[11368.918459]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.919013] RIP: 0033:0x7fc02d4812cf
[11368.919503] Code: Bad RIP value.
[11368.920058] RSP: 002b:00007fc02a25dc60 EFLAGS: 00000293 ORIG_RAX: 000000000000010f
[11368.920614] RAX: ffffffffffffffda RBX: 000055ea9bcdfbc0 RCX: 00007fc02d4812cf
[11368.921230] RDX: 00007fc02a25dc80 RSI: 0000000000000001 RDI: 00007fc02a25dca0
[11368.921779] RBP: 00000000000dbba0 R08: 0000000000000008 R09: 0000000000000000
[11368.922360] R10: 0000000000000000 R11: 0000000000000293 R12: 00007fc02a25dd90
[11368.922923] R13: 00007fc01c019910 R14: 00007fc01c19e5c0 R15: 00007fc01c193b40
[11368.923623] rs:main Q:Reg   S    0  2040      1 0x00000080
[11368.924213] Call Trace:
[11368.924816]  ? __schedule+0x31a/0x850
[11368.925383]  schedule+0x36/0xc0
[11368.925916]  futex_wait_queue_me+0xbf/0x150
[11368.926567]  futex_wait+0xe2/0x240
[11368.927186]  ? sched_clock+0x5/0x10
[11368.927719]  ? sched_clock_cpu+0xc/0xc0
[11368.928269]  ? inotify_handle_event+0x181/0x200
[11368.928862]  do_futex+0x599/0x930
[11368.929397]  ? sched_clock+0x5/0x10
[11368.929934]  ? sched_clock+0x5/0x10
[11368.930486]  ? sched_clock_cpu+0xc/0xc0
[11368.930979]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.931477]  __x64_sys_futex+0x134/0x180
[11368.932014]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11368.932563]  do_syscall_64+0x5a/0x240
[11368.933104]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.933603] RIP: 0033:0x7fc02e39b965
[11368.934136] Code: Bad RIP value.
[11368.934618] RSP: 002b:00007fc029e5cd50 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11368.935211] RAX: ffffffffffffffda RBX: 000055ea9bce04b0 RCX: 00007fc02e39b965
[11368.935731] RDX: 0000000000001769 RSI: 0000000000000080 RDI: 000055ea9bce069c
[11368.936267] RBP: 0000000000000000 R08: 000055ea9bce0400 R09: 0000000000000bb5
[11368.936842] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[11368.937388] R13: 000055ea9bce0698 R14: 000055ea9bce0630 R15: 00007fc029e5cda0
[11368.937959] tuned           S    0  2046      1 0x00000080
[11368.938584] Call Trace:
[11368.939119]  ? __schedule+0x31a/0x850
[11368.939665]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.940309]  schedule+0x36/0xc0
[11368.940922]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.941589]  ? hrtimer_init_sleeper+0x100/0x100
[11368.942231]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.942848]  do_select+0x634/0x8b0
[11368.943494]  ? __lock_acquire+0x26c/0x1480
[11368.944071]  ? __lock_acquire+0x26c/0x1480
[11368.944674]  ? sched_clock+0x5/0x10
[11368.945314]  ? sched_clock+0x5/0x10
[11368.945854]  ? sched_clock_cpu+0xc/0xc0
[11368.946475]  ? _raw_spin_unlock+0x24/0x30
[11368.947031]  ? do_wp_page+0x188/0x680
[11368.947587]  ? __lock_acquire+0x26c/0x1480
[11368.948179]  ? sched_clock+0x5/0x10
[11368.948762]  ? sched_clock+0x5/0x10
[11368.949330]  ? sched_clock_cpu+0xc/0xc0
[11368.949830]  ? core_sys_select+0x213/0x410
[11368.950347]  core_sys_select+0x213/0x410
[11368.950851]  ? sched_clock+0x5/0x10
[11368.951358]  ? sched_clock+0x5/0x10
[11368.951832]  ? sched_clock_cpu+0xc/0xc0
[11368.952458]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.953019]  ? ktime_get_ts64+0xae/0x170
[11368.953542]  kern_select+0xb5/0x100
[11368.954067]  __x64_sys_select+0x20/0x30
[11368.954592]  do_syscall_64+0x5a/0x240
[11368.955143]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.955651] RIP: 0033:0x7fcc71564f73
[11368.956220] Code: Bad RIP value.
[11368.956729] RSP: 002b:00007ffd19039a60 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11368.957279] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fcc71564f73
[11368.957843] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[11368.958463] RBP: 00000000016f30a0 R08: 00007ffd19039a90 R09: 00007ffd19039840
[11368.959041] R10: 0000000000000000 R11: 0000000000000293 R12: 00007fcc69c87810
[11368.959591] R13: 0000000000000001 R14: 0000000001a16910 R15: 00007fcc72576ea8
[11368.960186] gmain           S    0  2251      1 0x00000080
[11368.960737] Call Trace:
[11368.961288]  ? __schedule+0x31a/0x850
[11368.961811]  schedule+0x36/0xc0
[11368.962347]  schedule_hrtimeout_range_clock+0x104/0x110
[11368.962878]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.963494]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.964063]  do_sys_poll+0x3af/0x570
[11368.964634]  ? mark_held_locks+0x50/0x80
[11368.965203]  ? get_page_from_freelist+0x43f/0x1910
[11368.965745]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.966269]  ? prep_new_page+0x7c/0x120
[11368.966859]  ? get_page_from_freelist+0x5b4/0x1910
[11368.967457]  ? set_fd_set.part.2+0x40/0x40
[11368.967966]  ? __lock_acquire+0x26c/0x1480
[11368.968528]  ? mark_held_locks+0x50/0x80
[11368.969081]  ? mem_cgroup_commit_charge+0x68/0x4b0
[11368.969601]  ? sched_clock+0x5/0x10
[11368.970143]  ? sched_clock+0x5/0x10
[11368.970640]  ? sched_clock_cpu+0xc/0xc0
[11368.971220]  ? __lock_acquire+0x26c/0x1480
[11368.971748]  ? sched_clock+0x5/0x10
[11368.972262]  ? sched_clock+0x5/0x10
[11368.972767]  ? sched_clock_cpu+0xc/0xc0
[11368.973280]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.973778]  ? __x64_sys_poll+0x37/0x130
[11368.974301]  __x64_sys_poll+0x37/0x130
[11368.974822]  do_syscall_64+0x5a/0x240
[11368.975365]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.975918] RIP: 0033:0x7fcc7156320d
[11368.976519] Code: Bad RIP value.
[11368.977026] RSP: 002b:00007fcc61a3fe70 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11368.977591] RAX: ffffffffffffffda RBX: 0000000001a15d60 RCX: 00007fcc7156320d
[11368.978193] RDX: 00000000ffffffff RSI: 0000000000000001 RDI: 00007fcc5c0008e0
[11368.978759] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[11368.979375] R10: 0000000001a15de8 R11: 0000000000000293 R12: 00007fcc5c0008e0
[11368.979963] R13: 00000000ffffffff R14: 00007fcc63f128f0 R15: 0000000000000001
[11368.980673] tuned           S    0  2252      1 0x00000080
[11368.981231] Call Trace:
[11368.981774]  ? __schedule+0x31a/0x850
[11368.982357]  ? hrtimer_start_range_ns+0x1d9/0x320
[11368.982933]  schedule+0x36/0xc0
[11368.983589]  schedule_hrtimeout_range_clock+0x8d/0x110
[11368.984213]  ? hrtimer_init_sleeper+0x100/0x100
[11368.984837]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11368.985497]  do_select+0x634/0x8b0
[11368.986070]  ? _raw_spin_unlock_irqrestore+0x55/0x60
[11368.986638]  ? __lock_acquire+0x26c/0x1480
[11368.987266]  ? __lock_acquire+0x26c/0x1480
[11368.987802]  ? __lock_acquire+0x26c/0x1480
[11368.988362]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11368.988921]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.989586]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11368.990164]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.990690]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11368.991255]  ? __lock_acquire+0x26c/0x1480
[11368.991808]  ? sched_clock+0x5/0x10
[11368.992334]  ? sched_clock+0x5/0x10
[11368.992855]  ? sched_clock_cpu+0xc/0xc0
[11368.993397]  ? core_sys_select+0x213/0x410
[11368.993906]  core_sys_select+0x213/0x410
[11368.994535]  ? sched_clock+0x5/0x10
[11368.995029]  ? sched_clock+0x5/0x10
[11368.995523]  ? sched_clock_cpu+0xc/0xc0
[11368.996076]  ? lockdep_hardirqs_on+0xf0/0x180
[11368.996636]  ? ktime_get_ts64+0xae/0x170
[11368.997175]  kern_select+0xb5/0x100
[11368.997765]  __x64_sys_select+0x20/0x30
[11368.998274]  do_syscall_64+0x5a/0x240
[11368.998759]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11368.999287] RIP: 0033:0x7fcc71564f73
[11368.999832] Code: Bad RIP value.
[11369.000358] RSP: 002b:00007fcc6123dda0 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11369.000909] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fcc71564f73
[11369.001564] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
[11369.002189] RBP: 0000000001a16570 R08: 00007fcc6123ddd0 R09: 00007fcc6123db80
[11369.002796] R10: 0000000000000000 R11: 0000000000000293 R12: 00007fcc69c87810
[11369.003381] R13: 0000000000000001 R14: 00007fcc540012b0 R15: 00007fcc72576ea8
[11369.003999] tuned           S    0  2255      1 0x00000080
[11369.004672] Call Trace:
[11369.005228]  ? __schedule+0x31a/0x850
[11369.005776]  ? ep_poll+0x2c9/0x5b0
[11369.006292]  schedule+0x36/0xc0
[11369.006819]  schedule_hrtimeout_range_clock+0x104/0x110
[11369.007362]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.007865]  ep_poll+0x2a9/0x5b0
[11369.008472]  ? wake_up_q+0x80/0x80
[11369.008988]  do_epoll_wait+0xd7/0xf0
[11369.009505]  __x64_sys_epoll_wait+0x1a/0x20
[11369.010087]  do_syscall_64+0x5a/0x240
[11369.010617]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.011191] RIP: 0033:0x7fcc7156e483
[11369.011700] Code: Bad RIP value.
[11369.012273] RSP: 002b:00007fcc60a3d360 EFLAGS: 00000293 ORIG_RAX: 00000000000000e8
[11369.012850] RAX: ffffffffffffffda RBX: 00007fcc726b8a20 RCX: 00007fcc7156e483
[11369.013450] RDX: 00000000000003ff RSI: 00007fcc58000f60 RDI: 000000000000000a
[11369.013992] RBP: 00000000ffffffff R08: 00007fcc66d11890 R09: 0000000000002ff4
[11369.014542] R10: 00000000ffffffff R11: 0000000000000293 R12: 00007fcc5400aa80
[11369.015148] R13: 00007fcc58000f60 R14: 00007fcc58000d70 R15: 00007fcc61c6bd40
[11369.015731] tuned           S    0  2389      1 0x00000080
[11369.016320] Call Trace:
[11369.016926]  ? __schedule+0x31a/0x850
[11369.017606]  schedule+0x36/0xc0
[11369.018138]  schedule_hrtimeout_range_clock+0x104/0x110
[11369.018682]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.019296]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.019890]  do_sys_poll+0x3af/0x570
[11369.020582]  ? sched_clock+0x5/0x10
[11369.021166]  ? sched_clock+0x5/0x10
[11369.021715]  ? sched_clock_cpu+0xc/0xc0
[11369.022313]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.022892]  ? _raw_spin_unlock_irq+0x29/0x40
[11369.023586]  ? finish_task_switch+0x95/0x2b0
[11369.024223]  ? finish_task_switch+0x68/0x2b0
[11369.024851]  ? set_fd_set.part.2+0x40/0x40
[11369.025464]  ? set_fd_set.part.2+0x40/0x40
[11369.026018]  ? futex_wait+0x20e/0x240
[11369.026577]  ? try_to_wake_up+0x297/0x6e0
[11369.027186]  ? get_futex_key+0x505/0x6e0
[11369.027742]  ? __lock_acquire+0x26c/0x1480
[11369.028301]  ? sched_clock+0x5/0x10
[11369.028847]  ? sched_clock+0x5/0x10
[11369.029398]  ? sched_clock_cpu+0xc/0xc0
[11369.029942]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.030533]  ? __x64_sys_poll+0x37/0x130
[11369.031039]  __x64_sys_poll+0x37/0x130
[11369.031546]  do_syscall_64+0x5a/0x240
[11369.032092]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.032622] RIP: 0033:0x7fcc7156320d
[11369.033180] Code: Bad RIP value.
[11369.033709] RSP: 002b:00007fcc53ffdec0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11369.034301] RAX: ffffffffffffffda RBX: 0000000001a137c0 RCX: 00007fcc7156320d
[11369.034898] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007fcc4c001590
[11369.035562] RBP: 0000000000000002 R08: 0000000000000002 R09: 0000000000000000
[11369.036177] R10: 0000000001a13848 R11: 0000000000000293 R12: 00007fcc4c001590
[11369.036762] R13: 00000000ffffffff R14: 00007fcc63f128f0 R15: 0000000000000002
[11369.037330] rhsmcertd       S    0  2047      1 0x00000080
[11369.037894] Call Trace:
[11369.038481]  ? __schedule+0x31a/0x850
[11369.039059]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.039611]  schedule+0x36/0xc0
[11369.040217]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.040837]  ? hrtimer_init_sleeper+0x100/0x100
[11369.041511]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.042113]  do_sys_poll+0x3af/0x570
[11369.042694]  ? __lock_acquire+0x26c/0x1480
[11369.043253]  ? __lock_acquire+0x26c/0x1480
[11369.043781]  ? mark_held_locks+0x50/0x80
[11369.044284]  ? set_fd_set.part.2+0x40/0x40
[11369.044841]  ? release_pages+0x313/0x420
[11369.045366]  ? __lock_acquire+0x26c/0x1480
[11369.045904]  ? sched_clock+0x5/0x10
[11369.046463]  ? sched_clock+0x5/0x10
[11369.047009]  ? sched_clock_cpu+0xc/0xc0
[11369.047504]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.048037]  ? ktime_get_ts64+0xae/0x170
[11369.048556]  ? __x64_sys_poll+0x9e/0x130
[11369.049100]  __x64_sys_poll+0x9e/0x130
[11369.049609]  do_syscall_64+0x5a/0x240
[11369.050163]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.050688] RIP: 0033:0x7f894ce9c1f0
[11369.051260] Code: Bad RIP value.
[11369.051761] RSP: 002b:00007ffc222054c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
[11369.052293] RAX: ffffffffffffffda RBX: 00005631d0a5a8c0 RCX: 00007f894ce9c1f0
[11369.052863] RDX: 0000000000dbba00 RSI: 0000000000000001 RDI: 00005631d0a5a1b0
[11369.053461] RBP: 0000000000000001 R08: 0000000000000001 R09: 0000000000000000
[11369.054013] R10: 00005631d0a5a948 R11: 0000000000000246 R12: 00005631d0a5a1b0
[11369.054569] R13: 0000000000dbba00 R14: 00007f894d1d08f0 R15: 0000000000000001
[11369.055194] python          S    0  2054      1 0x00000080
[11369.055772] Call Trace:
[11369.056376]  ? __schedule+0x31a/0x850
[11369.056980]  schedule+0x36/0xc0
[11369.057670]  futex_wait_queue_me+0xbf/0x150
[11369.058270]  futex_wait+0xe2/0x240
[11369.058830]  ? sched_clock+0x5/0x10
[11369.059458]  ? sched_clock_cpu+0xc/0xc0
[11369.060028]  do_futex+0x599/0x930
[11369.060603]  ? sched_clock+0x5/0x10
[11369.061236]  ? sched_clock+0x5/0x10
[11369.061752]  ? sched_clock_cpu+0xc/0xc0
[11369.062290]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.062810]  __x64_sys_futex+0x134/0x180
[11369.063365]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.063890]  do_syscall_64+0x5a/0x240
[11369.064457]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.064971] RIP: 0033:0x7f859c03cadb
[11369.065484] Code: Bad RIP value.
[11369.066042] RSP: 002b:00007fff63fc97c0 EFLAGS: 00000282 ORIG_RAX: 00000000000000ca
[11369.066598] RAX: ffffffffffffffda RBX: 00000000000000ca RCX: 00007f859c03cadb
[11369.067171] RDX: 0000000000000000 RSI: 0000000000000080 RDI: 0000000001426aa0
[11369.067695] RBP: 0000000001426aa0 R08: 0000000000000000 R09: 00000000011540a0
[11369.068250] R10: 0000000000000000 R11: 0000000000000282 R12: fffffffeffffffff
[11369.068805] R13: 0000000000000000 R14: 000000000143bac0 R15: 00007f858ef9fb48
[11369.069384] python          S    0  2169      1 0x00000080
[11369.069928] Call Trace:
[11369.070597]  ? __schedule+0x31a/0x850
[11369.071158]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.071738]  schedule+0x36/0xc0
[11369.072295]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.072909]  ? hrtimer_init_sleeper+0x100/0x100
[11369.073581]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.074205]  do_select+0x634/0x8b0
[11369.074790]  ? set_fd_set.part.2+0x40/0x40
[11369.075390]  ? __lock_acquire+0x26c/0x1480
[11369.075965]  ? mark_held_locks+0x50/0x80
[11369.076665]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.077225]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.077776]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.078364]  ? __lock_acquire+0x26c/0x1480
[11369.078926]  ? __lock_acquire+0x26c/0x1480
[11369.079590]  ? sched_clock+0x5/0x10
[11369.080121]  ? sched_clock+0x5/0x10
[11369.080690]  ? sched_clock_cpu+0xc/0xc0
[11369.081327]  ? core_sys_select+0x213/0x410
[11369.081843]  core_sys_select+0x213/0x410
[11369.082380]  ? sched_clock+0x5/0x10
[11369.082906]  ? sched_clock+0x5/0x10
[11369.083446]  ? sched_clock_cpu+0xc/0xc0
[11369.083944]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.084447]  ? ktime_get_ts64+0xae/0x170
[11369.084999]  kern_select+0xb5/0x100
[11369.085504]  __x64_sys_select+0x20/0x30
[11369.086042]  do_syscall_64+0x5a/0x240
[11369.086544]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.087106] RIP: 0033:0x7f859b64df73
[11369.087662] Code: Bad RIP value.
[11369.088207] RSP: 002b:00007f858ef76d10 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11369.088808] RAX: ffffffffffffffda RBX: 00007f858ef76f00 RCX: 00007f859b64df73
[11369.089371] RDX: 00007f858ef76e00 RSI: 00007f858ef76d80 RDI: 0000000000000004
[11369.089908] RBP: 00007f858ef7af10 R08: 00007f858ef76d70 R09: 00007f8590622f79
[11369.090528] R10: 00007f858ef76e80 R11: 0000000000000293 R12: 00007f858ef7ef20
[11369.091103] R13: 00007f858ef76d80 R14: 00007f858ef76e00 R15: 0000000000000004
[11369.091686] python          S    0  2170      1 0x00000080
[11369.092313] Call Trace:
[11369.092877]  ? __schedule+0x31a/0x850
[11369.093484]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.094017]  schedule+0x36/0xc0
[11369.094549]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.095139]  ? hrtimer_init_sleeper+0x100/0x100
[11369.095691]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.096262]  do_select+0x634/0x8b0
[11369.096826]  ? set_fd_set.part.2+0x40/0x40
[11369.097386]  ? __lock_acquire+0x26c/0x1480
[11369.097948]  ? mark_held_locks+0x50/0x80
[11369.098571]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.099144]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.099671]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.100264]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.100835]  ? __lock_acquire+0x26c/0x1480
[11369.101352]  ? __lock_acquire+0x26c/0x1480
[11369.101846]  ? sched_clock+0x5/0x10
[11369.102357]  ? sched_clock+0x5/0x10
[11369.102842]  ? sched_clock_cpu+0xc/0xc0
[11369.103374]  ? core_sys_select+0x213/0x410
[11369.103913]  core_sys_select+0x213/0x410
[11369.104489]  ? sched_clock+0x5/0x10
[11369.105019]  ? sched_clock+0x5/0x10
[11369.105506]  ? sched_clock_cpu+0xc/0xc0
[11369.106038]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.106533]  ? ktime_get_ts64+0xae/0x170
[11369.107082]  kern_select+0xb5/0x100
[11369.107590]  __x64_sys_select+0x20/0x30
[11369.108131]  do_syscall_64+0x5a/0x240
[11369.108656]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.109230] RIP: 0033:0x7f859b64df73
[11369.109731] Code: Bad RIP value.
[11369.110208] RSP: 002b:00007f858e775d10 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11369.110738] RAX: ffffffffffffffda RBX: 00007f858e775f00 RCX: 00007f859b64df73
[11369.111272] RDX: 00007f858e775e00 RSI: 00007f858e775d80 RDI: 0000000000000005
[11369.111850] RBP: 00007f858e779f10 R08: 00007f858e775d70 R09: 00007f8590622f79
[11369.112393] R10: 00007f858e775e80 R11: 0000000000000293 R12: 00007f858e77df20
[11369.112974] R13: 00007f858e775d80 R14: 00007f858e775e00 R15: 0000000000000005
[11369.113593] python          S    0  2171      1 0x00000080
[11369.114158] Call Trace:
[11369.114771]  ? __schedule+0x31a/0x850
[11369.115315]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.115889]  schedule+0x36/0xc0
[11369.116459]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.117044]  ? hrtimer_init_sleeper+0x100/0x100
[11369.117578]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.118142]  do_select+0x634/0x8b0
[11369.118742]  ? set_fd_set.part.2+0x40/0x40
[11369.119313]  ? __lock_acquire+0x26c/0x1480
[11369.119831]  ? mark_held_locks+0x50/0x80
[11369.120316]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.120897]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.121458]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.122019]  ? __lock_acquire+0x26c/0x1480
[11369.122533]  ? __lock_acquire+0x26c/0x1480
[11369.123086]  ? sched_clock+0x5/0x10
[11369.123591]  ? sched_clock+0x5/0x10
[11369.124134]  ? sched_clock_cpu+0xc/0xc0
[11369.124663]  ? core_sys_select+0x213/0x410
[11369.125193]  core_sys_select+0x213/0x410
[11369.125751]  ? sched_clock+0x5/0x10
[11369.126225]  ? sched_clock+0x5/0x10
[11369.126744]  ? sched_clock_cpu+0xc/0xc0
[11369.127232]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.127736]  ? ktime_get_ts64+0xae/0x170
[11369.128235]  kern_select+0xb5/0x100
[11369.128770]  __x64_sys_select+0x20/0x30
[11369.129289]  do_syscall_64+0x5a/0x240
[11369.129803]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.130330] RIP: 0033:0x7f859b64df73
[11369.130906] Code: Bad RIP value.
[11369.131475] RSP: 002b:00007f858df74d10 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11369.132023] RAX: ffffffffffffffda RBX: 00007f858df74f00 RCX: 00007f859b64df73
[11369.132595] RDX: 00007f858df74e00 RSI: 00007f858df74d80 RDI: 0000000000000006
[11369.133176] RBP: 00007f858df78f10 R08: 00007f858df74d70 R09: 00007f8590622f79
[11369.133752] R10: 00007f858df74e80 R11: 0000000000000293 R12: 00007f858df7cf20
[11369.134331] R13: 00007f858df74d80 R14: 00007f858df74e00 R15: 0000000000000006
[11369.134907] python          S    0  2172      1 0x00000080
[11369.135556] Call Trace:
[11369.136160]  ? __schedule+0x31a/0x850
[11369.136743]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.137300]  schedule+0x36/0xc0
[11369.137857]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.138489]  ? hrtimer_init_sleeper+0x100/0x100
[11369.139049]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.139591]  do_select+0x634/0x8b0
[11369.140181]  ? set_fd_set.part.2+0x40/0x40
[11369.140747]  ? __lock_acquire+0x26c/0x1480
[11369.141265]  ? mark_held_locks+0x50/0x80
[11369.141800]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.142321]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.142875]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.143473]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.144056]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.144600]  ? __lock_acquire+0x26c/0x1480
[11369.145167]  ? __lock_acquire+0x26c/0x1480
[11369.145676]  ? sched_clock+0x5/0x10
[11369.146206]  ? sched_clock+0x5/0x10
[11369.146720]  ? sched_clock_cpu+0xc/0xc0
[11369.147258]  ? core_sys_select+0x213/0x410
[11369.147782]  core_sys_select+0x213/0x410
[11369.148277]  ? sched_clock+0x5/0x10
[11369.148822]  ? sched_clock+0x5/0x10
[11369.149300]  ? sched_clock_cpu+0xc/0xc0
[11369.149804]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.150295]  ? ktime_get_ts64+0xae/0x170
[11369.150815]  kern_select+0xb5/0x100
[11369.151331]  __x64_sys_select+0x20/0x30
[11369.151855]  do_syscall_64+0x5a/0x240
[11369.152394]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.152960] RIP: 0033:0x7f859b64df73
[11369.153586] Code: Bad RIP value.
[11369.154081] RSP: 002b:00007f858d773d10 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11369.154614] RAX: ffffffffffffffda RBX: 00007f858d773f00 RCX: 00007f859b64df73
[11369.155206] RDX: 00007f858d773e00 RSI: 00007f858d773d80 RDI: 0000000000000007
[11369.155785] RBP: 00007f858d777f10 R08: 00007f858d773d70 R09: 00007f8590622f79
[11369.156325] R10: 00007f858d773e80 R11: 0000000000000293 R12: 00007f858d77bf20
[11369.156908] R13: 00007f858d773d80 R14: 00007f858d773e00 R15: 0000000000000007
[11369.157567] python          S    0  2173      1 0x00000080
[11369.158095] Call Trace:
[11369.158625]  ? __schedule+0x31a/0x850
[11369.159205]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.159760]  schedule+0x36/0xc0
[11369.160271]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.160844]  ? hrtimer_init_sleeper+0x100/0x100
[11369.161379]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.161916]  do_select+0x634/0x8b0
[11369.162543]  ? set_fd_set.part.2+0x40/0x40
[11369.163077]  ? __lock_acquire+0x26c/0x1480
[11369.163591]  ? mark_held_locks+0x50/0x80
[11369.164159]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.164746]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.165276]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.165811]  ? __lock_acquire+0x26c/0x1480
[11369.166340]  ? __lock_acquire+0x26c/0x1480
[11369.166863]  ? sched_clock+0x5/0x10
[11369.167381]  ? sched_clock+0x5/0x10
[11369.167906]  ? sched_clock_cpu+0xc/0xc0
[11369.168398]  ? core_sys_select+0x213/0x410
[11369.168933]  core_sys_select+0x213/0x410
[11369.169475]  ? sched_clock+0x5/0x10
[11369.169970]  ? sched_clock+0x5/0x10
[11369.170452]  ? sched_clock_cpu+0xc/0xc0
[11369.171005]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.171499]  ? ktime_get_ts64+0xae/0x170
[11369.172046]  kern_select+0xb5/0x100
[11369.172600]  __x64_sys_select+0x20/0x30
[11369.173131]  do_syscall_64+0x5a/0x240
[11369.173645]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.174219] RIP: 0033:0x7f859b64df73
[11369.174737] Code: Bad RIP value.
[11369.175292] RSP: 002b:00007f858cf72d10 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11369.175937] RAX: ffffffffffffffda RBX: 00007f858cf72f00 RCX: 00007f859b64df73
[11369.176596] RDX: 00007f858cf72e00 RSI: 00007f858cf72d80 RDI: 0000000000000008
[11369.177209] RBP: 00007f858cf76f10 R08: 00007f858cf72d70 R09: 00007f8590622f79
[11369.177779] R10: 00007f858cf72e80 R11: 0000000000000293 R12: 00007f858cf7af20
[11369.178310] R13: 00007f858cf72d80 R14: 00007f858cf72e00 R15: 0000000000000008
[11369.178874] python          S    0  2174      1 0x00000080
[11369.179464] Call Trace:
[11369.180041]  ? __schedule+0x31a/0x850
[11369.180607]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.181222]  schedule+0x36/0xc0
[11369.181772]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.182305]  ? hrtimer_init_sleeper+0x100/0x100
[11369.182864]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.183476]  do_select+0x634/0x8b0
[11369.184045]  ? set_fd_set.part.2+0x40/0x40
[11369.184606]  ? __lock_acquire+0x26c/0x1480
[11369.185179]  ? mark_held_locks+0x50/0x80
[11369.185710]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.186235]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.186783]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.187329]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.187874]  ? __lock_acquire+0x26c/0x1480
[11369.188475]  ? __lock_acquire+0x26c/0x1480
[11369.189023]  ? sched_clock+0x5/0x10
[11369.189516]  ? sched_clock+0x5/0x10
[11369.190070]  ? sched_clock_cpu+0xc/0xc0
[11369.190589]  ? core_sys_select+0x213/0x410
[11369.191148]  core_sys_select+0x213/0x410
[11369.191662]  ? sched_clock+0x5/0x10
[11369.192201]  ? sched_clock+0x5/0x10
[11369.192752]  ? sched_clock_cpu+0xc/0xc0
[11369.193310]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.193854]  ? ktime_get_ts64+0xae/0x170
[11369.194354]  kern_select+0xb5/0x100
[11369.194895]  __x64_sys_select+0x20/0x30
[11369.195389]  do_syscall_64+0x5a/0x240
[11369.195895]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.196462] RIP: 0033:0x7f859b64df73
[11369.197027] Code: Bad RIP value.
[11369.197537] RSP: 002b:00007f8577ff1d10 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11369.198122] RAX: ffffffffffffffda RBX: 00007f8577ff1f00 RCX: 00007f859b64df73
[11369.198670] RDX: 00007f8577ff1e00 RSI: 00007f8577ff1d80 RDI: 000000000000000a
[11369.199223] RBP: 00007f8577ff5f10 R08: 00007f8577ff1d70 R09: 00007f8590622f79
[11369.199817] R10: 00007f8577ff1e80 R11: 0000000000000293 R12: 00007f8577ff9f20
[11369.200364] R13: 00007f8577ff1d80 R14: 00007f8577ff1e00 R15: 000000000000000a
[11369.200971] python          S    0  2175      1 0x00000080
[11369.201625] Call Trace:
[11369.202208]  ? __schedule+0x31a/0x850
[11369.202749]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.203323]  schedule+0x36/0xc0
[11369.203884]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.204549]  ? hrtimer_init_sleeper+0x100/0x100
[11369.205148]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.205687]  do_select+0x634/0x8b0
[11369.206234]  ? set_fd_set.part.2+0x40/0x40
[11369.206793]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.207338]  ? mark_held_locks+0x50/0x80
[11369.207874]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.208541]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.209106]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.209648]  ? __lock_acquire+0x26c/0x1480
[11369.210224]  ? __lock_acquire+0x26c/0x1480
[11369.210728]  ? sched_clock+0x5/0x10
[11369.211217]  ? sched_clock+0x5/0x10
[11369.211729]  ? sched_clock_cpu+0xc/0xc0
[11369.212233]  ? core_sys_select+0x213/0x410
[11369.212764]  core_sys_select+0x213/0x410
[11369.213278]  ? sched_clock+0x5/0x10
[11369.213799]  ? sched_clock+0x5/0x10
[11369.214311]  ? sched_clock_cpu+0xc/0xc0
[11369.214868]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.215383]  ? ktime_get_ts64+0xae/0x170
[11369.215907]  kern_select+0xb5/0x100
[11369.216527]  __x64_sys_select+0x20/0x30
[11369.217013]  do_syscall_64+0x5a/0x240
[11369.217501]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.218063] RIP: 0033:0x7f859b64df73
[11369.218582] Code: Bad RIP value.
[11369.219144] RSP: 002b:00007f85777f0d10 EFLAGS: 00000293 ORIG_RAX: 0000000000000017
[11369.219690] RAX: ffffffffffffffda RBX: 00007f85777f0f00 RCX: 00007f859b64df73
[11369.220239] RDX: 00007f85777f0e00 RSI: 00007f85777f0d80 RDI: 000000000000000b
[11369.220863] RBP: 00007f85777f4f10 R08: 00007f85777f0d70 R09: 00007f8590622f79
[11369.221485] R10: 00007f85777f0e80 R11: 0000000000000293 R12: 00007f85777f8f20
[11369.222126] R13: 00007f85777f0d80 R14: 00007f85777f0e00 R15: 000000000000000b
[11369.222765] libvirtd        S    0  2056      1 0x00000080
[11369.223311] Call Trace:
[11369.223875]  ? __schedule+0x31a/0x850
[11369.224525]  schedule+0x36/0xc0
[11369.225047]  schedule_hrtimeout_range_clock+0x104/0x110
[11369.225588]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.226168]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.226695]  do_sys_poll+0x3af/0x570
[11369.227220]  ? sched_clock_cpu+0xc/0xc0
[11369.227765]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.228288]  ? _raw_spin_unlock_irq+0x29/0x40
[11369.228864]  ? finish_task_switch+0x95/0x2b0
[11369.229465]  ? finish_task_switch+0x68/0x2b0
[11369.230046]  ? set_fd_set.part.2+0x40/0x40
[11369.230577]  ? set_fd_set.part.2+0x40/0x40
[11369.231133]  ? set_fd_set.part.2+0x40/0x40
[11369.231735]  ? set_fd_set.part.2+0x40/0x40
[11369.232250]  ? set_fd_set.part.2+0x40/0x40
[11369.232764]  ? set_fd_set.part.2+0x40/0x40
[11369.233229]  ? set_fd_set.part.2+0x40/0x40
[11369.233743]  ? set_fd_set.part.2+0x40/0x40
[11369.234183]  ? set_fd_set.part.2+0x40/0x40
[11369.234639]  ? __x64_sys_poll+0x37/0x130
[11369.235118]  __x64_sys_poll+0x37/0x130
[11369.235563]  do_syscall_64+0x5a/0x240
[11369.236049]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.236525] RIP: 0033:0x7f17f464820d
[11369.237036] Code: Bad RIP value.
[11369.237496] RSP: 002b:00007ffde8dbe0d0 EFLAGS: 00000293 ORIG_RAX: 0000000000000007
[11369.238029] RAX: ffffffffffffffda RBX: 0000000000000009 RCX: 00007f17f464820d
[11369.238527] RDX: 00000000ffffffff RSI: 0000000000000009 RDI: 0000558da9a6c620
[11369.239062] RBP: 00000000ffffffff R08: 00007f17f76e5a60 R09: 0000000000000000
[11369.239576] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000009
[11369.240102] R13: 00007f17f79e0a20 R14: 00007ffde8dbe140 R15: 0000000000000001
[11369.240657] libvirtd        S    0  2072      1 0x00000080
[11369.241230] Call Trace:
[11369.241754]  ? __schedule+0x31a/0x850
[11369.242313]  schedule+0x36/0xc0
[11369.242838]  futex_wait_queue_me+0xbf/0x150
[11369.243375]  futex_wait+0xe2/0x240
[11369.243907]  ? get_futex_key+0x505/0x6e0
[11369.244513]  do_futex+0x599/0x930
[11369.245016]  ? sched_clock+0x5/0x10
[11369.245484]  ? sched_clock+0x5/0x10
[11369.246009]  ? sched_clock_cpu+0xc/0xc0
[11369.246485]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.247007]  __x64_sys_futex+0x134/0x180
[11369.247499]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.248029]  do_syscall_64+0x5a/0x240
[11369.248509]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.249013] RIP: 0033:0x7f17f492d965
[11369.249496] Code: Bad RIP value.
[11369.249982] RSP: 002b:00007f17e78cdcb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.250467] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.251011] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 0000558da9a52abc
[11369.251484] RBP: 0000558da9a52b18 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.252031] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b30
[11369.252553] R13: 0000558da9a52a90 R14: 0000558da9a52ab8 R15: 0000558da9a52a50
[11369.253117] libvirtd        S    0  2073      1 0x00000080
[11369.253618] Call Trace:
[11369.254155]  ? __schedule+0x31a/0x850
[11369.254718]  schedule+0x36/0xc0
[11369.255234]  futex_wait_queue_me+0xbf/0x150
[11369.255765]  futex_wait+0xe2/0x240
[11369.256293]  do_futex+0x599/0x930
[11369.256844]  ? sched_clock+0x5/0x10
[11369.257371]  ? sched_clock+0x5/0x10
[11369.257922]  ? sched_clock_cpu+0xc/0xc0
[11369.258533]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.259060]  __x64_sys_futex+0x134/0x180
[11369.259599]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.260226]  do_syscall_64+0x5a/0x240
[11369.260807]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.261354] RIP: 0033:0x7f17f492d965
[11369.261909] Code: Bad RIP value.
[11369.262520] RSP: 002b:00007f17e70cccb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.263137] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.263694] RDX: 0000000000000002 RSI: 0000000000000080 RDI: 0000558da9a52abc
[11369.264297] RBP: 0000558da9a52b18 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.264894] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b30
[11369.265512] R13: 0000558da9a52a90 R14: 0000558da9a52ab8 R15: 0000558da9a52a50
[11369.266171] libvirtd        S    0  2074      1 0x00000080
[11369.266741] Call Trace:
[11369.267292]  ? __schedule+0x31a/0x850
[11369.267871]  schedule+0x36/0xc0
[11369.268505]  futex_wait_queue_me+0xbf/0x150
[11369.269120]  futex_wait+0xe2/0x240
[11369.269713]  do_futex+0x599/0x930
[11369.270277]  ? sched_clock+0x5/0x10
[11369.270862]  ? sched_clock+0x5/0x10
[11369.271495]  ? sched_clock_cpu+0xc/0xc0
[11369.272135]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.272725]  __x64_sys_futex+0x134/0x180
[11369.273265]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.273832]  do_syscall_64+0x5a/0x240
[11369.274373]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.274970] RIP: 0033:0x7f17f492d965
[11369.275617] Code: Bad RIP value.
[11369.276173] RSP: 002b:00007f17e68cbcb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.276804] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.277383] RDX: 0000000000000003 RSI: 0000000000000080 RDI: 0000558da9a52abc
[11369.277977] RBP: 0000558da9a52b18 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.278652] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b30
[11369.279269] R13: 0000558da9a52a90 R14: 0000558da9a52ab8 R15: 0000558da9a52a50
[11369.279894] libvirtd        S    0  2075      1 0x00000080
[11369.280601] Call Trace:
[11369.281151]  ? __schedule+0x31a/0x850
[11369.281779]  schedule+0x36/0xc0
[11369.282317]  futex_wait_queue_me+0xbf/0x150
[11369.282909]  futex_wait+0xe2/0x240
[11369.283613]  do_futex+0x599/0x930
[11369.284139]  ? sched_clock+0x5/0x10
[11369.284737]  ? sched_clock+0x5/0x10
[11369.285285]  ? sched_clock_cpu+0xc/0xc0
[11369.285851]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.286510]  __x64_sys_futex+0x134/0x180
[11369.287093]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.287651]  do_syscall_64+0x5a/0x240
[11369.288272]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.288862] RIP: 0033:0x7f17f492d965
[11369.289472] Code: Bad RIP value.
[11369.290052] RSP: 002b:00007f17e60cacb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.290672] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.291282] RDX: 0000000000000004 RSI: 0000000000000080 RDI: 0000558da9a52abc
[11369.291854] RBP: 0000558da9a52b18 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.292513] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b30
[11369.293079] R13: 0000558da9a52a90 R14: 0000558da9a52ab8 R15: 0000558da9a52a50
[11369.293660] libvirtd        S    0  2076      1 0x00000080
[11369.294307] Call Trace:
[11369.294890]  ? __schedule+0x31a/0x850
[11369.295471]  schedule+0x36/0xc0
[11369.296016]  futex_wait_queue_me+0xbf/0x150
[11369.296588]  futex_wait+0xe2/0x240
[11369.297205]  do_futex+0x599/0x930
[11369.297762]  ? sched_clock+0x5/0x10
[11369.298364]  ? sched_clock+0x5/0x10
[11369.298942]  ? sched_clock_cpu+0xc/0xc0
[11369.299599]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.300133]  __x64_sys_futex+0x134/0x180
[11369.300738]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.301305]  do_syscall_64+0x5a/0x240
[11369.301892]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.302542] RIP: 0033:0x7f17f492d965
[11369.303153] Code: Bad RIP value.
[11369.303701] RSP: 002b:00007f17e58c9cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.304366] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.305012] RDX: 0000000000000005 RSI: 0000000000000080 RDI: 0000558da9a52abc
[11369.305677] RBP: 0000558da9a52b18 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.306313] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b30
[11369.306916] R13: 0000558da9a52a90 R14: 0000558da9a52ab8 R15: 0000558da9a52a50
[11369.307569] libvirtd        S    0  2077      1 0x00000080
[11369.308128] Call Trace:
[11369.308734]  ? __schedule+0x31a/0x850
[11369.309327]  schedule+0x36/0xc0
[11369.309911]  futex_wait_queue_me+0xbf/0x150
[11369.310588]  futex_wait+0xe2/0x240
[11369.311132]  do_futex+0x599/0x930
[11369.311695]  ? sched_clock+0x5/0x10
[11369.312334]  ? sched_clock+0x5/0x10
[11369.312910]  ? sched_clock_cpu+0xc/0xc0
[11369.313533]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.314086]  __x64_sys_futex+0x134/0x180
[11369.314650]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.315293]  do_syscall_64+0x5a/0x240
[11369.315858]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.316561] RIP: 0033:0x7f17f492d965
[11369.317109] Code: Bad RIP value.
[11369.317672] RSP: 002b:00007f17e50c8cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.318286] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f17f492d965
[11369.318889] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 0000558da9a52b5c
[11369.319480] RBP: 0000558da9a52b40 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.320057] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b48
[11369.320648] R13: 0000558da9a52a90 R14: 0000558da9a52b58 R15: 0000558da9a52a50
[11369.321280] libvirtd        S    0  2078      1 0x00000080
[11369.321896] Call Trace:
[11369.322477]  ? __schedule+0x31a/0x850
[11369.323062]  schedule+0x36/0xc0
[11369.323615]  futex_wait_queue_me+0xbf/0x150
[11369.324227]  futex_wait+0xe2/0x240
[11369.324853]  do_futex+0x599/0x930
[11369.325435]  ? sched_clock+0x5/0x10
[11369.326044]  ? sched_clock+0x5/0x10
[11369.326603]  ? sched_clock_cpu+0xc/0xc0
[11369.327209]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.327783]  __x64_sys_futex+0x134/0x180
[11369.328394]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.329022]  do_syscall_64+0x5a/0x240
[11369.329637]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.330185] RIP: 0033:0x7f17f492d965
[11369.330780] Code: Bad RIP value.
[11369.331352] RSP: 002b:00007f17e48c7cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.331954] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f17f492d965
[11369.332660] RDX: 0000000000000002 RSI: 0000000000000080 RDI: 0000558da9a52b5c
[11369.333274] RBP: 0000558da9a52b40 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.333855] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b48
[11369.334560] R13: 0000558da9a52a90 R14: 0000558da9a52b58 R15: 0000558da9a52a50
[11369.335139] libvirtd        S    0  2079      1 0x00000080
[11369.335720] Call Trace:
[11369.336276]  ? __schedule+0x31a/0x850
[11369.336927]  schedule+0x36/0xc0
[11369.337541]  futex_wait_queue_me+0xbf/0x150
[11369.338154]  futex_wait+0xe2/0x240
[11369.338728]  do_futex+0x599/0x930
[11369.339257]  ? sched_clock+0x5/0x10
[11369.339820]  ? sched_clock+0x5/0x10
[11369.340440]  ? sched_clock_cpu+0xc/0xc0
[11369.341006]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.341576]  __x64_sys_futex+0x134/0x180
[11369.342189]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.342777]  do_syscall_64+0x5a/0x240
[11369.343338]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.343932] RIP: 0033:0x7f17f492d965
[11369.344635] Code: Bad RIP value.
[11369.345232] RSP: 002b:00007f17e40c6cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.345817] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f17f492d965
[11369.346391] RDX: 0000000000000003 RSI: 0000000000000080 RDI: 0000558da9a52b5c
[11369.347008] RBP: 0000558da9a52b40 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.347648] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b48
[11369.348340] R13: 0000558da9a52a90 R14: 0000558da9a52b58 R15: 0000558da9a52a50
[11369.348959] libvirtd        S    0  2080      1 0x00000080
[11369.349611] Call Trace:
[11369.350204]  ? __schedule+0x31a/0x850
[11369.350789]  schedule+0x36/0xc0
[11369.351371]  futex_wait_queue_me+0xbf/0x150
[11369.351942]  futex_wait+0xe2/0x240
[11369.352571]  do_futex+0x599/0x930
[11369.353113]  ? sched_clock+0x5/0x10
[11369.353680]  ? sched_clock+0x5/0x10
[11369.354301]  ? sched_clock_cpu+0xc/0xc0
[11369.354871]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.355489]  __x64_sys_futex+0x134/0x180
[11369.356081]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.356685]  do_syscall_64+0x5a/0x240
[11369.357256]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.357823] RIP: 0033:0x7f17f492d965
[11369.358447] Code: Bad RIP value.
[11369.359002] RSP: 002b:00007f17e38c5cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.359610] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f17f492d965
[11369.360254] RDX: 0000000000000004 RSI: 0000000000000080 RDI: 0000558da9a52b5c
[11369.360847] RBP: 0000558da9a52b40 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.361432] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b48
[11369.362055] R13: 0000558da9a52a90 R14: 0000558da9a52b58 R15: 0000558da9a52a50
[11369.362649] libvirtd        S    0  2081      1 0x00000080
[11369.363269] Call Trace:
[11369.363858]  ? __schedule+0x31a/0x850
[11369.364390]  schedule+0x36/0xc0
[11369.364992]  futex_wait_queue_me+0xbf/0x150
[11369.365635]  futex_wait+0xe2/0x240
[11369.366188]  do_futex+0x599/0x930
[11369.366745]  ? sched_clock+0x5/0x10
[11369.367304]  ? sched_clock+0x5/0x10
[11369.367864]  ? sched_clock_cpu+0xc/0xc0
[11369.368521]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.369120]  __x64_sys_futex+0x134/0x180
[11369.369677]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.370281]  do_syscall_64+0x5a/0x240
[11369.370891]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.371503] RIP: 0033:0x7f17f492d965
[11369.372121] Code: Bad RIP value.
[11369.372712] RSP: 002b:00007f17e30c4cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.373276] RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 00007f17f492d965
[11369.373883] RDX: 0000000000000005 RSI: 0000000000000080 RDI: 0000558da9a52b5c
[11369.374488] RBP: 0000558da9a52b40 R08: 0000558da9a52a00 R09: 0000000000000000
[11369.375064] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a52b48
[11369.375633] R13: 0000558da9a52a90 R14: 0000558da9a52b58 R15: 0000558da9a52a50
[11369.376287] libvirtd        S    0  2128      1 0x00000080
[11369.376934] Call Trace:
[11369.377578]  ? __schedule+0x31a/0x850
[11369.378182]  schedule+0x36/0xc0
[11369.378732]  futex_wait_queue_me+0xbf/0x150
[11369.379277]  futex_wait+0xe2/0x240
[11369.379866]  ? __lock_acquire+0x26c/0x1480
[11369.380496]  do_futex+0x599/0x930
[11369.381048]  ? sched_clock+0x5/0x10
[11369.381621]  ? sched_clock+0x5/0x10
[11369.382267]  ? sched_clock_cpu+0xc/0xc0
[11369.382855]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.383471]  __x64_sys_futex+0x134/0x180
[11369.384064]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.384661]  do_syscall_64+0x5a/0x240
[11369.385281]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.385846] RIP: 0033:0x7f17f492d965
[11369.386395] Code: Bad RIP value.
[11369.386971] RSP: 002b:00007f17d9493cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.387619] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.388226] RDX: 0000000000000001 RSI: 0000000000000080 RDI: 0000558da9a6a5ac
[11369.388853] RBP: 0000558da9a6a608 R08: 0000558da9a6a500 R09: 0000000000000000
[11369.389516] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a6a620
[11369.390145] R13: 0000558da9a6a580 R14: 0000558da9a6a5a8 R15: 0000558da9a6a540
[11369.390726] libvirtd        S    0  2130      1 0x00000080
[11369.391290] Call Trace:
[11369.391885]  ? __schedule+0x31a/0x850
[11369.392549]  schedule+0x36/0xc0
[11369.393094]  futex_wait_queue_me+0xbf/0x150
[11369.393672]  futex_wait+0xe2/0x240
[11369.394295]  do_futex+0x599/0x930
[11369.394869]  ? sched_clock+0x5/0x10
[11369.395421]  ? sched_clock+0x5/0x10
[11369.396044]  ? sched_clock_cpu+0xc/0xc0
[11369.396643]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.397251]  __x64_sys_futex+0x134/0x180
[11369.397832]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.398367]  do_syscall_64+0x5a/0x240
[11369.398909]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.399505] RIP: 0033:0x7f17f492d965
[11369.400078] Code: Bad RIP value.
[11369.400667] RSP: 002b:00007f17d8c92cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.401258] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.401831] RDX: 0000000000000002 RSI: 0000000000000080 RDI: 0000558da9a6a5ac
[11369.402396] RBP: 0000558da9a6a608 R08: 0000558da9a6a500 R09: 0000000000000000
[11369.402970] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a6a620
[11369.403620] R13: 0000558da9a6a580 R14: 0000558da9a6a5a8 R15: 0000558da9a6a540
[11369.404263] libvirtd        S    0  2131      1 0x00000080
[11369.404874] Call Trace:
[11369.405509]  ? __schedule+0x31a/0x850
[11369.406096]  schedule+0x36/0xc0
[11369.406644]  futex_wait_queue_me+0xbf/0x150
[11369.407243]  futex_wait+0xe2/0x240
[11369.407830]  do_futex+0x599/0x930
[11369.408371]  ? sched_clock+0x5/0x10
[11369.408952]  ? sched_clock+0x5/0x10
[11369.409582]  ? sched_clock_cpu+0xc/0xc0
[11369.410215]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.410805]  __x64_sys_futex+0x134/0x180
[11369.411369]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.411957]  do_syscall_64+0x5a/0x240
[11369.412637]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.413223] RIP: 0033:0x7f17f492d965
[11369.413790] Code: Bad RIP value.
[11369.414334] RSP: 002b:00007f17d8491cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.414958] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.415610] RDX: 0000000000000003 RSI: 0000000000000080 RDI: 0000558da9a6a5ac
[11369.416218] RBP: 0000558da9a6a608 R08: 0000558da9a6a500 R09: 0000000000000000
[11369.416807] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a6a620
[11369.417365] R13: 0000558da9a6a580 R14: 0000558da9a6a5a8 R15: 0000558da9a6a540
[11369.417955] libvirtd        S    0  2132      1 0x00000080
[11369.418624] Call Trace:
[11369.419211]  ? __schedule+0x31a/0x850
[11369.419814]  schedule+0x36/0xc0
[11369.420375]  futex_wait_queue_me+0xbf/0x150
[11369.420985]  futex_wait+0xe2/0x240
[11369.421624]  do_futex+0x599/0x930
[11369.422162]  ? sched_clock+0x5/0x10
[11369.422699]  ? sched_clock+0x5/0x10
[11369.423256]  ? sched_clock_cpu+0xc/0xc0
[11369.423810]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.424361]  __x64_sys_futex+0x134/0x180
[11369.424951]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.425567]  do_syscall_64+0x5a/0x240
[11369.426101]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.426682] RIP: 0033:0x7f17f492d965
[11369.427280] Code: Bad RIP value.
[11369.427837] RSP: 002b:00007f17d7c90cb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.428508] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.429126] RDX: 0000000000000004 RSI: 0000000000000080 RDI: 0000558da9a6a5ac
[11369.429691] RBP: 0000558da9a6a608 R08: 0000558da9a6a500 R09: 0000000000000000
[11369.430322] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a6a620
[11369.430931] R13: 0000558da9a6a580 R14: 0000558da9a6a5a8 R15: 0000558da9a6a540
[11369.431586] libvirtd        S    0  2133      1 0x00000080
[11369.432143] Call Trace:
[11369.432730]  ? __schedule+0x31a/0x850
[11369.433276]  schedule+0x36/0xc0
[11369.433828]  futex_wait_queue_me+0xbf/0x150
[11369.434458]  futex_wait+0xe2/0x240
[11369.435069]  do_futex+0x599/0x930
[11369.435636]  ? sched_clock+0x5/0x10
[11369.436276]  ? sched_clock+0x5/0x10
[11369.436846]  ? sched_clock_cpu+0xc/0xc0
[11369.437456]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.438050]  __x64_sys_futex+0x134/0x180
[11369.438626]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.439233]  do_syscall_64+0x5a/0x240
[11369.439808]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.440391] RIP: 0033:0x7f17f492d965
[11369.440977] Code: Bad RIP value.
[11369.441629] RSP: 002b:00007f17d748fcb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.442171] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f17f492d965
[11369.442821] RDX: 0000000000000005 RSI: 0000000000000080 RDI: 0000558da9a6a5ac
[11369.443539] RBP: 0000558da9a6a608 R08: 0000558da9a6a500 R09: 0000000000000000
[11369.444184] R10: 0000000000000000 R11: 0000000000000246 R12: 0000558da9a6a620
[11369.444774] R13: 0000558da9a6a580 R14: 0000558da9a6a5a8 R15: 0000558da9a6a540
[11369.445344] libvirtd        S    0  2196      1 0x00000080
[11369.445924] Call Trace:
[11369.446583]  ? __schedule+0x31a/0x850
[11369.447207]  schedule+0x36/0xc0
[11369.447805]  futex_wait_queue_me+0xbf/0x150
[11369.448389]  futex_wait+0xe2/0x240
[11369.449001]  ? ___sys_recvmsg+0x1ab/0x250
[11369.449684]  do_futex+0x599/0x930
[11369.450182]  ? sched_clock+0x5/0x10
[11369.450751]  ? sched_clock+0x5/0x10
[11369.451323]  ? sched_clock_cpu+0xc/0xc0
[11369.451904]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.452599]  __x64_sys_futex+0x134/0x180
[11369.453229]  ? trace_hardirqs_off_thunk+0x1a/0x20
[11369.453804]  do_syscall_64+0x5a/0x240
[11369.454442]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.455009] RIP: 0033:0x7f17f492d965
[11369.455571] Code: Bad RIP value.
[11369.456165] RSP: 002b:00007f17d627acb0 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[11369.456769] RAX: ffffffffffffffda RBX: 00007f17d00ee2a0 RCX: 00007f17f492d965
[11369.457399] RDX: 00000000000002ef RSI: 0000000000000080 RDI: 00007f17d00ee2f4
[11369.458059] RBP: 00007f17d00ee2f0 R08: 00007f17d00ee200 R09: 0000000000000177
[11369.458657] R10: 0000000000000000 R11: 0000000000000246 R12: 00007f17d00ee2b0
[11369.459291] R13: 0000000000000000 R14: 00007f17da737128 R15: 00007f17d627b550
[11369.459915] python          S    0  2066      1 0x00000080
[11369.460561] Call Trace:
[11369.461152]  ? __schedule+0x31a/0x850
[11369.461720]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.462278]  schedule+0x36/0xc0
[11369.462831]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.463391]  ? hrtimer_init_sleeper+0x100/0x100
[11369.463973]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.464663]  do_select+0x634/0x8b0
[11369.465301]  ? set_fd_set.part.2+0x40/0x40
[11369.465906]  ? mark_held_locks+0x50/0x80
[11369.466521]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.467112]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.467717]  ? trace_hardirqs_on_thunk+0x1a/0x20
[11369.468327]  ? __lock_acquire+0x26c/0x1480
[11369.468950]  ? __lock_acquire+0x26c/0x1480
[11369.469598]  ? sched_clock+0x5/0x10
[11369.470145]  ? sched_clock+0x5/0x10
[11369.470743]  ? sched_clock_cpu+0xc/0xc0
[11369.471478]  ? core_sys_select+0x213/0x410
[11369.472024]  core_sys_select+0x213/0x410
[11369.472610]  ? sched_clock+0x5/0x10
[11369.473191]  ? sched_clock+0x5/0x10
[11369.473724]  ? sched_clock_cpu+0xc/0xc0
[11369.474289]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.474815]  ? ktime_get_ts64+0xae/0x170
[11369.475352]  kern_select+0xb5/0x100
[11369.475905]  __x64_sys_select+0x20/0x30
[11369.476589]  do_syscall_64+0x5a/0x240
[11369.477153]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.477660] RIP: 0033:0x7f4a746b8f53
[11369.478273] Code: Bad RIP value.
[11369.478842] RSP: 002b:00007ffc3d855978 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[11369.479464] RAX: ffffffffffffffda RBX: 00007ffc3d855b60 RCX: 00007f4a746b8f53
[11369.480066] RDX: 00007ffc3d855a60 RSI: 00007ffc3d8559e0 RDI: 0000000000000004
[11369.480644] RBP: 00007ffc3d859b70 R08: 00007ffc3d8559d0 R09: 00007f4a68e55fe9
[11369.481249] R10: 00007ffc3d855ae0 R11: 0000000000000246 R12: 00007ffc3d85db80
[11369.481851] R13: 00007ffc3d8559e0 R14: 00007ffc3d855a60 R15: 0000000000000004
[11369.482528] crond           S    0  2069      1 0x00000080
[11369.483085] Call Trace:
[11369.483648]  ? __schedule+0x31a/0x850
[11369.484298]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.484922]  ? do_nanosleep+0x5b/0x1c0
[11369.485509]  schedule+0x36/0xc0
[11369.486047]  do_nanosleep+0xad/0x1c0
[11369.486572]  hrtimer_nanosleep+0xba/0x150
[11369.487158]  ? hrtimer_init_sleeper+0x100/0x100
[11369.487690]  __x64_sys_nanosleep+0x70/0xa0
[11369.488269]  do_syscall_64+0x5a/0x240
[11369.488833]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.489348] RIP: 0033:0x7f195d16be10
[11369.489896] Code: Bad RIP value.
[11369.490438] RSP: 002b:00007ffee91ec928 EFLAGS: 00000246 ORIG_RAX: 0000000000000023
[11369.491042] RAX: ffffffffffffffda RBX: 00007ffee91ec940 RCX: 00007f195d16be10
[11369.491589] RDX: 0000000000000000 RSI: 00007ffee91ec930 RDI: 00007ffee91ec930
[11369.492219] RBP: 00000000ffffffff R08: 00007ffee91eca40 R09: 00007ffee91ec880
[11369.492794] R10: 0000000000000008 R11: 0000000000000246 R12: 00007ffee91ec9c0
[11369.493332] R13: 00007ffee91ecb68 R14: 000000000192abac R15: 0000000000004d58
[11369.493907] agetty          S    0  2071      1 0x00000080
[11369.494589] Call Trace:
[11369.495192]  ? __schedule+0x31a/0x850
[11369.495748]  schedule+0x36/0xc0
[11369.496278]  schedule_timeout+0x204/0x3b0
[11369.496856]  ? sched_clock+0x5/0x10
[11369.497391]  ? sched_clock+0x5/0x10
[11369.497958]  ? sched_clock_cpu+0xc/0xc0
[11369.498612]  wait_woken+0x59/0xa0
[11369.499140]  ? up_read+0x1d/0x230
[11369.499698]  n_tty_read+0x49e/0x940
[11369.500273]  ? __ldsem_down_read_nested+0x79/0x290
[11369.500901]  ? do_wait_intr_irq+0xb0/0xb0
[11369.501490]  tty_read+0x78/0xd0
[11369.502042]  vfs_read+0x9e/0x170
[11369.502596]  ksys_read+0xa7/0xe0
[11369.503193]  do_syscall_64+0x5a/0x240
[11369.503785]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.504359] RIP: 0033:0x7f68397a5f70
[11369.504951] Code: Bad RIP value.
[11369.505545] RSP: 002b:00007fff8352e978 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[11369.506116] RAX: ffffffffffffffda RBX: 00007fff8352ed10 RCX: 00007f68397a5f70
[11369.506692] RDX: 0000000000000001 RSI: 00007fff8352e9b0 RDI: 0000000000000000
[11369.507290] RBP: 00007fff8352e9c0 R08: 0000000000000000 R09: 0000000001fa9840
[11369.507912] R10: 00007fff8352e060 R11: 0000000000000246 R12: 00000000006083a0
[11369.508565] R13: 0000000000000012 R14: 00007fff8352f200 R15: 0000000000000817
[11369.509186] atd             S    0  2084      1 0x00000080
[11369.509777] Call Trace:
[11369.510320]  ? __schedule+0x31a/0x850
[11369.510874]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.511475]  ? do_nanosleep+0x5b/0x1c0
[11369.512055]  schedule+0x36/0xc0
[11369.512634]  do_nanosleep+0xad/0x1c0
[11369.513245]  hrtimer_nanosleep+0xba/0x150
[11369.513841]  ? hrtimer_init_sleeper+0x100/0x100
[11369.514390]  __x64_sys_nanosleep+0x70/0xa0
[11369.514954]  do_syscall_64+0x5a/0x240
[11369.515593]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.516207] RIP: 0033:0x7f1498e0ce10
[11369.516781] Code: Bad RIP value.
[11369.517316] RSP: 002b:00007fff9f682c58 EFLAGS: 00000246 ORIG_RAX: 0000000000000023
[11369.517900] RAX: ffffffffffffffda RBX: 00007fff9f682c70 RCX: 00007f1498e0ce10
[11369.518502] RDX: 0000000000000000 RSI: 00007fff9f682c60 RDI: 00007fff9f682c60
[11369.519067] RBP: 00000000ffffffff R08: 00007fff9f682d70 R09: 00007fff9f682bb0
[11369.519630] R10: 0000000000000008 R11: 0000000000000246 R12: 00007fff9f682cf0
[11369.520260] R13: 000055eb1cc4f070 R14: 000055eb1cc4f06c R15: 0000000000000000
[11369.520859] rhnsd           S    0  2103      1 0x00000080
[11369.521394] Call Trace:
[11369.521934]  ? __schedule+0x31a/0x850
[11369.522550]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.523138]  ? do_nanosleep+0x5b/0x1c0
[11369.523725]  schedule+0x36/0xc0
[11369.524250]  do_nanosleep+0xad/0x1c0
[11369.524854]  hrtimer_nanosleep+0xba/0x150
[11369.525385]  ? hrtimer_init_sleeper+0x100/0x100
[11369.525996]  __x64_sys_nanosleep+0x70/0xa0
[11369.526657]  do_syscall_64+0x5a/0x240
[11369.527247]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.527841] RIP: 0033:0x7f00038d4e10
[11369.528516] Code: Bad RIP value.
[11369.529137] RSP: 002b:00007ffd2417a358 EFLAGS: 00000246 ORIG_RAX: 0000000000000023
[11369.529740] RAX: ffffffffffffffda RBX: 00007ffd2417a370 RCX: 00007f00038d4e10
[11369.530385] RDX: 0000000000000000 RSI: 00007ffd2417a360 RDI: 00007ffd2417a360
[11369.531027] RBP: 00000000ffffffff R08: 00007ffd2417a470 R09: 00007ffd2417a2b0
[11369.531708] R10: 0000000000000008 R11: 0000000000000246 R12: 00007ffd2417a3f0
[11369.532320] R13: 000000005e604cf4 R14: 0000000000000000 R15: 0000000000000000
[11369.533002] master          S    0  2322      1 0x00000080
[11369.533755] Call Trace:
[11369.534453]  ? __schedule+0x31a/0x850
[11369.535076]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.535671]  ? ep_poll+0x2c9/0x5b0
[11369.536316]  schedule+0x36/0xc0
[11369.536922]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.537586]  ? hrtimer_init_sleeper+0x100/0x100
[11369.538216]  ep_poll+0x2a9/0x5b0
[11369.538800]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.539369]  ? wake_up_q+0x80/0x80
[11369.539988]  do_epoll_wait+0xd7/0xf0
[11369.540722]  __x64_sys_epoll_wait+0x1a/0x20
[11369.541284]  do_syscall_64+0x5a/0x240
[11369.541894]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.542572] RIP: 0033:0x7f1db7da4463
[11369.543208] Code: Bad RIP value.
[11369.543788] RSP: 002b:00007fff718aeeb8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[11369.544391] RAX: ffffffffffffffda RBX: 00007fff718aeec0 RCX: 00007f1db7da4463
[11369.545060] RDX: 0000000000000064 RSI: 00007fff718aeec0 RDI: 000000000000000f
[11369.545735] RBP: 000000000000003c R08: 00005609f2aa2ba0 R09: 00005609f2aa1e70
[11369.546337] R10: 000000000000ea60 R11: 0000000000000246 R12: 00005609f2a6c6e4
[11369.546971] R13: 00005609f2a6c660 R14: 00005609f2a6d9c8 R15: 00005609f2aa44c0
[11369.547694] qmgr            S    0  2324   2322 0x00000080
[11369.548232] Call Trace:
[11369.548856]  ? __schedule+0x31a/0x850
[11369.549506]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.550097]  ? ep_poll+0x2c9/0x5b0
[11369.550668]  schedule+0x36/0xc0
[11369.551300]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.551893]  ? hrtimer_init_sleeper+0x100/0x100
[11369.552583]  ep_poll+0x2a9/0x5b0
[11369.553228]  ? wake_up_q+0x80/0x80
[11369.553863]  do_epoll_wait+0xd7/0xf0
[11369.554604]  __x64_sys_epoll_wait+0x1a/0x20
[11369.555230]  do_syscall_64+0x5a/0x240
[11369.555828]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.556486] RIP: 0033:0x7f26df264463
[11369.557066] Code: Bad RIP value.
[11369.557643] RSP: 002b:00007ffd85902b68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[11369.558316] RAX: ffffffffffffffda RBX: 00007ffd85902b70 RCX: 00007f26df264463
[11369.558923] RDX: 0000000000000064 RSI: 00007ffd85902b70 RDI: 0000000000000008
[11369.559590] RBP: 000000000000012c R08: 0000000000000000 R09: 00005567ea55aeb0
[11369.560238] R10: 00000000000493e0 R11: 0000000000000246 R12: 00005567e99fba44
[11369.560856] R13: 00005567e99fb9d0 R14: 00005567e99fba44 R15: 00005567e97adda0
[11369.561512] dnsmasq         S    0  2437      1 0x00000080
[11369.562099] Call Trace:
[11369.562694]  ? __schedule+0x31a/0x850
[11369.563294]  schedule+0x36/0xc0
[11369.563887]  schedule_hrtimeout_range_clock+0x104/0x110
[11369.564600]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.565243]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.565853]  do_sys_poll+0x3af/0x570
[11369.566589]  ? __lock_acquire+0x26c/0x1480
[11369.567175]  ? set_fd_set.part.2+0x40/0x40
[11369.567790]  ? set_fd_set.part.2+0x40/0x40
[11369.568389]  ? set_fd_set.part.2+0x40/0x40
[11369.569016]  ? set_fd_set.part.2+0x40/0x40
[11369.569672]  ? set_fd_set.part.2+0x40/0x40
[11369.570250]  ? set_fd_set.part.2+0x40/0x40
[11369.570811]  ? sched_clock+0x5/0x10
[11369.571347]  ? sched_clock+0x5/0x10
[11369.571913]  ? sched_clock_cpu+0xc/0xc0
[11369.572574]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.573107]  ? __x64_sys_poll+0x37/0x130
[11369.573635]  __x64_sys_poll+0x37/0x130
[11369.574228]  do_syscall_64+0x5a/0x240
[11369.574798]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.575304] RIP: 0033:0x7f3a100a21f0
[11369.575830] Code: Bad RIP value.
[11369.576357] RSP: 002b:00007ffc8f592458 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
[11369.576920] RAX: ffffffffffffffda RBX: 000000005e5fe0c9 RCX: 00007f3a100a21f0
[11369.577526] RDX: 00000000ffffffff RSI: 0000000000000006 RDI: 0000555b74a9e3a0
[11369.578078] RBP: 0000555b74224a20 R08: 0000555b74a9e3a0 R09: 0000000000000000
[11369.578605] R10: 0000000000000000 R11: 0000000000000246 R12: 00000000ffffffff
[11369.579181] R13: 00000000ffffffff R14: 00007ffc8f5924b0 R15: 0000000000000008
[11369.579761] dnsmasq         S    0  2438   2437 0x00000080
[11369.580322] Call Trace:
[11369.580895]  ? __schedule+0x31a/0x850
[11369.581532]  schedule+0x36/0xc0
[11369.582064]  pipe_wait+0x72/0xc0
[11369.582590]  ? finish_wait+0x80/0x80
[11369.583186]  pipe_read+0x22e/0x300
[11369.583747]  new_sync_read+0x127/0x1b0
[11369.584330]  vfs_read+0x9e/0x170
[11369.584905]  ksys_read+0xa7/0xe0
[11369.585493]  do_syscall_64+0x5a/0x240
[11369.586015]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.586511] RIP: 0033:0x7f3a1009df70
[11369.587069] Code: Bad RIP value.
[11369.587569] RSP: 002b:00007ffc8f592248 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[11369.588155] RAX: ffffffffffffffda RBX: 0000555b74a95040 RCX: 00007f3a1009df70
[11369.588739] RDX: 0000000000000070 RSI: 00007ffc8f592310 RDI: 000000000000000c
[11369.589284] RBP: 0000000000000070 R08: 0000000000000000 R09: 00007ffc8f5921f0
[11369.589819] R10: 0000000000000008 R11: 0000000000000246 R12: 00007ffc8f592310
[11369.590398] R13: 000000000000000c R14: 0000000000000001 R15: 0000000000000000
[11369.590949] kworker/12:0    I    0  3092      2 0x80004080
[11369.591584] Workqueue:  0x0 (events_power_efficient)
[11369.592183] Call Trace:
[11369.592744]  ? __schedule+0x31a/0x850
[11369.593284]  schedule+0x36/0xc0
[11369.593817]  worker_thread+0xc6/0x390
[11369.594353]  ? process_one_work+0x5d0/0x5d0
[11369.594889]  kthread+0x11f/0x140
[11369.595476]  ? kthread_park+0x90/0x90
[11369.596025]  ret_from_fork+0x24/0x30
[11369.596580] kworker/10:1    I    0  3148      2 0x80004080
[11369.597195] Workqueue:  0x0 (mm_percpu_wq)
[11369.597838] Call Trace:
[11369.598473]  ? __schedule+0x31a/0x850
[11369.599091]  schedule+0x36/0xc0
[11369.599663]  worker_thread+0xc6/0x390
[11369.600263]  ? process_one_work+0x5d0/0x5d0
[11369.600861]  kthread+0x11f/0x140
[11369.601471]  ? kthread_park+0x90/0x90
[11369.602062]  ret_from_fork+0x24/0x30
[11369.602641] kworker/8:0     R  running task        0  3269      2 0x80004080
[11369.603277] Workqueue:  0x0 (mm_percpu_wq)
[11369.603879] Call Trace:
[11369.604499]  ? __schedule+0x31a/0x850
[11369.605067]  schedule+0x36/0xc0
[11369.605612]  worker_thread+0xc6/0x390
[11369.606208]  ? process_one_work+0x5d0/0x5d0
[11369.606729]  kthread+0x11f/0x140
[11369.607229]  ? kthread_park+0x90/0x90
[11369.607761]  ret_from_fork+0x24/0x30
[11369.608286] kworker/1:0     I    0  3334      2 0x80004080
[11369.608874] Workqueue:  0x0 (events_power_efficient)
[11369.609456] Call Trace:
[11369.610028]  ? __schedule+0x31a/0x850
[11369.610581]  schedule+0x36/0xc0
[11369.611154]  worker_thread+0xc6/0x390
[11369.611683]  ? process_one_work+0x5d0/0x5d0
[11369.612239]  kthread+0x11f/0x140
[11369.612824]  ? kthread_park+0x90/0x90
[11369.613357]  ret_from_fork+0x24/0x30
[11369.613955] kworker/5:0     I    0  3358      2 0x80004080
[11369.614590] Workqueue:  0x0 (cgroup_pidlist_destroy)
[11369.615175] Call Trace:
[11369.615732]  ? __schedule+0x31a/0x850
[11369.616271]  schedule+0x36/0xc0
[11369.616847]  worker_thread+0xc6/0x390
[11369.617359]  ? process_one_work+0x5d0/0x5d0
[11369.617921]  kthread+0x11f/0x140
[11369.618498]  ? kthread_park+0x90/0x90
[11369.619090]  ret_from_fork+0x24/0x30
[11369.619639] kworker/9:1     I    0  4058      2 0x80004080
[11369.620149] Workqueue:  0x0 (cgroup_destroy)
[11369.620708] Call Trace:
[11369.621193]  ? __schedule+0x31a/0x850
[11369.621751]  schedule+0x36/0xc0
[11369.622253]  worker_thread+0xc6/0x390
[11369.622777]  ? process_one_work+0x5d0/0x5d0
[11369.623285]  kthread+0x11f/0x140
[11369.623816]  ? kthread_park+0x90/0x90
[11369.624352]  ret_from_fork+0x24/0x30
[11369.624901] kworker/10:2    I    0  4111      2 0x80004080
[11369.625475] Workqueue:  0x0 (cgroup_pidlist_destroy)
[11369.625982] Call Trace:
[11369.626484]  ? __schedule+0x31a/0x850
[11369.627050]  schedule+0x36/0xc0
[11369.627550]  worker_thread+0xc6/0x390
[11369.628128]  ? process_one_work+0x5d0/0x5d0
[11369.628679]  kthread+0x11f/0x140
[11369.629265]  ? kthread_park+0x90/0x90
[11369.629794]  ret_from_fork+0x24/0x30
[11369.630305] kworker/2:0     I    0  4191      2 0x80004080
[11369.630940] Workqueue:  0x0 (cgroup_destroy)
[11369.631518] Call Trace:
[11369.632085]  ? __schedule+0x31a/0x850
[11369.632632]  schedule+0x36/0xc0
[11369.633190]  worker_thread+0xc6/0x390
[11369.633727]  ? process_one_work+0x5d0/0x5d0
[11369.634219]  kthread+0x11f/0x140
[11369.634737]  ? kthread_park+0x90/0x90
[11369.635277]  ret_from_fork+0x24/0x30
[11369.635796] pickup          S    0  4201   2322 0x00000080
[11369.636295] Call Trace:
[11369.636836]  ? __schedule+0x31a/0x850
[11369.637334]  ? hrtimer_start_range_ns+0x1d9/0x320
[11369.637871]  ? ep_poll+0x2c9/0x5b0
[11369.638452]  schedule+0x36/0xc0
[11369.639021]  schedule_hrtimeout_range_clock+0x8d/0x110
[11369.639545]  ? hrtimer_init_sleeper+0x100/0x100
[11369.640112]  ep_poll+0x2a9/0x5b0
[11369.640654]  ? wake_up_q+0x80/0x80
[11369.641169]  do_epoll_wait+0xd7/0xf0
[11369.641698]  __x64_sys_epoll_wait+0x1a/0x20
[11369.642277]  do_syscall_64+0x5a/0x240
[11369.642818]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.643321] RIP: 0033:0x7fc880848463
[11369.643857] Code: Bad RIP value.
[11369.644389] RSP: 002b:00007ffd947c18c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000e8
[11369.644965] RAX: ffffffffffffffda RBX: 00007ffd947c18d0 RCX: 00007fc880848463
[11369.645607] RDX: 0000000000000064 RSI: 00007ffd947c18d0 RDI: 0000000000000008
[11369.646215] RBP: 0000000000000064 R08: 0000000000000003 R09: 0000000000000040
[11369.646769] R10: 00000000000186a0 R11: 0000000000000246 R12: 0000556601ab89a4
[11369.647332] R13: 0000556601ab8930 R14: 0000556601ab89a4 R15: 000055660187b7d0
[11369.647971] kworker/6:0     I    0  4281      2 0x80004080
[11369.648633] Workqueue:  0x0 (target_completion)
[11369.649223] Call Trace:
[11369.649809]  ? __schedule+0x31a/0x850
[11369.650361]  schedule+0x36/0xc0
[11369.650922]  worker_thread+0xc6/0x390
[11369.651564]  ? process_one_work+0x5d0/0x5d0
[11369.652172]  kthread+0x11f/0x140
[11369.652731]  ? kthread_park+0x90/0x90
[11369.653324]  ret_from_fork+0x24/0x30
[11369.653941] kworker/3:0     I    0  4427      2 0x80004080
[11369.654573] Workqueue:  0x0 (mm_percpu_wq)
[11369.655181] Call Trace:
[11369.655730]  ? __schedule+0x31a/0x850
[11369.656285]  schedule+0x36/0xc0
[11369.656862]  worker_thread+0xc6/0x390
[11369.657474]  ? process_one_work+0x5d0/0x5d0
[11369.658040]  kthread+0x11f/0x140
[11369.658559]  ? kthread_park+0x90/0x90
[11369.659144]  ret_from_fork+0x24/0x30
[11369.659732] sshd            S    0  4524   2019 0x00000080
[11369.660312] Call Trace:
[11369.660932]  ? __schedule+0x31a/0x850
[11369.661576]  ? sched_clock+0x5/0x10
[11369.662201]  schedule+0x36/0xc0
[11369.662771]  schedule_hrtimeout_range_clock+0x104/0x110
[11369.663308]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.663835]  do_select+0x634/0x8b0
[11369.664373]  ? set_fd_set.part.2+0x40/0x40
[11369.664998]  ? set_fd_set.part.2+0x40/0x40
[11369.665625]  ? set_fd_set.part.2+0x40/0x40
[11369.666201]  ? set_fd_set.part.2+0x40/0x40
[11369.666738]  ? set_fd_set.part.2+0x40/0x40
[11369.667282]  ? set_fd_set.part.2+0x40/0x40
[11369.667795]  ? __lock_acquire+0x26c/0x1480
[11369.668293]  ? sched_clock+0x5/0x10
[11369.668826]  ? sched_clock+0x5/0x10
[11369.669311]  ? sched_clock_cpu+0xc/0xc0
[11369.669819]  ? core_sys_select+0x213/0x410
[11369.670311]  core_sys_select+0x213/0x410
[11369.670830]  ? sched_clock+0x5/0x10
[11369.671335]  ? sched_clock+0x5/0x10
[11369.671820]  ? sched_clock_cpu+0xc/0xc0
[11369.672309]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.672808]  kern_select+0xb5/0x100
[11369.673287]  __x64_sys_select+0x20/0x30
[11369.673769]  do_syscall_64+0x5a/0x240
[11369.674242]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.674750] RIP: 0033:0x7f2be1b99f53
[11369.675214] Code: Bad RIP value.
[11369.675648] RSP: 002b:00007ffdaea009a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[11369.676195] RAX: ffffffffffffffda RBX: 0000558e57d63068 RCX: 00007f2be1b99f53
[11369.676689] RDX: 0000558e588c1e50 RSI: 0000558e588dd140 RDI: 000000000000000f
[11369.677215] RBP: 0000558e588dd140 R08: 0000000000000000 R09: 00007ffdaea00920
[11369.677701] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffdaea009ff
[11369.678194] R13: 0000558e57d5c7a0 R14: 0000000000000003 R15: 0000000000000000
[11369.678715] sshd            S    0  4526   2019 0x00000080
[11369.679226] Call Trace:
[11369.679720]  ? __schedule+0x31a/0x850
[11369.680207]  schedule+0x36/0xc0
[11369.680705]  schedule_hrtimeout_range_clock+0x104/0x110
[11369.681238]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.681762]  do_select+0x634/0x8b0
[11369.682307]  ? set_fd_set.part.2+0x40/0x40
[11369.682850]  ? set_fd_set.part.2+0x40/0x40
[11369.683339]  ? set_fd_set.part.2+0x40/0x40
[11369.683881]  ? set_fd_set.part.2+0x40/0x40
[11369.684344]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.684881]  ? __lock_acquire+0x26c/0x1480
[11369.685336]  ? __lock_acquire+0x26c/0x1480
[11369.685807]  ? sched_clock+0x5/0x10
[11369.686256]  ? sched_clock+0x5/0x10
[11369.686711]  ? sched_clock_cpu+0xc/0xc0
[11369.687163]  ? core_sys_select+0x213/0x410
[11369.687613]  core_sys_select+0x213/0x410
[11369.688088]  ? sched_clock+0x5/0x10
[11369.688548]  ? sched_clock+0x5/0x10
[11369.688995]  ? sched_clock_cpu+0xc/0xc0
[11369.689442]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.689936]  kern_select+0xb5/0x100
[11369.690370]  __x64_sys_select+0x20/0x30
[11369.690864]  do_syscall_64+0x5a/0x240
[11369.691312]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.691800] RIP: 0033:0x7fc6482cdf53
[11369.692261] Code: Bad RIP value.
[11369.692793] RSP: 002b:00007ffd85866658 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[11369.693290] RAX: ffffffffffffffda RBX: 000055f573b00068 RCX: 00007fc6482cdf53
[11369.693830] RDX: 000055f574c0d8f0 RSI: 000055f574bf38f0 RDI: 000000000000000f
[11369.694354] RBP: 000055f574bf38f0 R08: 0000000000000000 R09: 00007ffd858665d0
[11369.694936] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd858666af
[11369.695586] R13: 000055f573af97a0 R14: 0000000000000003 R15: 0000000000000000
[11369.696180] bash            S    0  4527   4524 0x00000080
[11369.696773] Call Trace:
[11369.697290]  ? __schedule+0x31a/0x850
[11369.697847]  ? do_wait+0xd8/0x2c0
[11369.698362]  schedule+0x36/0xc0
[11369.698887]  do_wait+0x1f9/0x2c0
[11369.699436]  kernel_wait4+0x8d/0x150
[11369.700003]  ? __list_del_entry+0x20/0x20
[11369.700532]  __do_sys_wait4+0x95/0xa0
[11369.701092]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.701591]  ? syscall_trace_enter+0x175/0x320
[11369.702128]  ? do_syscall_64+0x5a/0x240
[11369.702618]  do_syscall_64+0x5a/0x240
[11369.703137]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.703621] RIP: 0033:0x7fc9a1a72a3c
[11369.704180] Code: Bad RIP value.
[11369.704679] RSP: 002b:00007ffe6be7d018 EFLAGS: 00000246 ORIG_RAX: 000000000000003d
[11369.705173] RAX: ffffffffffffffda RBX: 000000000000000a RCX: 00007fc9a1a72a3c
[11369.705683] RDX: 000000000000000a RSI: 00007ffe6be7d040 RDI: ffffffffffffffff
[11369.706206] RBP: 0000000000e42270 R08: 0000000000e42270 R09: 0000000000000000
[11369.706732] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[11369.707252] R13: 0000000000000001 R14: 0000000000e33630 R15: 0000000000000000
[11369.707805] sftp-server     S    0  4577   4526 0x00000080
[11369.708334] Call Trace:
[11369.708942]  ? __schedule+0x31a/0x850
[11369.709550]  schedule+0x36/0xc0
[11369.710103]  schedule_hrtimeout_range_clock+0x104/0x110
[11369.710670]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.711278]  do_select+0x634/0x8b0
[11369.711880]  ? set_fd_set.part.2+0x40/0x40
[11369.712481]  ? rcu_read_lock_sched_held+0x52/0x80
[11369.713027]  ? __update_load_avg_cfs_rq+0x12b/0x330
[11369.713606]  ? rcu_read_lock_sched_held+0x52/0x80
[11369.714226]  ? update_load_avg+0x739/0x770
[11369.714809]  ? update_curr+0x112/0x400
[11369.715373]  ? account_entity_enqueue+0x9c/0xd0
[11369.715983]  ? __lock_acquire+0x26c/0x1480
[11369.716686]  ? __lock_acquire+0x26c/0x1480
[11369.717270]  ? sched_clock+0x5/0x10
[11369.717877]  ? sched_clock+0x5/0x10
[11369.718476]  ? sched_clock_cpu+0xc/0xc0
[11369.719113]  ? core_sys_select+0x213/0x410
[11369.719685]  core_sys_select+0x213/0x410
[11369.720254]  ? sched_clock+0x5/0x10
[11369.720815]  ? sched_clock+0x5/0x10
[11369.721323]  ? sched_clock_cpu+0xc/0xc0
[11369.721851]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.722374]  kern_select+0xb5/0x100
[11369.722951]  __x64_sys_select+0x20/0x30
[11369.723577]  do_syscall_64+0x5a/0x240
[11369.724140]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.724669] RIP: 0033:0x1553aeacff53
[11369.725255] Code: Bad RIP value.
[11369.725769] RSP: 002b:00007ffd38b45a58 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[11369.726313] RAX: ffffffffffffffda RBX: 00005594b69ad7d0 RCX: 00001553aeacff53
[11369.726868] RDX: 00005594b69ad7d0 RSI: 00005594b69ad7b0 RDI: 0000000000000002
[11369.727466] RBP: 00005594b69ad7b0 R08: 0000000000000000 R09: 00005594b69ad7f0
[11369.728022] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[11369.728602] R13: 00007ffd38b45ab0 R14: 00007ffd38b45a9c R15: 00007ffd38b45a9b
[11369.729248] kworker/0:0     I    0  4616      2 0x80004080
[11369.729817] Workqueue:  0x0 (events)
[11369.730371] Call Trace:
[11369.730933]  ? __schedule+0x31a/0x850
[11369.731587]  schedule+0x36/0xc0
[11369.732101]  worker_thread+0xc6/0x390
[11369.732650]  ? process_one_work+0x5d0/0x5d0
[11369.733235]  kthread+0x11f/0x140
[11369.733757]  ? kthread_park+0x90/0x90
[11369.734284]  ret_from_fork+0x24/0x30
[11369.734850] kworker/8:1     I    0  4627      2 0x80004080
[11369.735380] Workqueue:  0x0 (events)
[11369.735935] Call Trace:
[11369.736542]  ? __schedule+0x31a/0x850
[11369.737118]  schedule+0x36/0xc0
[11369.737653]  worker_thread+0xc6/0x390
[11369.738249]  ? process_one_work+0x5d0/0x5d0
[11369.738761]  kthread+0x11f/0x140
[11369.739263]  ? kthread_park+0x90/0x90
[11369.739798]  ret_from_fork+0x24/0x30
[11369.740341] kworker/11:0    I    0  4628      2 0x80004080
[11369.740887] Workqueue:  0x0 (mm_percpu_wq)
[11369.741370] Call Trace:
[11369.741862]  ? __schedule+0x31a/0x850
[11369.742350]  schedule+0x36/0xc0
[11369.742893]  worker_thread+0xc6/0x390
[11369.743462]  ? process_one_work+0x5d0/0x5d0
[11369.744026]  kthread+0x11f/0x140
[11369.744567]  ? kthread_park+0x90/0x90
[11369.745134]  ret_from_fork+0x24/0x30
[11369.745687] kworker/1:1     I    0  4636      2 0x80004080
[11369.746214] Call Trace:
[11369.746750]  ? __schedule+0x31a/0x850
[11369.747279]  schedule+0x36/0xc0
[11369.747816]  worker_thread+0xc6/0x390
[11369.748358]  ? process_one_work+0x5d0/0x5d0
[11369.748929]  kthread+0x11f/0x140
[11369.749554]  ? kthread_park+0x90/0x90
[11369.750141]  ret_from_fork+0x24/0x30
[11369.750688] kworker/15:0    I    0  4651      2 0x80004080
[11369.751257] Workqueue:  0x0 (events)
[11369.751824] Call Trace:
[11369.752357]  ? __schedule+0x31a/0x850
[11369.752919]  schedule+0x36/0xc0
[11369.753509]  worker_thread+0xc6/0x390
[11369.754022]  ? process_one_work+0x5d0/0x5d0
[11369.754511]  kthread+0x11f/0x140
[11369.755126]  ? kthread_park+0x90/0x90
[11369.755630]  ret_from_fork+0x24/0x30
[11369.756194] cxgb4           I    0  4657      2 0x80004080
[11369.756709] Call Trace:
[11369.757253]  ? __schedule+0x31a/0x850
[11369.757767]  schedule+0x36/0xc0
[11369.758289]  rescuer_thread+0x2fd/0x360
[11369.758822]  ? cancel_delayed_work+0xb0/0xb0
[11369.759350]  kthread+0x11f/0x140
[11369.759882]  ? kthread_park+0x90/0x90
[11369.760398]  ret_from_fork+0x24/0x30
[11369.760994] cxgb4_eeh       I    0  4658      2 0x80004080
[11369.761460] Call Trace:
[11369.762011]  ? __schedule+0x31a/0x850
[11369.762510]  schedule+0x36/0xc0
[11369.763067]  rescuer_thread+0x2fd/0x360
[11369.763563]  ? cancel_delayed_work+0xb0/0xb0
[11369.764113]  kthread+0x11f/0x140
[11369.764628]  ? kthread_park+0x90/0x90
[11369.765163]  ret_from_fork+0x24/0x30
[11369.765688] iw_cxgb4        I    0  4666      2 0x80004080
[11369.766247] Call Trace:
[11369.766812]  ? __schedule+0x31a/0x850
[11369.767312]  schedule+0x36/0xc0
[11369.767809]  rescuer_thread+0x2fd/0x360
[11369.768313]  ? cancel_delayed_work+0xb0/0xb0
[11369.768847]  kthread+0x11f/0x140
[11369.769382]  ? kthread_park+0x90/0x90
[11369.769900]  ret_from_fork+0x24/0x30
[11369.770390] Register_iWARP_ I    0  4667      2 0x80004080
[11369.770930] Call Trace:
[11369.771461]  ? __schedule+0x31a/0x850
[11369.771943]  schedule+0x36/0xc0
[11369.772387]  rescuer_thread+0x2fd/0x360
[11369.772924]  ? cancel_delayed_work+0xb0/0xb0
[11369.773473]  kthread+0x11f/0x140
[11369.773954]  ? kthread_park+0x90/0x90
[11369.774387]  ret_from_fork+0x24/0x30
[11369.774903] iscsi_eh        I    0  4751      2 0x80004080
[11369.775529] Call Trace:
[11369.776007]  ? __schedule+0x31a/0x850
[11369.776524]  schedule+0x36/0xc0
[11369.777098]  rescuer_thread+0x2fd/0x360
[11369.777624]  ? cancel_delayed_work+0xb0/0xb0
[11369.778166]  kthread+0x11f/0x140
[11369.778643]  ? kthread_park+0x90/0x90
[11369.779231]  ret_from_fork+0x24/0x30
[11369.779748] iw_cxgb4_free   I    0  4770      2 0x80004080
[11369.780281] Call Trace:
[11369.780810]  ? __schedule+0x31a/0x850
[11369.781341]  schedule+0x36/0xc0
[11369.781871]  rescuer_thread+0x2fd/0x360
[11369.782387]  ? cancel_delayed_work+0xb0/0xb0
[11369.782920]  kthread+0x11f/0x140
[11369.783458]  ? kthread_park+0x90/0x90
[11369.783979]  ret_from_fork+0x24/0x30
[11369.784510] rdma-ndd        S    0  4775      1 0x00000080
[11369.785069] Call Trace:
[11369.785582]  ? __schedule+0x31a/0x850
[11369.786126]  schedule+0x36/0xc0
[11369.786642]  schedule_hrtimeout_range_clock+0x104/0x110
[11369.787206]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.787737]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11369.788251]  do_sys_poll+0x3af/0x570
[11369.788804]  ? __lock_acquire+0x26c/0x1480
[11369.789314]  ? __lock_acquire+0x26c/0x1480
[11369.789823]  ? mark_held_locks+0x50/0x80
[11369.790329]  ? set_fd_set.part.2+0x40/0x40
[11369.790843]  ? set_fd_set.part.2+0x40/0x40
[11369.791339]  ? release_pages+0x313/0x420
[11369.791852]  ? __lock_acquire+0x26c/0x1480
[11369.792345]  ? sched_clock+0x5/0x10
[11369.792910]  ? sched_clock+0x5/0x10
[11369.793392]  ? sched_clock_cpu+0xc/0xc0
[11369.793908]  ? lockdep_hardirqs_on+0xf0/0x180
[11369.794395]  ? __x64_sys_poll+0x37/0x130
[11369.794928]  __x64_sys_poll+0x37/0x130
[11369.795465]  do_syscall_64+0x5a/0x240
[11369.795974]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11369.796469] RIP: 0033:0x7fcf5637a1f0
[11369.797010] Code: Bad RIP value.
[11369.797524] RSP: 002b:00007ffebf26e978 EFLAGS: 00000246 ORIG_RAX: 0000000000000007
[11369.798078] RAX: ffffffffffffffda RBX: 0000000001e974c0 RCX: 00007fcf5637a1f0
[11369.798610] RDX: 00000000ffffffff RSI: 0000000000000002 RDI: 00007ffebf26e980
[11369.799184] RBP: 0000000001e972f0 R08: 0000000000000001 R09: 0000000001e974c0
[11369.799690] R10: 00007fcf5664d7b8 R11: 0000000000000246 R12: 0000000001e97f20
[11369.800177] R13: 0000000000000004 R14: 0000000000000002 R15: 0000000000000000
[11369.800759] nvmet-buffered- I    0  4793      2 0x80004080
[11369.801266] Call Trace:
[11369.801788]  ? __schedule+0x31a/0x850
[11369.802306]  schedule+0x36/0xc0
[11369.802825]  rescuer_thread+0x2fd/0x360
[11369.803359]  ? cancel_delayed_work+0xb0/0xb0
[11369.803883]  kthread+0x11f/0x140
[11369.804467]  ? kthread_park+0x90/0x90
[11369.805017]  ret_from_fork+0x24/0x30
[11369.805507] mlx5_health0000 I    0  4802      2 0x80004080
[11369.806117] Call Trace:
[11369.806622]  ? __schedule+0x31a/0x850
[11369.807193]  schedule+0x36/0xc0
[11369.807744]  rescuer_thread+0x2fd/0x360
[11369.808252]  ? cancel_delayed_work+0xb0/0xb0
[11369.808813]  kthread+0x11f/0x140
[11369.809316]  ? kthread_park+0x90/0x90
[11369.809838]  ret_from_fork+0x24/0x30
[11369.810356] mlx5_page_alloc I    0  4803      2 0x80004080
[11369.810897] Call Trace:
[11369.811525]  ? __schedule+0x31a/0x850
[11369.812058]  schedule+0x36/0xc0
[11369.812579]  rescuer_thread+0x2fd/0x360
[11369.813131]  ? cancel_delayed_work+0xb0/0xb0
[11369.813652]  kthread+0x11f/0x140
[11369.814167]  ? kthread_park+0x90/0x90
[11369.814684]  ret_from_fork+0x24/0x30
[11369.815214] mlx5_cmd_0000:0 I    0  4804      2 0x80004080
[11369.815725] Call Trace:
[11369.816228]  ? __schedule+0x31a/0x850
[11369.816827]  schedule+0x36/0xc0
[11369.817399]  rescuer_thread+0x2fd/0x360
[11369.817983]  ? cancel_delayed_work+0xb0/0xb0
[11369.818546]  kthread+0x11f/0x140
[11369.819116]  ? kthread_park+0x90/0x90
[11369.819664]  ret_from_fork+0x24/0x30
[11369.820192] mlx5_events     I    0  4805      2 0x80004080
[11369.820755] Call Trace:
[11369.821258]  ? __schedule+0x31a/0x850
[11369.821781]  schedule+0x36/0xc0
[11369.822287]  rescuer_thread+0x2fd/0x360
[11369.822832]  ? cancel_delayed_work+0xb0/0xb0
[11369.823342]  kthread+0x11f/0x140
[11369.823885]  ? kthread_park+0x90/0x90
[11369.824400]  ret_from_fork+0x24/0x30
[11369.824983] mlx5_esw_wq     I    0  4806      2 0x80004080
[11369.825479] Call Trace:
[11369.826040]  ? __schedule+0x31a/0x850
[11369.826534]  schedule+0x36/0xc0
[11369.827081]  rescuer_thread+0x2fd/0x360
[11369.827602]  ? cancel_delayed_work+0xb0/0xb0
[11369.828160]  kthread+0x11f/0x140
[11369.828708]  ? kthread_park+0x90/0x90
[11369.829252]  ret_from_fork+0x24/0x30
[11369.829740] mlx5_fw_tracer  I    0  4807      2 0x80004080
[11369.830211] Call Trace:
[11369.830750]  ? __schedule+0x31a/0x850
[11369.831243]  schedule+0x36/0xc0
[11369.831773]  rescuer_thread+0x2fd/0x360
[11369.832280]  ? cancel_delayed_work+0xb0/0xb0
[11369.832812]  kthread+0x11f/0x140
[11369.833324]  ? kthread_park+0x90/0x90
[11369.833883]  ret_from_fork+0x24/0x30
[11369.834438] mlx5_hv_vhca    I    0  4808      2 0x80004080
[11369.834965] Call Trace:
[11369.835393]  ? __schedule+0x31a/0x850
[11369.835896]  schedule+0x36/0xc0
[11369.836489]  rescuer_thread+0x2fd/0x360
[11369.837032]  ? cancel_delayed_work+0xb0/0xb0
[11369.837511]  kthread+0x11f/0x140
[11369.838061]  ? kthread_park+0x90/0x90
[11369.838546]  ret_from_fork+0x24/0x30
[11369.839093] mlx5_fc         I    0  4809      2 0x80004080
[11369.839595] Call Trace:
[11369.840134]  ? __schedule+0x31a/0x850
[11369.840696]  schedule+0x36/0xc0
[11369.841252]  rescuer_thread+0x2fd/0x360
[11369.841750]  ? cancel_delayed_work+0xb0/0xb0
[11369.842233]  kthread+0x11f/0x140
[11369.842741]  ? kthread_park+0x90/0x90
[11369.843259]  ret_from_fork+0x24/0x30
[11369.843775] mlx5_health0000 I    0  4811      2 0x80004080
[11369.844300] Call Trace:
[11369.844838]  ? __schedule+0x31a/0x850
[11369.845338]  schedule+0x36/0xc0
[11369.845882]  rescuer_thread+0x2fd/0x360
[11369.846379]  ? cancel_delayed_work+0xb0/0xb0
[11369.846930]  kthread+0x11f/0x140
[11369.847522]  ? kthread_park+0x90/0x90
[11369.848048]  ret_from_fork+0x24/0x30
[11369.848575] mlx5_page_alloc I    0  4812      2 0x80004080
[11369.849122] Call Trace:
[11369.849626]  ? __schedule+0x31a/0x850
[11369.850161]  schedule+0x36/0xc0
[11369.850652]  rescuer_thread+0x2fd/0x360
[11369.851143]  ? cancel_delayed_work+0xb0/0xb0
[11369.851638]  kthread+0x11f/0x140
[11369.852174]  ? kthread_park+0x90/0x90
[11369.852693]  ret_from_fork+0x24/0x30
[11369.853205] mlx5_cmd_0000:0 I    0  4813      2 0x80004080
[11369.853714] Call Trace:
[11369.854240]  ? __schedule+0x31a/0x850
[11369.854792]  schedule+0x36/0xc0
[11369.855275]  rescuer_thread+0x2fd/0x360
[11369.855785]  ? cancel_delayed_work+0xb0/0xb0
[11369.856269]  kthread+0x11f/0x140
[11369.856821]  ? kthread_park+0x90/0x90
[11369.857320]  ret_from_fork+0x24/0x30
[11369.857823] mlx5_events     I    0  4814      2 0x80004080
[11369.858331] Call Trace:
[11369.858849]  ? __schedule+0x31a/0x850
[11369.859359]  schedule+0x36/0xc0
[11369.859886]  rescuer_thread+0x2fd/0x360
[11369.860393]  ? cancel_delayed_work+0xb0/0xb0
[11369.860960]  kthread+0x11f/0x140
[11369.861588]  ? kthread_park+0x90/0x90
[11369.862138]  ret_from_fork+0x24/0x30
[11369.862662] mlx5_esw_wq     I    0  4815      2 0x80004080
[11369.863244] Call Trace:
[11369.863752]  ? __schedule+0x31a/0x850
[11369.864244]  schedule+0x36/0xc0
[11369.864792]  rescuer_thread+0x2fd/0x360
[11369.865317]  ? cancel_delayed_work+0xb0/0xb0
[11369.865813]  kthread+0x11f/0x140
[11369.866315]  ? kthread_park+0x90/0x90
[11369.866849]  ret_from_fork+0x24/0x30
[11369.867375] mlx5_fw_tracer  I    0  4816      2 0x80004080
[11369.867905] Call Trace:
[11369.868448]  ? __schedule+0x31a/0x850
[11369.868964]  schedule+0x36/0xc0
[11369.869433]  rescuer_thread+0x2fd/0x360
[11369.869997]  ? cancel_delayed_work+0xb0/0xb0
[11369.870491]  kthread+0x11f/0x140
[11369.871042]  ? kthread_park+0x90/0x90
[11369.871563]  ret_from_fork+0x24/0x30
[11369.872091] mlx5_hv_vhca    I    0  4817      2 0x80004080
[11369.872623] Call Trace:
[11369.873193]  ? __schedule+0x31a/0x850
[11369.873682]  schedule+0x36/0xc0
[11369.874136]  rescuer_thread+0x2fd/0x360
[11369.874637]  ? cancel_delayed_work+0xb0/0xb0
[11369.875190]  kthread+0x11f/0x140
[11369.875690]  ? kthread_park+0x90/0x90
[11369.876177]  ret_from_fork+0x24/0x30
[11369.876722] mlx5_fc         I    0  4818      2 0x80004080
[11369.877225] Call Trace:
[11369.877751]  ? __schedule+0x31a/0x850
[11369.878233]  schedule+0x36/0xc0
[11369.878730]  rescuer_thread+0x2fd/0x360
[11369.879219]  ? cancel_delayed_work+0xb0/0xb0
[11369.879718]  kthread+0x11f/0x140
[11369.880260]  ? kthread_park+0x90/0x90
[11369.880843]  ret_from_fork+0x24/0x30
[11369.881458] mlx5e           I    0  4820      2 0x80004080
[11369.882004] Call Trace:
[11369.882503]  ? __schedule+0x31a/0x850
[11369.883030]  schedule+0x36/0xc0
[11369.883519]  rescuer_thread+0x2fd/0x360
[11369.884067]  ? cancel_delayed_work+0xb0/0xb0
[11369.884611]  kthread+0x11f/0x140
[11369.885188]  ? kthread_park+0x90/0x90
[11369.885670]  ret_from_fork+0x24/0x30
[11369.886216] mlx5e_arfs      I    0  4821      2 0x80004080
[11369.886742] Call Trace:
[11369.887249]  ? __schedule+0x31a/0x850
[11369.887804]  schedule+0x36/0xc0
[11369.888278]  rescuer_thread+0x2fd/0x360
[11369.888816]  ? cancel_delayed_work+0xb0/0xb0
[11369.889318]  kthread+0x11f/0x140
[11369.889831]  ? kthread_park+0x90/0x90
[11369.890331]  ret_from_fork+0x24/0x30
[11369.890894] mlx5_lag        I    0  4823      2 0x80004080
[11369.891424] Call Trace:
[11369.891968]  ? __schedule+0x31a/0x850
[11369.892497]  schedule+0x36/0xc0
[11369.893026]  rescuer_thread+0x2fd/0x360
[11369.893548]  ? cancel_delayed_work+0xb0/0xb0
[11369.894071]  kthread+0x11f/0x140
[11369.894561]  ? kthread_park+0x90/0x90
[11369.895142]  ret_from_fork+0x24/0x30
[11369.895655] mlx5e           I    0  4825      2 0x80004080
[11369.896234] Call Trace:
[11369.896778]  ? __schedule+0x31a/0x850
[11369.897280]  schedule+0x36/0xc0
[11369.897749]  rescuer_thread+0x2fd/0x360
[11369.898253]  ? cancel_delayed_work+0xb0/0xb0
[11369.898781]  kthread+0x11f/0x140
[11369.899307]  ? kthread_park+0x90/0x90
[11369.899799]  ret_from_fork+0x24/0x30
[11369.900308] mlx5e_arfs      I    0  4826      2 0x80004080
[11369.900865] Call Trace:
[11369.901367]  ? __schedule+0x31a/0x850
[11369.901890]  schedule+0x36/0xc0
[11369.902452]  rescuer_thread+0x2fd/0x360
[11369.902991]  ? cancel_delayed_work+0xb0/0xb0
[11369.903501]  kthread+0x11f/0x140
[11369.904030]  ? kthread_park+0x90/0x90
[11369.904542]  ret_from_fork+0x24/0x30
[11369.905126] mlx5_ib_page_fa I    0  4828      2 0x80004080
[11369.905632] Call Trace:
[11369.906216]  ? __schedule+0x31a/0x850
[11369.906701]  schedule+0x36/0xc0
[11369.907196]  rescuer_thread+0x2fd/0x360
[11369.907757]  ? cancel_delayed_work+0xb0/0xb0
[11369.908257]  kthread+0x11f/0x140
[11369.908831]  ? kthread_park+0x90/0x90
[11369.909334]  ret_from_fork+0x24/0x30
[11369.909808] ib_mad1         I    0  4831      2 0x80004080
[11369.910318] Call Trace:
[11369.910806]  ? __schedule+0x31a/0x850
[11369.911334]  schedule+0x36/0xc0
[11369.911844]  rescuer_thread+0x2fd/0x360
[11369.912351]  ? cancel_delayed_work+0xb0/0xb0
[11369.912854]  kthread+0x11f/0x140
[11369.913381]  ? kthread_park+0x90/0x90
[11369.913913]  ret_from_fork+0x24/0x30
[11369.914465] mkey_cache      I    0  4833      2 0x80004080
[11369.914967] Call Trace:
[11369.915461]  ? __schedule+0x31a/0x850
[11369.916023]  schedule+0x36/0xc0
[11369.916533]  rescuer_thread+0x2fd/0x360
[11369.917085]  ? cancel_delayed_work+0xb0/0xb0
[11369.917579]  kthread+0x11f/0x140
[11369.918143]  ? kthread_park+0x90/0x90
[11369.918636]  ret_from_fork+0x24/0x30
[11369.919211] mlx5_ib_page_fa I    0  4835      2 0x80004080
[11369.919721] Call Trace:
[11369.920205]  ? __schedule+0x31a/0x850
[11369.920739]  schedule+0x36/0xc0
[11369.921234]  rescuer_thread+0x2fd/0x360
[11369.921711]  ? cancel_delayed_work+0xb0/0xb0
[11369.922211]  kthread+0x11f/0x140
[11369.922759]  ? kthread_park+0x90/0x90
[11369.923266]  ret_from_fork+0x24/0x30
[11369.923806] ib_mad1         I    0  4836      2 0x80004080
[11369.924317] Call Trace:
[11369.924827]  ? __schedule+0x31a/0x850
[11369.925356]  schedule+0x36/0xc0
[11369.925849]  rescuer_thread+0x2fd/0x360
[11369.926378]  ? cancel_delayed_work+0xb0/0xb0
[11369.926881]  kthread+0x11f/0x140
[11369.927463]  ? kthread_park+0x90/0x90
[11369.928017]  ret_from_fork+0x24/0x30
[11369.928542] mkey_cache      I    0  4838      2 0x80004080
[11369.929131] Call Trace:
[11369.929635]  ? __schedule+0x31a/0x850
[11369.930225]  schedule+0x36/0xc0
[11369.930731]  rescuer_thread+0x2fd/0x360
[11369.931241]  ? cancel_delayed_work+0xb0/0xb0
[11369.931715]  kthread+0x11f/0x140
[11369.932219]  ? kthread_park+0x90/0x90
[11369.932733]  ret_from_fork+0x24/0x30
[11369.933264] kworker/14:2    I    0  5058      2 0x80004080
[11369.933758] Workqueue:  0x0 (mm_percpu_wq)
[11369.934304] Call Trace:
[11369.934826]  ? __schedule+0x31a/0x850
[11369.935337]  schedule+0x36/0xc0
[11369.935811]  worker_thread+0xc6/0x390
[11369.936321]  ? process_one_work+0x5d0/0x5d0
[11369.936869]  kthread+0x11f/0x140
[11369.937463]  ? kthread_park+0x90/0x90
[11369.937984]  ret_from_fork+0x24/0x30
[11369.938496] kworker/14:3    I    0  5059      2 0x80004080
[11369.939084] Call Trace:
[11369.939599]  ? __schedule+0x31a/0x850
[11369.940161]  schedule+0x36/0xc0
[11369.940699]  worker_thread+0xc6/0x390
[11369.941220]  ? process_one_work+0x5d0/0x5d0
[11369.941722]  kthread+0x11f/0x140
[11369.942198]  ? kthread_park+0x90/0x90
[11369.942713]  ret_from_fork+0x24/0x30
[11369.943225] kworker/3:2     I    0  5122      2 0x80004080
[11369.943716] Workqueue:  0x0 (cgroup_pidlist_destroy)
[11369.944232] Call Trace:
[11369.944744]  ? __schedule+0x31a/0x850
[11369.945278]  schedule+0x36/0xc0
[11369.945768]  worker_thread+0xc6/0x390
[11369.946277]  ? process_one_work+0x5d0/0x5d0
[11369.946801]  kthread+0x11f/0x140
[11369.947309]  ? kthread_park+0x90/0x90
[11369.947832]  ret_from_fork+0x24/0x30
[11369.948351] kworker/6:3     I    0  5146      2 0x80004080
[11369.948869] Call Trace:
[11369.949395]  ? __schedule+0x31a/0x850
[11369.949919]  schedule+0x36/0xc0
[11369.950455]  worker_thread+0xc6/0x390
[11369.950960]  ? process_one_work+0x5d0/0x5d0
[11369.951438]  kthread+0x11f/0x140
[11369.951997]  ? kthread_park+0x90/0x90
[11369.952520]  ret_from_fork+0x24/0x30
[11369.953092] kworker/4:2     I    0  5174      2 0x80004080
[11369.953588] Workqueue:  0x0 (mm_percpu_wq)
[11369.954177] Call Trace:
[11369.954683]  ? __schedule+0x31a/0x850
[11369.955261]  schedule+0x36/0xc0
[11369.955773]  worker_thread+0xc6/0x390
[11369.956286]  ? process_one_work+0x5d0/0x5d0
[11369.956798]  kthread+0x11f/0x140
[11369.957328]  ? kthread_park+0x90/0x90
[11369.957855]  ret_from_fork+0x24/0x30
[11369.958366] kworker/u32:0   I    0  5334      2 0x80004080
[11369.958860] Workqueue:  0x0 (events_unbound)
[11369.959395] Call Trace:
[11369.959924]  ? __schedule+0x31a/0x850
[11369.960493]  schedule+0x36/0xc0
[11369.960989]  worker_thread+0xc6/0x390
[11369.961488]  ? process_one_work+0x5d0/0x5d0
[11369.962033]  kthread+0x11f/0x140
[11369.962532]  ? kthread_park+0x90/0x90
[11369.963126]  ret_from_fork+0x24/0x30
[11369.963646] kworker/2:1     I    0  5348      2 0x80004080
[11369.964225] Workqueue:  0x0 (events_power_efficient)
[11369.964737] Call Trace:
[11369.965251]  ? __schedule+0x31a/0x850
[11369.965744]  schedule+0x36/0xc0
[11369.966252]  worker_thread+0xc6/0x390
[11369.966756]  ? process_one_work+0x5d0/0x5d0
[11369.967298]  kthread+0x11f/0x140
[11369.967826]  ? kthread_park+0x90/0x90
[11369.968342]  ret_from_fork+0x24/0x30
[11369.968864] kworker/12:1    I    0  5349      2 0x80004080
[11369.969435] Call Trace:
[11369.969927]  ? __schedule+0x31a/0x850
[11369.970398]  schedule+0x36/0xc0
[11369.970997]  worker_thread+0xc6/0x390
[11369.971577]  ? process_one_work+0x5d0/0x5d0
[11369.972111]  kthread+0x11f/0x140
[11369.972658]  ? kthread_park+0x90/0x90
[11369.973288]  ret_from_fork+0x24/0x30
[11369.973784] kworker/13:3    I    0  5432      2 0x80004080
[11369.974299] Workqueue:  0x0 (cgroup_pidlist_destroy)
[11369.974800] Call Trace:
[11369.975340]  ? __schedule+0x31a/0x850
[11369.975853]  schedule+0x36/0xc0
[11369.976364]  worker_thread+0xc6/0x390
[11369.976921]  ? process_one_work+0x5d0/0x5d0
[11369.977464]  kthread+0x11f/0x140
[11369.977996]  ? kthread_park+0x90/0x90
[11369.978506]  ret_from_fork+0x24/0x30
[11369.979048] kworker/5:1     I    0  5496      2 0x80004080
[11369.979562] Workqueue:  0x0 (mm_percpu_wq)
[11369.980138] Call Trace:
[11369.980688]  ? __schedule+0x31a/0x850
[11369.981246]  schedule+0x36/0xc0
[11369.981728]  worker_thread+0xc6/0x390
[11369.982240]  ? process_one_work+0x5d0/0x5d0
[11369.982772]  kthread+0x11f/0x140
[11369.983317]  ? kthread_park+0x90/0x90
[11369.983818]  ret_from_fork+0x24/0x30
[11369.984334] kworker/7:2     I    0  5525      2 0x80004080
[11369.984858] Call Trace:
[11369.985388]  ? __schedule+0x31a/0x850
[11369.985922]  schedule+0x36/0xc0
[11369.986463]  worker_thread+0xc6/0x390
[11369.986970]  ? process_one_work+0x5d0/0x5d0
[11369.987452]  kthread+0x11f/0x140
[11369.987999]  ? kthread_park+0x90/0x90
[11369.988541]  ret_from_fork+0x24/0x30
[11369.989087] kworker/0:2     I    0  5532      2 0x80004080
[11369.989597] Call Trace:
[11369.990166]  ? __schedule+0x31a/0x850
[11369.990709]  schedule+0x36/0xc0
[11369.991229]  worker_thread+0xc6/0x390
[11369.991715]  ? process_one_work+0x5d0/0x5d0
[11369.992220]  kthread+0x11f/0x140
[11369.992790]  ? kthread_park+0x90/0x90
[11369.993320]  ret_from_fork+0x24/0x30
[11369.993843] kworker/u32:1   I    0  5542      2 0x80004080
[11369.994355] Workqueue:  0x0 (events_unbound)
[11369.994884] Call Trace:
[11369.995456]  ? __schedule+0x31a/0x850
[11369.995963]  schedule+0x36/0xc0
[11369.996475]  worker_thread+0xc6/0x390
[11369.997030]  ? process_one_work+0x5d0/0x5d0
[11369.997526]  kthread+0x11f/0x140
[11369.998069]  ? kthread_park+0x90/0x90
[11369.998570]  ret_from_fork+0x24/0x30
[11369.999162] kworker/u33:1   I    0  5957      2 0x80004080
[11369.999671] Call Trace:
[11370.000234]  ? __schedule+0x31a/0x850
[11370.000807]  schedule+0x36/0xc0
[11370.001328]  worker_thread+0xc6/0x390
[11370.001844]  ? process_one_work+0x5d0/0x5d0
[11370.002345]  kthread+0x11f/0x140
[11370.002827]  ? kthread_park+0x90/0x90
[11370.003363]  ret_from_fork+0x24/0x30
[11370.003870] kworker/9:2     I    0  5963      2 0x80004080
[11370.004383] Workqueue:  0x0 (mm_percpu_wq)
[11370.004940] Call Trace:
[11370.005569]  ? __schedule+0x31a/0x850
[11370.006106]  schedule+0x36/0xc0
[11370.006598]  worker_thread+0xc6/0x390
[11370.007185]  ? process_one_work+0x5d0/0x5d0
[11370.007699]  kthread+0x11f/0x140
[11370.008257]  ? kthread_park+0x90/0x90
[11370.008815]  ret_from_fork+0x24/0x30
[11370.009346] iscsi_np        S    0  6038      2 0x80004080
[11370.009840] Call Trace:
[11370.010337]  ? __schedule+0x31a/0x850
[11370.010843]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[11370.011388]  schedule+0x36/0xc0
[11370.011934]  schedule_timeout+0x204/0x3b0
[11370.012557]  ? sched_clock+0x5/0x10
[11370.013078]  ? sched_clock+0x5/0x10
[11370.013560]  ? sched_clock_cpu+0xc/0xc0
[11370.014140]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[11370.014655]  inet_csk_accept+0x1dd/0x360
[11370.015219]  ? finish_wait+0x80/0x80
[11370.015717]  inet_accept+0x41/0x280
[11370.016236]  kernel_accept+0x4d/0xa0
[11370.016773]  iscsit_accept_np+0x39/0x210 [iscsi_target_mod]
[11370.017326]  ? __kmalloc_node+0x3a6/0x3e0
[11370.017837]  ? alloc_cpumask_var_node+0x1b/0x30
[11370.018371]  iscsi_target_login_thread+0x39d/0x1080 [iscsi_target_mod]
[11370.018914]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[11370.019544]  kthread+0x11f/0x140
[11370.020105]  ? kthread_park+0x90/0x90
[11370.020702]  ret_from_fork+0x24/0x30
[11370.021309] iscsi_np        D    0  6061      2 0x80004084
[11370.021875] Call Trace:
[11370.022499]  ? __schedule+0x31a/0x850
[11370.023071]  ? __lock_acquire+0x26c/0x1480
[11370.023613]  ? wait_for_completion+0x112/0x1a0
[11370.024249]  schedule+0x36/0xc0
[11370.024857]  schedule_timeout+0x204/0x3b0
[11370.025418]  ? sched_clock+0x5/0x10
[11370.025995]  ? sched_clock+0x5/0x10
[11370.026520]  ? sched_clock_cpu+0xc/0xc0
[11370.027130]  ? wait_for_completion+0x112/0x1a0
[11370.027656]  wait_for_completion+0x13a/0x1a0
[11370.028219]  ? wake_up_q+0x80/0x80
[11370.028769]  iscsi_check_for_session_reinstatement+0x1d7/0x280 [iscsi_target_mod]
[11370.029356]  iscsi_target_do_login+0xa6/0x5c0 [iscsi_target_mod]
[11370.029939]  iscsi_target_start_negotiation+0x51/0xd0 [iscsi_target_mod]
[11370.030585]  iscsi_target_login_thread+0xa3a/0x1080 [iscsi_target_mod]
[11370.031139]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[11370.031769]  kthread+0x11f/0x140
[11370.032338]  ? kthread_park+0x90/0x90
[11370.032959]  ret_from_fork+0x24/0x30
[11370.033636] iscsi_ttx       S    0  6422      2 0x80004080
[11370.034216] Call Trace:
[11370.034817]  ? __schedule+0x31a/0x850
[11370.035476]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11370.036087]  schedule+0x36/0xc0
[11370.036687]  iscsi_target_tx_thread+0x1c0/0x200 [iscsi_target_mod]
[11370.037327]  ? finish_wait+0x80/0x80
[11370.037951]  kthread+0x11f/0x140
[11370.038618]  ? kthread_park+0x90/0x90
[11370.039213]  ret_from_fork+0x24/0x30
[11370.039824] iscsi_trx       S    0  6423      2 0x80004080
[11370.040451] Call Trace:
[11370.041076]  ? __schedule+0x31a/0x850
[11370.041658]  ? __lock_acquire+0x26c/0x1480
[11370.042262]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.042840]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.043508]  schedule+0x36/0xc0
[11370.044110]  schedule_timeout+0x204/0x3b0
[11370.044704]  ? sched_clock+0x5/0x10
[11370.045286]  ? sched_clock+0x5/0x10
[11370.045857]  ? sched_clock_cpu+0xc/0xc0
[11370.046468]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.047046]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.047619]  wait_for_completion_interruptible+0x12e/0x1e0
[11370.048259]  ? wake_up_q+0x80/0x80
[11370.048846]  isert_get_rx_pdu+0x40/0x60 [ib_isert]
[11370.049570]  ? wait_for_completion_interruptible+0x49/0x1e0
[11370.050147]  iscsi_target_rx_thread+0xb5/0xf0 [iscsi_target_mod]
[11370.050729]  kthread+0x11f/0x140
[11370.051343]  ? kthread_park+0x90/0x90
[11370.051951]  ret_from_fork+0x24/0x30
[11370.052639] iscsi_ttx       S    0  6424      2 0x80004080
[11370.053208] Call Trace:
[11370.053776]  ? __schedule+0x31a/0x850
[11370.054478]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11370.055078]  schedule+0x36/0xc0
[11370.055691]  iscsi_target_tx_thread+0x1c0/0x200 [iscsi_target_mod]
[11370.056343]  ? finish_wait+0x80/0x80
[11370.056964]  kthread+0x11f/0x140
[11370.057656]  ? kthread_park+0x90/0x90
[11370.058276]  ret_from_fork+0x24/0x30
[11370.058883] iscsi_trx       S    0  6425      2 0x80004080
[11370.059519] Call Trace:
[11370.060173]  ? __schedule+0x31a/0x850
[11370.060778]  ? __lock_acquire+0x26c/0x1480
[11370.061345]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.061956]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.062620]  schedule+0x36/0xc0
[11370.063250]  schedule_timeout+0x204/0x3b0
[11370.063844]  ? sched_clock+0x5/0x10
[11370.064506]  ? sched_clock+0x5/0x10
[11370.065106]  ? sched_clock_cpu+0xc/0xc0
[11370.065696]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.066284]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.066904]  wait_for_completion_interruptible+0x12e/0x1e0
[11370.067564]  ? wake_up_q+0x80/0x80
[11370.068154]  isert_get_rx_pdu+0x40/0x60 [ib_isert]
[11370.068813]  ? wait_for_completion_interruptible+0x49/0x1e0
[11370.069525]  iscsi_target_rx_thread+0xb5/0xf0 [iscsi_target_mod]
[11370.070159]  kthread+0x11f/0x140
[11370.070776]  ? kthread_park+0x90/0x90
[11370.071435]  ret_from_fork+0x24/0x30
[11370.072055] iscsi_ttx       S    0  6426      2 0x80004080
[11370.072672] Call Trace:
[11370.073310]  ? __schedule+0x31a/0x850
[11370.073923]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11370.074618]  schedule+0x36/0xc0
[11370.075260]  iscsi_target_tx_thread+0x1c0/0x200 [iscsi_target_mod]
[11370.075906]  ? finish_wait+0x80/0x80
[11370.076650]  kthread+0x11f/0x140
[11370.077285]  ? kthread_park+0x90/0x90
[11370.077905]  ret_from_fork+0x24/0x30
[11370.078576] iscsi_trx       S    0  6427      2 0x80004080
[11370.079158] Call Trace:
[11370.079801]  ? __schedule+0x31a/0x850
[11370.080444]  ? __lock_acquire+0x26c/0x1480
[11370.081043]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.081639]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.082284]  schedule+0x36/0xc0
[11370.082931]  schedule_timeout+0x204/0x3b0
[11370.083631]  ? sched_clock+0x5/0x10
[11370.084253]  ? sched_clock+0x5/0x10
[11370.084890]  ? sched_clock_cpu+0xc/0xc0
[11370.085491]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.086051]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.086645]  wait_for_completion_interruptible+0x12e/0x1e0
[11370.087308]  ? wake_up_q+0x80/0x80
[11370.087921]  isert_get_rx_pdu+0x40/0x60 [ib_isert]
[11370.088653]  ? wait_for_completion_interruptible+0x49/0x1e0
[11370.089231]  iscsi_target_rx_thread+0xb5/0xf0 [iscsi_target_mod]
[11370.089843]  kthread+0x11f/0x140
[11370.090552]  ? kthread_park+0x90/0x90
[11370.091167]  ret_from_fork+0x24/0x30
[11370.091803] iscsi_ttx       S    0  6428      2 0x80004080
[11370.092483] Call Trace:
[11370.093095]  ? __schedule+0x31a/0x850
[11370.093685]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11370.094309]  schedule+0x36/0xc0
[11370.094952]  iscsi_target_tx_thread+0x1c0/0x200 [iscsi_target_mod]
[11370.095657]  ? finish_wait+0x80/0x80
[11370.096319]  kthread+0x11f/0x140
[11370.096986]  ? kthread_park+0x90/0x90
[11370.097668]  ret_from_fork+0x24/0x30
[11370.098313] iscsi_trx       S    0  6429      2 0x80004080
[11370.098953] Call Trace:
[11370.099629]  ? __schedule+0x31a/0x850
[11370.100243]  ? __lock_acquire+0x26c/0x1480
[11370.100894]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.101573]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.102161]  schedule+0x36/0xc0
[11370.102805]  schedule_timeout+0x204/0x3b0
[11370.103503]  ? sched_clock+0x5/0x10
[11370.104108]  ? sched_clock+0x5/0x10
[11370.104721]  ? sched_clock_cpu+0xc/0xc0
[11370.105350]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.105959]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.106635]  wait_for_completion_interruptible+0x12e/0x1e0
[11370.107254]  ? wake_up_q+0x80/0x80
[11370.107866]  isert_get_rx_pdu+0x40/0x60 [ib_isert]
[11370.108581]  ? wait_for_completion_interruptible+0x49/0x1e0
[11370.109164]  iscsi_target_rx_thread+0xb5/0xf0 [iscsi_target_mod]
[11370.109790]  kthread+0x11f/0x140
[11370.110394]  ? kthread_park+0x90/0x90
[11370.111015]  ret_from_fork+0x24/0x30
[11370.111728] iscsi_ttx       S    0  6430      2 0x80004080
[11370.112333] Call Trace:
[11370.112975]  ? __schedule+0x31a/0x850
[11370.113667]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11370.114294]  schedule+0x36/0xc0
[11370.114937]  iscsi_target_tx_thread+0x1c0/0x200 [iscsi_target_mod]
[11370.115672]  ? finish_wait+0x80/0x80
[11370.116320]  kthread+0x11f/0x140
[11370.116990]  ? kthread_park+0x90/0x90
[11370.117719]  ret_from_fork+0x24/0x30
[11370.118345] iscsi_trx       S    0  6431      2 0x80004080
[11370.118981] Call Trace:
[11370.119717]  ? __schedule+0x31a/0x850
[11370.120290]  ? __lock_acquire+0x26c/0x1480
[11370.120923]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.121611]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.122274]  schedule+0x36/0xc0
[11370.122904]  schedule_timeout+0x204/0x3b0
[11370.123605]  ? sched_clock+0x5/0x10
[11370.124265]  ? sched_clock+0x5/0x10
[11370.124914]  ? sched_clock_cpu+0xc/0xc0
[11370.125587]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.126169]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.126815]  wait_for_completion_interruptible+0x12e/0x1e0
[11370.127446]  ? wake_up_q+0x80/0x80
[11370.128031]  isert_get_rx_pdu+0x40/0x60 [ib_isert]
[11370.128673]  ? wait_for_completion_interruptible+0x49/0x1e0
[11370.129311]  iscsi_target_rx_thread+0xb5/0xf0 [iscsi_target_mod]
[11370.129934]  kthread+0x11f/0x140
[11370.130578]  ? kthread_park+0x90/0x90
[11370.131200]  ret_from_fork+0x24/0x30
[11370.131830] iscsi_ttx       D    0  6432      2 0x80004084
[11370.132394] Call Trace:
[11370.133063]  ? __schedule+0x31a/0x850
[11370.133750]  ? __lock_acquire+0x26c/0x1480
[11370.134326]  ? wait_for_completion+0x112/0x1a0
[11370.134965]  schedule+0x36/0xc0
[11370.135638]  schedule_timeout+0x204/0x3b0
[11370.136282]  ? sched_clock+0x5/0x10
[11370.136928]  ? sched_clock+0x5/0x10
[11370.137541]  ? sched_clock_cpu+0xc/0xc0
[11370.138176]  ? wait_for_completion+0x112/0x1a0
[11370.138769]  wait_for_completion+0x13a/0x1a0
[11370.139322]  ? wake_up_q+0x80/0x80
[11370.139934]  __ib_drain_sq+0x184/0x190 [ib_core]
[11370.140591]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[11370.141153]  ? wait_for_completion+0x49/0x1a0
[11370.141759]  ib_drain_qp+0xe/0x20 [ib_core]
[11370.142288]  isert_wait_conn+0x65/0x350 [ib_isert]
[11370.142882]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11370.143501]  iscsit_close_connection+0x154/0x8a0 [iscsi_target_mod]
[11370.144121]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11370.144759]  iscsit_take_action_for_connection_exit+0x7a/0x100 [iscsi_target_mod]
[11370.145330]  iscsi_target_tx_thread+0x16c/0x200 [iscsi_target_mod]
[11370.145973]  ? finish_wait+0x80/0x80
[11370.146630]  kthread+0x11f/0x140
[11370.147242]  ? kthread_park+0x90/0x90
[11370.147840]  ret_from_fork+0x24/0x30
[11370.148507] iscsi_ttx       S    0  6434      2 0x80004080
[11370.149074] Call Trace:
[11370.149646]  ? __schedule+0x31a/0x850
[11370.150285]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11370.150953]  schedule+0x36/0xc0
[11370.151665]  iscsi_target_tx_thread+0x1c0/0x200 [iscsi_target_mod]
[11370.152239]  ? finish_wait+0x80/0x80
[11370.152866]  kthread+0x11f/0x140
[11370.153525]  ? kthread_park+0x90/0x90
[11370.154122]  ret_from_fork+0x24/0x30
[11370.154774] iscsi_trx       S    0  6435      2 0x80004080
[11370.155476] Call Trace:
[11370.156087]  ? __schedule+0x31a/0x850
[11370.156688]  ? __lock_acquire+0x26c/0x1480
[11370.157352]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.157977]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.158688]  schedule+0x36/0xc0
[11370.159358]  schedule_timeout+0x204/0x3b0
[11370.159949]  ? sched_clock+0x5/0x10
[11370.160663]  ? sched_clock+0x5/0x10
[11370.161261]  ? sched_clock_cpu+0xc/0xc0
[11370.161860]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.162526]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.163130]  wait_for_completion_interruptible+0x12e/0x1e0
[11370.163727]  ? wake_up_q+0x80/0x80
[11370.164360]  isert_get_rx_pdu+0x40/0x60 [ib_isert]
[11370.165018]  ? wait_for_completion_interruptible+0x49/0x1e0
[11370.165750]  iscsi_target_rx_thread+0xb5/0xf0 [iscsi_target_mod]
[11370.166345]  kthread+0x11f/0x140
[11370.166979]  ? kthread_park+0x90/0x90
[11370.167626]  ret_from_fork+0x24/0x30
[11370.168223] iscsi_ttx       S    0  6436      2 0x80004080
[11370.168877] Call Trace:
[11370.169606]  ? __schedule+0x31a/0x850
[11370.170287]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11370.170920]  schedule+0x36/0xc0
[11370.171667]  iscsi_target_tx_thread+0x1c0/0x200 [iscsi_target_mod]
[11370.172273]  ? finish_wait+0x80/0x80
[11370.172966]  kthread+0x11f/0x140
[11370.173640]  ? kthread_park+0x90/0x90
[11370.174288]  ret_from_fork+0x24/0x30
[11370.174933] iscsi_trx       S    0  6437      2 0x80004080
[11370.175593] Call Trace:
[11370.176245]  ? __schedule+0x31a/0x850
[11370.176877]  ? __lock_acquire+0x26c/0x1480
[11370.177511]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.178148]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.178776]  schedule+0x36/0xc0
[11370.179394]  schedule_timeout+0x204/0x3b0
[11370.179991]  ? sched_clock+0x5/0x10
[11370.180749]  ? sched_clock+0x5/0x10
[11370.181362]  ? sched_clock_cpu+0xc/0xc0
[11370.181944]  ? wait_for_completion_interruptible+0x10f/0x1e0
[11370.182585]  ? iscsi_target_tx_thread+0x200/0x200 [iscsi_target_mod]
[11370.183176]  wait_for_completion_interruptible+0x12e/0x1e0
[11370.183774]  ? wake_up_q+0x80/0x80
[11370.184523]  isert_get_rx_pdu+0x40/0x60 [ib_isert]
[11370.185138]  ? wait_for_completion_interruptible+0x49/0x1e0
[11370.185781]  iscsi_target_rx_thread+0xb5/0xf0 [iscsi_target_mod]
[11370.186498]  kthread+0x11f/0x140
[11370.187116]  ? kthread_park+0x90/0x90
[11370.187723]  ret_from_fork+0x24/0x30
[11370.188398] sshd            S    0  6446   2019 0x00000080
[11370.189096] Call Trace:
[11370.189664]  ? __schedule+0x31a/0x850
[11370.190355]  ? sched_clock+0x5/0x10
[11370.190961]  schedule+0x36/0xc0
[11370.191698]  schedule_hrtimeout_range_clock+0x104/0x110
[11370.192325]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11370.192957]  do_select+0x634/0x8b0
[11370.193726]  ? set_fd_set.part.2+0x40/0x40
[11370.194259]  ? set_fd_set.part.2+0x40/0x40
[11370.194876]  ? set_fd_set.part.2+0x40/0x40
[11370.195582]  ? set_fd_set.part.2+0x40/0x40
[11370.196152]  ? set_fd_set.part.2+0x40/0x40
[11370.196731]  ? set_fd_set.part.2+0x40/0x40
[11370.197349]  ? __lock_acquire+0x26c/0x1480
[11370.197937]  ? sched_clock+0x5/0x10
[11370.198566]  ? sched_clock+0x5/0x10
[11370.199086]  ? sched_clock_cpu+0xc/0xc0
[11370.199590]  ? core_sys_select+0x213/0x410
[11370.200154]  core_sys_select+0x213/0x410
[11370.200804]  ? sched_clock+0x5/0x10
[11370.201326]  ? sched_clock+0x5/0x10
[11370.201878]  ? sched_clock_cpu+0xc/0xc0
[11370.202373]  ? lockdep_hardirqs_on+0xf0/0x180
[11370.202925]  kern_select+0xb5/0x100
[11370.203447]  __x64_sys_select+0x20/0x30
[11370.203948]  do_syscall_64+0x5a/0x240
[11370.204352]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11370.204897] RIP: 0033:0x7f05cd70cf53
[11370.205453] Code: Bad RIP value.
[11370.205957] RSP: 002b:00007ffd91bbaa28 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[11370.206373] RAX: ffffffffffffffda RBX: 0000563ecf8d5068 RCX: 00007f05cd70cf53
[11370.206897] RDX: 0000563ed15a8ec0 RSI: 0000563ed15bfd20 RDI: 000000000000000f
[11370.207545] RBP: 0000563ed15bfd20 R08: 0000000000000000 R09: 00007ffd91bba9a0
[11370.208072] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffd91bbaa7f
[11370.208613] R13: 0000563ecf8ce7a0 R14: 0000000000000003 R15: 0000000000000000
[11370.209211] sshd            S    0  6448   2019 0x00000080
[11370.209787] Call Trace:
[11370.210296]  ? __schedule+0x31a/0x850
[11370.210845]  schedule+0x36/0xc0
[11370.211344]  schedule_hrtimeout_range_clock+0x104/0x110
[11370.211905]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11370.212452]  do_select+0x634/0x8b0
[11370.212982]  ? set_fd_set.part.2+0x40/0x40
[11370.213486]  ? set_fd_set.part.2+0x40/0x40
[11370.213999]  ? set_fd_set.part.2+0x40/0x40
[11370.214549]  ? set_fd_set.part.2+0x40/0x40
[11370.215051]  ? lockdep_hardirqs_on+0xf0/0x180
[11370.215532]  ? __lock_acquire+0x26c/0x1480
[11370.216022]  ? __lock_acquire+0x26c/0x1480
[11370.216508]  ? sched_clock+0x5/0x10
[11370.216988]  ? sched_clock+0x5/0x10
[11370.217396]  ? sched_clock_cpu+0xc/0xc0
[11370.217875]  ? core_sys_select+0x213/0x410
[11370.218359]  core_sys_select+0x213/0x410
[11370.218886]  ? sched_clock+0x5/0x10
[11370.219348]  ? sched_clock+0x5/0x10
[11370.219836]  ? sched_clock_cpu+0xc/0xc0
[11370.220303]  ? lockdep_hardirqs_on+0xf0/0x180
[11370.220815]  kern_select+0xb5/0x100
[11370.221279]  __x64_sys_select+0x20/0x30
[11370.221790]  do_syscall_64+0x5a/0x240
[11370.222281]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11370.222824] RIP: 0033:0x7fcce1259f53
[11370.223312] Code: Bad RIP value.
[11370.223815] RSP: 002b:00007ffcba018938 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[11370.224330] RAX: ffffffffffffffda RBX: 000055bc0d27b068 RCX: 00007fcce1259f53
[11370.224894] RDX: 000055bc0e74a710 RSI: 000055bc0e74a6f0 RDI: 000000000000000f
[11370.225501] RBP: 000055bc0e74a6f0 R08: 0000000000000000 R09: 00007ffcba0188b0
[11370.226048] R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffcba01898f
[11370.226603] R13: 000055bc0d2747a0 R14: 0000000000000003 R15: 0000000000000000
[11370.227203] bash            R  running task        0  6450   6446 0x80000088
[11370.227788] Call Trace:
[11370.228320]  sched_show_task+0x191/0x230
[11370.228910]  show_state_filter+0xa2/0x1b0
[11370.229533]  sysrq_handle_showstate+0xc/0x20
[11370.230083]  __handle_sysrq+0xd2/0x230
[11370.230630]  write_sysrq_trigger+0x48/0x50
[11370.231208]  proc_reg_write+0x36/0x60
[11370.231753]  vfs_write+0xc1/0x1d0
[11370.232244]  ksys_write+0xa7/0xe0
[11370.232801]  do_syscall_64+0x5a/0x240
[11370.233282]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11370.233823] RIP: 0033:0x7f7dacacffd0
[11370.234310] Code: 73 01 c3 48 8b 0d c0 6e 2d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d cd cf 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ee cb 01 00 48 89 04 24
[11370.235437] RSP: 002b:00007ffd089b1998 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[11370.236063] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f7dacacffd0
[11370.236651] RDX: 0000000000000002 RSI: 00007f7dad3fb000 RDI: 0000000000000001
[11370.237278] RBP: 00007f7dad3fb000 R08: 000000000000000a R09: 00007f7dad3d6740
[11370.237867] R10: 00007f7dad3d6740 R11: 0000000000000246 R12: 00007f7dacda8400
[11370.238511] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
[11370.239121] sftp-server     S    0  6500   6448 0x00000080
[11370.239755] Call Trace:
[11370.240508]  ? __schedule+0x31a/0x850
[11370.241134]  schedule+0x36/0xc0
[11370.241771]  schedule_hrtimeout_range_clock+0x104/0x110
[11370.242526]  poll_schedule_timeout.constprop.12+0x4d/0x80
[11370.243164]  do_select+0x634/0x8b0
[11370.243858]  ? set_fd_set.part.2+0x40/0x40
[11370.244646]  ? rcu_read_lock_sched_held+0x52/0x80
[11370.245319]  ? __update_load_avg_cfs_rq+0x12b/0x330
[11370.245985]  ? rcu_read_lock_sched_held+0x52/0x80
[11370.246791]  ? update_load_avg+0x739/0x770
[11370.247398]  ? update_curr+0x112/0x400
[11370.248135]  ? account_entity_enqueue+0x9c/0xd0
[11370.248832]  ? __lock_acquire+0x26c/0x1480
[11370.249540]  ? __lock_acquire+0x26c/0x1480
[11370.250199]  ? sched_clock+0x5/0x10
[11370.250853]  ? sched_clock+0x5/0x10
[11370.251527]  ? sched_clock_cpu+0xc/0xc0
[11370.252163]  ? core_sys_select+0x213/0x410
[11370.252842]  core_sys_select+0x213/0x410
[11370.253582]  ? sched_clock+0x5/0x10
[11370.254179]  ? sched_clock+0x5/0x10
[11370.254784]  ? sched_clock_cpu+0xc/0xc0
[11370.255501]  ? lockdep_hardirqs_on+0xf0/0x180
[11370.256103]  kern_select+0xb5/0x100
[11370.256699]  __x64_sys_select+0x20/0x30
[11370.257342]  do_syscall_64+0x5a/0x240
[11370.257923]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11370.258588] RIP: 0033:0x152b1685af53
[11370.259211] Code: Bad RIP value.
[11370.259794] RSP: 002b:00007ffdd7103aa8 EFLAGS: 00000246 ORIG_RAX: 0000000000000017
[11370.260495] RAX: ffffffffffffffda RBX: 000055d4246c17d0 RCX: 0000152b1685af53
[11370.261128] RDX: 000055d4246c17d0 RSI: 000055d4246c17b0 RDI: 0000000000000002
[11370.261757] RBP: 000055d4246c17b0 R08: 0000000000000000 R09: 000055d4246c17f0
[11370.262396] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[11370.263054] R13: 00007ffdd7103b00 R14: 00007ffdd7103aec R15: 00007ffdd7103aeb
[11370.263825] dmesg           S    0  6547   4527 0x00004080
[11370.264499] Call Trace:
[11370.265159]  ? __schedule+0x31a/0x850
[11370.265785]  schedule+0x36/0xc0
[11370.266348]  devkmsg_read+0x149/0x2f0
[11370.266914]  ? finish_wait+0x80/0x80
[11370.267492]  vfs_read+0x9e/0x170
[11370.268040]  ksys_read+0xa7/0xe0
[11370.268576]  do_syscall_64+0x5a/0x240
[11370.269166]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11370.269779] RIP: 0033:0x14e4797b9f70
[11370.270289] Code: Bad RIP value.
[11370.270832] RSP: 002b:00007fff95fb4038 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
[11370.271373] RAX: ffffffffffffffda RBX: 000000000060934d RCX: 000014e4797b9f70
[11370.271966] RDX: 0000000000001fff RSI: 0000000000609338 RDI: 0000000000000003
[11370.272622] RBP: 000000000060938e R08: 000000000000000a R09: 000014e479c92740
[11370.273222] R10: 000014e479c92740 R11: 0000000000000246 R12: 00007fff95fb40b4
[11370.273786] R13: 00007fff95fb40b0 R14: 000014e479c926b0 R15: 0000000000000000
[11370.274365] kworker/u32:2   I    0  6549      2 0x80004080
[11370.274985] Workqueue:  0x0 (events_unbound)
[11370.275577] Call Trace:
[11370.276122]  ? __schedule+0x31a/0x850
[11370.276698]  schedule+0x36/0xc0
[11370.277333]  worker_thread+0xc6/0x390
[11370.277925]  ? process_one_work+0x5d0/0x5d0
[11370.278554]  kthread+0x11f/0x140
[11370.279114]  ? kthread_park+0x90/0x90
[11370.279679]  ret_from_fork+0x24/0x30
[11370.280337] sleep           S    0  6557   1789 0x00000080
[11370.280960] Call Trace:
[11370.281631]  ? __schedule+0x31a/0x850
[11370.282215]  ? hrtimer_start_range_ns+0x1d9/0x320
[11370.282832]  ? do_nanosleep+0x5b/0x1c0
[11370.283446]  schedule+0x36/0xc0
[11370.284051]  do_nanosleep+0xad/0x1c0
[11370.284672]  hrtimer_nanosleep+0xba/0x150
[11370.285276]  ? hrtimer_init_sleeper+0x100/0x100
[11370.285904]  __x64_sys_nanosleep+0x70/0xa0
[11370.286541]  do_syscall_64+0x5a/0x240
[11370.287141]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11370.287756] RIP: 0033:0x7f563a2c4e10
[11370.288348] Code: Bad RIP value.
[11370.288957] RSP: 002b:00007ffe943c6008 EFLAGS: 00000246 ORIG_RAX: 0000000000000023
[11370.289590] RAX: ffffffffffffffda RBX: 000000000000003c RCX: 00007f563a2c4e10
[11370.290188] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 00007ffe943c6010
[11370.290798] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
[11370.291467] R10: 00007ffe943c5a60 R11: 0000000000000246 R12: 00007ffe943c6010
[11370.292066] R13: 00007ffe943c60b8 R14: 00007ffe943c61f8 R15: 0000000000000001
[11370.292681] Sched Debug Version: v0.11, 5.4.0+ #24
[11370.293324] ktime                                   : 11370254.897903
[11370.293955] sched_clk                               : 11370410.016699
[11370.294616] cpu_clk                                 : 11370292.680254
[11370.295241] jiffies                                 : 4306037223
[11370.295853] sched_clock_stable()                    : 1
[11370.296479] sysctl_sched
[11370.297066]   .sysctl_sched_latency                    : 24.000000
[11370.297683]   .sysctl_sched_min_granularity            : 10.000000
[11370.298374]   .sysctl_sched_wakeup_granularity         : 15.000000
[11370.298990]   .sysctl_sched_child_runs_first           : 0
[11370.299678]   .sysctl_sched_features                   : 2059067
[11370.300318]   .sysctl_sched_tunable_scaling            : 1 (logarithmic)
[11370.300949] cpu#0, 2095.168 MHz
[11370.301581]   .nr_running                    : 0
[11370.302189]   .nr_switches                   : 3842248
[11370.302752]   .nr_load_updates               : 0
[11370.303288]   .nr_uninterruptible            : 20
[11370.303874]   .next_balance                  : 4306.037232
[11370.304499]   .curr->pid                     : 0
[11370.305047]   .clock                         : 11370304.503563
[11370.305600]   .clock_task                    : 11370304.503563
[11370.306183]   .avg_idle                      : 1000000
[11370.306746]   .max_idle_balance_cost         : 500000
[11370.307382] cfs_rq[0]:/
[11370.307933]   .exec_clock                    : 0.000000
[11370.308463]   .MIN_vruntime                  : 0.000001
[11370.308978]   .min_vruntime                  : 20554.761184
[11370.309480]   .max_vruntime                  : 0.000001
[11370.309988]   .spread                        : 0.000000
[11370.310461]   .spread0                       : 0.000000
[11370.310962]   .nr_spread_over                : 0
[11370.311402]   .nr_running                    : 0
[11370.311905]   .load                          : 0
[11370.312323]   .runnable_weight               : 0
[11370.312848]   .load_avg                      : 6
[11370.313261]   .runnable_load_avg             : 0
[11370.313764]   .util_avg                      : 5
[11370.314158]   .util_est_enqueued             : 0
[11370.314585]   .removed.load_avg              : 0
[11370.315020]   .removed.util_avg              : 0
[11370.315400]   .removed.runnable_sum          : 0
[11370.315846]   .tg_load_avg_contrib           : 0
[11370.316191]   .tg_load_avg                   : 0
[11370.316620]   .throttled                     : 0
[11370.317020]   .throttle_count                : 0
[11370.317353] rt_rq[0]:/
[11370.317774]   .rt_nr_running                 : 0
[11370.318078]   .rt_nr_migratory               : 0
[11370.318372]   .rt_throttled                  : 0
[11370.318782]   .rt_time                       : 0.000000
[11370.319139]   .rt_runtime                    : 950.000000
[11370.319524] dl_rq[0]:
[11370.319887]   .dl_nr_running                 : 0
[11370.320175]   .dl_nr_migratory               : 0
[11370.320512]   .dl_bw->bw                     : 996147
[11370.320871]   .dl_bw->total_bw               : 0
[11370.321187] runnable tasks:
[11370.321525]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.321928] -----------------------------------------------------------------------------------------------------------
[11370.322334]  I         rcu_gp     3         7.038466         2   100         0.000000         0.022865         0.000000 0 0 /
[11370.322818]  I     rcu_par_gp     4         8.542178         2   100         0.000000         0.010938         0.000000 0 0 /
[11370.323199]  I   kworker/0:0H     6      3092.288263         7   100         0.000000         0.819376         0.000000 0 0 /
[11370.323634]  I   mm_percpu_wq     8        14.125524         2   100         0.000000         0.011020         0.000000 0 0 /
[11370.324106]  S    ksoftirqd/0     9     20542.914997      7343   120         0.000000        74.170800         0.000000 0 0 /
[11370.324567]  I      rcu_sched    10     20554.808940     33337   120         0.000000       866.429657         0.000000 0 0 /
[11370.324992]  S    migration/0    11        20.132751      2867     0         0.000000        61.565718         0.000000 0 0 /
[11370.325363]  S        cpuhp/0    13     10159.162790        21   120         0.000000         3.009202         0.000000 0 0 /
[11370.325881]  I   kworker/0:1H   665     20542.761650   1594163   100         0.000000     72434.148368         0.000000 0 0 /
[11370.326296]  S     multipathd   834         0.000000      2276     0         0.000000        86.876172         0.000000 0 0 /autogroup-44
[11370.327165]  S          gdbus  1769       127.823356       415   120         0.000000        55.641555         0.000000 0 0 /autogroup-71
[11370.328060]  S   avahi-daemon  1735        44.792954       995   120         0.000000       173.245815         0.000000 0 0 /autogroup-83
[11370.329035]  S NetworkManager  1776       106.921226      3073   120         0.000000       772.997485         0.000000 0 0 /autogroup-92
[11370.330053]  S          tuned  2255        11.887418        45   120         0.000000         0.936002         0.000000 0 0 /autogroup-108
[11370.331127]  S            atd  2084         3.551771         8   120         0.000000         8.106144         0.000000 0 0 /autogroup-119
[11370.332260]  I    kworker/0:0  4616     20542.910302    765515   120         0.000000      5913.998601         0.000000 0 0 /
[11370.332987]  I     mlx5e_arfs  4826     12333.186992         2   100         0.000000         0.028241         0.000000 0 0 /
[11370.333597]  I     mkey_cache  4838     12346.273985         2   100         0.000000         0.028788         0.000000 0 0 /
[11370.334215]  I    kworker/0:2  5532     12915.779667         2   120         0.000000         0.017757         0.000000 0 0 /
[11370.334882]  S      iscsi_ttx  6422     20542.785406        25   120         0.000000         0.568396         0.000000 0 0 /
[11370.335482]  S      iscsi_trx  6431     14972.790124         3   120         0.000000         0.133698         0.000000 0 0 /
[11370.336155] cpu#1, 2095.168 MHz
[11370.337006]   .nr_running                    : 1
[11370.337795]   .nr_switches                   : 3848046
[11370.338581]   .nr_load_updates               : 0
[11370.339349]   .nr_uninterruptible            : 19
[11370.340162]   .next_balance                  : 4306.037267
[11370.341027]   .curr->pid                     : 0
[11370.341877]   .clock                         : 11370341.867025
[11370.342796]   .clock_task                    : 11370342.785460
[11370.343652]   .avg_idle                      : 908791
[11370.344559]   .max_idle_balance_cost         : 500000
[11370.345309] cfs_rq[1]:/autogroup-154
[11370.346049]   .exec_clock                    : 0.000000
[11370.346780]   .MIN_vruntime                  : 0.000001
[11370.347409]   .min_vruntime                  : 3032.981381
[11370.348109]   .max_vruntime                  : 0.000001
[11370.348865]   .spread                        : 0.000000
[11370.349541]   .spread0                       : -17521.911237
[11370.350224]   .nr_spread_over                : 0
[11370.350924]   .nr_running                    : 0
[11370.351509]   .load                          : 0
[11370.352114]   .runnable_weight               : 0
[11370.352777]   .load_avg                      : 58
[11370.353304]   .runnable_load_avg             : 0
[11370.353926]   .util_avg                      : 57
[11370.354512]   .util_est_enqueued             : 0
[11370.355107]   .removed.load_avg              : 0
[11370.355761]   .removed.util_avg              : 0
[11370.356257]   .removed.runnable_sum          : 0
[11370.356890]   .tg_load_avg_contrib           : 53
[11370.357437]   .tg_load_avg                   : 53
[11370.357993]   .throttled                     : 0
[11370.358468]   .throttle_count                : 0
[11370.358987]   .se->exec_start                : 11370344.599355
[11370.359432]   .se->vruntime                  : 19188.388919
[11370.359935]   .se->sum_exec_runtime          : 2044.043881
[11370.360338]   .se->load.weight               : 1048576
[11370.360854]   .se->runnable_weight           : 2
[11370.361230]   .se->avg.load_avg              : 49
[11370.361654]   .se->avg.util_avg              : 48
[11370.362062]   .se->avg.runnable_load_avg     : 0
[11370.362401] cfs_rq[1]:/
[11370.362821]   .exec_clock                    : 0.000000
[11370.363143]   .MIN_vruntime                  : 0.000001
[11370.363491]   .min_vruntime                  : 19188.388919
[11370.363880]   .max_vruntime                  : 0.000001
[11370.364189]   .spread                        : 0.000000
[11370.364560]   .spread0                       : -1366.573959
[11370.364920]   .nr_spread_over                : 0
[11370.365211]   .nr_running                    : 0
[11370.365540]   .load                          : 0
[11370.365896]   .runnable_weight               : 0
[11370.366183]   .load_avg                      : 45
[11370.366498]   .runnable_load_avg             : 0
[11370.366858]   .util_avg                      : 44
[11370.367141]   .util_est_enqueued             : 0
[11370.367444]   .removed.load_avg              : 0
[11370.367808]   .removed.util_avg              : 0
[11370.368085]   .removed.runnable_sum          : 0
[11370.368355]   .tg_load_avg_contrib           : 0
[11370.368753]   .tg_load_avg                   : 0
[11370.369020]   .throttled                     : 0
[11370.369286]   .throttle_count                : 0
[11370.369606] rt_rq[1]:/
[11370.369918]   .rt_nr_running                 : 0
[11370.370185]   .rt_nr_migratory               : 0
[11370.370472]   .rt_throttled                  : 0
[11370.370814]   .rt_time                       : 0.037302
[11370.371081]   .rt_runtime                    : 950.000000
[11370.371349] dl_rq[1]:
[11370.371694]   .dl_nr_running                 : 0
[11370.371995]   .dl_nr_migratory               : 0
[11370.372259]   .dl_bw->bw                     : 996147
[11370.372598]   .dl_bw->total_bw               : 0
[11370.372921] runnable tasks:
[11370.373183]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.373525] -----------------------------------------------------------------------------------------------------------
[11370.373918]  S        cpuhp/1    14      6966.194104        21   120         0.000000         1.236060         0.000000 0 0 /
[11370.374268]  S    migration/1    15         0.000000      2870     0         0.000000        60.803223         0.000000 0 0 /
[11370.374723]  S    ksoftirqd/1    16     18936.151782      6580   120         0.000000        58.519687         0.000000 0 0 /
[11370.375086]  I   kworker/1:0H    18      1714.979795         8   100         0.000000         0.082099         0.000000 0 0 /
[11370.375482]  I          netns    91        22.966277         2   100         0.000000         0.007241         0.000000 0 0 /
[11370.375947]  I     tpm_dev_wq   208       228.734741         2   100         0.000000         0.026742         0.000000 0 0 /
[11370.376317]  S      scsi_eh_6   539      9008.423450        26   120         0.000000         2.205045         0.000000 0 0 /
[11370.376815]  I     scsi_tmf_6   540      1336.601065         2   100         0.000000         0.025515         0.000000 0 0 /
[11370.377191]  I   kworker/1:1H   747     18951.797061   1593563   100         0.000000     72318.849295         0.000000 0 0 /
[11370.377634]  I        kmpathd   819      1810.818657         2   100         0.000000         0.043361         0.000000 0 0 /
[11370.378075]  S     multipathd   835         0.000000     11360     0         0.000000       368.727227         0.000000 0 0 /autogroup-44
[11370.378953]  I ib-comp-unb-wq  1316      4940.139566         2   100         0.000000         0.042091         0.000000 0 0 /
[11370.379375]  S          gdbus  1768         0.165681       136   120         0.000000        21.859173         0.000000 0 0 /autogroup-73
[11370.380310]  S probing-thread  1791        39.007799        12   120         0.000000         0.341005         0.000000 0 0 /autogroup-77
[11370.381353]  S systemd-logind  1729        14.177902      1919   120         0.000000       246.531498         0.000000 0 0 /autogroup-81
[11370.382427]  S        chronyd  1785        63.667117       402   120         0.000000        65.853487         0.000000 0 0 /autogroup-94
[11370.383550]  S       libvirtd  2072        10.983183         1   120         0.000000         0.031768         0.000000 0 0 /autogroup-113
[11370.384790]  S       libvirtd  2073        22.998176         1   120         0.000000         0.015002         0.000000 0 0 /autogroup-113
[11370.385996]  S       libvirtd  2074        35.012828         1   120         0.000000         0.014661         0.000000 0 0 /autogroup-113
[11370.387248]  S       libvirtd  2075        47.026039         1   120         0.000000         0.013220         0.000000 0 0 /autogroup-113
[11370.388631]  S       libvirtd  2076        59.039072         1   120         0.000000         0.013042         0.000000 0 0 /autogroup-113
[11370.390041]  S       libvirtd  2077        71.052758         1   120         0.000000         0.013695         0.000000 0 0 /autogroup-113
[11370.391489]  S       libvirtd  2078        83.066153         1   120         0.000000         0.013404         0.000000 0 0 /autogroup-113
[11370.393058]  S       libvirtd  2079        95.078925         1   120         0.000000         0.012781         0.000000 0 0 /autogroup-113
[11370.394643]  S       libvirtd  2080       107.091542         1   120         0.000000         0.012626         0.000000 0 0 /autogroup-113
[11370.396266]  S       libvirtd  2081       119.103974         1   120         0.000000         0.012441         0.000000 0 0 /autogroup-113
[11370.398012]  S          rhnsd  2103         0.433781         1   120         0.000000         0.860259         0.000000 0 0 /autogroup-120
[11370.399787]  I    kworker/1:0  3334     19170.849267    767611   120         0.000000      5802.780197         0.000000 0 0 /
[11370.400725]  I    kworker/1:1  4636     10436.604041         2   120         0.000000         0.045349         0.000000 0 0 /
[11370.401627]  I      cxgb4_eeh  4658     10458.116635         2   100         0.000000         0.017824         0.000000 0 0 /
[11370.402537]  S       rdma-ndd  4775         3.782349         5   120         0.000000         5.872016         0.000000 0 0 /autogroup-157
[11370.404279]  I    mlx5_events  4814     10865.160842         2   100         0.000000         0.050466         0.000000 0 0 /
[11370.405241]  Imlx5_ib_page_fa  4835     10969.804383         2   100         0.000000         0.017626         0.000000 0 0 /
[11370.406173]  S      iscsi_ttx  6424     18951.811813        23   120         0.000000         0.645949         0.000000 0 0 /
[11370.407087]  S          dmesg  6547      3032.981381      3270   120         0.000000       253.540992         0.000000 0 0 /autogroup-154
[11370.408965] cpu#2, 2095.168 MHz
[11370.410090]   .nr_running                    : 0
[11370.411188]   .nr_switches                   : 3815891
[11370.412236]   .nr_load_updates               : 0
[11370.413295]   .nr_uninterruptible            : 13
[11370.414293]   .next_balance                  : 4306.037345
[11370.415357]   .curr->pid                     : 0
[11370.416317]   .clock                         : 11370415.436879
[11370.417366]   .clock_task                    : 11370416.446834
[11370.418335]   .avg_idle                      : 1000000
[11370.419311]   .max_idle_balance_cost         : 500000
[11370.420321] cfs_rq[2]:/
[11370.421259]   .exec_clock                    : 0.000000
[11370.422075]   .MIN_vruntime                  : 0.000001
[11370.422873]   .min_vruntime                  : 19695.826934
[11370.423582]   .max_vruntime                  : 0.000001
[11370.424290]   .spread                        : 0.000000
[11370.425113]   .spread0                       : -859.351075
[11370.425848]   .nr_spread_over                : 0
[11370.426480]   .nr_running                    : 0
[11370.427151]   .load                          : 0
[11370.427844]   .runnable_weight               : 0
[11370.428429]   .load_avg                      : 0
[11370.429084]   .runnable_load_avg             : 0
[11370.429724]   .util_avg                      : 0
[11370.430310]   .util_est_enqueued             : 0
[11370.430962]   .removed.load_avg              : 0
[11370.431550]   .removed.util_avg              : 0
[11370.432180]   .removed.runnable_sum          : 0
[11370.432819]   .tg_load_avg_contrib           : 0
[11370.433277]   .tg_load_avg                   : 0
[11370.433821]   .throttled                     : 0
[11370.434248]   .throttle_count                : 0
[11370.434765] rt_rq[2]:/
[11370.435157]   .rt_nr_running                 : 0
[11370.435597]   .rt_nr_migratory               : 0
[11370.436028]   .rt_throttled                  : 0
[11370.436392]   .rt_time                       : 0.000000
[11370.436868]   .rt_runtime                    : 950.000000
[11370.437212] dl_rq[2]:
[11370.437593]   .dl_nr_running                 : 0
[11370.437982]   .dl_nr_migratory               : 0
[11370.438350]   .dl_bw->bw                     : 996147
[11370.438764]   .dl_bw->total_bw               : 0
[11370.439067] runnable tasks:
[11370.439357]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.439800] -----------------------------------------------------------------------------------------------------------
[11370.440131]  S        cpuhp/2    19      7841.513713        21   120         0.000000         1.277269         0.000000 0 0 /
[11370.440543]  S    migration/2    20         0.000000      2878     0         0.000000        69.760518         0.000000 0 0 /
[11370.440967]  S    ksoftirqd/2    21     19344.983218      6192   120         0.000000        43.461007         0.000000 0 0 /
[11370.441329]  I   kworker/2:0H    23      1913.885769         8   100         0.000000         0.173524         0.000000 0 0 /
[11370.441816]  I      writeback    95       167.508345         2   100         0.000000         0.000000         0.000000 0 0 /
[11370.442188]  S  irq/25-aerdrv   237         0.000000         3    49         0.000000         0.066011         0.000000 0 0 /
[11370.442618]  I  ipv6_addrconf   251       701.767502         2   100         0.000000         0.045054         0.000000 0 0 /
[11370.443050]  I   kworker/2:1H   777     19683.827287   1595343   100         0.000000     73754.088934         0.000000 0 0 /
[11370.443456]  S        lvmetad   801         5.898599         3   120         0.000000         8.537295         0.000000 0 0 /autogroup-34
[11370.444290]  S    jbd2/dm-3-8  1650      7965.147600         2   120         0.000000         0.071236         0.000000 0 0 /
[11370.444847]  S       gssproxy  1709        10.988690         2   120         0.000000         0.037275         0.000000 0 0 /autogroup-69
[11370.445747]  S        cleanup  1792        20.931524         2   120         0.000000         0.679935         0.000000 0 0 /autogroup-77
[11370.446652]  S          gmain  1766        11.137970         3   120         0.000000         0.186555         0.000000 0 0 /autogroup-85
[11370.447653]  S          abrtd  1739        10.438734       103   120         0.000000        73.579807         0.000000 0 0 /autogroup-87
[11370.448769]  I    kworker/2:0  4191     12992.372640       498   120         0.000000        18.514168         0.000000 0 0 /
[11370.449286]  I       iscsi_eh  4751     11525.895523         2   100         0.000000         0.031149         0.000000 0 0 /
[11370.449927]  I    mlx5_esw_wq  4806     11537.914070         2   100         0.000000         0.023411         0.000000 0 0 /
[11370.450482]  I          mlx5e  4825     11575.319677         2   100         0.000000         0.064792         0.000000 0 0 /
[11370.451091]  I        ib_mad1  4836     11600.275214         2   100         0.000000         0.027544         0.000000 0 0 /
[11370.451735]  I    kworker/2:1  5348     19683.861564    758698   120         0.000000      5612.447951         0.000000 0 0 /
[11370.452275]  S      iscsi_ttx  6426     19683.863487        24   120         0.000000         0.654089         0.000000 0 0 /
[11370.452965]  S      iscsi_trx  6437     13782.151781         3   120         0.000000         0.099154         0.000000 0 0 /
[11370.453597] cpu#3, 2095.168 MHz
[11370.454314]   .nr_running                    : 0
[11370.455071]   .nr_switches                   : 3787897
[11370.455873]   .nr_load_updates               : 0
[11370.456685]   .nr_uninterruptible            : -62
[11370.457373]   .next_balance                  : 4306.037384
[11370.458159]   .curr->pid                     : 0
[11370.458981]   .clock                         : 11370458.240565
[11370.459791]   .clock_task                    : 11370459.042384
[11370.460605]   .avg_idle                      : 505212
[11370.461338]   .max_idle_balance_cost         : 500000
[11370.462041] cfs_rq[3]:/
[11370.462844]   .exec_clock                    : 0.000000
[11370.463508]   .MIN_vruntime                  : 0.000001
[11370.464169]   .min_vruntime                  : 22281.871107
[11370.464885]   .max_vruntime                  : 0.000001
[11370.465493]   .spread                        : 0.000000
[11370.466124]   .spread0                       : 1726.548547
[11370.466843]   .nr_spread_over                : 0
[11370.467443]   .nr_running                    : 0
[11370.468068]   .load                          : 0
[11370.468656]   .runnable_weight               : 0
[11370.469242]   .load_avg                      : 20
[11370.469838]   .runnable_load_avg             : 0
[11370.470328]   .util_avg                      : 20
[11370.470915]   .util_est_enqueued             : 0
[11370.471393]   .removed.load_avg              : 0
[11370.471971]   .removed.util_avg              : 0
[11370.472482]   .removed.runnable_sum          : 0
[11370.473031]   .tg_load_avg_contrib           : 0
[11370.473559]   .tg_load_avg                   : 0
[11370.474045]   .throttled                     : 0
[11370.474495]   .throttle_count                : 0
[11370.474979] rt_rq[3]:/
[11370.475404]   .rt_nr_running                 : 0
[11370.475913]   .rt_nr_migratory               : 0
[11370.476332]   .rt_throttled                  : 0
[11370.476836]   .rt_time                       : 0.000000
[11370.477184]   .rt_runtime                    : 950.000000
[11370.477561] dl_rq[3]:
[11370.477937]   .dl_nr_running                 : 0
[11370.478251]   .dl_nr_migratory               : 0
[11370.478615]   .dl_bw->bw                     : 996147
[11370.478972]   .dl_bw->total_bw               : 0
[11370.479275] runnable tasks:
[11370.479622]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.479996] -----------------------------------------------------------------------------------------------------------
[11370.480338]  S        cpuhp/3    24      9582.985335        21   120         0.000000         1.049306         0.000000 0 0 /
[11370.480839]  S    migration/3    25         0.000000      2861     0         0.000000        72.593136         0.000000 0 0 /
[11370.481195]  S    ksoftirqd/3    26     22138.833818      6425   120         0.000000       159.040033         0.000000 0 0 /
[11370.481610]  I   kworker/3:0H    28      3158.317936         8   100         0.000000         0.312501         0.000000 0 0 /
[11370.482030]  S     khungtaskd    93     22140.882633        94   120         0.000000         4.857296         0.000000 0 0 /
[11370.482405]  I             md   209        35.087873         2   100         0.000000         0.000000         0.000000 0 0 /
[11370.482886]  S  irq/27-aerdrv   241         0.000000         3    49         0.000000         0.028523         0.000000 0 0 /
[11370.483267]  I        ata_sff   515      2406.807321         2   100         0.000000         0.028906         0.000000 0 0 /
[11370.483756]  I     scsi_tmf_0   520      2733.532067         2   100         0.000000         0.045546         0.000000 0 0 /
[11370.484145]  I     scsi_tmf_4   536      2915.976291         2   100         0.000000         0.028047         0.000000 0 0 /
[11370.484608]  S      scsi_eh_5   537     10450.262717        26   120         0.000000         1.349030         0.000000 0 0 /
[11370.485054]  I     scsi_tmf_5   538      2939.665255         2   100         0.000000         0.022807         0.000000 0 0 /
[11370.485477]  S      scsi_eh_7   541     10450.296464        26   120         0.000000         2.140087         0.000000 0 0 /
[11370.485959]  I     scsi_tmf_7   542      2939.671679         2   100         0.000000         0.020417         0.000000 0 0 /
[11370.486365]  I     scsi_tmf_8   544      2939.683971         2   100         0.000000         0.019114         0.000000 0 0 /
[11370.486875]  S      scsi_eh_9   545     10450.268883        26   120         0.000000         0.934113         0.000000 0 0 /
[11370.487286]  I     scsi_tmf_9   546      2939.696100         2   100         0.000000         0.019032         0.000000 0 0 /
[11370.487804]  I   kworker/3:1H   666     22199.946058   1595147   100         0.000000     72558.371796         0.000000 0 0 /
[11370.488229]  S    jbd2/dm-0-8   689     22200.040864       614   120         0.000000        68.786339         0.000000 0 0 /
[11370.488787]  S  systemd-udevd   796       801.666461      1174   120         0.000000      2019.518969         0.000000 0 0 /autogroup-33
[11370.489742]  S     multipathd   831         0.000000         8     0         0.000000        24.902922         0.000000 0 0 /autogroup-44
[11370.490753]  S    jbd2/dm-2-8  1646     18164.156656         6   120         0.000000         0.257645         0.000000 0 0 /
[11370.491248]  S        rpcbind  1702        48.963552       494   120         0.000000        57.168341         0.000000 0 0 /autogroup-68
[11370.492316]  S   ModemManager  1714         1.358442       156   120         0.000000        50.185220         0.000000 0 0 /autogroup-73
[11370.493513]  S        udisksd  1719        12.389285       555   120         0.000000       100.041562         0.000000 0 0 /autogroup-77
[11370.494769]  S   avahi-daemon  1765         0.870793         4   120         0.000000         0.446129         0.000000 0 0 /autogroup-83
[11370.495996]  S         python  2054       175.948732        41   120         0.000000       148.990629         0.000000 0 0 /autogroup-103
[11370.497320]  I    kworker/3:0  4427     22263.070630    762473   120         0.000000      6465.064870         0.000000 0 0 /
[11370.498073]  S           sshd  4526         0.798702        30   120         0.000000        41.235508         0.000000 0 0 /autogroup-153
[11370.499472]  I  iw_cxgb4_free  4770     13090.682517         2   100         0.000000         0.067556         0.000000 0 0 /
[11370.500215]  Imlx5_health0000  4811     13102.711240         2   100         0.000000         0.033360         0.000000 0 0 /
[11370.501031]  I        ib_mad1  4831     13128.967395         2   100         0.000000         0.020802         0.000000 0 0 /
[11370.501804]  I    kworker/3:2  5122     13895.398585         4   120         0.000000         0.054780         0.000000 0 0 /
[11370.502532]  I  kworker/u32:0  5334     22281.871107      4784   120         0.000000       150.252520         0.000000 0 0 /
[11370.503279]  S      iscsi_ttx  6428     22162.840544        23   120         0.000000         0.592951         0.000000 0 0 /
[11370.504085]  S      iscsi_trx  6435     16521.232507         3   120         0.000000         0.098251         0.000000 0 0 /
[11370.504949] cpu#4, 2095.168 MHz
[11370.505942]   .nr_running                    : 0
[11370.506895]   .nr_switches                   : 3807760
[11370.507826]   .nr_load_updates               : 0
[11370.508817]   .nr_uninterruptible            : -15
[11370.509675]   .next_balance                  : 4306.037441
[11370.510512]   .curr->pid                     : 0
[11370.511343]   .clock                         : 11370510.440062
[11370.512153]   .clock_task                    : 11370511.404175
[11370.513057]   .avg_idle                      : 1000000
[11370.513945]   .max_idle_balance_cost         : 500000
[11370.514857] cfs_rq[4]:/
[11370.515743]   .exec_clock                    : 0.000000
[11370.516447]   .MIN_vruntime                  : 0.000001
[11370.517190]   .min_vruntime                  : 27887.961913
[11370.517941]   .max_vruntime                  : 0.000001
[11370.518626]   .spread                        : 0.000000
[11370.519306]   .spread0                       : 7332.432970
[11370.520033]   .nr_spread_over                : 0
[11370.520763]   .nr_running                    : 0
[11370.521340]   .load                          : 0
[11370.522027]   .runnable_weight               : 0
[11370.522697]   .load_avg                      : 15
[11370.523291]   .runnable_load_avg             : 0
[11370.523968]   .util_avg                      : 0
[11370.524606]   .util_est_enqueued             : 0
[11370.525201]   .removed.load_avg              : 0
[11370.525804]   .removed.util_avg              : 0
[11370.526332]   .removed.runnable_sum          : 0
[11370.526920]   .tg_load_avg_contrib           : 0
[11370.527384]   .tg_load_avg                   : 0
[11370.527944]   .throttled                     : 0
[11370.528378]   .throttle_count                : 0
[11370.528927] rt_rq[4]:/
[11370.529325]   .rt_nr_running                 : 0
[11370.529837]   .rt_nr_migratory               : 0
[11370.530216]   .rt_throttled                  : 0
[11370.530640]   .rt_time                       : 0.000000
[11370.531040]   .rt_runtime                    : 950.000000
[11370.531383] dl_rq[4]:
[11370.531815]   .dl_nr_running                 : 0
[11370.532133]   .dl_nr_migratory               : 0
[11370.532493]   .dl_bw->bw                     : 996147
[11370.532877]   .dl_bw->total_bw               : 0
[11370.533180] runnable tasks:
[11370.533559]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.533953] -----------------------------------------------------------------------------------------------------------
[11370.534295]  S        cpuhp/4    29     16686.277806        21   120         0.000000         2.052423         0.000000 0 0 /
[11370.534766]  S    migration/4    30       102.054038      2870     0         0.000000        70.763143         0.000000 0 0 /
[11370.535122]  S    ksoftirqd/4    31     27726.165082      5917   120         0.000000        40.370996         0.000000 0 0 /
[11370.535520]  I   kworker/4:0H    33      4175.551996         8   100         0.000000         0.272541         0.000000 0 0 /
[11370.535962]  S        kauditd    92     27731.136501       407   120         0.000000        19.231337         0.000000 0 0 /
[11370.536336]  S     oom_reaper    94        10.951455         2   120         0.000000         0.000000         0.000000 0 0 /
[11370.536838]  I    kworker/4:1   134     20306.631051       467   120         0.000000        21.579898         0.000000 0 0 /
[11370.537220]  I    edac-poller   210        35.647859         2   100         0.000000         0.509948         0.000000 0 0 /
[11370.537689]  I       kthrotld   236        47.685503         2   100         0.000000         0.021359         0.000000 0 0 /
[11370.538119]  S  irq/29-aerdrv   242         0.000000         3    49         0.000000         0.025165         0.000000 0 0 /
[11370.538554]  I   kworker/4:1H   655     27875.962460   1591837   100         0.000000     73860.507010         0.000000 0 0 /
[11370.539022]  S        audispd  1676         0.697958       405   112         0.000000        21.126095         0.000000 0 0 /autogroup-62
[11370.539903]  S          gmain  1720        10.769269         3   120         0.000000         0.223576         0.000000 0 0 /autogroup-73
[11370.540854]  S          gmain  2251        11.104894         1   120         0.000000         0.153479         0.000000 0 0 /autogroup-108
[11370.541835]  S          tuned  2389        24.409098         4   120         0.000000         1.304213         0.000000 0 0 /autogroup-108
[11370.542862]  S       libvirtd  2128        39.162527         1   120         0.000000         0.027106         0.000000 0 0 /autogroup-113
[11370.543944]  S       libvirtd  2131        51.177141         1   120         0.000000         0.014621         0.000000 0 0 /autogroup-113
[11370.545096]  S       libvirtd  2133        63.191281         1   120         0.000000         0.014147         0.000000 0 0 /autogroup-113
[11370.546276]  I mlx5_fw_tracer  4807     19047.896151         2   100         0.000000         0.027704         0.000000 0 0 /
[11370.546960]  Imlx5_cmd_0000:0  4813     19059.919219         2   100         0.000000         0.030794         0.000000 0 0 /
[11370.547596]  I   mlx5_hv_vhca  4817     19059.926335         2   100         0.000000         0.037016         0.000000 0 0 /
[11370.548242]  I     mkey_cache  4833     19357.479387         2   100         0.000000         0.030772         0.000000 0 0 /
[11370.548968]  I    kworker/4:2  5174     27875.977825    760325   120         0.000000      5657.206568         0.000000 0 0 /
[11370.549627]  S      iscsi_trx  6425     22071.182780         3   120         0.000000         0.096864         0.000000 0 0 /
[11370.550285]  S      iscsi_ttx  6430     27875.976891        24   120         0.000000         0.633421         0.000000 0 0 /
[11370.551019]  S          sleep  6557      1072.477745         1   120         0.000000         1.446784         0.000000 0 0 /autogroup-95
[11370.552383] cpu#5, 2095.168 MHz
[11370.553267]   .nr_running                    : 0
[11370.554115]   .nr_switches                   : 3803875
[11370.555037]   .nr_load_updates               : 0
[11370.555943]   .nr_uninterruptible            : 2
[11370.556901]   .next_balance                  : 4306.037486
[11370.557853]   .curr->pid                     : 0
[11370.558746]   .clock                         : 11370558.437967
[11370.559621]   .clock_task                    : 11370559.434575
[11370.560468]   .avg_idle                      : 745466
[11370.561271]   .max_idle_balance_cost         : 500000
[11370.562028] cfs_rq[5]:/
[11370.562890]   .exec_clock                    : 0.000000
[11370.563551]   .MIN_vruntime                  : 0.000001
[11370.564218]   .min_vruntime                  : 18513.589637
[11370.564949]   .max_vruntime                  : 0.000001
[11370.565644]   .spread                        : 0.000000
[11370.566279]   .spread0                       : -2042.128085
[11370.566943]   .nr_spread_over                : 0
[11370.567525]   .nr_running                    : 0
[11370.568133]   .load                          : 0
[11370.568810]   .runnable_weight               : 0
[11370.569340]   .load_avg                      : 1
[11370.570001]   .runnable_load_avg             : 0
[11370.570560]   .util_avg                      : 1
[11370.571133]   .util_est_enqueued             : 0
[11370.571763]   .removed.load_avg              : 0
[11370.572244]   .removed.util_avg              : 0
[11370.572836]   .removed.runnable_sum          : 0
[11370.573289]   .tg_load_avg_contrib           : 0
[11370.573834]   .tg_load_avg                   : 0
[11370.574298]   .throttled                     : 0
[11370.574868]   .throttle_count                : 0
[11370.575271] rt_rq[5]:/
[11370.575752]   .rt_nr_running                 : 0
[11370.576176]   .rt_nr_migratory               : 0
[11370.576612]   .rt_throttled                  : 0
[11370.577016]   .rt_time                       : 0.000000
[11370.577354]   .rt_runtime                    : 950.000000
[11370.577797] dl_rq[5]:
[11370.578110]   .dl_nr_running                 : 0
[11370.578450]   .dl_nr_migratory               : 0
[11370.578848]   .dl_bw->bw                     : 996147
[11370.579156]   .dl_bw->total_bw               : 0
[11370.579481] runnable tasks:
[11370.579851]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.580176] -----------------------------------------------------------------------------------------------------------
[11370.580573]  S        cpuhp/5    34      6678.576688        21   120         0.000000         1.417899         0.000000 0 0 /
[11370.580985]  S    migration/5    35       141.054086      2895     0         0.000000        66.314255         0.000000 0 0 /
[11370.581343]  S    ksoftirqd/5    36     18483.786959      6485   120         0.000000        50.612647         0.000000 0 0 /
[11370.581806]  I   kworker/5:0H    38      1475.209546         8   100         0.000000         0.303150         0.000000 0 0 /
[11370.582176]  S      kdevtmpfs    90     10163.598331       245   120         0.000000        10.924548         0.000000 0 0 /
[11370.582602]  S     kcompactd0    96        10.951418         2   120         0.000000         0.000000         0.000000 0 0 /
[11370.583030]  I     devfreq_wq   211        11.023483         2   100         0.000000         0.000000         0.000000 0 0 /
[11370.583426]  I     scsi_tmf_1   523       943.901869         2   100         0.000000         0.029263         0.000000 0 0 /
[11370.583895]  S      scsi_eh_2   525      9476.350442        29   120         0.000000         0.967962         0.000000 0 0 /
[11370.584282]  S   kworker/5:1H   768     18484.543585   1587890   100         0.000000     72517.181658         0.000000 0 0 /
[11370.584807]  S        dnsmasq  2438        20.932776         1   120         0.000000         9.981360         0.000000 0 0 /autogroup-123
[11370.585661]  I    kworker/5:0  3358     11023.019433       293   120         0.000000        10.307843         0.000000 0 0 /
[11370.586134]  IRegister_iWARP_  4667      9999.412474         2   100         0.000000         0.019827         0.000000 0 0 /
[11370.586616]  Invmet-buffered-  4793     10127.979728         2   100         0.000000         0.025318         0.000000 0 0 /
[11370.587096]  I        mlx5_fc  4809     10140.024731         2   100         0.000000         0.049799         0.000000 0 0 /
[11370.587581]  I       mlx5_lag  4823     10152.082726         2   100         0.000000         0.064095         0.000000 0 0 /
[11370.588077]  I    kworker/5:1  5496     18496.738821    756421   120         0.000000      5565.124445         0.000000 0 0 /
[11370.588596]  D      iscsi_ttx  6432     18484.862083        12   120         0.000000         0.470365         0.000000 0 0 /
[11370.589104]  I  kworker/u32:2  6549     18513.589637       950   120         0.000000        22.385155         0.000000 0 0 /
[11370.589660] cpu#6, 2095.168 MHz
[11370.590294]   .nr_running                    : 1
[11370.590971]   .nr_switches                   : 3830124
[11370.591601]   .nr_load_updates               : 0
[11370.592250]   .nr_uninterruptible            : -6
[11370.592932]   .next_balance                  : 4306.037645
[11370.593570]   .curr->pid                     : 780
[11370.594174]   .clock                         : 11370593.570083
[11370.594829]   .clock_task                    : 11370594.804626
[11370.595510]   .avg_idle                      : 858242
[11370.596137]   .max_idle_balance_cost         : 500000
[11370.596747] cfs_rq[6]:/autogroup-24
[11370.597383]   .exec_clock                    : 0.000000
[11370.598010]   .MIN_vruntime                  : 0.000001
[11370.598518]   .min_vruntime                  : 123.154662
[11370.599060]   .max_vruntime                  : 0.000001
[11370.599580]   .spread                        : 0.000000
[11370.600109]   .spread0                       : -20432.677550
[11370.600670]   .nr_spread_over                : 0
[11370.601204]   .nr_running                    : 0
[11370.601777]   .load                          : 0
[11370.602277]   .runnable_weight               : 0
[11370.602887]   .load_avg                      : 150
[11370.603400]   .runnable_load_avg             : 0
[11370.603978]   .util_avg                      : 150
[11370.604556]   .util_est_enqueued             : 0
[11370.605098]   .removed.load_avg              : 0
[11370.605587]   .removed.util_avg              : 0
[11370.606066]   .removed.runnable_sum          : 0
[11370.606558]   .tg_load_avg_contrib           : 139
[11370.607031]   .tg_load_avg                   : 139
[11370.607453]   .throttled                     : 0
[11370.607929]   .throttle_count                : 0
[11370.608315]   .se->exec_start                : 11370597.054196
[11370.608832]   .se->vruntime                  : 19943.351575
[11370.609218]   .se->sum_exec_runtime          : 124.203238
[11370.609664]   .se->load.weight               : 1048576
[11370.610100]   .se->runnable_weight           : 2
[11370.610497]   .se->avg.load_avg              : 127
[11370.610927]   .se->avg.util_avg              : 127
[11370.611266]   .se->avg.runnable_load_avg     : 0
[11370.611662] cfs_rq[6]:/
[11370.612032]   .exec_clock                    : 0.000000
[11370.612361]   .MIN_vruntime                  : 0.000001
[11370.612831]   .min_vruntime                  : 19943.351575
[11370.613152]   .max_vruntime                  : 0.000001
[11370.613494]   .spread                        : 0.000000
[11370.613874]   .spread0                       : -612.539193
[11370.614166]   .nr_spread_over                : 0
[11370.614485]   .nr_running                    : 0
[11370.614848]   .load                          : 0
[11370.615135]   .runnable_weight               : 0
[11370.615441]   .load_avg                      : 120
[11370.615811]   .runnable_load_avg             : 0
[11370.616095]   .util_avg                      : 117
[11370.616377]   .util_est_enqueued             : 0
[11370.616785]   .removed.load_avg              : 0
[11370.617065]   .removed.util_avg              : 0
[11370.617341]   .removed.runnable_sum          : 0
[11370.617697]   .tg_load_avg_contrib           : 0
[11370.617998]   .tg_load_avg                   : 0
[11370.618266]   .throttled                     : 0
[11370.618577]   .throttle_count                : 0
[11370.618904] rt_rq[6]:/
[11370.619161]   .rt_nr_running                 : 0
[11370.619449]   .rt_nr_migratory               : 0
[11370.619795]   .rt_throttled                  : 0
[11370.620059]   .rt_time                       : 0.000000
[11370.620373]   .rt_runtime                    : 950.000000
[11370.620785] dl_rq[6]:
[11370.621041]   .dl_nr_running                 : 0
[11370.621307]   .dl_nr_migratory               : 0
[11370.621629]   .dl_bw->bw                     : 996147
[11370.621945]   .dl_bw->total_bw               : 0
[11370.622210] runnable tasks:
[11370.622503]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.622882] -----------------------------------------------------------------------------------------------------------
[11370.623204]  S        cpuhp/6    39      9226.301855        21   120         0.000000         1.775906         0.000000 0 0 /
[11370.623603]  S    migration/6    40         0.000000      2880     0         0.000000        50.516604         0.000000 0 0 /
[11370.624012]  S    ksoftirqd/6    41     19863.221822      5873   120         0.000000        36.708447         0.000000 0 0 /
[11370.624372]  I   kworker/6:0H    43      3510.115101         8   100         0.000000         0.248616         0.000000 0 0 /
[11370.624868]  S           ksmd    97      9383.252086         3   125         0.000000         0.012093         0.000000 0 0 /
[11370.625238]  I         kaluad   245        73.406936         2   100         0.000000         0.026992         0.000000 0 0 /
[11370.625693]  Ssystemd-journal   780       123.154662      4353   120         0.000000      1305.452688         0.000000 0 0 /autogroup-24
[11370.626479]  I   kworker/6:1H   826     19911.283680   1599319   100         0.000000     73862.525788         0.000000 0 0 /
[11370.626960]  I         cryptd  1113      5589.362157         2   100         0.000000         0.022827         0.000000 0 0 /
[11370.627374]  I  kworker/u33:0  1315     14246.254431        14   100         0.000000         0.969039         0.000000 0 0 /
[11370.627903]  Saccounts-daemon  1712         0.062334       490   120         0.000000       526.388220         0.000000 0 0 /autogroup-71
[11370.628839]  S          gmain  1732        21.675376         9   120         0.000000         0.673312         0.000000 0 0 /autogroup-77
[11370.629811]  S   rtkit-daemon  1773         0.000000      1703     0         0.000000        97.373095         0.000000 0 0 /autogroup-79
[11370.630838]  I    kworker/6:0  4281     19876.320279    762020   120         0.000000      5639.904895         0.000000 0 0 /
[11370.631347]  Imlx5_page_alloc  4803     12495.332423         2   100         0.000000         0.057020         0.000000 0 0 /
[11370.631959]  I    kworker/6:3  5146     13288.432774         2   120         0.000000         0.012212         0.000000 0 0 /
[11370.632536]  S      iscsi_trx  6427     14270.324248         3   120         0.000000         0.070437         0.000000 0 0 /
[11370.633130]  S      iscsi_ttx  6434     19911.299093        25   120         0.000000         0.733132         0.000000 0 0 /
[11370.633794] cpu#7, 2095.168 MHz
[11370.634550]   .nr_running                    : 0
[11370.635220]   .nr_switches                   : 3909447
[11370.635967]   .nr_load_updates               : 0
[11370.636692]   .nr_uninterruptible            : 9
[11370.637445]   .next_balance                  : 4306.037569
[11370.638109]   .curr->pid                     : 0
[11370.638834]   .clock                         : 11370638.435269
[11370.639624]   .clock_task                    : 11370639.404913
[11370.640299]   .avg_idle                      : 1000000
[11370.641016]   .max_idle_balance_cost         : 500000
[11370.641868] cfs_rq[7]:/
[11370.642615]   .exec_clock                    : 0.000000
[11370.643245]   .MIN_vruntime                  : 0.000001
[11370.643928]   .min_vruntime                  : 23448.121635
[11370.644589]   .max_vruntime                  : 0.000001
[11370.645206]   .spread                        : 0.000000
[11370.645968]   .spread0                       : 2892.121423
[11370.646765]   .nr_spread_over                : 0
[11370.647356]   .nr_running                    : 0
[11370.648034]   .load                          : 0
[11370.648677]   .runnable_weight               : 0
[11370.649252]   .load_avg                      : 1
[11370.649883]   .runnable_load_avg             : 0
[11370.650404]   .util_avg                      : 0
[11370.651024]   .util_est_enqueued             : 0
[11370.651596]   .removed.load_avg              : 0
[11370.652130]   .removed.util_avg              : 0
[11370.652745]   .removed.runnable_sum          : 0
[11370.653220]   .tg_load_avg_contrib           : 0
[11370.653777]   .tg_load_avg                   : 0
[11370.654225]   .throttled                     : 0
[11370.654784]   .throttle_count                : 0
[11370.655248] rt_rq[7]:/
[11370.655775]   .rt_nr_running                 : 0
[11370.656216]   .rt_nr_migratory               : 0
[11370.656725]   .rt_throttled                  : 0
[11370.657176]   .rt_time                       : 0.000000
[11370.657602]   .rt_runtime                    : 950.000000
[11370.658020] dl_rq[7]:
[11370.658362]   .dl_nr_running                 : 0
[11370.658817]   .dl_nr_migratory               : 0
[11370.659138]   .dl_bw->bw                     : 996147
[11370.659471]   .dl_bw->total_bw               : 0
[11370.659851] runnable tasks:
[11370.660138]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.660517] -----------------------------------------------------------------------------------------------------------
[11370.660930]  S       kthreadd     2     22961.402089       525   120         0.000000        28.076411         0.000000 0 0 /
[11370.661281]  S        cpuhp/7    44      8609.037007        21   120         0.000000         1.391760         0.000000 0 0 /
[11370.661753]  S    migration/7    45       219.097094      2897     0         0.000000        49.156600         0.000000 0 0 /
[11370.662111]  S    ksoftirqd/7    46     22938.975173      6240   120         0.000000        42.759075         0.000000 0 0 /
[11370.662509]  I   kworker/7:0H    48      1654.495306         8   100         0.000000         0.071750         0.000000 0 0 /
[11370.662956]  S     khugepaged    98     23430.359948      1114   139         0.000000        98.587160         0.000000 0 0 /
[11370.663329]  I    kworker/7:1   100     23436.171587    811086   120         0.000000      9876.360350         0.000000 0 0 /
[11370.663826]  I        kblockd   205       162.290595         2   100         0.000000         0.004767         0.000000 0 0 /
[11370.664214]  I   kmpath_rdacd   244       188.505518         2   100         0.000000         0.052883         0.000000 0 0 /
[11370.664719]  I   kworker/7:1H   679     23436.122177   1591422   100         0.000000     72339.134406         0.000000 0 0 /
[11370.665147]  Ikmpath_handlerd   820      1835.392014         2   100         0.000000         0.042357         0.000000 0 0 /
[11370.665600]  S         kipmi0  1011      4208.089892       262   139         0.000000         4.396343         0.000000 0 0 /
[11370.666062]  I        rdma_cm  1352      5869.880833         2   100         0.000000         0.040701         0.000000 0 0 /
[11370.666504]  I       kdmflush  1618      8680.995254         2   100         0.000000         0.042874         0.000000 0 0 /
[11370.666988]  Iext4-rsv-conver  1647      8693.078402         2   100         0.000000         0.043348         0.000000 0 0 /
[11370.667406]  S       gssproxy  1707        11.059573         2   120         0.000000         0.108158         0.000000 0 0 /autogroup-69
[11370.668321]  S       rsyslogd  2024        33.874950        20   120         0.000000         9.529760         0.000000 0 0 /autogroup-105
[11370.669331]  S       libvirtd  2132        10.989688         1   120         0.000000         0.038271         0.000000 0 0 /autogroup-113
[11370.670369]  I          mlx5e  4820     13671.314275         2   100         0.000000         0.019403         0.000000 0 0 /
[11370.670975]  Imlx5_ib_page_fa  4828     13692.829766         2   100         0.000000         0.026469         0.000000 0 0 /
[11370.671514]  I    kworker/7:2  5525     15882.029085         2   120         0.000000         0.020192         0.000000 0 0 /
[11370.672095]  S      iscsi_ttx  6436     23436.137068        25   120         0.000000         0.757014         0.000000 0 0 /
[11370.672791] cpu#8, 2095.168 MHz
[11370.673517]   .nr_running                    : 3
[11370.674216]   .nr_switches                   : 315715
[11370.674927]   .nr_load_updates               : 0
[11370.675665]   .nr_uninterruptible            : 12
[11370.676306]   .next_balance                  : 4306.037608
[11370.677033]   .curr->pid                     : 6450
[11370.677856]   .clock                         : 11370677.850920
[11370.678562]   .clock_task                    : 11370678.556271
[11370.679287]   .avg_idle                      : 1000000
[11370.679934]   .max_idle_balance_cost         : 500000
[11370.680769] cfs_rq[8]:/autogroup-176
[11370.681478]   .exec_clock                    : 0.000000
[11370.682114]   .MIN_vruntime                  : 0.000001
[11370.682756]   .min_vruntime                  : 3821.227482
[11370.683303]   .max_vruntime                  : 0.000001
[11370.683962]   .spread                        : 0.000000
[11370.684628]   .spread0                       : -16734.920006
[11370.685223]   .nr_spread_over                : 0
[11370.685870]   .nr_running                    : 1
[11370.686395]   .load                          : 1048576
[11370.687019]   .runnable_weight               : 1048576
[11370.687617]   .load_avg                      : 1024
[11370.688149]   .runnable_load_avg             : 1024
[11370.688754]   .util_avg                      : 1024
[11370.689222]   .util_est_enqueued             : 0
[11370.689802]   .removed.load_avg              : 0
[11370.690256]   .removed.util_avg              : 0
[11370.690802]   .removed.runnable_sum          : 0
[11370.691238]   .tg_load_avg_contrib           : 1020
[11370.691771]   .tg_load_avg                   : 1020
[11370.692199]   .throttled                     : 0
[11370.692783]   .throttle_count                : 0
[11370.693191]   .se->exec_start                : 11370680.744896
[11370.693663]   .se->vruntime                  : 22408.251960
[11370.694127]   .se->sum_exec_runtime          : 3822.276065
[11370.694577]   .se->load.weight               : 1048576
[11370.695039]   .se->runnable_weight           : 1048576
[11370.695456]   .se->avg.load_avg              : 1023
[11370.695922]   .se->avg.util_avg              : 1024
[11370.696291]   .se->avg.runnable_load_avg     : 1023
[11370.696791] cfs_rq[8]:/
[11370.697128]   .exec_clock                    : 0.000000
[11370.697495]   .MIN_vruntime                  : 18784.356500
[11370.697911]   .min_vruntime                  : 18784.356500
[11370.698231]   .max_vruntime                  : 18784.356500
[11370.698623]   .spread                        : 0.000000
[11370.698974]   .spread0                       : -1771.860119
[11370.699267]   .nr_spread_over                : 0
[11370.699609]   .nr_running                    : 2
[11370.699983]   .load                          : 2097152
[11370.700305]   .runnable_weight               : 2097152
[11370.700685]   .load_avg                      : 2048
[11370.701035]   .runnable_load_avg             : 2048
[11370.701320]   .util_avg                      : 1024
[11370.701688]   .util_est_enqueued             : 40
[11370.701992]   .removed.load_avg              : 0
[11370.702276]   .removed.util_avg              : 0
[11370.702609]   .removed.runnable_sum          : 0
[11370.702938]   .tg_load_avg_contrib           : 0
[11370.703210]   .tg_load_avg                   : 0
[11370.703515]   .throttled                     : 0
[11370.703855]   .throttle_count                : 0
[11370.704144] rt_rq[8]:/
[11370.704500]   .rt_nr_running                 : 0
[11370.704860]   .rt_nr_migratory               : 0
[11370.705173]   .rt_throttled                  : 0
[11370.705461]   .rt_time                       : 0.000000
[11370.705809]   .rt_runtime                    : 950.000000
[11370.706078] dl_rq[8]:
[11370.706336]   .dl_nr_running                 : 0
[11370.706686]   .dl_nr_migratory               : 0
[11370.706970]   .dl_bw->bw                     : 996147
[11370.707287]   .dl_bw->total_bw               : 0
[11370.707604] runnable tasks:
[11370.707921]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.708227] -----------------------------------------------------------------------------------------------------------
[11370.708625]  S        cpuhp/8    49      7961.681285        21   120         0.000000         1.237092         0.000000 0 0 /
[11370.709026]  R    migration/8    50       263.097141      2889     0         0.000000        53.370676         0.000000 0 0 /
[11370.709381]  S    ksoftirqd/8    51     18626.683138       193   120         0.000000         8.204026         0.000000 0 0 /
[11370.709858]  I   kworker/8:0H    53      1072.327206         8   100         0.000000         0.192540         0.000000 0 0 /
[11370.710227]  I blkcg_punt_bio   206        48.588683         2   100         0.000000         0.000000         0.000000 0 0 /
[11370.710661]  S      scsi_eh_8   543      9060.804035        26   120         0.000000         1.443875         0.000000 0 0 /
[11370.711097]  I   kworker/8:1H   568     18772.356794       104   100         0.000000         2.080452         0.000000 0 0 /
[11370.711510]  S     multipathd   836         0.000000        17     0         0.000000        10.168330         0.000000 0 0 /autogroup-44
[11370.712321]  S abrt-watch-log  1746        19.869593         7   120         0.000000        16.847282         0.000000 0 0 /autogroup-89
[11370.713266]  R    kworker/8:0  3269     18784.356500       769   120         0.000000       112.053753         0.000000 0 0 /
[11370.713807]  S    sftp-server  4577        19.260125        38   120         0.000000        20.555820         0.000000 0 0 /autogroup-155
[11370.714770]  I    kworker/8:1  4627     11494.543260         5   120         0.000000         0.265759         0.000000 0 0 /
[11370.715244]  Imlx5_page_alloc  4812     12449.466785         2   100         0.000000         0.028557         0.000000 0 0 /
[11370.715829]  I        mlx5_fc  4818     12461.485224         2   100         0.000000         0.025169         0.000000 0 0 /
[11370.716313]  S       iscsi_np  6038     16753.671728         2   120         0.000000         0.031895         0.000000 0 0 /
[11370.716950] >R           bash  6450      3821.227482       170   120         0.000000      3822.323552         0.000000 0 0 /autogroup-176
[11370.718030] cpu#9, 2095.168 MHz
[11370.718783]   .nr_running                    : 0
[11370.719461]   .nr_switches                   : 136346
[11370.720113]   .nr_load_updates               : 0
[11370.720833]   .nr_uninterruptible            : 23
[11370.721544]   .next_balance                  : 4306.037653
[11370.722189]   .curr->pid                     : 2040
[11370.722878]   .clock                         : 11370722.655732
[11370.723601]   .clock_task                    : 11370723.599679
[11370.724249]   .avg_idle                      : 79654
[11370.724943]   .max_idle_balance_cost         : 500000
[11370.725749] cfs_rq[9]:/autogroup-105
[11370.726478]   .exec_clock                    : 0.000000
[11370.727079]   .MIN_vruntime                  : 0.000001
[11370.727662]   .min_vruntime                  : 255.575995
[11370.728225]   .max_vruntime                  : 0.000001
[11370.728892]   .spread                        : 0.000000
[11370.729402]   .spread0                       : -20300.743446
[11370.730020]   .nr_spread_over                : 0
[11370.730673]   .nr_running                    : 0
[11370.731239]   .load                          : 0
[11370.731861]   .runnable_weight               : 0
[11370.732367]   .load_avg                      : 70
[11370.733036]   .runnable_load_avg             : 0
[11370.733662]   .util_avg                      : 65
[11370.734212]   .util_est_enqueued             : 0
[11370.734807]   .removed.load_avg              : 0
[11370.735284]   .removed.util_avg              : 0
[11370.735839]   .removed.runnable_sum          : 0
[11370.736285]   .tg_load_avg_contrib           : 65
[11370.736871]   .tg_load_avg                   : 194
[11370.737353]   .throttled                     : 0
[11370.737899]   .throttle_count                : 0
[11370.738355]   .se->exec_start                : 11370725.999595
[11370.738909]   .se->vruntime                  : 16326.612447
[11370.739323]   .se->sum_exec_runtime          : 267.411746
[11370.739843]   .se->load.weight               : 320276
[11370.740307]   .se->runnable_weight           : 2
[11370.740825]   .se->avg.load_avg              : 16
[11370.741187]   .se->avg.util_avg              : 55
[11370.741589]   .se->avg.runnable_load_avg     : 0
[11370.741982] cfs_rq[9]:/autogroup-108
[11370.742307]   .exec_clock                    : 0.000000
[11370.742754]   .MIN_vruntime                  : 0.000001
[11370.743077]   .min_vruntime                  : 357.585583
[11370.743399]   .max_vruntime                  : 0.000001
[11370.743818]   .spread                        : 0.000000
[11370.744118]   .spread0                       : -20198.789487
[11370.744448]   .nr_spread_over                : 0
[11370.744836]   .nr_running                    : 0
[11370.745130]   .load                          : 0
[11370.745439]   .runnable_weight               : 0
[11370.745819]   .load_avg                      : 0
[11370.746107]   .runnable_load_avg             : 0
[11370.746392]   .util_avg                      : 0
[11370.746787]   .util_est_enqueued             : 0
[11370.747071]   .removed.load_avg              : 0
[11370.747352]   .removed.util_avg              : 0
[11370.747748]   .removed.runnable_sum          : 0
[11370.748020]   .tg_load_avg_contrib           : 0
[11370.748289]   .tg_load_avg                   : 0
[11370.748634]   .throttled                     : 0
[11370.748949]   .throttle_count                : 0
[11370.749215]   .se->exec_start                : 11370332.568084
[11370.749522]   .se->vruntime                  : 16292.733187
[11370.749867]   .se->sum_exec_runtime          : 142.634315
[11370.750140]   .se->load.weight               : 2
[11370.750471]   .se->runnable_weight           : 2
[11370.750841]   .se->avg.load_avg              : 0
[11370.751116]   .se->avg.util_avg              : 0
[11370.751387]   .se->avg.runnable_load_avg     : 0
[11370.751759] cfs_rq[9]:/
[11370.752023]   .exec_clock                    : 0.000000
[11370.752301]   .MIN_vruntime                  : 0.000001
[11370.752661]   .min_vruntime                  : 16326.612447
[11370.752987]   .max_vruntime                  : 0.000001
[11370.753268]   .spread                        : 0.000000
[11370.753596]   .spread0                       : -4229.787287
[11370.753953]   .nr_spread_over                : 0
[11370.754233]   .nr_running                    : 0
[11370.754554]   .load                          : 0
[11370.754915]   .runnable_weight               : 0
[11370.755225]   .load_avg                      : 12
[11370.755532]   .runnable_load_avg             : 0
[11370.755871]   .util_avg                      : 42
[11370.756141]   .util_est_enqueued             : 0
[11370.756429]   .removed.load_avg              : 0
[11370.756803]   .removed.util_avg              : 0
[11370.757070]   .removed.runnable_sum          : 0
[11370.757331]   .tg_load_avg_contrib           : 0
[11370.757649]   .tg_load_avg                   : 0
[11370.757964]   .throttled                     : 0
[11370.758219]   .throttle_count                : 0
[11370.758508] rt_rq[9]:/
[11370.758829]   .rt_nr_running                 : 0
[11370.759085]   .rt_nr_migratory               : 0
[11370.759338]   .rt_throttled                  : 0
[11370.759655]   .rt_time                       : 0.000000
[11370.759969]   .rt_runtime                    : 950.000000
[11370.760226] dl_rq[9]:
[11370.760533]   .dl_nr_running                 : 0
[11370.760862]   .dl_nr_migratory               : 0
[11370.761120]   .dl_bw->bw                     : 996147
[11370.761429]   .dl_bw->total_bw               : 0
[11370.761789] runnable tasks:
[11370.762044]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.762343] -----------------------------------------------------------------------------------------------------------
[11370.762777]  S        cpuhp/9    54     11408.938047        21   120         0.000000         1.052019         0.000000 0 0 /
[11370.763119]  S    migration/9    55       319.104352      2874     0         0.000000        37.209127         0.000000 0 0 /
[11370.763500]  S    ksoftirqd/9    56     15913.896688        82   120         0.000000         3.634311         0.000000 0 0 /
[11370.763933]  I   kworker/9:0H    58      1274.624063         8   100         0.000000         0.317532         0.000000 0 0 /
[11370.764296]  I          kstrp   252        23.182952         2   100         0.000000         0.109881         0.000000 0 0 /
[11370.764801]  S      scsi_eh_3   527     12144.763484        29   120         0.000000         1.139270         0.000000 0 0 /
[11370.765169]  I       kdmflush   667      1226.717386         2   100         0.000000         0.038298         0.000000 0 0 /
[11370.765588]  I   kworker/9:1H   771     16081.472472       179   100         0.000000         4.660369         0.000000 0 0 /
[11370.766020]  I        xprtiod  1481     11398.912498         2   100         0.000000         0.045412         0.000000 0 0 /
[11370.766402]  S     sedispatch  1677         5.408904       428   116         0.000000        26.578164         0.000000 0 0 /autogroup-62
[11370.767261]  S       gssproxy  1706        11.051812         2   120         0.000000         0.100397         0.000000 0 0 /autogroup-69
[11370.768175]  S         smartd  1715        23.609903        48   120         0.000000        50.579537         0.000000 0 0 /autogroup-74
[11370.769154]  S   rtkit-daemon  1722        15.689131        16   121         0.000000        24.626646         0.000000 0 0 /autogroup-79
[11370.770157]  S          gmain  1805        11.307430         5   120         0.000000         0.356015         0.000000 0 0 /autogroup-92
[11370.771226]  S          cupsd  2018        19.277720        63   120         0.000000        32.733207         0.000000 0 0 /autogroup-99
[11370.772348]  S           sshd  2019        21.577555        13   120         0.000000        24.135983         0.000000 0 0 /autogroup-100
[11370.773584]  S  rs:main Q:Reg  2040       255.575995      4658   120         0.000000       319.574283         0.000000 0 0 /autogroup-105
[11370.774865]  S          tuned  2252       357.585583     11516   120         0.000000       991.720272         0.000000 0 0 /autogroup-108
[11370.776140]  S         python  2169      1280.530777     23830   120         0.000000      1621.515456         0.000000 0 0 /autogroup-103
[11370.777541]  S       libvirtd  2056       396.690994      1457   120         0.000000       525.419552         0.000000 0 0 /autogroup-113
[11370.779000]  S         agetty  2071        -5.948417         3   120         0.000000         7.319814         0.000000 0 0 /autogroup-127
[11370.780533]  S           qmgr  2324        -1.220584        68   120         0.000000        21.337724         0.000000 0 0 /autogroup-122
[11370.782105]  I    kworker/9:1  4058     15234.998734       398   120         0.000000        19.489441         0.000000 0 0 /
[11370.783002]  I   mlx5_hv_vhca  4808     14310.928050         2   100         0.000000         0.021178         0.000000 0 0 /
[11370.783911]  I    kworker/9:2  5963     16279.196886        77   120         0.000000         1.567562         0.000000 0 0 /
[11370.784791]  D       iscsi_np  6061     16077.575226        33   120         0.000000         7.231336         0.000000 0 0 /
[11370.785606]  S      iscsi_trx  6423     15813.737627         3   120         0.000000         0.030947         0.000000 0 0 /
[11370.786483] cpu#10, 2095.168 MHz
[11370.787474]   .nr_running                    : 0
[11370.788487]   .nr_switches                   : 108466
[11370.789490]   .nr_load_updates               : 0
[11370.790458]   .nr_uninterruptible            : 0
[11370.791453]   .next_balance                  : 4306.037721
[11370.792449]   .curr->pid                     : 0
[11370.793390]   .clock                         : 11370792.445142
[11370.794351]   .clock_task                    : 11370793.438027
[11370.795321]   .avg_idle                      : 1000000
[11370.796262]   .max_idle_balance_cost         : 500000
[11370.797226] rt_rq[10]:/
[11370.798141]   .rt_nr_running                 : 0
[11370.798959]   .rt_nr_migratory               : 0
[11370.799763]   .rt_throttled                  : 0
[11370.800512]   .rt_time                       : 0.000000
[11370.801258]   .rt_runtime                    : 950.000000
[11370.802043] dl_rq[10]:
[11370.802794]   .dl_nr_running                 : 0
[11370.803456]   .dl_nr_migratory               : 0
[11370.804167]   .dl_bw->bw                     : 996147
[11370.804920]   .dl_bw->total_bw               : 0
[11370.805566] runnable tasks:
[11370.806210]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.806937] -----------------------------------------------------------------------------------------------------------
[11370.807665]  S       cpuhp/10    59     10782.359266        21   120         0.000000         1.116559         0.000000 0 0 /
[11370.808398]  S   migration/10    60       375.104410      2880     0         0.000000        38.064077         0.000000 0 0 /
[11370.809146]  S   ksoftirqd/10    61     17767.266299       197   120         0.000000        17.094352         0.000000 0 0 /
[11370.809878]  I  kworker/10:0H    63      3393.948181         8   100         0.000000         0.115273         0.000000 0 0 /
[11370.810569]  I       ttm_swap   554      3105.011309         2   100         0.000000         0.072022         0.000000 0 0 /
[11370.811253]  I  kworker/10:1H   652     17913.172163        72   100         0.000000         1.543478         0.000000 0 0 /
[11370.811946]  I       ib_mcast  1317      7913.660858         2   100         0.000000         0.022970         0.000000 0 0 /
[11370.812642]  I         rpciod  1479     10767.251652         2   100         0.000000         0.036156         0.000000 0 0 /
[11370.813260]  I       xcopy_wq  1593     10821.345147         2   100         0.000000         0.042817         0.000000 0 0 /
[11370.813939]  S         auditd  1674         6.700899       584   116         0.000000        49.027536         0.000000 0 0 /autogroup-61
[11370.815132]  S          gdbus  1770        50.109965       939   120         0.000000       126.203791         0.000000 0 0 /autogroup-85
[11370.816336]  S abrt-watch-log  1747        65.903893       341   120         0.000000        53.590825         0.000000 0 0 /autogroup-90
[11370.817565]  S         python  2171      1035.668270     25949   120         0.000000      1726.646769         0.000000 0 0 /autogroup-103
[11370.818777]  S         master  2322         7.763075       655   120         0.000000        68.037606         0.000000 0 0 /autogroup-122
[11370.819953]  I   kworker/10:1  3148     17936.255205       547   120         0.000000        34.518038         0.000000 0 0 /
[11370.820590]  I   kworker/10:2  4111     14428.215118         3   120         0.000000         0.026883         0.000000 0 0 /
[11370.821215]  I mlx5_fw_tracer  4816     15160.096327         2   100         0.000000         0.025219         0.000000 0 0 /
[11370.821893]  I  kworker/u32:1  5542     17920.107834      2302   120         0.000000        50.361439         0.000000 0 0 /
[11370.822480]  S      iscsi_trx  6429     17806.734902         3   120         0.000000         0.097620         0.000000 0 0 /
[11370.823144] cpu#11, 2095.168 MHz
[11370.823977]   .nr_running                    : 1
[11370.824831]   .nr_switches                   : 158681
[11370.825536]   .nr_load_updates               : 0
[11370.826281]   .nr_uninterruptible            : -6
[11370.826985]   .next_balance                  : 4306.037758
[11370.827837]   .curr->pid                     : 0
[11370.828614]   .clock                         : 11370828.434806
[11370.829351]   .clock_task                    : 11370828.434806
[11370.830058]   .avg_idle                      : 514311
[11370.830864]   .max_idle_balance_cost         : 500000
[11370.831659] cfs_rq[11]:/autogroup-105
[11370.832323]   .exec_clock                    : 0.000000
[11370.833033]   .MIN_vruntime                  : 0.000001
[11370.833698]   .min_vruntime                  : 122.042037
[11370.834306]   .max_vruntime                  : 0.000001
[11370.834974]   .spread                        : 0.000000
[11370.835678]   .spread0                       : -20434.714171
[11370.836280]   .nr_spread_over                : 0
[11370.836971]   .nr_running                    : 0
[11370.837570]   .load                          : 0
[11370.838182]   .runnable_weight               : 0
[11370.838820]   .load_avg                      : 127
[11370.839395]   .runnable_load_avg             : 0
[11370.840003]   .util_avg                      : 116
[11370.840635]   .util_est_enqueued             : 0
[11370.841177]   .removed.load_avg              : 0
[11370.841779]   .removed.util_avg              : 0
[11370.842257]   .removed.runnable_sum          : 0
[11370.842844]   .tg_load_avg_contrib           : 116
[11370.843310]   .tg_load_avg                   : 167
[11370.843891]   .throttled                     : 0
[11370.844349]   .throttle_count                : 0
[11370.844938]   .se->exec_start                : 11370831.059989
[11370.845383]   .se->vruntime                  : 16487.716823
[11370.845923]   .se->sum_exec_runtime          : 111.090620
[11370.846344]   .se->load.weight               : 725529
[11370.846869]   .se->runnable_weight           : 2
[11370.847261]   .se->avg.load_avg              : 72
[11370.847760]   .se->avg.util_avg              : 105
[11370.848124]   .se->avg.runnable_load_avg     : 0
[11370.848534] cfs_rq[11]:/autogroup-103
[11370.848939]   .exec_clock                    : 0.000000
[11370.849272]   .MIN_vruntime                  : 0.000001
[11370.849665]   .min_vruntime                  : 1390.843561
[11370.850050]   .max_vruntime                  : 0.000001
[11370.850366]   .spread                        : 0.000000
[11370.850794]   .spread0                       : -19166.013210
[11370.851093]   .nr_spread_over                : 0
[11370.851389]   .nr_running                    : 0
[11370.851793]   .load                          : 0
[11370.852086]   .runnable_weight               : 0
[11370.852376]   .load_avg                      : 0
[11370.852794]   .runnable_load_avg             : 0
[11370.853081]   .util_avg                      : 0
[11370.853367]   .util_est_enqueued             : 0
[11370.853752]   .removed.load_avg              : 0
[11370.854035]   .removed.util_avg              : 0
[11370.854314]   .removed.runnable_sum          : 0
[11370.854651]   .tg_load_avg_contrib           : 0
[11370.855020]   .tg_load_avg                   : 0
[11370.855330]   .throttled                     : 0
[11370.855662]   .throttle_count                : 0
[11370.855988]   .se->exec_start                : 11370740.036752
[11370.856263]   .se->vruntime                  : 16465.125738
[11370.856613]   .se->sum_exec_runtime          : 2100.846826
[11370.856938]   .se->load.weight               : 2
[11370.857213]   .se->runnable_weight           : 2
[11370.857525]   .se->avg.load_avg              : 0
[11370.857867]   .se->avg.util_avg              : 0
[11370.858141]   .se->avg.runnable_load_avg     : 0
[11370.858433] cfs_rq[11]:/
[11370.858788]   .exec_clock                    : 0.000000
[11370.859067]   .MIN_vruntime                  : 0.000001
[11370.859344]   .min_vruntime                  : 16487.716823
[11370.859727]   .max_vruntime                  : 0.000001
[11370.860008]   .spread                        : 0.000000
[11370.860287]   .spread0                       : -4069.165234
[11370.860650]   .nr_spread_over                : 0
[11370.860977]   .nr_running                    : 0
[11370.861257]   .load                          : 0
[11370.861610]   .runnable_weight               : 0
[11370.861951]   .load_avg                      : 52
[11370.862225]   .runnable_load_avg             : 0
[11370.862534]   .util_avg                      : 75
[11370.862875]   .util_est_enqueued             : 0
[11370.863144]   .removed.load_avg              : 0
[11370.863433]   .removed.util_avg              : 0
[11370.863784]   .removed.runnable_sum          : 0
[11370.864047]   .tg_load_avg_contrib           : 0
[11370.864307]   .tg_load_avg                   : 0
[11370.864645]   .throttled                     : 0
[11370.864949]   .throttle_count                : 0
[11370.865207] rt_rq[11]:/
[11370.865484]   .rt_nr_running                 : 0
[11370.865819]   .rt_nr_migratory               : 0
[11370.866073]   .rt_throttled                  : 0
[11370.866327]   .rt_time                       : 0.000000
[11370.866644]   .rt_runtime                    : 950.000000
[11370.866965] dl_rq[11]:
[11370.867214]   .dl_nr_running                 : 0
[11370.867506]   .dl_nr_migratory               : 0
[11370.867838]   .dl_bw->bw                     : 996147
[11370.868098]   .dl_bw->total_bw               : 0
[11370.868358] runnable tasks:
[11370.868739]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.869053] -----------------------------------------------------------------------------------------------------------
[11370.869370]  S       cpuhp/11    64      9486.876698        21   120         0.000000         1.046562         0.000000 0 0 /
[11370.869830]  S   migration/11    65         0.000000      2864     0         0.000000        35.900009         0.000000 0 0 /
[11370.870179]  S   ksoftirqd/11    66     16325.796130       309   120         0.000000        12.917791         0.000000 0 0 /
[11370.870583]  I  kworker/11:0H    68      3618.824697         8   100         0.000000         0.361939         0.000000 0 0 /
[11370.871000]  I   kworker/11:1   117     13552.894443        58   120         0.000000         1.245331         0.000000 0 0 /
[11370.871365]  I    kintegrityd   204       108.085528         2   100         0.000000         0.000000         0.000000 0 0 /
[11370.871843]  I       kdmflush   656      3531.929484         2   100         0.000000         0.041808         0.000000 0 0 /
[11370.872214]  I  kworker/11:1H   798     13047.968694        94   100         0.000000         2.132186         0.000000 0 0 /
[11370.872678]  S     multipathd   833         0.000000        13     0         0.000000         8.592059         0.000000 0 0 /autogroup-44
[11370.873515]  I    ib_nl_sa_wq  1318      6675.566306         2   100         0.000000         0.030391         0.000000 0 0 /
[11370.874001]  Itarget_completi  1591      9590.581969         2   100         0.000000         0.043067         0.000000 0 0 /
[11370.874432]  I       kdmflush  1619      9602.619733         2   100         0.000000         0.047926         0.000000 0 0 /
[11370.874938]  S       gssproxy  1705         0.983278         2   120         0.000000         0.130464         0.000000 0 0 /autogroup-69
[11370.875854]  S   rtkit-daemon  1772         0.298784      1711   120         0.000000        95.094598         0.000000 0 0 /autogroup-79
[11370.876846]  S        polkitd  1737        17.367893       955   120         0.000000       107.666282         0.000000 0 0 /autogroup-85
[11370.877869]  S   in:imjournal  2037       122.042037     16511   120         0.000000      1310.915400         0.000000 0 0 /autogroup-105
[11370.878955]  S         python  2173      1390.843561     23065   120         0.000000      1588.893711         0.000000 0 0 /autogroup-103
[11370.880103]  S         python  2175      1390.765555     22669   120         0.000000      1550.817360         0.000000 0 0 /autogroup-103
[11370.881325]  S       libvirtd  2196       323.740462       403   120         0.000000        57.619159         0.000000 0 0 /autogroup-113
[11370.882643]  I   kworker/11:0  4628     16391.744827      1977   120         0.000000       685.555315         0.000000 0 0 /
[11370.883315]  I       iw_cxgb4  4666     12946.046361         2   100         0.000000         0.021802         0.000000 0 0 /
[11370.884046]  Imlx5_cmd_0000:0  4804     13072.004985         2   100         0.000000         0.026291         0.000000 0 0 /
[11370.884804]  I     mlx5e_arfs  4821     13090.277025         2   100         0.000000         0.027058         0.000000 0 0 /
[11370.885465]  I  kworker/u33:1  5957     15065.004556         2   100         0.000000         0.057958         0.000000 0 0 /
[11370.886199]  S           sshd  6446       108.904738       313   120         0.000000       110.531261         0.000000 0 0 /autogroup-174
[11370.887694] cpu#12, 2095.168 MHz
[11370.888649]   .nr_running                    : 0
[11370.889499]   .nr_switches                   : 61952
[11370.890368]   .nr_load_updates               : 0
[11370.891221]   .nr_uninterruptible            : -1
[11370.892119]   .next_balance                  : 4306.037821
[11370.893022]   .curr->pid                     : 0
[11370.894010]   .clock                         : 11370893.436271
[11370.894942]   .clock_task                    : 11370894.438260
[11370.895854]   .avg_idle                      : 1000000
[11370.896861]   .max_idle_balance_cost         : 500000
[11370.897865] cfs_rq[12]:/autogroup-103
[11370.898845]   .exec_clock                    : 0.000000
[11370.899558]   .MIN_vruntime                  : 0.000001
[11370.900274]   .min_vruntime                  : 431.435150
[11370.901033]   .max_vruntime                  : 0.000001
[11370.901767]   .spread                        : 0.000000
[11370.902382]   .spread0                       : -20125.602612
[11370.903092]   .nr_spread_over                : 0
[11370.903809]   .nr_running                    : 0
[11370.904387]   .load                          : 0
[11370.905085]   .runnable_weight               : 0
[11370.905749]   .load_avg                      : 0
[11370.906299]   .runnable_load_avg             : 0
[11370.906936]   .util_avg                      : 0
[11370.907499]   .util_est_enqueued             : 0
[11370.908098]   .removed.load_avg              : 0
[11370.908766]   .removed.util_avg              : 0
[11370.909274]   .removed.runnable_sum          : 0
[11370.909906]   .tg_load_avg_contrib           : 0
[11370.910461]   .tg_load_avg                   : 0
[11370.911004]   .throttled                     : 0
[11370.911531]   .throttle_count                : 0
[11370.912067]   .se->exec_start                : 11370824.485363
[11370.912592]   .se->vruntime                  : 12628.512605
[11370.913077]   .se->sum_exec_runtime          : 419.950071
[11370.913554]   .se->load.weight               : 2
[11370.914036]   .se->runnable_weight           : 2
[11370.914514]   .se->avg.load_avg              : 0
[11370.914954]   .se->avg.util_avg              : 0
[11370.915336]   .se->avg.runnable_load_avg     : 0
[11370.915795] cfs_rq[12]:/
[11370.916162]   .exec_clock                    : 0.000000
[11370.916586]   .MIN_vruntime                  : 0.000001
[11370.917012]   .min_vruntime                  : 12628.512605
[11370.917356]   .max_vruntime                  : 0.000001
[11370.917762]   .spread                        : 0.000000
[11370.918087]   .spread0                       : -7928.590246
[11370.918435]   .nr_spread_over                : 0
[11370.918804]   .nr_running                    : 0
[11370.919087]   .load                          : 0
[11370.919368]   .runnable_weight               : 0
[11370.919767]   .load_avg                      : 2
[11370.920045]   .runnable_load_avg             : 0
[11370.920323]   .util_avg                      : 2
[11370.920687]   .util_est_enqueued             : 0
[11370.921024]   .removed.load_avg              : 0
[11370.921299]   .removed.util_avg              : 0
[11370.921624]   .removed.runnable_sum          : 0
[11370.921937]   .tg_load_avg_contrib           : 0
[11370.922198]   .tg_load_avg                   : 0
[11370.922486]   .throttled                     : 0
[11370.922838]   .throttle_count                : 0
[11370.923097] rt_rq[12]:/
[11370.923347]   .rt_nr_running                 : 0
[11370.923689]   .rt_nr_migratory               : 0
[11370.923961]   .rt_throttled                  : 0
[11370.924216]   .rt_time                       : 0.000000
[11370.924531]   .rt_runtime                    : 950.000000
[11370.924861] dl_rq[12]:
[11370.925112]   .dl_nr_running                 : 0
[11370.925371]   .dl_nr_migratory               : 0
[11370.925730]   .dl_bw->bw                     : 996147
[11370.925992]   .dl_bw->total_bw               : 0
[11370.926251] runnable tasks:
[11370.926547]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.926917] -----------------------------------------------------------------------------------------------------------
[11370.927235]  S       cpuhp/12    69      7585.250846        21   120         0.000000         1.200253         0.000000 0 0 /
[11370.927634]  S   migration/12    70       487.127987      2893     0         0.000000        34.563487         0.000000 0 0 /
[11370.928034]  S   ksoftirqd/12    71     12616.444653        78   120         0.000000         3.848771         0.000000 0 0 /
[11370.928392]  I  kworker/12:0H    73      2483.942623         8   100         0.000000         0.889496         0.000000 0 0 /
[11370.928880]  I  kworker/12:1H   688     12235.701100       116   100         0.000000         2.286724         0.000000 0 0 /
[11370.929244]  S     multipathd   832        14.676017         5   120         0.000000         2.558474         0.000000 0 0 /autogroup-44
[11370.930060]  I     ib-comp-wq  1314      5767.761185         2   100         0.000000         0.029213         0.000000 0 0 /
[11370.930480]  S       gssproxy  1704        10.992942         4   120         0.000000        12.355919         0.000000 0 0 /autogroup-69
[11370.931320]  S        polkitd  1777        -7.441886        10   120         0.000000         0.426983         0.000000 0 0 /autogroup-85
[11370.932253]  S       ksmtuned  1789      1870.272753       947   120         0.000000       282.100676         0.000000 0 0 /autogroup-95
[11370.933243]  S         python  2170       431.435150     25849   120         0.000000      1704.122159         0.000000 0 0 /autogroup-103
[11370.934266]  S         python  2174       427.423554     23677   120         0.000000      1604.102516         0.000000 0 0 /autogroup-103
[11370.935348]  S       libvirtd  2130        10.972035         1   120         0.000000         0.020618         0.000000 0 0 /autogroup-113
[11370.936557]  S        dnsmasq  2437        44.052824        29   120         0.000000        59.708289         0.000000 0 0 /autogroup-123
[11370.937811]  I   kworker/12:0  3092     12627.671971      3959   120         0.000000      1092.851247         0.000000 0 0 /
[11370.938400]  I   kworker/12:1  5349     11695.571830         2   120         0.000000         0.017154         0.000000 0 0 /
[11370.939092]  S           sshd  6448        44.270674        29   120         0.000000        61.347985         0.000000 0 0 /autogroup-175
[11370.940380] cpu#13, 2095.168 MHz
[11370.941222]   .nr_running                    : 0
[11370.942043]   .nr_switches                   : 125491
[11370.942924]   .nr_load_updates               : 0
[11370.943797]   .nr_uninterruptible            : -11
[11370.944579]   .next_balance                  : 4306.037876
[11370.945394]   .curr->pid                     : 0
[11370.946174]   .clock                         : 11370944.451154
[11370.947048]   .clock_task                    : 11370946.176185
[11370.947937]   .avg_idle                      : 1000000
[11370.948813]   .max_idle_balance_cost         : 500000
[11370.949685] cfs_rq[13]:/autogroup-72
[11370.950507]   .exec_clock                    : 0.000000
[11370.951257]   .MIN_vruntime                  : 0.000001
[11370.952029]   .min_vruntime                  : 535.291293
[11370.952798]   .max_vruntime                  : 0.000001
[11370.953479]   .spread                        : 0.000000
[11370.954187]   .spread0                       : -20021.944160
[11370.954932]   .nr_spread_over                : 0
[11370.955673]   .nr_running                    : 0
[11370.956312]   .load                          : 0
[11370.957023]   .runnable_weight               : 0
[11370.957644]   .load_avg                      : 2
[11370.958262]   .runnable_load_avg             : 0
[11370.958912]   .util_avg                      : 2
[11370.959481]   .util_est_enqueued             : 0
[11370.960112]   .removed.load_avg              : 0
[11370.960814]   .removed.util_avg              : 0
[11370.961376]   .removed.runnable_sum          : 0
[11370.961987]   .tg_load_avg_contrib           : 2
[11370.962578]   .tg_load_avg                   : 2
[11370.963160]   .throttled                     : 0
[11370.963748]   .throttle_count                : 0
[11370.964203]   .se->exec_start                : 11370947.302288
[11370.964797]   .se->vruntime                  : 17507.116177
[11370.965231]   .se->sum_exec_runtime          : 536.339869
[11370.965755]   .se->load.weight               : 1048576
[11370.966164]   .se->runnable_weight           : 2
[11370.966613]   .se->avg.load_avg              : 1
[11370.967047]   .se->avg.util_avg              : 2
[11370.967431]   .se->avg.runnable_load_avg     : 0
[11370.967872] cfs_rq[13]:/
[11370.968209]   .exec_clock                    : 0.000000
[11370.968621]   .MIN_vruntime                  : 0.000001
[11370.968989]   .min_vruntime                  : 17507.116177
[11370.969306]   .max_vruntime                  : 0.000001
[11370.969753]   .spread                        : 0.000000
[11370.970047]   .spread0                       : -3050.185829
[11370.970340]   .nr_spread_over                : 0
[11370.970731]   .nr_running                    : 0
[11370.971020]   .load                          : 0
[11370.971308]   .runnable_weight               : 0
[11370.971658]   .load_avg                      : 2
[11370.971999]   .runnable_load_avg             : 0
[11370.972281]   .util_avg                      : 1
[11370.972643]   .util_est_enqueued             : 0
[11370.972971]   .removed.load_avg              : 0
[11370.973251]   .removed.util_avg              : 0
[11370.973571]   .removed.runnable_sum          : 0
[11370.973903]   .tg_load_avg_contrib           : 0
[11370.974171]   .tg_load_avg                   : 0
[11370.974462]   .throttled                     : 0
[11370.974812]   .throttle_count                : 0
[11370.975078] rt_rq[13]:/
[11370.975334]   .rt_nr_running                 : 0
[11370.975663]   .rt_nr_migratory               : 0
[11370.975968]   .rt_throttled                  : 0
[11370.976231]   .rt_time                       : 0.000000
[11370.976557]   .rt_runtime                    : 950.000000
[11370.976890] dl_rq[13]:
[11370.977148]   .dl_nr_running                 : 0
[11370.977431]   .dl_nr_migratory               : 0
[11370.977779]   .dl_bw->bw                     : 996147
[11370.978045]   .dl_bw->total_bw               : 0
[11370.978309] runnable tasks:
[11370.978625]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11370.978979] -----------------------------------------------------------------------------------------------------------
[11370.979299]  S        systemd     1       241.944596      3715   120         0.000000      5026.124029         0.000000 0 0 /autogroup-1
[11370.980078]  S       cpuhp/13    74      8530.894471        21   120         0.000000         1.199176         0.000000 0 0 /
[11370.980506]  S   migration/13    75       543.128025      2909     0         0.000000        34.581716         0.000000 0 0 /
[11370.980960]  S   ksoftirqd/13    76     17146.928537        94   120         0.000000         6.500149         0.000000 0 0 /
[11370.981342]  I  kworker/13:0H    78      1277.122832         8   100         0.000000         0.856494         0.000000 0 0 /
[11370.981830]  Iacpi_thermal_pm   243       146.080069         2   100         0.000000         0.025931         0.000000 0 0 /
[11370.982220]  I   kworker/13:2   305     17478.704738       463   120         0.000000        84.109970         0.000000 0 0 /
[11370.982702]  I  kworker/13:1H   751     17309.354334        68   100         0.000000         1.466901         0.000000 0 0 /
[11370.983134]  Iext4-rsv-conver  1580      8582.944588         2   100         0.000000         0.069278         0.000000 0 0 /
[11370.983593]  Iext4-rsv-conver  1651      8601.863975         2   100         0.000000         0.074817         0.000000 0 0 /
[11370.984060]  S       gssproxy  1708        11.019845         2   120         0.000000         0.068430         0.000000 0 0 /autogroup-69
[11370.984974]  S           rngd  1713       535.328296    242074   120         0.000000      3678.182202         0.000000 0 0 /autogroup-72
[11370.985904]  S   JS GC Helper  1771        13.296469         2   120         0.000000         0.247575         0.000000 0 0 /autogroup-85
[11370.986909]  S      rhsmcertd  2047         1.200560         3   120         0.000000         2.493678         0.000000 0 0 /autogroup-109
[11370.987964]  S         pickup  4201        13.778954        89   120         0.000000        26.299931         0.000000 0 0 /autogroup-122
[11370.989094]  Imlx5_health0000  4802     11952.350266         2   100         0.000000         0.074174         0.000000 0 0 /
[11370.989757]  I    mlx5_esw_wq  4815     11964.404984         2   100         0.000000         0.060134         0.000000 0 0 /
[11370.990305]  I   kworker/13:3  5432     15441.196840         3   120         0.000000         0.053227         0.000000 0 0 /
[11370.990984] cpu#14, 2095.168 MHz
[11370.991807]   .nr_running                    : 1
[11370.992585]   .nr_switches                   : 160860
[11370.993286]   .nr_load_updates               : 0
[11370.994024]   .nr_uninterruptible            : 9
[11370.994863]   .next_balance                  : 4306.037921
[11370.995721]   .curr->pid                     : 0
[11370.996550]   .clock                         : 11370996.457633
[11370.997249]   .clock_task                    : 11370996.457633
[11370.998003]   .avg_idle                      : 947163
[11370.998855]   .max_idle_balance_cost         : 500000
[11370.999714] cfs_rq[14]:/autogroup-152
[11371.000503]   .exec_clock                    : 0.000000
[11371.001178]   .MIN_vruntime                  : 0.000001
[11371.001868]   .min_vruntime                  : 388.682115
[11371.002519]   .max_vruntime                  : 0.000001
[11371.003157]   .spread                        : 0.000000
[11371.003839]   .spread0                       : -20168.764580
[11371.004427]   .nr_spread_over                : 0
[11371.005097]   .nr_running                    : 0
[11371.005778]   .load                          : 0
[11371.006340]   .runnable_weight               : 0
[11371.007003]   .load_avg                      : 64
[11371.007628]   .runnable_load_avg             : 0
[11371.008202]   .util_avg                      : 64
[11371.008876]   .util_est_enqueued             : 0
[11371.009364]   .removed.load_avg              : 0
[11371.009954]   .removed.util_avg              : 0
[11371.010449]   .removed.runnable_sum          : 0
[11371.011001]   .tg_load_avg_contrib           : 59
[11371.011534]   .tg_load_avg                   : 59
[11371.012069]   .throttled                     : 0
[11371.012631]   .throttle_count                : 0
[11371.013170]   .se->exec_start                : 11370999.882166
[11371.013698]   .se->vruntime                  : 18959.901131
[11371.014155]   .se->sum_exec_runtime          : 389.730691
[11371.014700]   .se->load.weight               : 1048576
[11371.015195]   .se->runnable_weight           : 2
[11371.015703]   .se->avg.load_avg              : 54
[11371.016122]   .se->avg.util_avg              : 54
[11371.016583]   .se->avg.runnable_load_avg     : 0
[11371.017017] cfs_rq[14]:/
[11371.017361]   .exec_clock                    : 0.000000
[11371.017804]   .MIN_vruntime                  : 0.000001
[11371.018132]   .min_vruntime                  : 18959.901131
[11371.018505]   .max_vruntime                  : 0.000001
[11371.018885]   .spread                        : 0.000000
[11371.019188]   .spread0                       : -1597.615127
[11371.019548]   .nr_spread_over                : 0
[11371.019913]   .nr_running                    : 0
[11371.020200]   .load                          : 0
[11371.020547]   .runnable_weight               : 0
[11371.020900]   .load_avg                      : 46
[11371.021181]   .runnable_load_avg             : 0
[11371.021493]   .util_avg                      : 46
[11371.021852]   .util_est_enqueued             : 0
[11371.022136]   .removed.load_avg              : 0
[11371.022434]   .removed.util_avg              : 0
[11371.022796]   .removed.runnable_sum          : 0
[11371.023069]   .tg_load_avg_contrib           : 0
[11371.023336]   .tg_load_avg                   : 0
[11371.023667]   .throttled                     : 0
[11371.023983]   .throttle_count                : 0
[11371.024249] rt_rq[14]:/
[11371.024569]   .rt_nr_running                 : 0
[11371.024898]   .rt_nr_migratory               : 0
[11371.025158]   .rt_throttled                  : 0
[11371.025439]   .rt_time                       : 0.000000
[11371.025792]   .rt_runtime                    : 950.000000
[11371.026059] dl_rq[14]:
[11371.026316]   .dl_nr_running                 : 0
[11371.026641]   .dl_nr_migratory               : 0
[11371.026950]   .dl_bw->bw                     : 996147
[11371.027215]   .dl_bw->total_bw               : 0
[11371.027511] runnable tasks:
[11371.027842]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11371.028145] -----------------------------------------------------------------------------------------------------------
[11371.028522]  S       cpuhp/14    79      7757.307848        21   120         0.000000         1.058348         0.000000 0 0 /
[11371.028942]  S   migration/14    80       599.138237      2880     0         0.000000        35.935918         0.000000 0 0 /
[11371.029340]  S   ksoftirqd/14    81     18292.496396       203   120         0.000000        12.523436         0.000000 0 0 /
[11371.029801]  I  kworker/14:0H    83      2183.842565         8   100         0.000000         0.867054         0.000000 0 0 /
[11371.030166]  S      watchdogd   212        11.999994         2     0         0.000000         0.000000         0.000000 0 0 /
[11371.030583]  S      scsi_eh_1   522     12276.791145        29   120         0.000000         1.037008         0.000000 0 0 /
[11371.031015]  I     scsi_tmf_2   526       909.983453         2   100         0.000000         0.039708         0.000000 0 0 /
[11371.031391]  I     scsi_tmf_3   528       921.832656         2   100         0.000000         0.024755         0.000000 0 0 /
[11371.031873]  I  kworker/14:1H   769     17465.456859       228   100         0.000000         4.916517         0.000000 0 0 /
[11371.032254]  S    jbd2/sda1-8  1579     12362.897265         6   120         0.000000         0.410975         0.000000 0 0 /
[11371.032792]  S         auditd  1675         0.458863        27   116         0.000000         2.703557         0.000000 0 0 /autogroup-61
[11371.033598]  S        audispd  1678         1.868281       940   112         0.000000        34.385201         0.000000 0 0 /autogroup-62
[11371.034480]  S        alsactl  1716       199.082224        78   139         0.000000        15.685347         0.000000 0 0 /autogroup-75
[11371.035430]  SJS Sour~ Thread  1774        -1.717122        11   120         0.000000         0.316581         0.000000 0 0 /autogroup-85
[11371.036476]  S          crond  2069        54.606081       227   120         0.000000        41.957886         0.000000 0 0 /autogroup-118
[11371.037565]  S           sshd  4524       388.682115     16533   120         0.000000      1375.831435         0.000000 0 0 /autogroup-152
[11371.038752]  S           bash  4527      3347.360988       317   120         0.000000       159.429331         0.000000 0 0 /autogroup-154
[11371.039931]  I          cxgb4  4657     13518.241259         2   100         0.000000         0.031801         0.000000 0 0 /
[11371.040577]  I   kworker/14:2  5058     18896.585672       144   120         0.000000        39.162269         0.000000 0 0 /
[11371.041224]  I   kworker/14:3  5059     14742.597317         2   120         0.000000         0.046233         0.000000 0 0 /
[11371.041933] cpu#15, 2095.168 MHz
[11371.042799]   .nr_running                    : 0
[11371.043578]   .nr_switches                   : 113372
[11371.044334]   .nr_load_updates               : 0
[11371.045144]   .nr_uninterruptible            : -4
[11371.046008]   .next_balance                  : 4306.037974
[11371.046908]   .curr->pid                     : 0
[11371.047810]   .clock                         : 11371046.913751
[11371.048628]   .clock_task                    : 11371046.913751
[11371.049470]   .avg_idle                      : 1000000
[11371.050220]   .max_idle_balance_cost         : 500000
[11371.050964] cfs_rq[15]:/autogroup-71
[11371.051857]   .exec_clock                    : 0.000000
[11371.052541]   .MIN_vruntime                  : 0.000001
[11371.053208]   .min_vruntime                  : 14.343093
[11371.053924]   .max_vruntime                  : 0.000001
[11371.054565]   .spread                        : 0.000000
[11371.055225]   .spread0                       : -20543.305881
[11371.055969]   .nr_spread_over                : 0
[11371.056685]   .nr_running                    : 0
[11371.057290]   .load                          : 0
[11371.057971]   .runnable_weight               : 0
[11371.058607]   .load_avg                      : 0
[11371.059187]   .runnable_load_avg             : 0
[11371.059831]   .util_avg                      : 0
[11371.060348]   .util_est_enqueued             : 0
[11371.060989]   .removed.load_avg              : 0
[11371.061533]   .removed.util_avg              : 0
[11371.062102]   .removed.runnable_sum          : 0
[11371.062766]   .tg_load_avg_contrib           : 0
[11371.063257]   .tg_load_avg                   : 0
[11371.063874]   .throttled                     : 0
[11371.064387]   .throttle_count                : 0
[11371.064963]   .se->exec_start                : 11371055.233115
[11371.065476]   .se->vruntime                  : 14483.485634
[11371.065992]   .se->sum_exec_runtime          : 4.039019
[11371.066433]   .se->load.weight               : 2
[11371.066926]   .se->runnable_weight           : 2
[11371.067320]   .se->avg.load_avg              : 0
[11371.067819]   .se->avg.util_avg              : 0
[11371.068184]   .se->avg.runnable_load_avg     : 0
[11371.068609] cfs_rq[15]:/autogroup-102
[11371.068998]   .exec_clock                    : 0.000000
[11371.069332]   .MIN_vruntime                  : 0.000001
[11371.069770]   .min_vruntime                  : 482.835448
[11371.070078]   .max_vruntime                  : 0.000001
[11371.070430]   .spread                        : 0.000000
[11371.070826]   .spread0                       : -20074.897611
[11371.071110]   .nr_spread_over                : 0
[11371.071392]   .nr_running                    : 0
[11371.071772]   .load                          : 0
[11371.072050]   .runnable_weight               : 0
[11371.072327]   .load_avg                      : 0
[11371.072690]   .runnable_load_avg             : 0
[11371.073028]   .util_avg                      : 0
[11371.073300]   .util_est_enqueued             : 0
[11371.073629]   .removed.load_avg              : 0
[11371.073945]   .removed.util_avg              : 0
[11371.074210]   .removed.runnable_sum          : 0
[11371.074503]   .tg_load_avg_contrib           : 0
[11371.074837]   .tg_load_avg                   : 0
[11371.075095]   .throttled                     : 0
[11371.075351]   .throttle_count                : 0
[11371.075690]   .se->exec_start                : 11370585.131036
[11371.075969]   .se->vruntime                  : 14490.908410
[11371.076233]   .se->sum_exec_runtime          : 483.884024
[11371.076558]   .se->load.weight               : 2
[11371.076886]   .se->runnable_weight           : 2
[11371.077151]   .se->avg.load_avg              : 0
[11371.077436]   .se->avg.util_avg              : 0
[11371.077786]   .se->avg.runnable_load_avg     : 0
[11371.078050] cfs_rq[15]:/autogroup-103
[11371.078312]   .exec_clock                    : 0.000000
[11371.078647]   .MIN_vruntime                  : 0.000001
[11371.078978]   .min_vruntime                  : 1031.589693
[11371.079254]   .max_vruntime                  : 0.000001
[11371.079575]   .spread                        : 0.000000
[11371.079911]   .spread0                       : -19526.169145
[11371.080187]   .nr_spread_over                : 0
[11371.080518]   .nr_running                    : 0
[11371.080869]   .load                          : 0
[11371.081144]   .runnable_weight               : 0
[11371.081432]   .load_avg                      : 0
[11371.081784]   .runnable_load_avg             : 0
[11371.082051]   .util_avg                      : 0
[11371.082317]   .util_est_enqueued             : 0
[11371.082643]   .removed.load_avg              : 0
[11371.082958]   .removed.util_avg              : 0
[11371.083224]   .removed.runnable_sum          : 0
[11371.083521]   .tg_load_avg_contrib           : 0
[11371.083852]   .tg_load_avg                   : 0
[11371.084107]   .throttled                     : 0
[11371.084363]   .throttle_count                : 0
[11371.084744]   .se->exec_start                : 11370753.588086
[11371.085021]   .se->vruntime                  : 14491.267682
[11371.085283]   .se->sum_exec_runtime          : 1032.638269
[11371.085597]   .se->load.weight               : 2
[11371.085934]   .se->runnable_weight           : 2
[11371.086199]   .se->avg.load_avg              : 0
[11371.086494]   .se->avg.util_avg              : 0
[11371.086834]   .se->avg.runnable_load_avg     : 0
[11371.087098] cfs_rq[15]:/
[11371.087357]   .exec_clock                    : 0.000000
[11371.087760]   .MIN_vruntime                  : 0.000001
[11371.088175]   .min_vruntime                  : 14495.169263
[11371.088614]   .max_vruntime                  : 0.000001
[11371.088958]   .spread                        : 0.000000
[11371.089230]   .spread0                       : -6062.616579
[11371.089547]   .nr_spread_over                : 0
[11371.089908]   .nr_running                    : 0
[11371.090185]   .load                          : 0
[11371.090487]   .runnable_weight               : 0
[11371.090831]   .load_avg                      : 0
[11371.091098]   .runnable_load_avg             : 0
[11371.091362]   .util_avg                      : 1
[11371.091746]   .util_est_enqueued             : 0
[11371.092011]   .removed.load_avg              : 0
[11371.092280]   .removed.util_avg              : 0
[11371.092620]   .removed.runnable_sum          : 0
[11371.092935]   .tg_load_avg_contrib           : 0
[11371.093194]   .tg_load_avg                   : 0
[11371.093478]   .throttled                     : 0
[11371.093814]   .throttle_count                : 0
[11371.094070] rt_rq[15]:/
[11371.094318]   .rt_nr_running                 : 0
[11371.094631]   .rt_nr_migratory               : 0
[11371.094928]   .rt_throttled                  : 0
[11371.095180]   .rt_time                       : 0.000000
[11371.095460]   .rt_runtime                    : 950.000000
[11371.095798] dl_rq[15]:
[11371.096046]   .dl_nr_running                 : 0
[11371.096303]   .dl_nr_migratory               : 0
[11371.096636]   .dl_bw->bw                     : 996147
[11371.096941]   .dl_bw->total_bw               : 0
[11371.097199] runnable tasks:
[11371.097481]  S           task   PID         tree-key  switches  prio     wait-time             sum-exec        sum-sleep
[11371.097852] -----------------------------------------------------------------------------------------------------------
[11371.098169]  S       cpuhp/15    84      7519.989589        21   120         0.000000         1.056787         0.000000 0 0 /
[11371.098553]  S   migration/15    85       655.148289      2893     0         0.000000        41.019687         0.000000 0 0 /
[11371.098960]  S   ksoftirqd/15    86     14325.602349       230   120         0.000000        32.239626         0.000000 0 0 /
[11371.099313]  I  kworker/15:0H    88      1284.787156         8   100         0.000000         0.856234         0.000000 0 0 /
[11371.099789]  I   kworker/15:1   136     14483.218259       489   120         0.000000       101.581068         0.000000 0 0 /
[11371.100152]  S        kswapd0   233        61.646747         3   120         0.000000         0.044747         0.000000 0 0 /
[11371.100588]  S      scsi_eh_0   519      8734.704328        29   120         0.000000         0.929899         0.000000 0 0 /
[11371.101018]  S      scsi_eh_4   535      8740.759378        39   120         0.000000         2.672699         0.000000 0 0 /
[11371.101391]  Iext4-rsv-conver   690      1269.187584         2   100         0.000000         0.047690         0.000000 0 0 /
[11371.101875]  I  kworker/15:1H   762     14130.352643        36   100         0.000000         0.837028         0.000000 0 0 /
[11371.102263]  S          gmain  1717        14.368316      3490   120         0.000000       173.009226         0.000000 0 0 /autogroup-71
[11371.103134]  S          gdbus  1767        24.283862       413   120         0.000000        55.821800         0.000000 0 0 /autogroup-77
[11371.104033]  S           lsmd  1723         0.723007       783   120         0.000000       120.184254         0.000000 0 0 /autogroup-80
[11371.105011]  S    dbus-daemon  1749        96.330500      4055   120         0.000000       811.904690         0.000000 0 0 /autogroup-91
[11371.106023]  S          gdbus  1807        58.959983       871   120         0.000000        85.774089         0.000000 0 0 /autogroup-92
[11371.107089]  S          tuned  2046       180.007660        88   120         0.000000       179.262991         0.000000 0 0 /autogroup-108
[11371.108225]  S         python  2172      1031.589693     23742   120         0.000000      1612.888813         0.000000 0 0 /autogroup-103
[11371.109470]  S         python  2066       482.872049     22669   120         0.000000      1567.712547         0.000000 0 0 /autogroup-102
[11371.110787]  I   kworker/15:0  4651     10446.283557         5   120         0.000000         0.133532         0.000000 0 0 /
[11371.111396]  I    mlx5_events  4805      9911.969621         2   100         0.000000         0.053183         0.000000 0 0 /
[11371.112116]  S    sftp-server  6500        24.553911        12   120         0.000000        25.366448         0.000000 0 0 /autogroup-177
[11371.113558] 
Showing all locks held in the system:
[11371.115217] 2 locks held by kworker/5:1H/768:
[11371.116109]  #0: ffff9af6943b4148 ((wq_completion)ib-comp-wq){+.+.}, at: process_one_work+0x1b5/0x5d0
[11371.117078]  #1: ffffb351c0687e68 ((work_completion)(&cq->work)){+.+.}, at: process_one_work+0x1b5/0x5d0
[11371.118084] no locks held by systemd-journal/780.
[11371.119074] 4 locks held by rs:main Q:Reg/2040:
[11371.120009]  #0: ffff9af69dde81d8 (&rq->lock){-.-.}, at: __schedule+0xf5/0x850
[11371.121020]  #1: ffff9af686c0c480 (sb_writers#9){.+.+}, at: vfs_write+0x1af/0x1d0
[11371.122018]  #2: ffffffffa4ed3680 (&fsnotify_mark_srcu){....}, at: fsnotify+0xc3/0x420
[11371.123012]  #3: ffff9af64e194428 (&(&group->notification_lock)->rlock){+.+.}, at: fsnotify_add_event+0x31/0x170
[11371.124054] 2 locks held by agetty/2071:
[11371.125082]  #0: ffff9af6104460a0 (&tty->ldisc_sem){++++}, at: tty_ldisc_ref_wait+0x24/0x50
[11371.126095]  #1: ffffb351c09af2f0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0xd9/0x940
[11371.127119] 3 locks held by bash/6450:
[11371.128129]  #0: ffff9aef47438480 (sb_writers#3){.+.+}, at: vfs_write+0x1af/0x1d0
[11371.129184]  #1: ffffffffa0e89f60 (rcu_read_lock){....}, at: __handle_sysrq+0x5/0x230
[11371.130197]  #2: ffffffffa0e89f60 (rcu_read_lock){....}, at: debug_show_all_locks+0xe/0x1b0
[11371.131267] 1 lock held by dmesg/6547:

[11371.133279] =============================================

[11371.135157] Showing busy workqueues and worker pools:
[11371.136140] workqueue events: flags=0x0
[11371.137223]   pwq 16: cpus=8 node=0 flags=0x0 nice=0 active=1/256
[11371.138266]     pending: drm_fb_helper_dirty_work [drm_kms_helper]

[11371.139128] ======================================================
[11371.139129] WARNING: possible circular locking dependency detected
[11371.139129] 5.4.0+ #24 Tainted: G           OE    
[11371.139129] ------------------------------------------------------
[11371.139130] bash/6450 is trying to acquire lock:
[11371.139130] ffffffffa0e73a20 (console_owner){..-.}, at: console_unlock+0x186/0x5e0

[11371.139132] but task is already holding lock:
[11371.139132] ffff9af69d1e7958 (&(&pool->lock)->rlock){-.-.}, at: show_workqueue_state+0x307/0x710

[11371.139134] which lock already depends on the new lock.


[11371.139135] the existing dependency chain (in reverse order) is:

[11371.139135] -> #1 (&(&pool->lock)->rlock){-.-.}:
[11371.139137]        _raw_spin_lock+0x30/0x70
[11371.139137]        __queue_work+0x100/0x640
[11371.139137]        queue_work_on+0x81/0x90
[11371.139138]        soft_cursor+0x1f3/0x220
[11371.139138]        bit_cursor+0x513/0x620
[11371.139138]        hide_cursor+0x24/0x90
[11371.139139]        vt_console_print+0x3b8/0x3d0
[11371.139139]        console_unlock+0x45c/0x5e0
[11371.139139]        vprintk_emit+0x110/0x370
[11371.139140]        dev_vprintk_emit+0x1c8/0x1f2
[11371.139140]        dev_printk_emit+0x4a/0x66
[11371.139140]        _dev_err+0x64/0x80
[11371.139140]        init_one+0x1a57/0x1bd0 [cxgb4]
[11371.139141]        local_pci_probe+0x3d/0x90
[11371.139141]        work_for_cpu_fn+0x10/0x20
[11371.139141]        process_one_work+0x235/0x5d0
[11371.139142]        worker_thread+0x1d5/0x390
[11371.139142]        kthread+0x11f/0x140
[11371.139142]        ret_from_fork+0x24/0x30

[11371.139143] -> #0 (console_owner){..-.}:
[11371.139144]        __lock_acquire+0x11fa/0x1480
[11371.139144]        lock_acquire+0x9e/0x1a0
[11371.139145]        console_unlock+0x1e8/0x5e0
[11371.139145]        vprintk_emit+0x110/0x370
[11371.139145]        printk+0x52/0x6e
[11371.139146]        show_workqueue_state+0x37d/0x710
[11371.139146]        __handle_sysrq+0xd2/0x230
[11371.139146]        write_sysrq_trigger+0x48/0x50
[11371.139147]        proc_reg_write+0x36/0x60
[11371.139147]        vfs_write+0xc1/0x1d0
[11371.139147]        ksys_write+0xa7/0xe0
[11371.139147]        do_syscall_64+0x5a/0x240
[11371.139148]        entry_SYSCALL_64_after_hwframe+0x49/0xbe

[11371.139148] other info that might help us debug this:

[11371.139149]  Possible unsafe locking scenario:

[11371.139150]        CPU0                    CPU1
[11371.139150]        ----                    ----
[11371.139150]   lock(&(&pool->lock)->rlock);
[11371.139151]                                lock(console_owner);
[11371.139152]                                lock(&(&pool->lock)->rlock);
[11371.139153]   lock(console_owner);

[11371.139153]  *** DEADLOCK ***

[11371.139154] 5 locks held by bash/6450:
[11371.139154]  #0: ffff9aef47438480 (sb_writers#3){.+.+}, at: vfs_write+0x1af/0x1d0
[11371.139156]  #1: ffffffffa0e89f60 (rcu_read_lock){....}, at: __handle_sysrq+0x5/0x230
[11371.139157]  #2: ffffffffa0e89f60 (rcu_read_lock){....}, at: show_workqueue_state+0x5/0x710
[11371.139159]  #3: ffff9af69d1e7958 (&(&pool->lock)->rlock){-.-.}, at: show_workqueue_state+0x307/0x710
[11371.139160]  #4: ffffffffa0e73d00 (console_lock){+.+.}, at: vprintk_emit+0x103/0x370

[11371.139161] stack backtrace:
[11371.139162] CPU: 8 PID: 6450 Comm: bash Kdump: loaded Tainted: G           OE     5.4.0+ #24
[11371.139162] Hardware name: Supermicro X10SRA-F/X10SRA-F, BIOS 2.0a 06/23/2016
[11371.139163] Call Trace:
[11371.139163]  dump_stack+0x8f/0xcb
[11371.139163]  check_noncircular+0x184/0x1a0
[11371.139163]  ? __lock_acquire+0x11fa/0x1480
[11371.139164]  __lock_acquire+0x11fa/0x1480
[11371.139164]  lock_acquire+0x9e/0x1a0
[11371.139164]  ? console_unlock+0x186/0x5e0
[11371.139165]  console_unlock+0x1e8/0x5e0
[11371.139165]  ? console_unlock+0x186/0x5e0
[11371.139165]  vprintk_emit+0x110/0x370
[11371.139166]  printk+0x52/0x6e
[11371.139166]  show_workqueue_state+0x37d/0x710
[11371.139166]  ? printk+0x52/0x6e
[11371.139167]  __handle_sysrq+0xd2/0x230
[11371.139167]  write_sysrq_trigger+0x48/0x50
[11371.139167]  proc_reg_write+0x36/0x60
[11371.139167]  vfs_write+0xc1/0x1d0
[11371.139168]  ksys_write+0xa7/0xe0
[11371.139168]  do_syscall_64+0x5a/0x240
[11371.139168]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[11371.139169] RIP: 0033:0x7f7dacacffd0
[11371.139169] Code: 73 01 c3 48 8b 0d c0 6e 2d 00 f7 d8 64 89 01 48 83 c8 ff c3 66 0f 1f 44 00 00 83 3d cd cf 2d 00 00 75 10 b8 01 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 31 c3 48 83 ec 08 e8 ee cb 01 00 48 89 04 24
[11371.139170] RSP: 002b:00007ffd089b1998 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
[11371.139170] RAX: ffffffffffffffda RBX: 0000000000000002 RCX: 00007f7dacacffd0
[11371.139171] RDX: 0000000000000002 RSI: 00007f7dad3fb000 RDI: 0000000000000001
[11371.139171] RBP: 00007f7dad3fb000 R08: 000000000000000a R09: 00007f7dad3d6740
[11371.139172] R10: 00007f7dad3d6740 R11: 0000000000000246 R12: 00007f7dacda8400
[11371.139172] R13: 0000000000000002 R14: 0000000000000001 R15: 0000000000000000
[11371.191652] workqueue ib-comp-wq: flags=0x58
[11371.192311]   pwq 11: cpus=5 node=0 flags=0x0 nice=-20 active=1/256
[11371.192966]     in-flight: 768:ib_cq_poll_work [ib_core]
[11371.193643] pool 11: cpus=5 node=0 flags=0x0 nice=-20 hung=75s workers=2 idle: 38
[11429.199506] INFO: task iscsi_ttx:6432 blocked for more than 122 seconds.
[11429.200197]       Tainted: G           OE     5.4.0+ #24
[11429.200744] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11429.201607] iscsi_ttx       D    0  6432      2 0x80004084
[11429.202310] Call Trace:
[11429.202890]  ? __schedule+0x31a/0x850
[11429.203844]  ? __lock_acquire+0x26c/0x1480
[11429.204457]  ? wait_for_completion+0x112/0x1a0
[11429.205209]  schedule+0x36/0xc0
[11429.205791]  schedule_timeout+0x204/0x3b0
[11429.206551]  ? sched_clock+0x5/0x10
[11429.207187]  ? sched_clock+0x5/0x10
[11429.207709]  ? sched_clock_cpu+0xc/0xc0
[11429.208462]  ? wait_for_completion+0x112/0x1a0
[11429.209107]  wait_for_completion+0x13a/0x1a0
[11429.209648]  ? wake_up_q+0x80/0x80
[11429.210484]  __ib_drain_sq+0x184/0x190 [ib_core]
[11429.211036]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[11429.211568]  ? wait_for_completion+0x49/0x1a0
[11429.212303]  ib_drain_qp+0xe/0x20 [ib_core]
[11429.212837]  isert_wait_conn+0x65/0x350 [ib_isert]
[11429.213548]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11429.214199]  iscsit_close_connection+0x154/0x8a0 [iscsi_target_mod]
[11429.214771]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11429.215452]  iscsit_take_action_for_connection_exit+0x7a/0x100 [iscsi_target_mod]
[11429.216122]  iscsi_target_tx_thread+0x16c/0x200 [iscsi_target_mod]
[11429.216689]  ? finish_wait+0x80/0x80
[11429.217553]  kthread+0x11f/0x140
[11429.218124]  ? kthread_park+0x90/0x90
[11429.218689]  ret_from_fork+0x24/0x30
[11429.219409] INFO: lockdep is turned off.
[11552.079434] INFO: task iscsi_np:6061 blocked for more than 122 seconds.
[11552.079976]       Tainted: G           OE     5.4.0+ #24
[11552.080610] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11552.081551] iscsi_np        D    0  6061      2 0x80004084
[11552.082269] Call Trace:
[11552.082869]  ? __schedule+0x31a/0x850
[11552.083843]  ? __lock_acquire+0x26c/0x1480
[11552.084476]  ? wait_for_completion+0x112/0x1a0
[11552.085229]  schedule+0x36/0xc0
[11552.085790]  schedule_timeout+0x204/0x3b0
[11552.086547]  ? sched_clock+0x5/0x10
[11552.087207]  ? sched_clock+0x5/0x10
[11552.087765]  ? sched_clock_cpu+0xc/0xc0
[11552.088521]  ? wait_for_completion+0x112/0x1a0
[11552.089193]  wait_for_completion+0x13a/0x1a0
[11552.089733]  ? wake_up_q+0x80/0x80
[11552.090676]  iscsi_check_for_session_reinstatement+0x1d7/0x280 [iscsi_target_mod]
[11552.091255]  iscsi_target_do_login+0xa6/0x5c0 [iscsi_target_mod]
[11552.091805]  iscsi_target_start_negotiation+0x51/0xd0 [iscsi_target_mod]
[11552.092567]  iscsi_target_login_thread+0xa3a/0x1080 [iscsi_target_mod]
[11552.093226]  ? iscsi_target_login_sess_out+0x200/0x200 [iscsi_target_mod]
[11552.093799]  kthread+0x11f/0x140
[11552.094551]  ? kthread_park+0x90/0x90
[11552.095134]  ret_from_fork+0x24/0x30
[11552.095655] INFO: task iscsi_ttx:6432 blocked for more than 245 seconds.
[11552.096446]       Tainted: G           OE     5.4.0+ #24
[11552.097101] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[11552.097634] iscsi_ttx       D    0  6432      2 0x80004084
[11552.098384] Call Trace:
[11552.099066]  ? __schedule+0x31a/0x850
[11552.099638]  ? __lock_acquire+0x26c/0x1480
[11552.100298]  ? wait_for_completion+0x112/0x1a0
[11552.100840]  schedule+0x36/0xc0
[11552.101574]  schedule_timeout+0x204/0x3b0
[11552.102220]  ? sched_clock+0x5/0x10
[11552.102774]  ? sched_clock+0x5/0x10
[11552.103479]  ? sched_clock_cpu+0xc/0xc0
[11552.104113]  ? wait_for_completion+0x112/0x1a0
[11552.104628]  wait_for_completion+0x13a/0x1a0
[11552.105263]  ? wake_up_q+0x80/0x80
[11552.105775]  __ib_drain_sq+0x184/0x190 [ib_core]
[11552.106365]  ? ib_sg_to_pages+0x1a0/0x1a0 [ib_core]
[11552.106980]  ? wait_for_completion+0x49/0x1a0
[11552.107480]  ib_drain_qp+0xe/0x20 [ib_core]
[11552.108086]  isert_wait_conn+0x65/0x350 [ib_isert]
[11552.108616]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11552.109230]  iscsit_close_connection+0x154/0x8a0 [iscsi_target_mod]
[11552.109767]  ? iscsit_thread_get_cpumask+0xb0/0xb0 [iscsi_target_mod]
[11552.110346]  iscsit_take_action_for_connection_exit+0x7a/0x100 [iscsi_target_mod]
[11552.110960]  iscsi_target_tx_thread+0x16c/0x200 [iscsi_target_mod]
[11552.111526]  ? finish_wait+0x80/0x80
[11552.112166]  kthread+0x11f/0x140
[11552.112677]  ? kthread_park+0x90/0x90
[11552.113267]  ret_from_fork+0x24/0x30
[11552.113792] INFO: lockdep is turned off.

--5vNYLRcllDrimb99--

From: David Disseldorp <ddiss@suse.de>
Date: Tue, 12 Jun 2018 22:12:20 +0000
Subject: iscsi_trx oops on todays mainline with 804209d8a0096d9ed8c9891f987f42bc1a98b8f9
Message-Id: <20180613001220.137a9d28@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

I'm reliably hitting the following oops while running the libiscsi test
suite (any test) against an LIO iSCSI target:

[    7.722496] BUG: unable to handle kernel paging request at ffff88047e427904
[    7.723598] PGD 1eaa067 P4D 1eaa067 PUD 0
[    7.724218] Oops: 0000 [#1] SMP PTI
[    7.724651] CPU: 0 PID: 323 Comm: iscsi_trx Not tainted 4.17.0+ #12
[    7.725732] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.0.0-prebuilt.qemu-project.org 04/01/2014
[    7.726721] RIP: 0010:percpu_ida_alloc+0x57/0x70
[    7.727162] Code: 81 48 89 44 24 18 48 89 44 24 20 65 48 03 1d b8 84 da 7e 48 89 df e8 88 40 26 00 8b 4b 04 48 89 c6 48 89 df 8d 51 ff 89 53 04 <8b> 6c 93 08 e8 70 3f 26 00 48 83 c4 28 5b 89 e8 5d c3 0f 1f 80 00
[    7.728846] RSP: 0018:ffffc9000034fdc0 EFLAGS: 00010046
[    7.729310] RAX: 0000000000000286 RBX: ffff88007e427900 RCX: 0000000000000000
[    7.729938] RDX: 00000000ffffffff RSI: 0000000000000286 RDI: ffff88007e427900
[    7.730566] RBP: ffff88007b97f800 R08: 0000000000000218 R09: 0000000000000077
[    7.731637] R10: 0000000000015bc6 R11: 0000000000000010 R12: 0000000000000005
[    7.732774] R13: ffff88007f46ce00 R14: ffffc9000034fe60 R15: ffff88007f73c5d8
[    7.733999] FS:  0000000000000000(0000) GS:ffff88007e400000(0000) knlGS:0000000000000000
[    7.735254] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.736136] CR2: ffff88047e427904 CR3: 0000000001c0a000 CR4: 00000000000006b0
[    7.737219] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.738303] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    7.739391] Call Trace:
[    7.739778]  ? wait_woken+0x80/0x80
[    7.740324]  ? iscsit_allocate_cmd+0x23/0x110 [iscsi_target_mod]
[    7.741236]  ? iscsit_get_rx_pdu+0x2c0/0xc90 [iscsi_target_mod]
[    7.742138]  ? pick_next_task_fair+0x3e4/0x600
[    7.742825]  ? iscsi_target_rx_thread+0x93/0xc0 [iscsi_target_mod]
[    7.743764]  ? kthread+0xee/0x120
[    7.744281]  ? iscsi_target_tx_thread+0x1e0/0x1e0 [iscsi_target_mod]
[    7.745245]  ? kthread_flush_work_fn+0x10/0x10
[    7.745924]  ? ret_from_fork+0x35/0x40
[    7.746499] Modules linked in: dm_delay loop iscsi_target_mod target_core_file target_core_iblock target_core_mod
[    7.748057] CR2: ffff88047e427904
[    7.748569] ---[ end trace d969d2677664575c ]---

The libiscsi test doesn't matter, as the oops occurs while handling the
first SCSI command after iSCSI login (TUR).

Bisect points at:

commit 804209d8a0096d9ed8c9891f987f42bc1a98b8f9
Author: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Date:   Thu Jun 7 17:10:48 2018 -0700

    lib/percpu_ida.c: use _irqsave() instead of local_irq_save() + spin_lock

    percpu_ida() decouples disabling interrupts from the locking operations.
    This breaks some assumptions if the locking operations are replaced like
    they are under -RT.

    The same locking can be achieved by avoiding local_irq_save() and using
    spin_lock_irqsave() instead.  percpu_ida_alloc() gains one more preemption
    point because after unlocking the fastpath and before the pool lock is
    acquired, the interrupts are briefly enabled.

    Link: http://lkml.kernel.org/r/20180504153218.7301-1-bigeasy@linutronix.de
    Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
    Cc: Thomas Gleixner <tglx@linutronix.de>
    Cc: Nicholas Bellinger <nab@linux-iscsi.org>
    Cc: Shaohua Li <shli@fb.com>
    Cc: Kent Overstreet <kent.overstreet@gmail.com>
    Cc: Matthew Wilcox <willy@infradead.org>
    Cc: Jens Axboe <axboe@kernel.dk>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

Aside from the bisect I haven't had time to look closer at the bug, but
figured I'd get an early report in, just in case someone's already
dealing / dealt with it.

Cheers, David

From: xiubli@redhat.com
Date: Thu, 19 Jul 2018 14:30:59 +0000
Subject: [PATCH] tcmu: fix crash for dereferencing the released udev->mb_addr memory
Message-Id: <1532010659-4657-1-git-send-email-xiubli@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

The logs are:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
IP: [<ffffffffc072b9a9>] tcmu_reset_ring_store+0x149/0x240 [target_core_user]
PGD 800000000e254067 PUD e255067 PMD 0
Oops: 0002 [#1] SMP
[...]
CPU: 0 PID: 36077 Comm: tcmu-runner Kdump: loaded Not tainted 3.10.0-924.el7.test.x86_64 #1
Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 05/19/2017
task: ffff922db95ab0c0 ti: ffff922d9f8d4000 task.ti: ffff922d9f8d4000
RIP: 0010:[<ffffffffc072b9a9>]  [<ffffffffc072b9a9>] tcmu_reset_ring_store+0x149/0x240 [target_core_user]
RSP: 0018:ffff922d9f8d7e30  EFLAGS: 00010246
RAX: 0000000000000000 RBX: 0000000000001000 RCX: 00000000c0000100
RDX: ffff922d9f8d5fd8 RSI: 0000000000000000 RDI: ffff922d4b91f440
RBP: ffff922d9f8d7e70 R08: 0000000000000000 R09: 0000000000000001
R10: 0000000000000000 R11: 0000000000000000 R12: ffff922d4b91e550
R13: ffff922d4b91f3e8 R14: 0000000000000000 R15: 0000000000000000
FS:  00007f70467d7880(0000) GS:ffff922dbb600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000040 CR3: 000000000a2b0000 CR4: 00000000003607f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 [<ffffffffac0cafaf>] configfs_write_file+0x11f/0x160

From the crash tools:

crash> bt
PID: 36077  TASK: ffff922db95ab0c0  CPU: 0   COMMAND: "tcmu-runner"
 #0 [ffff922d9f8d7ac8] machine_kexec at ffffffffabe62d8a
 #1 [ffff922d9f8d7b28] __crash_kexec at ffffffffabf1bb02
 #2 [ffff922d9f8d7bf8] crash_kexec at ffffffffabf1bbf0
 #3 [ffff922d9f8d7c10] oops_end at ffffffffac564798
 #4 [ffff922d9f8d7c38] no_context at ffffffffac552b3b
 #5 [ffff922d9f8d7c88] __bad_area_nosemaphore at ffffffffac552bd2
 #6 [ffff922d9f8d7cd8] bad_area_nosemaphore at ffffffffac552d43
 #7 [ffff922d9f8d7ce8] __do_page_fault at ffffffffac567750
 #8 [ffff922d9f8d7d50] do_page_fault at ffffffffac567945
 #9 [ffff922d9f8d7d80] page_fault at ffffffffac563788
    [exception RIP: tcmu_reset_ring_store+329]
    RIP: ffffffffc072b9a9  RSP: ffff922d9f8d7e30  RFLAGS: 00010246
    RAX: 0000000000000000  RBX: 0000000000001000  RCX: 00000000c0000100
    RDX: ffff922d9f8d5fd8  RSI: 0000000000000000  RDI: ffff922d4b91f440
    RBP: ffff922d9f8d7e70   R8: 0000000000000000   R9: 0000000000000001
    R10: 0000000000000000  R11: 0000000000000000  R12: ffff922d4b91e550
    R13: ffff922d4b91f3e8  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
    RIP: 00007f70458a074d  RSP: 00007ffcf788dc50  RFLAGS: 00000293
    RAX: 0000000000000001  RBX: 0000000000000000  RCX: ffffffffffffffff
    RDX: 0000000000000002  RSI: 00007ffcf788dce0  RDI: 0000000000000007
    RBP: 00007ffcf788dcc0   R8: 0000000000000000   R9: 00007f7044cd10fd
    R10: 00007ffcf788e720  R11: 0000000000000293  R12: 0000000000407c80
    R13: 00007ffcf788f170  R14: 0000000000000000  R15: 0000000000000000
    ORIG_RAX: 0000000000000001  CS: 0033  SS: 002b

We can see that the IP is tcmu_reset_ring_store+329.

crash> dis tcmu_reset_ring_store
[...]
0xffffffffc072b955 <tcmu_reset_ring_store+245>: callq  0xffffffffac019810 <kmem_cache_free>
0xffffffffc072b95a <tcmu_reset_ring_store+250>: jmpq   0xffffffffc072b8d8 <tcmu_reset_ring_store+120>
0xffffffffc072b95f <tcmu_reset_ring_store+255>: nop
[...]
0xffffffffc072b98e <tcmu_reset_ring_store+302>: jne    0xffffffffc072b988 <tcmu_reset_ring_store+296>
0xffffffffc072b990 <tcmu_reset_ring_store+304>: testb  $0x4,0x3efb(%rip)        # 0xffffffffc072f892
0xffffffffc072b997 <tcmu_reset_ring_store+311>: jne    0xffffffffc072ba6e <tcmu_reset_ring_store+526>
0xffffffffc072b99d <tcmu_reset_ring_store+317>: movl   $0x0,0xe74(%r12)
0xffffffffc072b9a9 <tcmu_reset_ring_store+329>: movl   $0x0,0x40(%r14)
0xffffffffc072b9b1 <tcmu_reset_ring_store+337>: movl   $0x0,0xc(%r14)
0xffffffffc072b9b9 <tcmu_reset_ring_store+345>: nopl   0x0(%rax)
0xffffffffc072b9c0 <tcmu_reset_ring_store+352>: sub    $0x1000,%rbx
0xffffffffc072b9c7 <tcmu_reset_ring_store+359>: jne    0xffffffffc072b9c0 <tcmu_reset_ring_store+352>
0xffffffffc072b9c9 <tcmu_reset_ring_store+361>: lea    0xf18(%r12),%rdi
0xffffffffc072b9d1 <tcmu_reset_ring_store+369>: callq  0xffffffffabea8b00 <del_timer>
[...]

And the related target_core_user.c C code for line:
0xffffffffc072b9a9 <tcmu_reset_ring_store+329>: movl   $0x0,0x40(%r14)
is "mb->cmd_tail = 0;"

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 drivers/target/target_core_user.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 847707a..8d7274e 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1587,16 +1587,16 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	bool all_expired = true;
 	int i;
 
-	vfree(udev->mb_addr);
-	udev->mb_addr = NULL;
-
 	spin_lock_bh(&timed_out_udevs_lock);
 	if (!list_empty(&udev->timedout_entry))
 		list_del(&udev->timedout_entry);
 	spin_unlock_bh(&timed_out_udevs_lock);
 
-	/* Upper layer should drain all requests before calling this */
 	mutex_lock(&udev->cmdr_lock);
+	vfree(udev->mb_addr);
+	udev->mb_addr = NULL;
+
+	/* Upper layer should drain all requests before calling this */
 	idr_for_each_entry(&udev->commands, cmd, i) {
 		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
 			all_expired = false;
-- 
1.8.3.1


From: Henry Willard <henry.willard@oracle.com>
Date: Fri, 19 Jun 2020 18:41:45 +0000
Subject: [PATCH] scsi: target: tcmu: Call flush_dcache_page() with proper page struct
Message-Id: <1592592105-11497-1-git-send-email-henry.willard@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

tcmu_flush_dcache_range() gets called with addresses from both kernel
linear space and vmalloc space, so virt_to_page() or vmalloc_to_page()
have to be used as appropriate to get the proper page struct. On x86_64
flush_dcache_page() is the default noop implementation, so this hasn't
been a problem there.

When tcmu_flush_dcache_range() is called with a vmalloc address on Arm64,
the result is a kernel panic with the following stack trace:

[  448.873342] CPU: 0 PID: 34102 Comm: iscsi_trx Kdump: loaded
Not tainted 5.4.17-2011.3.2.1.el8uek.aarch64 #2
[  448.876144] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 02/06/2015
[  448.878377] pstate: 80400005 (Nzcv daif +PAN -UAO)
[  448.880182] pc : flush_dcache_page+0x18/0x60
[  448.881888] lr : is_ring_space_avail+0x74/0x390 [target_core_user]
[  448.883969] sp : ffff80001720fa70
[  448.885450] x29: ffff80001720fa70 x28: 0000000000000000
[  448.887348] x27: 0000000000010000 x26: ffff0003c4b88000
[  448.889285] x25: 0000000000010000 x24: ffff800017da0000
[  448.891166] x23: ffffffdfffe00000 x22: 0000000000000078
[  448.893061] x21: 0000800017da0001 x20: 000000000000ffff
[  448.894931] x19: ffffffffffe5f680 x18: 0000000000000000
[  448.896826] x17: 0000000000000000 x16: 0000000000000000
[  448.898704] x15: 0000000000000000 x14: 0000000000000000
[  448.900562] x13: 0000000000000000 x12: 0000000000000000
[  448.902403] x11: ffff0003d188e4d0 x10: 0000000000000030
[  448.904230] x9 : 0000000000000000 x8 : ffff0003d4073f00
[  448.906094] x7 : 00000000000013b0 x6 : 000000000000003f
[  448.907911] x5 : 0000000000000040 x4 : ffff0003d16d6258
[  448.909720] x3 : 0000000000010000 x2 : 0000000000000078
[  448.911664] x1 : ffff0003d16d6228 x0 : ffff800009f43b1c
[  448.913767] Call trace:
[  448.914984]  flush_dcache_page+0x18/0x60
[  448.916518]  is_ring_space_avail+0x74/0x390 [target_core_user]
[  448.918450]  queue_cmd_ring+0x228/0x700 [target_core_user]
[  448.920318]  tcmu_queue_cmd+0xd8/0x14c [target_core_user]
[  448.922192]  __target_execute_cmd+0x30/0x130 [target_core_mod]
[  448.924170]  target_execute_cmd+0x1a4/0x450 [target_core_mod]
[  448.926212]  transport_generic_new_cmd+0x1b8/0x3a0 [target_core_mod]
[  448.928289]  transport_handle_cdb_direct+0x50/0xb0 [target_core_mod]
[  448.930368]  iscsit_execute_cmd+0x2c0/0x360 [iscsi_target_mod]
[  448.932347]  iscsit_sequence_cmd+0xd8/0x1c8 [iscsi_target_mod]
[  448.934313]  iscsit_process_scsi_cmd+0xac/0xf8 [iscsi_target_mod]
[  448.936479]  iscsit_get_rx_pdu+0x450/0xd68 [iscsi_target_mod]
[  448.938423]  iscsi_target_rx_thread+0xc0/0x168 [iscsi_target_mod]
[  448.940387]  kthread+0x110/0x114
[  448.941802]  ret_from_fork+0x10/0x18
[  448.943271] Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (f9400260)
[  448.945271] SMP: stopping secondary CPUs

Signed-off-by: Henry Willard <henry.willard@oracle.com>
---
 drivers/target/target_core_user.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 560bfec933bc..7557c0630483 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -597,11 +597,19 @@ static inline void tcmu_flush_dcache_range(void *vaddr, size_t size)
 {
 	unsigned long offset = offset_in_page(vaddr);
 	void *start = vaddr - offset;
+	struct page *pg;
 
 	size = round_up(size+offset, PAGE_SIZE);
 
 	while (size) {
-		flush_dcache_page(virt_to_page(start));
+		if (virt_addr_valid(start))
+			pg = virt_to_page(start);
+		else if (is_vmalloc_addr(start))
+			pg = vmalloc_to_page(start);
+		else
+			break;
+
+		flush_dcache_page(pg);
 		start += PAGE_SIZE;
 		size -= PAGE_SIZE;
 	}
-- 
1.8.3.1

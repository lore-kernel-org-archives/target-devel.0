From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Thu, 01 Mar 2018 22:26:32 +0000
Subject: [PATCH 14/14] target: Fix handling of removed LUNs
Message-Id: <20180301222632.31507-15-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Send a valid ASC / ASCQ combination back to the initiator if a SCSI
command is received after a LUN has been removed. This patch fixes
the following call trace:

WARNING: CPU: 0 PID: 4 at drivers/target/target_core_transport.c:3131 translate_sense_reason+0x164/0x190 [target_core_mod]
Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
RIP: 0010:translate_sense_reason+0x164/0x190 [target_core_mod]
Call Trace:
transport_send_check_condition_and_sense+0x95/0x1c0 [target_core_mod]
transport_generic_request_failure+0x102/0x270 [target_core_mod]
transport_generic_new_cmd+0x138/0x340 [target_core_mod]
transport_handle_cdb_direct+0x2f/0x80 [target_core_mod]
target_submit_cmd_map_sgls+0x212/0x2a0 [target_core_mod]
srpt_handle_new_iu+0x244/0x680 [ib_srpt]
__ib_process_cq+0x6d/0xc0 [ib_core]
ib_cq_poll_work+0x18/0x50 [ib_core]
process_one_work+0x20b/0x6a0
worker_thread+0x35/0x380
kthread+0x117/0x130
ret_from_fork+0x24/0x30

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_ua.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index be25eb807a5f..08c1e550babd 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -218,17 +218,15 @@ void core_scsi3_ua_for_check_condition(
 		return;
 
 	nacl = sess->se_node_acl;
-	if (!nacl)
+	if (WARN_ON_ONCE(!nacl))
 		return;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
-	if (!deve) {
-		rcu_read_unlock();
-		return;
-	}
-	if (!atomic_read(&deve->ua_count)) {
+	if (!deve || !atomic_read(&deve->ua_count)) {
 		rcu_read_unlock();
+		*asc = 0x25;
+		*ascq = 0;
 		return;
 	}
 	/*
-- 
2.16.2


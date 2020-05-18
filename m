From: Lance Digby <lance.digby@gmail.com>
Date: Mon, 18 May 2020 01:02:16 +0000
Subject: [PATCH v1 target] target: Add initiatorname to NON_EXISTENT_LUN error
Message-Id: <9b13bb2e1f52f1792cd81850ee95bf3781bb5363.1589759816.git.lance.digby@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mchristi@redhat.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

The NON_EXISTENT_LUN error can be written without an error condition
on the initiator responsible. Adding the initiatorname to this message
will reduce the effort required to fix this when many initiators are
supported by a target.

This version ensures the initiator name is also printed on the same
message in transport_lookup_tmr_lun for consistency.

Signed-off-by: Lance Digby <lance.digby@gmail.com>
---
 drivers/target/target_core_device.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4cee113..15064a5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -100,9 +100,10 @@
 		 */
 		if (unpacked_lun != 0) {
 			pr_err("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-				" Access for 0x%08llx\n",
+				" Access for 0x%08llx from %s\n",
 				se_cmd->se_tfo->fabric_name,
-				unpacked_lun);
+				unpacked_lun,
+				nacl->initiatorname);
 			return TCM_NON_EXISTENT_LUN;
 		}
 
@@ -174,9 +175,10 @@ int transport_lookup_tmr_lun(struct se_cmd *se_cmd, u64 unpacked_lun)
 
 	if (!se_lun) {
 		pr_debug("TARGET_CORE[%s]: Detected NON_EXISTENT_LUN"
-			" Access for 0x%08llx\n",
+			" Access for 0x%08llx for %s\n",
 			se_cmd->se_tfo->fabric_name,
-			unpacked_lun);
+			unpacked_lun,
+			nacl->initiatorname);
 		return -ENODEV;
 	}
 	se_cmd->se_dev = rcu_dereference_raw(se_lun->lun_se_dev);
-- 
1.8.3.1

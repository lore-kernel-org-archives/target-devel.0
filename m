From: Lance Digby <lance.digby@gmail.com>
Date: Thu, 14 May 2020 04:01:38 +0000
Subject: [PATCH target] target: Add initiatorname to NON_EXISTENT_LUN error
Message-Id: <cd119ce943d9ec62ef1bff237ebb49e35a337c3b.1589407872.git.lance.digby@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

The NON_EXISTENT_LUN error can be written without an error condition
 on the initiator responsible. Adding the initiatorname to this message
 will reduce the effort required to fix this when many initiators are
supported by a target.

Signed-off-by: Lance Digby <lance.digby@gmail.com>
---
 drivers/target/target_core_device.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 4cee113..604dea0 100644
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
+				se_sess->se_node_acl->initiatorname);
 			return TCM_NON_EXISTENT_LUN;
 		}
 
-- 
1.8.3.1

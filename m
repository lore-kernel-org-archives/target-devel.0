From: David Disseldorp <ddiss@suse.de>
Date: Tue, 09 Oct 2018 11:37:04 +0000
Subject: [PATCH 2/4] target: log Data-Out timeouts as errors
Message-Id: <20181009113706.27696-3-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Data-Out timeouts resulting in connection outages should be logged as
errors.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_erl1.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 5efa42b939a1..d75cc11ca83c 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1169,13 +1169,13 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 	na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!sess->sess_ops->ErrorRecoveryLevel) {
-		pr_debug("Unable to recover from DataOut timeout while"
-			" in ERL=0.\n");
+		pr_err("Unable to recover from DataOut timeout while"
+			" in ERL=0, closing iSCSI connection.\n");
 		goto failure;
 	}
 
 	if (++cmd->dataout_timeout_retries = na->dataout_timeout_retries) {
-		pr_debug("Command ITT: 0x%08x exceeded max retries"
+		pr_err("Command ITT: 0x%08x exceeded max retries"
 			" for DataOUT timeout %u, closing iSCSI connection.\n",
 			cmd->init_task_tag, na->dataout_timeout_retries);
 		goto failure;
-- 
2.13.7

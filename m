From: David Disseldorp <ddiss@suse.de>
Date: Fri, 12 Oct 2018 10:01:17 +0000
Subject: [PATCH v2 2/5] target: log Data-Out timeouts as errors
Message-Id: <20181012100120.2365-3-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Data-Out timeouts resulting in connection outages should be logged as
errors. Include the I_T Nexus in the message to aid path identification.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_erl1.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 5efa42b939a1..7f3a1a06696e 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1169,15 +1169,21 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 	na = iscsit_tpg_get_node_attrib(sess);
 
 	if (!sess->sess_ops->ErrorRecoveryLevel) {
-		pr_debug("Unable to recover from DataOut timeout while"
-			" in ERL=0.\n");
+		pr_err("Unable to recover from DataOut timeout while"
+			" in ERL=0, closing iSCSI connection for I_T Nexus"
+			" %s,i,0x%6phN,%s,t,0x%02x\n",
+			sess->sess_ops->InitiatorName, sess->isid,
+			sess->tpg->tpg_tiqn->tiqn, (u32)sess->tpg->tpgt);
 		goto failure;
 	}
 
 	if (++cmd->dataout_timeout_retries = na->dataout_timeout_retries) {
-		pr_debug("Command ITT: 0x%08x exceeded max retries"
-			" for DataOUT timeout %u, closing iSCSI connection.\n",
-			cmd->init_task_tag, na->dataout_timeout_retries);
+		pr_err("Command ITT: 0x%08x exceeded max retries"
+			" for DataOUT timeout %u, closing iSCSI connection for"
+			" I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
+			cmd->init_task_tag, na->dataout_timeout_retries,
+			sess->sess_ops->InitiatorName, sess->isid,
+			sess->tpg->tpg_tiqn->tiqn, (u32)sess->tpg->tpgt);
 		goto failure;
 	}
 
-- 
2.13.7

From: David Disseldorp <ddiss@suse.de>
Date: Fri, 12 Oct 2018 10:01:18 +0000
Subject: [PATCH v2 3/5] target: log NOP ping timeouts as errors
Message-Id: <20181012100120.2365-4-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Events resulting in connection outages like this should be logged as
errors. Include the I_T Nexus in the message to aid path identification.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_util.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 49be1e41290c..931c51f56435 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -915,6 +915,7 @@ static int iscsit_add_nopin(struct iscsi_conn *conn, int want_response)
 void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 {
 	struct iscsi_conn *conn = from_timer(conn, t, nopin_response_timer);
+	struct iscsi_session *sess = conn->sess;
 
 	iscsit_inc_conn_usage_count(conn);
 
@@ -925,9 +926,10 @@ void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 		return;
 	}
 
-	pr_debug("Did not receive response to NOPIN on CID: %hu on"
-		" SID: %u, failing connection.\n", conn->cid,
-			conn->sess->sid);
+	pr_err("Did not receive response to NOPIN on CID: %hu, failing"
+		" connection for I_T Nexus %s,i,0x%6phN,%s,t,0x%02x\n",
+		conn->cid, sess->sess_ops->InitiatorName, sess->isid,
+		sess->tpg->tpg_tiqn->tiqn, (u32)sess->tpg->tpgt);
 	conn->nopin_response_timer_flags &= ~ISCSI_TF_RUNNING;
 	spin_unlock_bh(&conn->nopin_timer_lock);
 
-- 
2.13.7

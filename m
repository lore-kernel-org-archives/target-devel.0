From: David Disseldorp <ddiss@suse.de>
Date: Tue, 09 Oct 2018 11:37:05 +0000
Subject: [PATCH 3/4] target: stash sess_err_stats on Data-Out timeout
Message-Id: <20181009113706.27696-4-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

sess_err_stats are currently filled on NOP ping timeout, but not
Data-Out timeout. Stash details of Data-Out timeouts using a
ISCSI_SESS_ERR_CXN_TIMEOUT value for last_sess_failure_type.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_erl1.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index d75cc11ca83c..44ba50feae6d 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1224,6 +1224,21 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 
 failure:
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
+	{
+	struct iscsi_portal_group *tpg = conn->sess->tpg;
+	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
+
+	if (tiqn) {
+		spin_lock_bh(&tiqn->sess_err_stats.lock);
+		strcpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
+				conn->sess->sess_ops->InitiatorName);
+		tiqn->sess_err_stats.last_sess_failure_type +				ISCSI_SESS_ERR_CXN_TIMEOUT;
+		tiqn->sess_err_stats.cxn_timeout_errors++;
+		atomic_long_inc(&conn->sess->conn_timeout_errors);
+		spin_unlock_bh(&tiqn->sess_err_stats.lock);
+	}
+	}
 	iscsit_cause_connection_reinstatement(conn, 0);
 	iscsit_dec_conn_usage_count(conn);
 }
-- 
2.13.7

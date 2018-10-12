From: David Disseldorp <ddiss@suse.de>
Date: Fri, 12 Oct 2018 10:01:20 +0000
Subject: [PATCH v2 5/5] target: stash sess_err_stats on Data-Out timeout
Message-Id: <20181012100120.2365-6-ddiss@suse.de>
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
 drivers/target/iscsi/iscsi_target_erl1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 7f3a1a06696e..a211e8154f4c 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1230,6 +1230,7 @@ void iscsit_handle_dataout_timeout(struct timer_list *t)
 
 failure:
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
+	iscsit_fill_cxn_timeout_err_stats(sess);
 	iscsit_cause_connection_reinstatement(conn, 0);
 	iscsit_dec_conn_usage_count(conn);
 }
-- 
2.13.7

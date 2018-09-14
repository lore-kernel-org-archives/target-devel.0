From: Colin King <colin.king@canonical.com>
Date: Fri, 14 Sep 2018 12:28:08 +0000
Subject: [PATCH] scsi: iscsi: target: fix spelling mistake "entires" -> "entries"
Message-Id: <20180914122808.5447-1-colin.king@canonical.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Nicholas A . Bellinger" <nab@linux-iscsi.org>, Bart Van Assche <bvanassche@acm.org>, target-devel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

Trivial fix to spelling mistake in function name and comment

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/target/iscsi/iscsi_target.c       | 2 +-
 drivers/target/iscsi/iscsi_target_erl2.c  | 2 +-
 drivers/target/iscsi/iscsi_target_erl2.h  | 2 +-
 drivers/target/iscsi/iscsi_target_login.c | 2 +-
 4 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index cc756a123fd8..c1d5a173553d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4355,7 +4355,7 @@ int iscsit_close_session(struct iscsi_session *sess)
 	transport_deregister_session(sess->se_sess);
 
 	if (sess->sess_ops->ErrorRecoveryLevel = 2)
-		iscsit_free_connection_recovery_entires(sess);
+		iscsit_free_connection_recovery_entries(sess);
 
 	iscsit_free_all_ooo_cmdsns(sess);
 
diff --git a/drivers/target/iscsi/iscsi_target_erl2.c b/drivers/target/iscsi/iscsi_target_erl2.c
index 8df9c90f3db3..b08b620b1bf0 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.c
+++ b/drivers/target/iscsi/iscsi_target_erl2.c
@@ -125,7 +125,7 @@ struct iscsi_conn_recovery *iscsit_get_inactive_connection_recovery_entry(
 	return NULL;
 }
 
-void iscsit_free_connection_recovery_entires(struct iscsi_session *sess)
+void iscsit_free_connection_recovery_entries(struct iscsi_session *sess)
 {
 	struct iscsi_cmd *cmd, *cmd_tmp;
 	struct iscsi_conn_recovery *cr, *cr_tmp;
diff --git a/drivers/target/iscsi/iscsi_target_erl2.h b/drivers/target/iscsi/iscsi_target_erl2.h
index 93e180d68d07..a39b0caf2337 100644
--- a/drivers/target/iscsi/iscsi_target_erl2.h
+++ b/drivers/target/iscsi/iscsi_target_erl2.h
@@ -13,7 +13,7 @@ extern void iscsit_create_conn_recovery_datain_values(struct iscsi_cmd *, __be32
 extern void iscsit_create_conn_recovery_dataout_values(struct iscsi_cmd *);
 extern struct iscsi_conn_recovery *iscsit_get_inactive_connection_recovery_entry(
 			struct iscsi_session *, u16);
-extern void iscsit_free_connection_recovery_entires(struct iscsi_session *);
+extern void iscsit_free_connection_recovery_entries(struct iscsi_session *);
 extern int iscsit_remove_active_connection_recovery_entry(
 			struct iscsi_conn_recovery *, struct iscsi_session *);
 extern int iscsit_remove_cmd_from_connection_recovery(struct iscsi_cmd *,
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index bb90c80ff388..ae3209efd0e0 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -578,7 +578,7 @@ int iscsi_login_post_auth_non_zero_tsih(
 	}
 
 	/*
-	 * Check for any connection recovery entires containing CID.
+	 * Check for any connection recovery entries containing CID.
 	 * We use the original ExpStatSN sent in the first login request
 	 * to acknowledge commands for the failed connection.
 	 *
-- 
2.17.1

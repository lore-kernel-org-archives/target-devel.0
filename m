From: David Disseldorp <ddiss@suse.de>
Date: Fri, 12 Oct 2018 10:01:16 +0000
Subject: [PATCH v2 1/5] target: use ISCSI_IQN_LEN in iscsi_target_stat
Message-Id: <20181012100120.2365-2-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Move the ISCSI_IQN_LEN definition up, so that it can be used in more
places instead of a hardcoded value.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_stat.c | 4 ++--
 include/target/iscsi/iscsi_target_core.h | 6 +++---
 include/target/iscsi/iscsi_target_stat.h | 4 ++--
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index df0a39811dc2..bb98882bdaa7 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -328,10 +328,10 @@ static ssize_t iscsi_stat_tgt_attr_fail_intr_name_show(struct config_item *item,
 {
 	struct iscsi_tiqn *tiqn = iscsi_tgt_attr_tiqn(item);
 	struct iscsi_login_stats *lstat = &tiqn->login_stats;
-	unsigned char buf[224];
+	unsigned char buf[ISCSI_IQN_LEN];
 
 	spin_lock(&lstat->lock);
-	snprintf(buf, 224, "%s", lstat->last_intr_fail_name[0] ?
+	snprintf(buf, ISCSI_IQN_LEN, "%s", lstat->last_intr_fail_name[0] ?
 				lstat->last_intr_fail_name : NONE);
 	spin_unlock(&lstat->lock);
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index f2e6abea8490..24c398f4a68f 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -25,6 +25,7 @@ struct sock;
 #define ISCSIT_TCP_BACKLOG		256
 #define ISCSI_RX_THREAD_NAME		"iscsi_trx"
 #define ISCSI_TX_THREAD_NAME		"iscsi_ttx"
+#define ISCSI_IQN_LEN			224
 
 /* struct iscsi_node_attrib sanity values */
 #define NA_DATAOUT_TIMEOUT		3
@@ -270,9 +271,9 @@ struct iscsi_conn_ops {
 };
 
 struct iscsi_sess_ops {
-	char	InitiatorName[224];
+	char	InitiatorName[ISCSI_IQN_LEN];
 	char	InitiatorAlias[256];
-	char	TargetName[224];
+	char	TargetName[ISCSI_IQN_LEN];
 	char	TargetAlias[256];
 	char	TargetAddress[256];
 	u16	TargetPortalGroupTag;		/* [0..65535] */
@@ -855,7 +856,6 @@ struct iscsi_wwn_stat_grps {
 };
 
 struct iscsi_tiqn {
-#define ISCSI_IQN_LEN				224
 	unsigned char		tiqn[ISCSI_IQN_LEN];
 	enum tiqn_state_table	tiqn_state;
 	int			tiqn_access_count;
diff --git a/include/target/iscsi/iscsi_target_stat.h b/include/target/iscsi/iscsi_target_stat.h
index 4d75a2c426ca..ff6a47209313 100644
--- a/include/target/iscsi/iscsi_target_stat.h
+++ b/include/target/iscsi/iscsi_target_stat.h
@@ -33,7 +33,7 @@ struct iscsi_sess_err_stats {
 	u32		cxn_timeout_errors;
 	u32		pdu_format_errors;
 	u32		last_sess_failure_type;
-	char		last_sess_fail_rem_name[224];
+	char		last_sess_fail_rem_name[ISCSI_IQN_LEN];
 } ____cacheline_aligned;
 
 /* iSCSI login failure types (sub oids) */
@@ -56,7 +56,7 @@ struct iscsi_login_stats {
 	u32		last_fail_type;
 	int		last_intr_fail_ip_family;
 	struct sockaddr_storage last_intr_fail_sockaddr;
-	char		last_intr_fail_name[224];
+	char		last_intr_fail_name[ISCSI_IQN_LEN];
 } ____cacheline_aligned;
 
 /* iSCSI logout stats */
-- 
2.13.7

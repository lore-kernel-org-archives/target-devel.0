From: David Disseldorp <ddiss@suse.de>
Date: Wed, 17 Oct 2018 15:48:18 +0000
Subject: [RFC PATCH 1/3] target: remove unused session digest-errors metric
Message-Id: <20181017154820.9722-2-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_stat.c | 14 +-------------
 include/target/iscsi/iscsi_target_stat.h |  2 --
 2 files changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index df0a39811dc2..ce60d123aa90 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -103,8 +103,7 @@ static ssize_t iscsi_stat_instance_fail_sess_show(struct config_item *item,
 	u32 sess_err_count;
 
 	spin_lock_bh(&sess_err->lock);
-	sess_err_count = (sess_err->digest_errors +
-			  sess_err->cxn_timeout_errors +
+	sess_err_count = (sess_err->cxn_timeout_errors +
 			  sess_err->pdu_format_errors);
 	spin_unlock_bh(&sess_err->lock);
 
@@ -209,15 +208,6 @@ static ssize_t iscsi_stat_sess_err_inst_show(struct config_item *item,
 		iscsi_sess_err_tiqn(item)->tiqn_index);
 }
 
-static ssize_t iscsi_stat_sess_err_digest_errors_show(struct config_item *item,
-		char *page)
-{
-	struct iscsi_tiqn *tiqn = iscsi_sess_err_tiqn(item);
-	struct iscsi_sess_err_stats *sess_err = &tiqn->sess_err_stats;
-
-	return snprintf(page, PAGE_SIZE, "%u\n", sess_err->digest_errors);
-}
-
 static ssize_t iscsi_stat_sess_err_cxn_errors_show(struct config_item *item,
 		char *page)
 {
@@ -237,13 +227,11 @@ static ssize_t iscsi_stat_sess_err_format_errors_show(struct config_item *item,
 }
 
 CONFIGFS_ATTR_RO(iscsi_stat_sess_err_, inst);
-CONFIGFS_ATTR_RO(iscsi_stat_sess_err_, digest_errors);
 CONFIGFS_ATTR_RO(iscsi_stat_sess_err_, cxn_errors);
 CONFIGFS_ATTR_RO(iscsi_stat_sess_err_, format_errors);
 
 static struct configfs_attribute *iscsi_stat_sess_err_attrs[] = {
 	&iscsi_stat_sess_err_attr_inst,
-	&iscsi_stat_sess_err_attr_digest_errors,
 	&iscsi_stat_sess_err_attr_cxn_errors,
 	&iscsi_stat_sess_err_attr_format_errors,
 	NULL,
diff --git a/include/target/iscsi/iscsi_target_stat.h b/include/target/iscsi/iscsi_target_stat.h
index 4d75a2c426ca..b2d0f190483d 100644
--- a/include/target/iscsi/iscsi_target_stat.h
+++ b/include/target/iscsi/iscsi_target_stat.h
@@ -22,14 +22,12 @@ extern const struct config_item_type iscsi_stat_sess_cit;
 
 /* iSCSI session error types */
 #define ISCSI_SESS_ERR_UNKNOWN		0
-#define ISCSI_SESS_ERR_DIGEST		1
 #define ISCSI_SESS_ERR_CXN_TIMEOUT	2
 #define ISCSI_SESS_ERR_PDU_FORMAT	3
 
 /* iSCSI session error stats */
 struct iscsi_sess_err_stats {
 	spinlock_t	lock;
-	u32		digest_errors;
 	u32		cxn_timeout_errors;
 	u32		pdu_format_errors;
 	u32		last_sess_failure_type;
-- 
2.13.7

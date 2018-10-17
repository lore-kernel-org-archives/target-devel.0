From: David Disseldorp <ddiss@suse.de>
Date: Wed, 17 Oct 2018 15:48:19 +0000
Subject: [RFC PATCH 2/3] target: remove unused session PDU-format-errors metric
Message-Id: <20181017154820.9722-3-ddiss@suse.de>
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
index ce60d123aa90..645c26f888cf 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -103,8 +103,7 @@ static ssize_t iscsi_stat_instance_fail_sess_show(struct config_item *item,
 	u32 sess_err_count;
 
 	spin_lock_bh(&sess_err->lock);
-	sess_err_count = (sess_err->cxn_timeout_errors +
-			  sess_err->pdu_format_errors);
+	sess_err_count = sess_err->cxn_timeout_errors;
 	spin_unlock_bh(&sess_err->lock);
 
 	return snprintf(page, PAGE_SIZE, "%u\n", sess_err_count);
@@ -217,23 +216,12 @@ static ssize_t iscsi_stat_sess_err_cxn_errors_show(struct config_item *item,
 	return snprintf(page, PAGE_SIZE, "%u\n", sess_err->cxn_timeout_errors);
 }
 
-static ssize_t iscsi_stat_sess_err_format_errors_show(struct config_item *item,
-		char *page)
-{
-	struct iscsi_tiqn *tiqn = iscsi_sess_err_tiqn(item);
-	struct iscsi_sess_err_stats *sess_err = &tiqn->sess_err_stats;
-
-	return snprintf(page, PAGE_SIZE, "%u\n", sess_err->pdu_format_errors);
-}
-
 CONFIGFS_ATTR_RO(iscsi_stat_sess_err_, inst);
 CONFIGFS_ATTR_RO(iscsi_stat_sess_err_, cxn_errors);
-CONFIGFS_ATTR_RO(iscsi_stat_sess_err_, format_errors);
 
 static struct configfs_attribute *iscsi_stat_sess_err_attrs[] = {
 	&iscsi_stat_sess_err_attr_inst,
 	&iscsi_stat_sess_err_attr_cxn_errors,
-	&iscsi_stat_sess_err_attr_format_errors,
 	NULL,
 };
 
diff --git a/include/target/iscsi/iscsi_target_stat.h b/include/target/iscsi/iscsi_target_stat.h
index b2d0f190483d..2e32b934a678 100644
--- a/include/target/iscsi/iscsi_target_stat.h
+++ b/include/target/iscsi/iscsi_target_stat.h
@@ -23,13 +23,11 @@ extern const struct config_item_type iscsi_stat_sess_cit;
 /* iSCSI session error types */
 #define ISCSI_SESS_ERR_UNKNOWN		0
 #define ISCSI_SESS_ERR_CXN_TIMEOUT	2
-#define ISCSI_SESS_ERR_PDU_FORMAT	3
 
 /* iSCSI session error stats */
 struct iscsi_sess_err_stats {
 	spinlock_t	lock;
 	u32		cxn_timeout_errors;
-	u32		pdu_format_errors;
 	u32		last_sess_failure_type;
 	char		last_sess_fail_rem_name[224];
 } ____cacheline_aligned;
-- 
2.13.7

From: David Disseldorp <ddiss@suse.de>
Date: Wed, 17 Oct 2018 15:48:20 +0000
Subject: [RFC PATCH 3/3] target: remove cumulative session errors metric
Message-Id: <20181017154820.9722-4-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The cumulative session errors metric matches cxn_timeout_errors, so drop
the duplicate.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_stat.c | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index 645c26f888cf..94b6f5ad48a4 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -95,20 +95,6 @@ static ssize_t iscsi_stat_instance_sessions_show(struct config_item *item,
 		iscsi_instance_tiqn(item)->tiqn_nsessions);
 }
 
-static ssize_t iscsi_stat_instance_fail_sess_show(struct config_item *item,
-		char *page)
-{
-	struct iscsi_tiqn *tiqn = iscsi_instance_tiqn(item);
-	struct iscsi_sess_err_stats *sess_err = &tiqn->sess_err_stats;
-	u32 sess_err_count;
-
-	spin_lock_bh(&sess_err->lock);
-	sess_err_count = sess_err->cxn_timeout_errors;
-	spin_unlock_bh(&sess_err->lock);
-
-	return snprintf(page, PAGE_SIZE, "%u\n", sess_err_count);
-}
-
 static ssize_t iscsi_stat_instance_fail_type_show(struct config_item *item,
 		char *page)
 {
@@ -160,7 +146,6 @@ CONFIGFS_ATTR_RO(iscsi_stat_instance_, max_ver);
 CONFIGFS_ATTR_RO(iscsi_stat_instance_, portals);
 CONFIGFS_ATTR_RO(iscsi_stat_instance_, nodes);
 CONFIGFS_ATTR_RO(iscsi_stat_instance_, sessions);
-CONFIGFS_ATTR_RO(iscsi_stat_instance_, fail_sess);
 CONFIGFS_ATTR_RO(iscsi_stat_instance_, fail_type);
 CONFIGFS_ATTR_RO(iscsi_stat_instance_, fail_rem_name);
 CONFIGFS_ATTR_RO(iscsi_stat_instance_, disc_time);
@@ -175,7 +160,6 @@ static struct configfs_attribute *iscsi_stat_instance_attrs[] = {
 	&iscsi_stat_instance_attr_portals,
 	&iscsi_stat_instance_attr_nodes,
 	&iscsi_stat_instance_attr_sessions,
-	&iscsi_stat_instance_attr_fail_sess,
 	&iscsi_stat_instance_attr_fail_type,
 	&iscsi_stat_instance_attr_fail_rem_name,
 	&iscsi_stat_instance_attr_disc_time,
-- 
2.13.7

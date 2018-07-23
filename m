From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:51 +0000
Subject: [PATCH 9/9] tcmu: use u64 for dev_size
Message-Id: <1532372871-7128-10-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

We use unsigned long, size_t and u64 for dev_size. This has us
standardize on u64.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index cfe4f4b..b34179a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -137,7 +137,7 @@ struct tcmu_dev {
 	struct inode *inode;
 
 	struct tcmu_mailbox *mb_addr;
-	size_t dev_size;
+	uint64_t dev_size;
 	u32 cmdr_size;
 	u32 cmdr_last_cleaned;
 	/* Offset of data area from start of mb */
@@ -2016,7 +2016,7 @@ enum {
 
 static match_table_t tokens = {
 	{Opt_dev_config, "dev_config=%s"},
-	{Opt_dev_size, "dev_size=%u"},
+	{Opt_dev_size, "dev_size=%s"},
 	{Opt_hw_block_size, "hw_block_size=%d"},
 	{Opt_hw_max_sectors, "hw_max_sectors=%d"},
 	{Opt_nl_reply_supported, "nl_reply_supported=%d"},
@@ -2083,7 +2083,7 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 		const char *page, ssize_t count)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
-	char *orig, *ptr, *opts, *arg_p;
+	char *orig, *ptr, *opts;
 	substring_t args[MAX_OPT_ARGS];
 	int ret = 0, token;
 
@@ -2108,15 +2108,10 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 			pr_debug("TCMU: Referencing Path: %s\n", udev->dev_config);
 			break;
 		case Opt_dev_size:
-			arg_p = match_strdup(&args[0]);
-			if (!arg_p) {
-				ret = -ENOMEM;
-				break;
-			}
-			ret = kstrtoul(arg_p, 0, (unsigned long *) &udev->dev_size);
-			kfree(arg_p);
+			ret = match_u64(&args[0], &udev->dev_size);
 			if (ret < 0)
-				pr_err("kstrtoul() failed for dev_size=\n");
+				pr_err("match_u64() failed for dev_size=. Error %d.\n",
+				       ret);
 			break;
 		case Opt_hw_block_size:
 			ret = tcmu_set_dev_attrib(&args[0],
@@ -2154,7 +2149,7 @@ static ssize_t tcmu_show_configfs_dev_params(struct se_device *dev, char *b)
 
 	bl = sprintf(b + bl, "Config: %s ",
 		     udev->dev_config[0] ? udev->dev_config : "NULL");
-	bl += sprintf(b + bl, "Size: %zu ", udev->dev_size);
+	bl += sprintf(b + bl, "Size: %llu ", udev->dev_size);
 	bl += sprintf(b + bl, "MaxDataAreaMB: %u\n",
 		      TCMU_BLOCKS_TO_MBS(udev->max_blocks));
 
@@ -2323,7 +2318,7 @@ static ssize_t tcmu_dev_size_show(struct config_item *item, char *page)
 						struct se_dev_attrib, da_group);
 	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
 
-	return snprintf(page, PAGE_SIZE, "%zu\n", udev->dev_size);
+	return snprintf(page, PAGE_SIZE, "%llu\n", udev->dev_size);
 }
 
 static int tcmu_send_dev_size_event(struct tcmu_dev *udev, u64 size)
-- 
1.8.3.1


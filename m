From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:50 +0000
Subject: [PATCH 8/9] tcmu: use match_int for dev params
Message-Id: <1532372871-7128-9-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of doing strdup and kstrto* just use match_int for dev params.

It will be ok to use int instead of unsigned long in tcmu_set_dev_attrib
because that is only being used for max sectors and block size and the
supported values for them are well under the max possible integer value.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 969ccba..cfe4f4b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2017,8 +2017,8 @@ enum {
 static match_table_t tokens = {
 	{Opt_dev_config, "dev_config=%s"},
 	{Opt_dev_size, "dev_size=%u"},
-	{Opt_hw_block_size, "hw_block_size=%u"},
-	{Opt_hw_max_sectors, "hw_max_sectors=%u"},
+	{Opt_hw_block_size, "hw_block_size=%d"},
+	{Opt_hw_max_sectors, "hw_max_sectors=%d"},
 	{Opt_nl_reply_supported, "nl_reply_supported=%d"},
 	{Opt_max_data_area_mb, "max_data_area_mb=%d"},
 	{Opt_err, NULL}
@@ -2026,25 +2026,21 @@ enum {
 
 static int tcmu_set_dev_attrib(substring_t *arg, u32 *dev_attrib)
 {
-	unsigned long tmp_ul;
-	char *arg_p;
-	int ret;
-
-	arg_p = match_strdup(arg);
-	if (!arg_p)
-		return -ENOMEM;
+	int val, ret;
 
-	ret = kstrtoul(arg_p, 0, &tmp_ul);
-	kfree(arg_p);
+	ret = match_int(arg, &val);
 	if (ret < 0) {
-		pr_err("kstrtoul() failed for dev attrib\n");
+		pr_err("match_int() failed for dev attrib. Error %d.\n",
+		       ret);
 		return ret;
 	}
-	if (!tmp_ul) {
-		pr_err("dev attrib must be nonzero\n");
+
+	if (val <= 0) {
+		pr_err("Invalid dev attrib value %d. Must be greater than zero.\n",
+		       val);
 		return -EINVAL;
 	}
-	*dev_attrib = tmp_ul;
+	*dev_attrib = val;
 	return 0;
 }
 
@@ -2131,15 +2127,10 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 					&(dev->dev_attrib.hw_max_sectors));
 			break;
 		case Opt_nl_reply_supported:
-			arg_p = match_strdup(&args[0]);
-			if (!arg_p) {
-				ret = -ENOMEM;
-				break;
-			}
-			ret = kstrtoint(arg_p, 0, &udev->nl_reply_supported);
-			kfree(arg_p);
+			ret = match_int(&args[0], &udev->nl_reply_supported);
 			if (ret < 0)
-				pr_err("kstrtoint() failed for nl_reply_supported=\n");
+				pr_err("match_int() failed for nl_reply_supported=. Error %d.\n",
+				       ret);
 			break;
 		case Opt_max_data_area_mb:
 			ret = tcmu_set_max_blocks_param(udev, &args[0]);
-- 
1.8.3.1


From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:49 +0000
Subject: [PATCH 7/9] tcmu: do not set max_blocks if data_bitmap has been setup
Message-Id: <1532372871-7128-8-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch prevents a bug where data_bitmap is allocated in
tcmu_configure_device, userspace changes the max_blocks setting, the
device is mapped to a LUN, then we try to access the data_bitmap based
on the new max_blocks limit which may now be out of range.

To prevent this, we just check if data_bitmap has been setup. If it has
then we fail the max_blocks update operation.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 73 +++++++++++++++++++++------------------
 1 file changed, 40 insertions(+), 33 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 31cfe83..969ccba 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1811,9 +1811,11 @@ static int tcmu_configure_device(struct se_device *dev)
 
 	info = &udev->uio_info;
 
+	mutex_lock(&udev->cmdr_lock);
 	udev->data_bitmap = kcalloc(BITS_TO_LONGS(udev->max_blocks),
 				    sizeof(unsigned long),
 				    GFP_KERNEL);
+	mutex_unlock(&udev->cmdr_lock);
 	if (!udev->data_bitmap) {
 		ret = -ENOMEM;
 		goto err_bitmap_alloc;
@@ -2018,7 +2020,7 @@ enum {
 	{Opt_hw_block_size, "hw_block_size=%u"},
 	{Opt_hw_max_sectors, "hw_max_sectors=%u"},
 	{Opt_nl_reply_supported, "nl_reply_supported=%d"},
-	{Opt_max_data_area_mb, "max_data_area_mb=%u"},
+	{Opt_max_data_area_mb, "max_data_area_mb=%d"},
 	{Opt_err, NULL}
 };
 
@@ -2046,13 +2048,48 @@ static int tcmu_set_dev_attrib(substring_t *arg, u32 *dev_attrib)
 	return 0;
 }
 
+static int tcmu_set_max_blocks_param(struct tcmu_dev *udev, substring_t *arg)
+{
+	int val, ret;
+
+	ret = match_int(arg, &val);
+	if (ret < 0) {
+		pr_err("match_int() failed for max_data_area_mb=. Error %d.\n",
+		       ret);
+		return ret;
+	}
+
+	if (val <= 0) {
+		pr_err("Invalid max_data_area %d.\n", val);
+		return -EINVAL;
+	}
+
+	mutex_lock(&udev->cmdr_lock);
+	if (udev->data_bitmap) {
+		pr_err("Cannot set max_data_area_mb after it has been enabled.\n");
+		ret = -EINVAL;
+		goto unlock;
+	}
+
+	udev->max_blocks = TCMU_MBS_TO_BLOCKS(val);
+	if (udev->max_blocks > tcmu_global_max_blocks) {
+		pr_err("%d is too large. Adjusting max_data_area_mb to global limit of %u\n",
+		       val, TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
+		udev->max_blocks = tcmu_global_max_blocks;
+	}
+
+unlock:
+	mutex_unlock(&udev->cmdr_lock);
+	return ret;
+}
+
 static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 		const char *page, ssize_t count)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
 	char *orig, *ptr, *opts, *arg_p;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, token, tmpval;
+	int ret = 0, token;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -2105,37 +2142,7 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 				pr_err("kstrtoint() failed for nl_reply_supported=\n");
 			break;
 		case Opt_max_data_area_mb:
-			if (dev->export_count) {
-				pr_err("Unable to set max_data_area_mb while exports exist\n");
-				ret = -EINVAL;
-				break;
-			}
-
-			arg_p = match_strdup(&args[0]);
-			if (!arg_p) {
-				ret = -ENOMEM;
-				break;
-			}
-			ret = kstrtoint(arg_p, 0, &tmpval);
-			kfree(arg_p);
-			if (ret < 0) {
-				pr_err("kstrtoint() failed for max_data_area_mb=\n");
-				break;
-			}
-
-			if (tmpval <= 0) {
-				pr_err("Invalid max_data_area %d\n", tmpval);
-				ret = -EINVAL;
-				break;
-			}
-
-			udev->max_blocks = TCMU_MBS_TO_BLOCKS(tmpval);
-			if (udev->max_blocks > tcmu_global_max_blocks) {
-				pr_err("%d is too large. Adjusting max_data_area_mb to global limit of %u\n",
-				       tmpval,
-				       TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
-				udev->max_blocks = tcmu_global_max_blocks;
-			}
+			ret = tcmu_set_max_blocks_param(udev, &args[0]);
 			break;
 		default:
 			break;
-- 
1.8.3.1


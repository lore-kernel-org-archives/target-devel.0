From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Date: Thu, 14 Sep 2017 09:03:09 +0000
Subject: [PATCH v2] target/tcmu: Add a timeout for the completion of netlink command reply
Message-Id: <20170914090309.22297-1-nakayamakenjiro@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch adds a timeout for the completion of netlink command reply.

Current code waits for the netlink reply from userspace and the status
change, but it hangs forever when userspace failed to reply. To fix
this issue, this patch replace wait_for_completion with
wait_for_completion_timeout.

Default timeout is 300 sec that gives enough time, and this is
configurable via configfs.

Changes in v2:

        Makes default timeout enough long as 300 sec.
        Makes timeout configurable via configfs.
        Suggested by Mike Christie.

Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
---
 drivers/target/target_core_user.c | 59 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 56 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 942d094269fb..ef8570cb68a8 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -150,6 +150,9 @@ struct tcmu_dev {
 	wait_queue_head_t nl_cmd_wq;
 
 	char dev_config[TCMU_CONFIG_LEN];
+
+	/* timeout for netlink reply from userspace */
+	unsigned int nl_timeout;
 };
 
 #define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev, se_dev)
@@ -1332,8 +1335,14 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 	if (!tcmu_kern_cmd_reply_supported)
 		return 0;
 
-	pr_debug("sleeping for nl reply\n");
-	wait_for_completion(&nl_cmd->complete);
+	pr_debug("sleeping for nl reply with timeout %lu\n",
+			msecs_to_jiffies(udev->nl_timeout));
+	ret = wait_for_completion_timeout(&nl_cmd->complete,
+			msecs_to_jiffies(udev->nl_timeout));
+	if (!ret) {
+		printk(KERN_ERR "timeout waiting for nl reply from userspace\n");
+		return -ETIME;
+	}
 
 	spin_lock(&udev->nl_cmd_lock);
 	nl_cmd->cmd = TCMU_CMD_UNSPEC;
@@ -1506,6 +1515,10 @@ static int tcmu_configure_device(struct se_device *dev)
 		dev->dev_attrib.emulate_write_cache = 0;
 	dev->dev_attrib.hw_queue_depth = 128;
 
+	/* Set default timeout 300 sec */
+	if (!udev->nl_timeout)
+		udev->nl_timeout = 300000;
+
 	/*
 	 * Get a ref incase userspace does a close on the uio device before
 	 * LIO has initiated tcmu_free_device.
@@ -1610,7 +1623,7 @@ static void tcmu_destroy_device(struct se_device *dev)
 
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
-	Opt_err,
+	Opt_nl_timeout, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -1618,6 +1631,7 @@ static match_table_t tokens = {
 	{Opt_dev_size, "dev_size=%u"},
 	{Opt_hw_block_size, "hw_block_size=%u"},
 	{Opt_hw_max_sectors, "hw_max_sectors=%u"},
+	{Opt_nl_timeout, "nl_timeout=%u"},
 	{Opt_err, NULL}
 };
 
@@ -1692,6 +1706,17 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 			ret = tcmu_set_dev_attrib(&args[0],
 					&(dev->dev_attrib.hw_max_sectors));
 			break;
+		case Opt_nl_timeout:
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			ret = kstrtou32(arg_p, 0, &udev->nl_timeout);
+			kfree(arg_p);
+			if (ret < 0)
+				pr_err("kstrtoul() failed for nl_timeout=\n");
+			break;
 		default:
 			break;
 		}
@@ -1879,11 +1904,39 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
+static ssize_t tcmu_nl_timeout_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+		       struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%u\n", udev->nl_timeout);
+}
+
+static ssize_t tcmu_nl_timeout_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+			struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+	u32 val;
+	int ret;
+
+	ret = kstrtou32(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	udev->nl_timeout = val;
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, nl_timeout);
+
 static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_cmd_time_out,
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
+	&tcmu_attr_nl_timeout,
 	NULL,
 };
 
-- 
2.13.5


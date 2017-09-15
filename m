From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
Date: Fri, 15 Sep 2017 07:17:13 +0000
Subject: [PATCH v3] target/tcmu: Add a timeout for the completion of netlink command reply
Message-Id: <20170915071713.13758-1-nakayamakenjiro@gmail.com>
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

Changes since v1(suggested by Mike Christie):
v2: - Makes default timeout enough long as 300 sec.
    - Makes timeout configurable via configfs.
v3: - Reinit command status and wake up other calls waiting after
      timeout.
    - Use timeout in seconds.

Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
---
 drivers/target/target_core_user.c | 65 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 61 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 942d094269fb..63d01d15d67c 100644
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
@@ -1327,17 +1330,24 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
 {
 	struct tcmu_nl_cmd *nl_cmd = &udev->curr_nl_cmd;
 	int ret;
+	unsigned long timeout_hz;
 	DEFINE_WAIT(__wait);
 
 	if (!tcmu_kern_cmd_reply_supported)
 		return 0;
 
-	pr_debug("sleeping for nl reply\n");
-	wait_for_completion(&nl_cmd->complete);
+	timeout_hz = msecs_to_jiffies(udev->nl_timeout);
+	pr_debug("sleeping for nl reply with timeout %lu\n", timeout_hz);
+	ret = wait_for_completion_timeout(&nl_cmd->complete, timeout_hz);
+	if (!ret) {
+		printk(KERN_ERR "timeout waiting for nl reply from userspace\n");
+		ret = -ETIME;
+	}
 
 	spin_lock(&udev->nl_cmd_lock);
 	nl_cmd->cmd = TCMU_CMD_UNSPEC;
-	ret = nl_cmd->status;
+	if (ret > 0)
+		ret = nl_cmd->status;
 	nl_cmd->status = 0;
 	spin_unlock(&udev->nl_cmd_lock);
 
@@ -1506,6 +1516,10 @@ static int tcmu_configure_device(struct se_device *dev)
 		dev->dev_attrib.emulate_write_cache = 0;
 	dev->dev_attrib.hw_queue_depth = 128;
 
+	/* Set default timeout 300 sec */
+	if (!udev->nl_timeout)
+		udev->nl_timeout = 300 * MSEC_PER_SEC;
+
 	/*
 	 * Get a ref incase userspace does a close on the uio device before
 	 * LIO has initiated tcmu_free_device.
@@ -1610,7 +1624,7 @@ static void tcmu_destroy_device(struct se_device *dev)
 
 enum {
 	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
-	Opt_err,
+	Opt_nl_timeout, Opt_err,
 };
 
 static match_table_t tokens = {
@@ -1618,6 +1632,7 @@ static match_table_t tokens = {
 	{Opt_dev_size, "dev_size=%u"},
 	{Opt_hw_block_size, "hw_block_size=%u"},
 	{Opt_hw_max_sectors, "hw_max_sectors=%u"},
+	{Opt_nl_timeout, "nl_timeout=%u"},
 	{Opt_err, NULL}
 };
 
@@ -1652,6 +1667,7 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 	char *orig, *ptr, *opts, *arg_p;
 	substring_t args[MAX_OPT_ARGS];
 	int ret = 0, token;
+	u32 val;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -1692,6 +1708,18 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
 			ret = tcmu_set_dev_attrib(&args[0],
 					&(dev->dev_attrib.hw_max_sectors));
 			break;
+		case Opt_nl_timeout:
+			arg_p = match_strdup(&args[0]);
+			if (!arg_p) {
+				ret = -ENOMEM;
+				break;
+			}
+			ret = kstrtou32(arg_p, 0, &val);
+			kfree(arg_p);
+			if (ret < 0)
+				pr_err("kstrtoul() failed for nl_timeout=\n");
+			udev->nl_timeout = val * MSEC_PER_SEC;
+			break;
 		default:
 			break;
 		}
@@ -1879,11 +1907,40 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
+static ssize_t tcmu_nl_timeout_show(struct config_item *item, char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+		       struct se_dev_attrib, da_group);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%lu\n",
+			udev->nl_timeout / MSEC_PER_SEC);
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
+	udev->nl_timeout = val * MSEC_PER_SEC;
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


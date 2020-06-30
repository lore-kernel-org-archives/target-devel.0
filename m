From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 30 Jun 2020 10:47:09 +0000
Subject: [RFC PATCH 8/8] scsi: target: tcmu: Make TMR notification optional
Message-Id: <20200630104709.23066-9-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

Add "tmr_notification" configFS attribute to tcmu devices.
If default value 0 of the attribute is used, tcmu only
removes aborted commands from qfull_queue.
If user changes tmr_notification to 1, additionally
TMR notifications will be written to the cmd ring.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 8d69cfa125b2..1082c5882dc6 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -118,6 +118,7 @@ struct tcmu_dev {
 #define TCMU_DEV_BIT_OPEN 0
 #define TCMU_DEV_BIT_BROKEN 1
 #define TCMU_DEV_BIT_BLOCKED 2
+#define TCMU_DEV_BIT_TMR_NOTIFY 3
 	unsigned long flags;
 
 	struct uio_info uio_info;
@@ -1261,6 +1262,9 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
 	if (unqueued)
 		tcmu_set_next_deadline(&dev->qfull_queue, &dev->qfull_timer);
 
+	if (!test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags))
+		goto unlock;
+
 	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
 		 tcmu_tmr_type(tmf), dev->name, i, cmd_cnt);
 
@@ -2707,6 +2711,40 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 }
 CONFIGFS_ATTR(tcmu_, emulate_write_cache);
 
+static ssize_t tcmu_tmr_notification_show(struct config_item *item,
+					     char *page)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+	struct tcmu_dev *dev = TCMU_DEV(da->da_dev);
+
+	return snprintf(page, PAGE_SIZE, "%i\n",
+			test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags));
+}
+
+static ssize_t tcmu_tmr_notification_store(struct config_item *item,
+					   const char *page, size_t count)
+{
+	struct se_dev_attrib *da = container_of(to_config_group(item),
+					struct se_dev_attrib, da_group);
+	struct tcmu_dev *dev = TCMU_DEV(da->da_dev);
+	u8 val;
+	int ret;
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+	if (val > 1)
+		return -EINVAL;
+
+	if (val)
+		set_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags);
+	else
+		clear_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags);
+	return count;
+}
+CONFIGFS_ATTR(tcmu_, tmr_notification);
+
 static ssize_t tcmu_block_dev_show(struct config_item *item, char *page)
 {
 	struct se_device *se_dev = container_of(to_config_group(item),
@@ -2788,6 +2826,7 @@ static struct configfs_attribute *tcmu_attrib_attrs[] = {
 	&tcmu_attr_dev_config,
 	&tcmu_attr_dev_size,
 	&tcmu_attr_emulate_write_cache,
+	&tcmu_attr_tmr_notification,
 	&tcmu_attr_nl_reply_supported,
 	NULL,
 };
-- 
2.12.3

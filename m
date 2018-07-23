From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:45 +0000
Subject: [PATCH 3/9] target: add helper to check if dev is configured
Message-Id: <1532372871-7128-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This just adds a helper function to check if a device is configured and
it converts the target users to use it. The next patch will add a
backend module user so those types of modules do not have to know the
lio core details.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_configfs.c        | 8 ++++----
 drivers/target/target_core_device.c          | 6 +++---
 drivers/target/target_core_fabric_configfs.c | 3 ++-
 include/target/target_core_backend.h         | 4 ++++
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 93d3ff3..f6b1549 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -810,7 +810,7 @@ static ssize_t pi_prot_type_store(struct config_item *item,
 		       dev->transport->name);
 		return -ENOSYS;
 	}
-	if (!(dev->dev_flags & DF_CONFIGURED)) {
+	if (!target_dev_configured(dev)) {
 		pr_err("DIF protection requires device to be configured\n");
 		return -ENODEV;
 	}
@@ -859,7 +859,7 @@ static ssize_t pi_prot_format_store(struct config_item *item,
 		       dev->transport->name);
 		return -ENOSYS;
 	}
-	if (!(dev->dev_flags & DF_CONFIGURED)) {
+	if (!target_dev_configured(dev)) {
 		pr_err("DIF protection format requires device to be configured\n");
 		return -ENODEV;
 	}
@@ -1948,7 +1948,7 @@ static ssize_t target_dev_enable_show(struct config_item *item, char *page)
 {
 	struct se_device *dev = to_device(item);
 
-	return snprintf(page, PAGE_SIZE, "%d\n", !!(dev->dev_flags & DF_CONFIGURED));
+	return snprintf(page, PAGE_SIZE, "%d\n", target_dev_configured(dev));
 }
 
 static ssize_t target_dev_enable_store(struct config_item *item,
@@ -2473,7 +2473,7 @@ static ssize_t target_tg_pt_gp_alua_access_state_store(struct config_item *item,
 			" tg_pt_gp ID: %hu\n", tg_pt_gp->tg_pt_gp_valid_id);
 		return -EINVAL;
 	}
-	if (!(dev->dev_flags & DF_CONFIGURED)) {
+	if (!target_dev_configured(dev)) {
 		pr_err("Unable to set alua_access_state while device is"
 		       " not configured\n");
 		return -ENODEV;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 73675ee..47b5ef1 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -900,7 +900,7 @@ static int target_devices_idr_iter(int id, void *p, void *data)
 	 * to allow other callers to access partially setup devices,
 	 * so we skip them here.
 	 */
-	if (!(dev->dev_flags & DF_CONFIGURED))
+	if (!target_dev_configured(dev))
 		return 0;
 
 	iter->prev_item = config_item_get_unless_zero(&dev->dev_group.cg_item);
@@ -940,7 +940,7 @@ int target_configure_device(struct se_device *dev)
 	struct se_hba *hba = dev->se_hba;
 	int ret, id;
 
-	if (dev->dev_flags & DF_CONFIGURED) {
+	if (target_dev_configured(dev)) {
 		pr_err("se_dev->se_dev_ptr already set for storage"
 				" object\n");
 		return -EEXIST;
@@ -1045,7 +1045,7 @@ void target_free_device(struct se_device *dev)
 
 	WARN_ON(!list_empty(&dev->dev_sep_list));
 
-	if (dev->dev_flags & DF_CONFIGURED) {
+	if (target_dev_configured(dev)) {
 		destroy_workqueue(dev->tmr_wq);
 
 		dev->transport->destroy_device(dev);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 1fa436e..aa2f4f6 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -34,6 +34,7 @@
 #include <linux/configfs.h>
 
 #include <target/target_core_base.h>
+#include <target/target_core_backend.h>
 #include <target/target_core_fabric.h>
 
 #include "target_core_internal.h"
@@ -642,7 +643,7 @@ static int target_fabric_port_link(
 	}
 	dev = container_of(to_config_group(se_dev_ci), struct se_device, dev_group);
 
-	if (!(dev->dev_flags & DF_CONFIGURED)) {
+	if (!target_dev_configured(dev)) {
 		pr_err("se_device not configured yet, cannot port link\n");
 		return -ENODEV;
 	}
diff --git a/include/target/target_core_backend.h b/include/target/target_core_backend.h
index c3ac472..51b6f50 100644
--- a/include/target/target_core_backend.h
+++ b/include/target/target_core_backend.h
@@ -111,6 +111,10 @@ sense_reason_t passthrough_parse_cdb(struct se_cmd *cmd,
 bool target_configure_unmap_from_queue(struct se_dev_attrib *attrib,
 				       struct request_queue *q);
 
+static inline bool target_dev_configured(struct se_device *se_dev)
+{
+	return !!(se_dev->dev_flags & DF_CONFIGURED);
+}
 
 /* Only use get_unaligned_be24() if reading p - 1 is allowed. */
 static inline uint32_t get_unaligned_be24(const uint8_t *const p)
-- 
1.8.3.1


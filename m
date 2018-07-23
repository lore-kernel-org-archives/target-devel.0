From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:46 +0000
Subject: [PATCH 4/9] tcmu: use lio core se_device configuration helper
Message-Id: <1532372871-7128-5-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Use the lio core helper to check if the device is configured.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index b010ed7..bc8121f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1908,11 +1908,6 @@ static int tcmu_configure_device(struct se_device *dev)
 	return ret;
 }
 
-static bool tcmu_dev_configured(struct tcmu_dev *udev)
-{
-	return udev->uio_info.uio_dev ? true : false;
-}
-
 static void tcmu_free_device(struct se_device *dev)
 {
 	struct tcmu_dev *udev = TCMU_DEV(dev);
@@ -2305,7 +2300,7 @@ static ssize_t tcmu_dev_config_store(struct config_item *item, const char *page,
 		return -EINVAL;
 
 	/* Check if device has been configured before */
-	if (tcmu_dev_configured(udev)) {
+	if (target_dev_configured(&udev->se_dev)) {
 		ret = tcmu_send_dev_config_event(udev, page);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
@@ -2367,7 +2362,7 @@ static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
 		return ret;
 
 	/* Check if device has been configured before */
-	if (tcmu_dev_configured(udev)) {
+	if (target_dev_configured(&udev->se_dev)) {
 		ret = tcmu_send_dev_size_event(udev, val);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
@@ -2449,7 +2444,7 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
 		return ret;
 
 	/* Check if device has been configured before */
-	if (tcmu_dev_configured(udev)) {
+	if (target_dev_configured(&udev->se_dev)) {
 		ret = tcmu_send_emulate_write_cache(udev, val);
 		if (ret) {
 			pr_err("Unable to reconfigure device\n");
-- 
1.8.3.1


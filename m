From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:47 +0000
Subject: [PATCH 5/9] tcmu: check if dev is configured before block/reset
Message-Id: <1532372871-7128-6-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Do not allow userspace to block or reset the ring until the device has
been configured. This will prevent the bug where userspace can write to
those files and access mb_addr before it has been setup.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index bc8121f..d6b4022 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2480,6 +2480,11 @@ static ssize_t tcmu_block_dev_store(struct config_item *item, const char *page,
 	u8 val;
 	int ret;
 
+	if (!target_dev_configured(&udev->se_dev)) {
+		pr_err("Device is not configured.\n");
+		return -EINVAL;
+	}
+
 	ret = kstrtou8(page, 0, &val);
 	if (ret < 0)
 		return ret;
@@ -2507,6 +2512,11 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
 	u8 val;
 	int ret;
 
+	if (!target_dev_configured(&udev->se_dev)) {
+		pr_err("Device is not configured.\n");
+		return -EINVAL;
+	}
+
 	ret = kstrtou8(page, 0, &val);
 	if (ret < 0)
 		return ret;
-- 
1.8.3.1


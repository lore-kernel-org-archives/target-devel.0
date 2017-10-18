From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Oct 2017 18:27:40 +0000
Subject: [PATCH 3/3] tcmu: Use macro to call container_of in tcmu_cmd_time_out_show
Message-Id: <1508351260-6646-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Kenjiro Nakayama <nakayamakenjiro@gmail.com>

This patch makes a tiny change that using TCMU_DEV in
tcmu_cmd_time_out_show so it is consistent with other functions.

Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
[added missing tcmu_cmd_time_out_store conversion]
Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 2ee551a..43e4b24 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1839,8 +1839,7 @@ static ssize_t tcmu_cmd_time_out_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
 					struct se_dev_attrib, da_group);
-	struct tcmu_dev *udev = container_of(da->da_dev,
-					struct tcmu_dev, se_dev);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
 
 	return snprintf(page, PAGE_SIZE, "%lu\n", udev->cmd_time_out / MSEC_PER_SEC);
 }
@@ -1850,8 +1849,7 @@ static ssize_t tcmu_cmd_time_out_store(struct config_item *item, const char *pag
 {
 	struct se_dev_attrib *da = container_of(to_config_group(item),
 					struct se_dev_attrib, da_group);
-	struct tcmu_dev *udev = container_of(da->da_dev,
-					struct tcmu_dev, se_dev);
+	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
 	u32 val;
 	int ret;
 
-- 
2.7.2


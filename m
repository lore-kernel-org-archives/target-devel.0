From: tang.wenji@zte.com.cn
Date: Mon, 15 Jan 2018 12:09:37 +0000
Subject: [PATCH] target:fix destory device in target_configure_device
Message-Id: <1516018177-7714-1-git-send-email-tang.wenji@zte.com.cn>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

After dev->transport->configure_device succeeds,target_configure_device
exits abnormally, dev_flags has not set DF_CONFIGURED yet, does not call
destory_device function in free_device

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/target_core_device.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e8dd6da..18716fa 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -997,7 +997,7 @@ int target_configure_device(struct se_device *dev)
 
 	ret = core_setup_alua(dev);
 	if (ret)
-		goto out_free_index;
+		goto out_destory_device;
 
 	/*
 	 * Startup the struct se_device processing thread
@@ -1041,6 +1041,8 @@ int target_configure_device(struct se_device *dev)
 
 out_free_alua:
 	core_alua_free_lu_gp_mem(dev);
+out_destory_device:
+	dev->transport->destroy_device(dev);
 out_free_index:
 	mutex_lock(&device_mutex);
 	idr_remove(&devices_idr, dev->dev_index);
-- 
2.8.1.windows.1


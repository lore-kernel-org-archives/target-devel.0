From: tangwenji <hndksztwj@163.com>
Date: Wed, 13 Mar 2019 14:07:26 +0000
Subject: [PATCH] target:alua: fix the tg_pt_gps_count
Message-Id: <1552486046-1360-1-git-send-email-hndksztwj@163.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

Reducing the count should be alua_tg_pt_gps_count instead of alua_tg_pt_gps_counter when free alua group.

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/target_core_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index e09f0cf..4808654 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -1761,7 +1761,7 @@ void core_alua_free_tg_pt_gp(
 	 */
 	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
 	list_del(&tg_pt_gp->tg_pt_gp_list);
-	dev->t10_alua.alua_tg_pt_gps_counter--;
+	dev->t10_alua.alua_tg_pt_gps_count--;
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
 
 	/*
-- 
2.5.0.windows.1

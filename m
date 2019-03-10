From: tangwenji <hndksztwj@163.com>
Date: Sun, 10 Mar 2019 14:07:53 +0000
Subject: [PATCH] target:tcmu:add '\n' when return user space
Message-Id: <1552226873-3668-1-git-send-email-hndksztwj@163.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

In function tcmu_get_global_max_data_area return string should include '\n'.

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5831e0e..50229c1 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -244,7 +244,7 @@ static int tcmu_set_global_max_data_area(const char *str,
 static int tcmu_get_global_max_data_area(char *buffer,
 					 const struct kernel_param *kp)
 {
-	return sprintf(buffer, "%d", TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
+	return sprintf(buffer, "%d\n", TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
 }
 
 static const struct kernel_param_ops tcmu_global_max_data_area_op = {
-- 
2.5.0.windows.1

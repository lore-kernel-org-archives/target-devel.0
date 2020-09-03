From: Xiongfeng Wang <wangxiongfeng2@huawei.com>
Date: Thu, 03 Sep 2020 11:29:33 +0000
Subject: [PATCH] scsi: target: tcmu: add a missing newline when printing parameters
Message-Id: <1599132573-33818-1-git-send-email-wangxiongfeng2@huawei.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, wangxiongfeng2@huawei.com

When I cat module paramter 'global_max_data_area_mb' by sysfs, it
displays as follows. It's better to add a newline for easy reading.

root@(none):/# cat /sys/module/target_core_user/parameters/global_max_data_area_mb
2048noneroot@(none):/#

Signed-off-by: Xiongfeng Wang <wangxiongfeng2@huawei.com>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9b75923..9775670 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -242,7 +242,7 @@ static int tcmu_set_global_max_data_area(const char *str,
 static int tcmu_get_global_max_data_area(char *buffer,
 					 const struct kernel_param *kp)
 {
-	return sprintf(buffer, "%d", TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
+	return sprintf(buffer, "%d\n", TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
 }
 
 static const struct kernel_param_ops tcmu_global_max_data_area_op = {
-- 
1.7.12.4

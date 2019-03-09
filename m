From: hndksztwj@163.com
Date: Sat, 09 Mar 2019 13:27:06 +0000
Subject: [PATCH] target:tcmu free cmd->bdi in tcmu_check_and_free_pending_cmd
Message-Id: <1552138026-5016-1-git-send-email-hndksztwj@163.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5831e0e..bb5d85d 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1616,7 +1616,7 @@ static void tcmu_dev_call_rcu(struct rcu_head *p)
 static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 {
 	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
-		kmem_cache_free(tcmu_cmd_cache, cmd);
+		tcmu_free_cmd(cmd);
 		return 0;
 	}
 	return -EINVAL;
-- 
2.5.0.windows.1

From: tangwenji <hndksztwj@163.com>
Date: Sun, 10 Mar 2019 14:43:18 +0000
Subject: [PATCH] target: fix the exceptioin handling in target_pr_res_aptpl_metadata_store
Message-Id: <1552228998-3044-1-git-send-email-hndksztwj@163.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

The function should exit when the i_port,isid and t_port length exceed the specified value.

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/target_core_configfs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index fc5ef31..eff2ff5 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1773,7 +1773,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 					" exceeds PR_APTPL_MAX_IPORT_LEN: %d\n",
 					PR_APTPL_MAX_IPORT_LEN);
 				ret = -EINVAL;
-				break;
+				goto out;
 			}
 			break;
 		case Opt_initiator_sid:
@@ -1787,7 +1787,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 					"= exceeds PR_REG_ISID_LEN: %d\n",
 					PR_REG_ISID_LEN);
 				ret = -EINVAL;
-				break;
+				goto out;
 			}
 			break;
 		case Opt_sa_res_key:
@@ -1851,7 +1851,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 					" exceeds PR_APTPL_MAX_TPORT_LEN: %d\n",
 					PR_APTPL_MAX_TPORT_LEN);
 				ret = -EINVAL;
-				break;
+				goto out;
 			}
 			break;
 		case Opt_tpgt:
-- 
2.5.0.windows.1

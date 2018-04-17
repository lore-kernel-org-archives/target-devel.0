From: Chengguang Xu <cgxu519@gmx.com>
Date: Tue, 17 Apr 2018 03:28:44 +0000
Subject: [PATCH] target: fix potential memory leak in option parsing
Message-Id: <1523935724-6991-1-git-send-email-cgxu519@gmx.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

When specifying same string type option several times,
current option parsing will cause memory leak. Hence,
call kfree for previous one in this case.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 drivers/target/target_core_configfs.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3f4bf12..ee1a3a8 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1659,6 +1659,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 		token = match_token(ptr, tokens, args);
 		switch (token) {
 		case Opt_initiator_fabric:
+			kfree(i_fabric);
 			i_fabric = match_strdup(args);
 			if (!i_fabric) {
 				ret = -ENOMEM;
@@ -1666,6 +1667,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 			}
 			break;
 		case Opt_initiator_node:
+			kfree(i_port);
 			i_port = match_strdup(args);
 			if (!i_port) {
 				ret = -ENOMEM;
@@ -1680,6 +1682,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 			}
 			break;
 		case Opt_initiator_sid:
+			kfree(isid);
 			isid = match_strdup(args);
 			if (!isid) {
 				ret = -ENOMEM;
@@ -1737,6 +1740,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 		 * PR APTPL Metadata for Target Port
 		 */
 		case Opt_target_fabric:
+			kfree(t_fabric);
 			t_fabric = match_strdup(args);
 			if (!t_fabric) {
 				ret = -ENOMEM;
@@ -1744,6 +1748,7 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 			}
 			break;
 		case Opt_target_node:
+			kfree(t_port);
 			t_port = match_strdup(args);
 			if (!t_port) {
 				ret = -ENOMEM;
-- 
1.8.3.1


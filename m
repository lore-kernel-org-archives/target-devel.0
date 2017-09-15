From: tang.wenji@zte.com.cn
Date: Fri, 15 Sep 2017 09:18:07 +0000
Subject: [PATCH] iscsi-target:fix memory leak in iscsit_release_discovery_tpg()
Message-Id: <20170915091807.4476-1-tang.wenji@zte.com.cn>
List-Id: <target-devel.vger.kernel.org>
References: <20170915080313.4496-1-tang.wenji@zte.com.cn>
In-Reply-To: <20170915080313.4496-1-tang.wenji@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

Need to release the param_list for tpg in iscsi_release_discovery_tpg funtcion,this is also required before the iscsit_load_discovery_tpg function exits abnormally.

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/iscsi/iscsi_target_tpg.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 594d07a1e995..4b34f71547c6 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -90,10 +90,10 @@ int iscsit_load_discovery_tpg(void)
 	 */
 	param = iscsi_find_param_from_key(AUTHMETHOD, tpg->param_list);
 	if (!param)
-		goto out;
+		goto free_pl_out;
 
 	if (iscsi_update_param_value(param, "CHAP,None") < 0)
-		goto out;
+		goto free_pl_out;
 
 	tpg->tpg_attrib.authentication = 0;
 
@@ -105,6 +105,8 @@ int iscsit_load_discovery_tpg(void)
 	pr_debug("CORE[0] - Allocated Discovery TPG\n");
 
 	return 0;
+free_pl_out:
+	iscsi_release_param_list(tpg->param_list);
 out:
 	if (tpg->sid = 1)
 		core_tpg_deregister(&tpg->tpg_se_tpg);
@@ -119,6 +121,7 @@ void iscsit_release_discovery_tpg(void)
 	if (!tpg)
 		return;
 
+	iscsi_release_param_list(tpg->param_list);
 	core_tpg_deregister(&tpg->tpg_se_tpg);
 
 	kfree(tpg);
-- 
2.13.2.windows.1


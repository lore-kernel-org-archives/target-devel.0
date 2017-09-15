From: tang.wenji@zte.com.cn
Date: Fri, 15 Sep 2017 08:03:13 +0000
Subject: [PATCH] iscsi-target:fix memory leak in lio_target_tiqn_addtpg()
Message-Id: <20170915080313.4496-1-tang.wenji@zte.com.cn>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

tpg must free when call core_tpg_register() return fail

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/iscsi/iscsi_target_configfs.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 0dd4c45f7575..0ebc4818e132 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1123,7 +1123,7 @@ static struct se_portal_group *lio_target_tiqn_addtpg(
 
 	ret = core_tpg_register(wwn, &tpg->tpg_se_tpg, SCSI_PROTOCOL_ISCSI);
 	if (ret < 0)
-		return NULL;
+		goto free_out;
 
 	ret = iscsit_tpg_add_portal_group(tiqn, tpg);
 	if (ret != 0)
@@ -1135,6 +1135,7 @@ static struct se_portal_group *lio_target_tiqn_addtpg(
 	return &tpg->tpg_se_tpg;
 out:
 	core_tpg_deregister(&tpg->tpg_se_tpg);
+free_out:
 	kfree(tpg);
 	return NULL;
 }
-- 
2.13.2.windows.1


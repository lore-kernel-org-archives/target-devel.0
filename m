From: David Disseldorp <ddiss@suse.de>
Date: Wed, 19 Feb 2020 13:01:36 +0000
Subject: [PATCH v2 2/2] scsi: target: convert boolean se_dev_attrib types to bool
Message-Id: <20200219130136.18946-3-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This should harden us against configfs API regressions similar to the
one fixed by the previous commit.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_tmr.c  |  6 +++---
 include/target/target_core_base.h | 32 ++++++++++++++++----------------
 2 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index feeba3966617..afbd492c76a9 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -78,7 +78,7 @@ static int target_check_cdb_and_preempt(struct list_head *list,
 }
 
 static bool __target_check_io_state(struct se_cmd *se_cmd,
-				    struct se_session *tmr_sess, int tas)
+				    struct se_session *tmr_sess, bool tas)
 {
 	struct se_session *sess = se_cmd->se_sess;
 
@@ -251,7 +251,7 @@ static void core_tmr_drain_state_list(
 	struct se_device *dev,
 	struct se_cmd *prout_cmd,
 	struct se_session *tmr_sess,
-	int tas,
+	bool tas,
 	struct list_head *preempt_and_abort_list)
 {
 	LIST_HEAD(drain_task_list);
@@ -334,7 +334,7 @@ int core_tmr_lun_reset(
 	struct se_node_acl *tmr_nacl = NULL;
 	struct se_portal_group *tmr_tpg = NULL;
 	struct se_session *tmr_sess = NULL;
-	int tas;
+	bool tas;
         /*
 	 * TASK_ABORTED status bit, this is configurable via ConfigFS
 	 * struct se_device attributes.  spc4r17 section 7.4.6 Control mode page
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 35188e64239e..bbac0f1c3ba1 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -663,25 +663,25 @@ struct se_dev_entry {
 };
 
 struct se_dev_attrib {
-	int		emulate_model_alias;
-	int		emulate_dpo;
-	int		emulate_fua_write;
-	int		emulate_fua_read;
-	int		emulate_write_cache;
+	bool		emulate_model_alias;
+	bool		emulate_dpo;		/* deprecated */
+	bool		emulate_fua_write;
+	bool		emulate_fua_read;	/* deprecated */
+	bool		emulate_write_cache;
 	int		emulate_ua_intlck_ctrl;
-	int		emulate_tas;
-	int		emulate_tpu;
-	int		emulate_tpws;
-	int		emulate_caw;
-	int		emulate_3pc;
-	int		emulate_pr;
+	bool		emulate_tas;
+	bool		emulate_tpu;
+	bool		emulate_tpws;
+	bool		emulate_caw;
+	bool		emulate_3pc;
+	bool		emulate_pr;
 	enum target_prot_type pi_prot_type;
 	enum target_prot_type hw_pi_prot_type;
-	int		pi_prot_verify;
-	int		enforce_pr_isids;
-	int		force_pr_aptpl;
-	int		is_nonrot;
-	int		emulate_rest_reord;
+	bool		pi_prot_verify;
+	bool		enforce_pr_isids;
+	bool		force_pr_aptpl;
+	bool		is_nonrot;
+	bool		emulate_rest_reord;
 	bool		unmap_zeroes_data;
 	u32		hw_block_size;
 	u32		block_size;
-- 
2.16.4

From: Mike Christie <michael.christie@oracle.com>
Date: Sat, 27 Jun 2020 04:35:05 +0000
Subject: [RFC PATCH 06/10] tcm_loop: fix nexus races
Message-Id: <1593232509-13720-7-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

We could be freeing the loop nexus while accessing it from other
configfs files, and we could have multiple writers to the nexus file.
This adds a mutex aroung these operations like is done in other modules
that have the nexus configfs interface.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/loopback/tcm_loop.c | 30 ++++++++++++++++++++++++++----
 drivers/target/loopback/tcm_loop.h |  1 +
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 70eb87e..570dff2 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -720,14 +720,18 @@ static int tcm_loop_make_nexus(
 	struct tcm_loop_nexus *tl_nexus;
 	int ret;
 
+	mutex_lock(&tl_tpg->tl_nexus_mutex);
 	if (tl_tpg->tl_nexus) {
 		pr_debug("tl_tpg->tl_nexus already exists\n");
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return -EEXIST;
 	}
 
 	tl_nexus = kzalloc(sizeof(*tl_nexus), GFP_KERNEL);
-	if (!tl_nexus)
+	if (!tl_nexus) {
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return -ENOMEM;
+	}
 
 	tl_nexus->se_sess = target_setup_session(&tl_tpg->tl_se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
@@ -735,8 +739,10 @@ static int tcm_loop_make_nexus(
 	if (IS_ERR(tl_nexus->se_sess)) {
 		ret = PTR_ERR(tl_nexus->se_sess);
 		kfree(tl_nexus);
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return ret;
 	}
+	mutex_unlock(&tl_tpg->tl_nexus_mutex);
 
 	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated %s Initiator Port: %s\n",
 		 tcm_loop_dump_proto_id(tl_hba), name);
@@ -749,17 +755,23 @@ static int tcm_loop_drop_nexus(
 	struct se_session *se_sess;
 	struct tcm_loop_nexus *tl_nexus;
 
+	mutex_lock(&tpg->tl_nexus_mutex);
 	tl_nexus = tpg->tl_nexus;
-	if (!tl_nexus)
+	if (!tl_nexus) {
+		mutex_unlock(&tpg->tl_nexus_mutex);
 		return -ENODEV;
+	}
 
 	se_sess = tl_nexus->se_sess;
-	if (!se_sess)
+	if (!se_sess) {
+		mutex_unlock(&tpg->tl_nexus_mutex);
 		return -ENODEV;
+	}
 
 	if (atomic_read(&tpg->tl_tpg_port_count)) {
 		pr_err("Unable to remove TCM_Loop I_T Nexus with active TPG port count: %d\n",
 		       atomic_read(&tpg->tl_tpg_port_count));
+		mutex_unlock(&tpg->tl_nexus_mutex);
 		return -EPERM;
 	}
 
@@ -771,6 +783,8 @@ static int tcm_loop_drop_nexus(
 	 */
 	target_remove_session(se_sess);
 	tpg->tl_nexus = NULL;
+	mutex_unlock(&tpg->tl_nexus_mutex);
+
 	kfree(tl_nexus);
 	return 0;
 }
@@ -785,12 +799,16 @@ static ssize_t tcm_loop_tpg_nexus_show(struct config_item *item, char *page)
 	struct tcm_loop_nexus *tl_nexus;
 	ssize_t ret;
 
+	mutex_lock(&tl_tpg->tl_nexus_mutex);
 	tl_nexus = tl_tpg->tl_nexus;
-	if (!tl_nexus)
+	if (!tl_nexus) {
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return -ENODEV;
+	}
 
 	ret = snprintf(page, PAGE_SIZE, "%s\n",
 		tl_nexus->se_sess->se_node_acl->initiatorname);
+	mutex_unlock(&tl_tpg->tl_nexus_mutex);
 
 	return ret;
 }
@@ -909,11 +927,14 @@ static ssize_t tcm_loop_tpg_transport_status_store(struct config_item *item,
 	}
 	if (!strncmp(page, "offline", 7)) {
 		tl_tpg->tl_transport_status = TCM_TRANSPORT_OFFLINE;
+
+		mutex_lock(&tl_tpg->tl_nexus_mutex);
 		if (tl_tpg->tl_nexus) {
 			struct se_session *tl_sess = tl_tpg->tl_nexus->se_sess;
 
 			core_allocate_nexus_loss_ua(tl_sess->se_node_acl);
 		}
+		mutex_unlock(&tl_tpg->tl_nexus_mutex);
 		return count;
 	}
 	return -EINVAL;
@@ -968,6 +989,7 @@ static struct se_portal_group *tcm_loop_make_naa_tpg(struct se_wwn *wwn,
 	tl_tpg = &tl_hba->tl_hba_tpgs[tpgt];
 	tl_tpg->tl_hba = tl_hba;
 	tl_tpg->tl_tpgt = tpgt;
+	mutex_init(&tl_tpg->tl_nexus_mutex);
 	/*
 	 * Register the tl_tpg as a emulated TCM Target Endpoint
 	 */
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopback/tcm_loop.h
index d311090..88a4eff 100644
--- a/drivers/target/loopback/tcm_loop.h
+++ b/drivers/target/loopback/tcm_loop.h
@@ -40,6 +40,7 @@ struct tcm_loop_tpg {
 	struct se_portal_group tl_se_tpg;
 	struct tcm_loop_hba *tl_hba;
 	struct tcm_loop_nexus *tl_nexus;
+	struct mutex tl_nexus_mutex;
 };
 
 struct tcm_loop_hba {
-- 
1.8.3.1

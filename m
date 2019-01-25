From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:53 +0000
Subject: [PATCH 11/16] target/iscsi: Convert comments about locking into runtime checks
Message-Id: <20190125183458.220477-12-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target.c      | 10 ++++------
 drivers/target/iscsi/iscsi_target_erl0.c |  5 ++---
 drivers/target/iscsi/iscsi_target_erl1.c | 16 +++++++---------
 drivers/target/iscsi/iscsi_target_util.c | 16 +++++++---------
 drivers/target/target_core_alua.c        |  5 ++---
 drivers/target/target_core_device.c      |  6 +++---
 drivers/target/target_core_pr.c          | 15 ++++++---------
 7 files changed, 31 insertions(+), 42 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 984941e036c8..98984c3adfba 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -308,9 +308,6 @@ bool iscsit_check_np_match(
 	return false;
 }
 
-/*
- * Called with mutex np_lock held
- */
 static struct iscsi_np *iscsit_get_np(
 	struct sockaddr_storage *sockaddr,
 	int network_transport)
@@ -318,6 +315,8 @@ static struct iscsi_np *iscsit_get_np(
 	struct iscsi_np *np;
 	bool match;
 
+	lockdep_assert_held(&np_lock);
+
 	list_for_each_entry(np, &g_np_list, np_list) {
 		spin_lock_bh(&np->np_thread_lock);
 		if (np->np_thread_state != ISCSI_NP_THREAD_ACTIVE) {
@@ -2655,9 +2654,6 @@ static int iscsit_handle_immediate_data(
 	return IMMEDIATE_DATA_NORMAL_OPERATION;
 }
 
-/*
- *	Called with sess->conn_lock held.
- */
 /* #warning iscsi_build_conn_drop_async_message() only sends out on connections
 	with active network interface */
 static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
@@ -2666,6 +2662,8 @@ static void iscsit_build_conn_drop_async_message(struct iscsi_conn *conn)
 	struct iscsi_conn *conn_p;
 	bool found = false;
 
+	lockdep_assert_held(&conn->sess->conn_lock);
+
 	/*
 	 * Only send a Asynchronous Message on connections whos network
 	 * interface is still functional.
diff --git a/drivers/target/iscsi/iscsi_target_erl0.c b/drivers/target/iscsi/iscsi_target_erl0.c
index 1193cf884a28..8890c0721053 100644
--- a/drivers/target/iscsi/iscsi_target_erl0.c
+++ b/drivers/target/iscsi/iscsi_target_erl0.c
@@ -802,14 +802,13 @@ void iscsit_start_time2retain_handler(struct iscsi_session *sess)
 		  jiffies + sess->sess_ops->DefaultTime2Retain * HZ);
 }
 
-/*
- *	Called with spin_lock_bh(&struct se_portal_group->session_lock) held
- */
 int iscsit_stop_time2retain_timer(struct iscsi_session *sess)
 {
 	struct iscsi_portal_group *tpg = sess->tpg;
 	struct se_portal_group *se_tpg = &tpg->tpg_se_tpg;
 
+	lockdep_assert_held(&se_tpg->session_lock);
+
 	if (sess->time2retain_timer_flags & ISCSI_TF_EXPIRED)
 		return -1;
 
diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index 1b54a9c70851..38210ab09887 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -797,14 +797,14 @@ static struct iscsi_ooo_cmdsn *iscsit_allocate_ooo_cmdsn(void)
 	return ooo_cmdsn;
 }
 
-/*
- *	Called with sess->cmdsn_mutex held.
- */
 static int iscsit_attach_ooo_cmdsn(
 	struct iscsi_session *sess,
 	struct iscsi_ooo_cmdsn *ooo_cmdsn)
 {
 	struct iscsi_ooo_cmdsn *ooo_tail, *ooo_tmp;
+
+	lockdep_assert_held(&sess->cmdsn_mutex);
+
 	/*
 	 * We attach the struct iscsi_ooo_cmdsn entry to the out of order
 	 * list in increasing CmdSN order.
@@ -871,15 +871,14 @@ void iscsit_clear_ooo_cmdsns_for_conn(struct iscsi_conn *conn)
 	mutex_unlock(&sess->cmdsn_mutex);
 }
 
-/*
- *	Called with sess->cmdsn_mutex held.
- */
 int iscsit_execute_ooo_cmdsns(struct iscsi_session *sess)
 {
 	int ooo_count = 0;
 	struct iscsi_cmd *cmd = NULL;
 	struct iscsi_ooo_cmdsn *ooo_cmdsn, *ooo_cmdsn_tmp;
 
+	lockdep_assert_held(&sess->cmdsn_mutex);
+
 	list_for_each_entry_safe(ooo_cmdsn, ooo_cmdsn_tmp,
 				&sess->sess_ooo_cmdsn_list, ooo_list) {
 		if (ooo_cmdsn->cmdsn != sess->exp_cmd_sn)
@@ -1232,9 +1231,6 @@ void iscsit_mod_dataout_timer(struct iscsi_cmd *cmd)
 	spin_unlock_bh(&cmd->dataout_timeout_lock);
 }
 
-/*
- *	Called with cmd->dataout_timeout_lock held.
- */
 void iscsit_start_dataout_timer(
 	struct iscsi_cmd *cmd,
 	struct iscsi_conn *conn)
@@ -1242,6 +1238,8 @@ void iscsit_start_dataout_timer(
 	struct iscsi_session *sess = conn->sess;
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
+	lockdep_assert_held(&cmd->dataout_timeout_lock);
+
 	if (cmd->dataout_timer_flags & ISCSI_TF_RUNNING)
 		return;
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 762448e2f8b7..58886d4b33cb 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -56,9 +56,6 @@
 extern struct list_head g_tiqn_list;
 extern spinlock_t tiqn_lock;
 
-/*
- *	Called with cmd->r2t_lock held.
- */
 int iscsit_add_r2t_to_list(
 	struct iscsi_cmd *cmd,
 	u32 offset,
@@ -68,6 +65,8 @@ int iscsit_add_r2t_to_list(
 {
 	struct iscsi_r2t *r2t;
 
+	lockdep_assert_held(&cmd->r2t_lock);
+
 	r2t = kmem_cache_zalloc(lio_r2t_cache, GFP_ATOMIC);
 	if (!r2t) {
 		pr_err("Unable to allocate memory for struct iscsi_r2t.\n");
@@ -128,11 +127,10 @@ struct iscsi_r2t *iscsit_get_r2t_from_list(struct iscsi_cmd *cmd)
 	return NULL;
 }
 
-/*
- *	Called with cmd->r2t_lock held.
- */
 void iscsit_free_r2t(struct iscsi_r2t *r2t, struct iscsi_cmd *cmd)
 {
+	lockdep_assert_held(&cmd->r2t_lock);
+
 	list_del(&r2t->r2t_list);
 	kmem_cache_free(lio_r2t_cache, r2t);
 }
@@ -1013,13 +1011,13 @@ void iscsit_handle_nopin_timeout(struct timer_list *t)
 	iscsit_dec_conn_usage_count(conn);
 }
 
-/*
- * Called with conn->nopin_timer_lock held.
- */
 void __iscsit_start_nopin_timer(struct iscsi_conn *conn)
 {
 	struct iscsi_session *sess = conn->sess;
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
+
+	lockdep_assert_held(&conn->nopin_timer_lock);
+
 	/*
 	* NOPIN timeout is disabled.
 	 */
diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 6b0d9beacf90..e09f0cf86bed 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -910,9 +910,6 @@ static int core_alua_write_tpg_metadata(
 	return (ret < 0) ? -EIO : 0;
 }
 
-/*
- * Called with tg_pt_gp->tg_pt_gp_transition_mutex held
- */
 static int core_alua_update_tpg_primary_metadata(
 	struct t10_alua_tg_pt_gp *tg_pt_gp)
 {
@@ -921,6 +918,8 @@ static int core_alua_update_tpg_primary_metadata(
 	char *path;
 	int len, rc;
 
+	lockdep_assert_held(&tg_pt_gp->tg_pt_gp_transition_mutex);
+
 	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
 	if (!md_buf) {
 		pr_err("Unable to allocate buf for ALUA metadata\n");
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 93c56f4a9911..1f8482b6473b 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -404,9 +404,6 @@ int core_enable_device_list_for_node(
 	return 0;
 }
 
-/*
- *	Called with se_node_acl->lun_entry_mutex held.
- */
 void core_disable_device_list_for_node(
 	struct se_lun *lun,
 	struct se_dev_entry *orig,
@@ -418,6 +415,9 @@ void core_disable_device_list_for_node(
 	 * reference to se_device->dev_group.
 	 */
 	struct se_device *dev = rcu_dereference_raw(lun->lun_se_dev);
+
+	lockdep_assert_held(&nacl->lun_entry_mutex);
+
 	/*
 	 * If the MappedLUN entry is being disabled, the entry in
 	 * lun->lun_deve_list must be removed now before clearing the
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 397f38cb7f4e..1597a9ebadca 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1290,9 +1290,6 @@ static int core_scsi3_check_implicit_release(
 	return ret;
 }
 
-/*
- * Called with struct t10_reservation->registration_lock held.
- */
 static void __core_scsi3_free_registration(
 	struct se_device *dev,
 	struct t10_pr_registration *pr_reg,
@@ -1308,6 +1305,8 @@ static void __core_scsi3_free_registration(
 	struct se_dev_entry *deve;
 	char i_buf[PR_REG_ISID_ID_LEN];
 
+	lockdep_assert_held(&pr_tmpl->registration_lock);
+
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 
@@ -2450,9 +2449,6 @@ core_scsi3_emulate_pro_reserve(struct se_cmd *cmd, int type, int scope,
 	}
 }
 
-/*
- * Called with struct se_device->dev_reservation_lock held.
- */
 static void __core_scsi3_complete_pro_release(
 	struct se_device *dev,
 	struct se_node_acl *se_nacl,
@@ -2464,6 +2460,8 @@ static void __core_scsi3_complete_pro_release(
 	char i_buf[PR_REG_ISID_ID_LEN];
 	int pr_res_type = 0, pr_res_scope = 0;
 
+	lockdep_assert_held(&dev->dev_reservation_lock);
+
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 	/*
@@ -2760,9 +2758,6 @@ core_scsi3_emulate_pro_clear(struct se_cmd *cmd, u64 res_key)
 	return 0;
 }
 
-/*
- * Called with struct se_device->dev_reservation_lock held.
- */
 static void __core_scsi3_complete_pro_preempt(
 	struct se_device *dev,
 	struct t10_pr_registration *pr_reg,
@@ -2775,6 +2770,8 @@ static void __core_scsi3_complete_pro_preempt(
 	const struct target_core_fabric_ops *tfo = nacl->se_tpg->se_tpg_tfo;
 	char i_buf[PR_REG_ISID_ID_LEN];
 
+	lockdep_assert_held(&dev->dev_reservation_lock);
+
 	memset(i_buf, 0, PR_REG_ISID_ID_LEN);
 	core_pr_dump_initiator_port(pr_reg, i_buf, PR_REG_ISID_ID_LEN);
 	/*
-- 
2.20.1.495.gaa96b0ce6b-goog

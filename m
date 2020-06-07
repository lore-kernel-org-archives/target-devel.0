From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 07 Jun 2020 20:36:01 +0000
Subject: [PATCH 14/17] target: add free_session callout
Message-Id: <1591562164-9766-15-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The next patches hook the iscsi target into the syfs API and has it
export some basic info about the session.

To allow fabric drivers to export info in sysfs, they need to be able
to free resources when all userspace refs have dropped. This patch
adds a new session callback free_session which the fabric drivers can
use to free their internal resources that are accessed via sysfs.

This also moves the setting of the fabric_sess_ptr to
transport_alloc_session so drivers like iscsi that use that function
can know that if that function returns success then they can always
free the resources pointed at fabric_sess_ptr in the free_session
callback.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/iscsi/iscsi_target.c          |  7 +----
 drivers/target/iscsi/iscsi_target_configfs.c |  9 ++++++
 drivers/target/iscsi/iscsi_target_login.c    |  8 ++---
 drivers/target/target_core_transport.c       | 47 +++++++++++++++++-----------
 include/target/target_core_base.h            |  1 +
 include/target/target_core_fabric.h          | 12 +++++--
 6 files changed, 51 insertions(+), 33 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d9853d5..4c73374 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4383,8 +4383,6 @@ int iscsit_close_session(struct iscsi_session *sess)
 		}
 	}
 
-	transport_deregister_session(sess->se_sess);
-
 	if (sess->sess_ops->ErrorRecoveryLevel = 2)
 		iscsit_free_connection_recovery_entries(sess);
 
@@ -4401,12 +4399,9 @@ int iscsit_close_session(struct iscsi_session *sess)
 
 	pr_debug("Decremented number of active iSCSI Sessions on"
 		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
-
-	kfree(sess->sess_ops);
-	sess->sess_ops = NULL;
 	spin_unlock_bh(&se_tpg->session_lock);
 
-	kfree(sess);
+	transport_deregister_session(sess->se_sess);
 	return 0;
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 66a3b8d..ba608fa 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1481,6 +1481,14 @@ static void lio_tpg_close_session(struct se_session *se_sess)
 	iscsit_dec_session_usage_count(sess);
 }
 
+static void lio_free_session(struct se_session *se_sess)
+{
+	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
+
+	kfree(sess->sess_ops);
+	kfree(sess);
+}
+
 static u32 lio_tpg_get_inst_index(struct se_portal_group *se_tpg)
 {
 	return iscsi_tpg(se_tpg)->tpg_tiqn->tiqn_index;
@@ -1530,6 +1538,7 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	.check_stop_free		= lio_check_stop_free,
 	.release_cmd			= lio_release_cmd,
 	.close_session			= lio_tpg_close_session,
+	.free_session			= lio_free_session,
 	.sess_get_index			= lio_sess_get_index,
 	.write_pending			= lio_write_pending,
 	.set_default_node_attributes	= lio_set_default_node_attributes,
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 417b797..3001dd7 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -307,7 +307,8 @@ static int iscsi_login_zero_tsih_s1(
 		goto free_sess;
 	}
 
-	sess->se_sess = transport_alloc_session(TARGET_PROT_NORMAL);
+	sess->se_sess = transport_alloc_session(&iscsi_ops, TARGET_PROT_NORMAL,
+						sess);
 	if (IS_ERR(sess->se_sess)) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
@@ -740,7 +741,7 @@ void iscsi_post_login_handler(
 
 	spin_lock_bh(&se_tpg->session_lock);
 	__transport_register_session(&sess->tpg->tpg_se_tpg,
-			se_sess->se_node_acl, se_sess, sess);
+			se_sess->se_node_acl, se_sess);
 	pr_debug("Moving to TARG_SESS_STATE_LOGGED_IN.\n");
 	sess->session_state = TARG_SESS_STATE_LOGGED_IN;
 
@@ -1146,9 +1147,6 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 		goto old_sess_out;
 
 	transport_free_session(conn->sess->se_sess);
-	kfree(conn->sess->sess_ops);
-	kfree(conn->sess);
-	conn->sess = NULL;
 
 old_sess_out:
 	iscsi_stop_login_thread_timer(np);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 34da12a..ed63e36 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -239,9 +239,13 @@ int transport_init_session(struct se_session *se_sess)
 
 /**
  * transport_alloc_session - allocate a session object and initialize it
+ * @tfo: target core fabric ops
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
+ * @private: storage for fabric driver accessible via fabric_sess_ptr
  */
-struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
+struct se_session *transport_alloc_session(const struct target_core_fabric_ops *tfo,
+					   enum target_prot_op sup_prot_ops,
+					   void *private)
 {
 	struct se_session *se_sess;
 	int ret;
@@ -252,6 +256,8 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
+	se_sess->fabric_sess_ptr = private;
+	se_sess->tfo = tfo;
 
 	ret = target_sysfs_init_session(se_sess);
 	if (ret) {
@@ -311,14 +317,17 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 
 /**
  * transport_init_session_tags - allocate a session and target driver private data
+ * @tfo: target core fabric ops
  * @tag_num:  Maximum number of in-flight commands between initiator and target.
  * @tag_size: Size in bytes of the private data a target driver associates with
  *	      each command.
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
+ * @private: storage for fabric driver accessible via fabric_sess_ptr
  */
 static struct se_session *
-transport_init_session_tags(unsigned int tag_num, unsigned int tag_size,
-			    enum target_prot_op sup_prot_ops)
+transport_init_session_tags(const struct target_core_fabric_ops *tfo,
+			    unsigned int tag_num, unsigned int tag_size,
+			    enum target_prot_op sup_prot_ops, void *private)
 {
 	struct se_session *se_sess;
 	int rc;
@@ -334,7 +343,7 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 		return ERR_PTR(-EINVAL);
 	}
 
-	se_sess = transport_alloc_session(sup_prot_ops);
+	se_sess = transport_alloc_session(tfo, sup_prot_ops, private);
 	if (IS_ERR(se_sess))
 		return se_sess;
 
@@ -353,15 +362,13 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 void __transport_register_session(
 	struct se_portal_group *se_tpg,
 	struct se_node_acl *se_nacl,
-	struct se_session *se_sess,
-	void *fabric_sess_ptr)
+	struct se_session *se_sess)
 {
-	const struct target_core_fabric_ops *tfo = se_tpg->se_tpg_tfo;
+	const struct target_core_fabric_ops *tfo = se_sess->tfo;
 	unsigned char *sid;
 	unsigned long flags;
 
 	se_sess->se_tpg = se_tpg;
-	se_sess->fabric_sess_ptr = fabric_sess_ptr;
 	/*
 	 * Used by struct se_node_acl's under ConfigFS to locate active se_session-t
 	 *
@@ -406,20 +413,19 @@ void __transport_register_session(
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
 	pr_debug("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
-		se_tpg->se_tpg_tfo->fabric_name, se_sess->fabric_sess_ptr);
+		se_sess->tfo->fabric_name, se_sess->fabric_sess_ptr);
 }
 EXPORT_SYMBOL(__transport_register_session);
 
 void transport_register_session(
 	struct se_portal_group *se_tpg,
 	struct se_node_acl *se_nacl,
-	struct se_session *se_sess,
-	void *fabric_sess_ptr)
+	struct se_session *se_sess)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
-	__transport_register_session(se_tpg, se_nacl, se_sess, fabric_sess_ptr);
+	__transport_register_session(se_tpg, se_nacl, se_sess);
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 }
 EXPORT_SYMBOL(transport_register_session);
@@ -451,9 +457,11 @@ struct se_session *
 	 * of I/O descriptor tags, go ahead and perform that setup now..
 	 */
 	if (tag_num != 0)
-		sess = transport_init_session_tags(tag_num, tag_size, prot_op);
+		sess = transport_init_session_tags(tpg->se_tpg_tfo, tag_num,
+						   tag_size, prot_op, private);
 	else
-		sess = transport_alloc_session(prot_op);
+		sess = transport_alloc_session(tpg->se_tpg_tfo, prot_op,
+					       private);
 
 	if (IS_ERR(sess))
 		return sess;
@@ -485,7 +493,7 @@ struct se_session *
 			goto rm_sysfs;
 	}
 
-	transport_register_session(tpg, sess->se_node_acl, sess, private);
+	transport_register_session(tpg, sess->se_node_acl, sess);
 	return sess;
 
 rm_sysfs:
@@ -585,7 +593,6 @@ void transport_free_session(struct se_session *se_sess)
 	 */
 	if (se_nacl) {
 		struct se_portal_group *se_tpg = se_nacl->se_tpg;
-		const struct target_core_fabric_ops *se_tfo = se_tpg->se_tpg_tfo;
 		unsigned long flags;
 
 		se_sess->se_node_acl = NULL;
@@ -597,7 +604,7 @@ void transport_free_session(struct se_session *se_sess)
 		 */
 		mutex_lock(&se_tpg->acl_node_mutex);
 		if (se_nacl->dynamic_node_acl &&
-		    !se_tfo->tpg_check_demo_mode_cache(se_tpg)) {
+		    !se_sess->tfo->tpg_check_demo_mode_cache(se_tpg)) {
 			spin_lock_irqsave(&se_nacl->nacl_sess_lock, flags);
 			if (list_empty(&se_nacl->acl_sess_list))
 				se_nacl->dynamic_stop = true;
@@ -624,6 +631,9 @@ void transport_free_session(struct se_session *se_sess)
 
 void __target_free_session(struct se_session *se_sess)
 {
+	if (se_sess->tfo->free_session)
+		se_sess->tfo->free_session(se_sess);
+
 	target_free_transport_id(se_sess->tpt_id);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
@@ -650,7 +660,6 @@ void transport_deregister_session(struct se_session *se_sess)
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
 	list_del(&se_sess->sess_list);
 	se_sess->se_tpg = NULL;
-	se_sess->fabric_sess_ptr = NULL;
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 
 	/*
@@ -660,7 +669,7 @@ void transport_deregister_session(struct se_session *se_sess)
 	target_for_each_device(target_release_res, se_sess);
 
 	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
-		se_tpg->se_tpg_tfo->fabric_name);
+		 se_sess->tfo->fabric_name);
 	/*
 	 * If last kref is dropping now for an explicit NodeACL, awake sleeping
 	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 0d9916b..85c0eea2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -643,6 +643,7 @@ struct se_session {
 	char			*tpg_name;
 	char			*target_name;
 	char			*fabric_name;
+	const struct target_core_fabric_ops *tfo;
 };
 
 struct se_device;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 2a93daa..af7d585 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -65,6 +65,11 @@ struct target_core_fabric_ops {
 	 */
 	int (*check_stop_free)(struct se_cmd *);
 	void (*release_cmd)(struct se_cmd *);
+	/*
+	 * Callout to free session resources that can be accessed from
+	 * session_attrs below.
+	 */
+	void (*free_session)(struct se_session *);
 	void (*close_session)(struct se_session *);
 	u32 (*sess_get_index)(struct se_session *);
 	int (*write_pending)(struct se_cmd *);
@@ -134,13 +139,14 @@ struct se_session *target_setup_session(struct se_portal_group *,
 void target_remove_session(struct se_session *);
 
 int transport_init_session(struct se_session *se_sess);
-struct se_session *transport_alloc_session(enum target_prot_op);
+struct se_session *transport_alloc_session(const struct target_core_fabric_ops *,
+					   enum target_prot_op, void *);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
 void	__transport_register_session(struct se_portal_group *,
-		struct se_node_acl *, struct se_session *, void *);
+		struct se_node_acl *, struct se_session *);
 void	transport_register_session(struct se_portal_group *,
-		struct se_node_acl *, struct se_session *, void *);
+		struct se_node_acl *, struct se_session *);
 ssize_t	target_show_dynamic_sessions(struct se_portal_group *, char *);
 void	transport_free_session(struct se_session *);
 void	target_spc2_release(struct se_node_acl *nacl);
-- 
1.8.3.1

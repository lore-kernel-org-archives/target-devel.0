From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:25 +0000
Subject: [PATCH 09/15] target: add session dir in configfs
Message-Id: <1531696591-8558-10-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Drivers like iscsi will dump one of the session's info in
a info file under the acl. The problem with this is that
it only prints one session and only sessions with an acl.

Then there is a dynamic_sessions file which dumps the initiator
name of each session without an acl. The problem with this
is that the info printed is limited to only the node name.
For iscsi we do not get the entire initiator port string
(name + isid). Also all dynamic sessions are printed in one
file so setups that do a target per lun quickly run out of
space.

To handle all these issues, this patch adds a per session
dir under the tpg. We can then export info like initiator
name and if needed isid. These patches will then also add
some files to test sessions.

TODO:
1. handle target_fabric_register_session failure in iscsi target.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c          |  4 ++
 drivers/target/iscsi/iscsi_target_login.c    |  3 ++
 drivers/target/target_core_fabric_configfs.c | 47 +++++++++++++++++++++++
 drivers/target/target_core_internal.h        |  2 +
 drivers/target/target_core_transport.c       | 57 ++++++++++++++++++++--------
 include/target/target_core_base.h            |  3 ++
 include/target/target_core_fabric.h          |  5 ++-
 7 files changed, 105 insertions(+), 16 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 6d81a59..793ee98 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4324,6 +4324,10 @@ int iscsit_close_session(struct iscsi_session *sess)
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 
+
+	if (tpg != iscsit_global->discovery_tpg)
+		target_fabric_unregister_session(sess->se_sess);
+
 	/*
 	 * transport_deregister_session_configfs() will clear the
 	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index d6a4b93..48a9522 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -778,6 +778,9 @@ void iscsi_post_login_handler(
 
 	iscsit_determine_maxcmdsn(sess);
 
+	if (tpg != iscsit_global->discovery_tpg)
+		target_fabric_register_session(se_tpg, se_sess);
+
 	spin_lock_bh(&se_tpg->session_lock);
 	__transport_register_session(&sess->tpg->tpg_se_tpg,
 			se_sess->se_node_acl, se_sess, sess);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 1fa436e..497fa01 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -878,6 +878,11 @@ static struct config_group *target_fabric_make_tpg(
 	configfs_add_default_group(&se_tpg->tpg_param_group,
 			&se_tpg->tpg_group);
 
+	config_group_init_type_name(&se_tpg->tpg_session_group, "sessions",
+			&tf->tf_tpg_session_cit);
+	configfs_add_default_group(&se_tpg->tpg_session_group,
+			&se_tpg->tpg_group);
+
 	return &se_tpg->tpg_group;
 }
 
@@ -892,6 +897,48 @@ static void target_fabric_drop_tpg(
 	config_item_put(item);
 }
 
+static void target_fabric_session_release(struct config_item *item)
+{
+	struct se_session *se_sess = container_of(to_config_group(item),
+						  struct se_session, group);
+	target_release_session(se_sess);
+}
+
+static struct configfs_item_operations target_session_item_ops = {
+	.release	= target_fabric_session_release,
+};
+
+int target_fabric_init_session(struct se_session *se_sess)
+{
+	char *name;
+
+	name = kasprintf(GFP_KERNEL, "%d", se_sess->sid);
+	if (!name)
+		return -ENOMEM;
+
+	se_sess->cit.ct_owner = THIS_MODULE;
+	se_sess->cit.ct_item_ops = &target_session_item_ops;
+	config_group_init_type_name(&se_sess->group, name, &se_sess->cit);
+	kfree(name);
+	return 0;
+}
+EXPORT_SYMBOL(target_fabric_init_session);
+
+int target_fabric_register_session(
+	struct se_portal_group *se_tpg,
+	struct se_session *se_sess)
+{
+	return configfs_register_group(&se_tpg->tpg_session_group,
+				       &se_sess->group);
+}
+EXPORT_SYMBOL(target_fabric_register_session);
+
+void target_fabric_unregister_session(struct se_session *se_sess)
+{
+	configfs_unregister_group(&se_sess->group);
+}
+EXPORT_SYMBOL(target_fabric_unregister_session);
+
 static void target_fabric_release_wwn(struct config_item *item)
 {
 	struct se_wwn *wwn = container_of(to_config_group(item),
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 0c66355..73c90ae 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -44,6 +44,7 @@ struct target_fabric_configfs {
 	struct config_item_type tf_tpg_attrib_cit;
 	struct config_item_type tf_tpg_auth_cit;
 	struct config_item_type tf_tpg_param_cit;
+	struct config_item_type tf_tpg_session_cit;
 	struct config_item_type tf_tpg_nacl_cit;
 	struct config_item_type tf_tpg_nacl_base_cit;
 	struct config_item_type tf_tpg_nacl_attrib_cit;
@@ -154,6 +155,7 @@ void	target_qf_do_work(struct work_struct *work);
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	target_release_session(struct se_session *);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 57279fe..0efb3dc 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -271,11 +271,22 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 
 	if (ret < 0) {
 		pr_err("Unable to allocate session index.\n");
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
+		goto free_sess;
 	}
 
+	ret = target_fabric_init_session(se_sess);
+	if (ret)
+		goto free_sid;
+
 	return se_sess;
+
+free_sid:
+	spin_lock_irqsave(&se_sess_idr_lock, flags);
+	idr_remove(&se_sess_idr, se_sess->sid);
+	spin_unlock_irqrestore(&se_sess_idr_lock, flags);
+free_sess:
+	kmem_cache_free(se_sess_cache, se_sess);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(transport_alloc_session);
 
@@ -443,6 +454,7 @@ target_setup_session(struct se_portal_group *tpg,
 				     struct se_session *, void *))
 {
 	struct se_session *sess;
+	int rc;
 
 	/*
 	 * If the fabric driver is using percpu-ida based pre allocation
@@ -459,23 +471,32 @@ target_setup_session(struct se_portal_group *tpg,
 	sess->se_node_acl = core_tpg_check_initiator_node_acl(tpg,
 					(unsigned char *)initiatorname);
 	if (!sess->se_node_acl) {
-		transport_free_session(sess);
-		return ERR_PTR(-EACCES);
+		rc = -EACCES;
+		goto free_sess;
 	}
+
+	rc = target_fabric_register_session(tpg, sess);
+	if (rc)
+		goto free_sess;
+
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
 	 */
 	if (callback != NULL) {
-		int rc = callback(tpg, sess, private);
-		if (rc) {
-			transport_free_session(sess);
-			return ERR_PTR(rc);
-		}
+		rc = callback(tpg, sess, private);
+		if (rc)
+			goto unregister_fabric;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
+
+unregister_fabric:
+	target_fabric_unregister_session(sess);
+free_sess:
+	transport_free_session(sess);
+	return ERR_PTR(rc);
 }
 EXPORT_SYMBOL(target_setup_session);
 
@@ -558,6 +579,17 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
 }
 EXPORT_SYMBOL(transport_deregister_session_configfs);
 
+void target_release_session(struct se_session *se_sess)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&se_sess_idr_lock, flags);
+	idr_remove(&se_sess_idr, se_sess->sid);
+	spin_unlock_irqrestore(&se_sess_idr_lock, flags);
+
+	kmem_cache_free(se_sess_cache, se_sess);
+}
+
 void transport_free_session(struct se_session *se_sess)
 {
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
@@ -600,12 +632,6 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-
-	spin_lock_irqsave(&se_sess_idr_lock, flags);
-	idr_remove(&se_sess_idr, se_sess->sid);
-	spin_unlock_irqrestore(&se_sess_idr_lock, flags);
-
-	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
 
@@ -642,6 +668,7 @@ EXPORT_SYMBOL(transport_deregister_session);
 
 void target_remove_session(struct se_session *se_sess)
 {
+	target_fabric_unregister_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d5efde8..01caaa3 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -610,6 +610,8 @@ struct se_session {
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
 	int			sid;
+	struct config_group	group;
+	struct config_item_type	cit;
 };
 
 struct se_device;
@@ -887,6 +889,7 @@ struct se_portal_group {
 	struct config_group	tpg_attrib_group;
 	struct config_group	tpg_auth_group;
 	struct config_group	tpg_param_group;
+	struct config_group	tpg_session_group;
 };
 
 static inline struct se_portal_group *to_tpg(struct config_item *item)
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index aa69b13..36077d6 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -128,7 +128,10 @@ void	transport_free_session(struct se_session *);
 void	target_put_nacl(struct se_node_acl *);
 void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
-
+int	target_fabric_init_session(struct se_session *);
+int	target_fabric_register_session(struct se_portal_group *,
+				       struct se_session *);
+void	target_fabric_unregister_session(struct se_session *);
 
 void	transport_init_se_cmd(struct se_cmd *,
 		const struct target_core_fabric_ops *,
-- 
2.7.2


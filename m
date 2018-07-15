From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:28 +0000
Subject: [PATCH 12/15] target: add callout to test a session
Message-Id: <1531696591-8558-13-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This adds a callout and configfs file so userspace apps can
test a session. It is useful for apps that do not want
to enable target nops that may disrupt normal traffic
and only want to test it during specific events like
failover/failbacks when there might be multiple sessions
to the same target port.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_login.c    |  2 +-
 drivers/target/target_core_fabric_configfs.c | 71 ++++++++++++++++++++++++++--
 drivers/target/target_core_transport.c       | 20 +++++---
 include/target/target_core_base.h            |  1 +
 include/target/target_core_fabric.h          |  7 ++-
 5 files changed, 88 insertions(+), 13 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 48a9522..8f219b9 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -353,7 +353,7 @@ static int iscsi_login_zero_tsih_s1(
 		return -ENOMEM;
 	}
 
-	sess->se_sess = transport_alloc_session(TARGET_PROT_NORMAL);
+	sess->se_sess = transport_alloc_session(&iscsi_ops, TARGET_PROT_NORMAL);
 	if (IS_ERR(sess->se_sess)) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index 2deda28..a5bb9a1 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -937,7 +937,48 @@ static ssize_t target_fabric_session_initiator_port_show(
 	return len;
 }
 
+static ssize_t target_fabric_session_test_store(
+	struct config_item *item, const char *page, size_t count)
+{
+	struct se_session *se_sess = container_of(to_config_group(item),
+						  struct se_session, group);
+	struct se_portal_group *se_tpg;
+	unsigned long flags;
+
+	int ret;
+	u8 val;
+
+	ret = kstrtou8(page, 0, &val);
+	if (ret < 0)
+		return ret;
+
+	spin_lock_irqsave(&se_sess->configfs_lock, flags);
+	se_tpg = se_sess->se_tpg;
+	if (!se_tpg) {
+		ret = -ENOTCONN;
+		goto unlock;
+	}
+
+	if (!config_item_get_unless_zero(&se_tpg->tpg_group.cg_item)) {
+		ret = -ENOTCONN;
+		goto unlock;
+	}
+	spin_unlock_irqrestore(&se_sess->configfs_lock, flags);
+
+	ret = se_tpg->se_tpg_tfo->test_session(se_sess, val);
+	if (!ret)
+		ret = count;
+
+	config_item_put(&se_tpg->tpg_group.cg_item);
+	return ret;
+
+unlock:
+	spin_unlock_irqrestore(&se_sess->configfs_lock, flags);
+	return ret;
+}
+
 CONFIGFS_ATTR_RO(target_fabric_session_, initiator_port);
+CONFIGFS_ATTR_WO(target_fabric_session_, test);
 
 static struct configfs_attribute *target_fabric_session_attrs[] = {
 	&target_fabric_session_attr_initiator_port,
@@ -955,8 +996,11 @@ static struct configfs_item_operations target_session_item_ops = {
 	.release	= target_fabric_session_release,
 };
 
-int target_fabric_init_session(struct se_session *se_sess)
+int target_fabric_init_session(const struct target_core_fabric_ops *tfo,
+			       struct se_session *se_sess)
 {
+	struct configfs_attribute **attrs;
+	int len = 0, i, ret;
 	char *name;
 
 	name = kasprintf(GFP_KERNEL, "%d", se_sess->sid);
@@ -965,10 +1009,31 @@ int target_fabric_init_session(struct se_session *se_sess)
 
 	se_sess->cit.ct_owner = THIS_MODULE;
 	se_sess->cit.ct_item_ops = &target_session_item_ops;
-	se_sess->cit.ct_attrs = target_fabric_session_attrs;
+
+	for (i = 0; target_fabric_session_attrs[i] != NULL; i++)
+		len += sizeof(struct configfs_attribute *);
+	if (tfo->test_session)
+		len += sizeof(struct configfs_attribute *);
+
+	attrs = kzalloc(len, GFP_KERNEL);
+	if (!attrs) {
+		ret = -ENOMEM;
+		goto free_name;
+	}
+
+	for (i = 0; target_fabric_session_attrs[i] != NULL; i++)
+		attrs[i] = target_fabric_session_attrs[i];
+
+	if (tfo->test_session)
+		attrs[i] = &target_fabric_session_attr_test;
+
+	se_sess->cit.ct_attrs = se_sess->attrs = attrs;
+
 	config_group_init_type_name(&se_sess->group, name, &se_sess->cit);
+	ret = 0;
+free_name:
 	kfree(name);
-	return 0;
+	return ret;
 }
 EXPORT_SYMBOL(target_fabric_init_session);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 04ef13c..5f0f7a4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -245,9 +245,11 @@ EXPORT_SYMBOL(transport_init_session);
 
 /**
  * transport_alloc_session - allocate a session object and initialize it
+ * @tfo: pointer to fabric ops template.
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
  */
-struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
+struct se_session *transport_alloc_session(const struct target_core_fabric_ops *tfo,
+					   enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
 	unsigned long flags;
@@ -275,7 +277,7 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 		goto free_sess;
 	}
 
-	ret = target_fabric_init_session(se_sess);
+	ret = target_fabric_init_session(tfo, se_sess);
 	if (ret)
 		goto free_sid;
 
@@ -329,13 +331,15 @@ EXPORT_SYMBOL(transport_alloc_session_tags);
 
 /**
  * transport_init_session_tags - allocate a session and target driver private data
+ * @tfo: pointer to fabric ops template.
  * @tag_num:  Maximum number of in-flight commands between initiator and target.
  * @tag_size: Size in bytes of the private data a target driver associates with
  *	      each command.
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
  */
 static struct se_session *
-transport_init_session_tags(unsigned int tag_num, unsigned int tag_size,
+transport_init_session_tags(const struct target_core_fabric_ops *tfo,
+			    unsigned int tag_num, unsigned int tag_size,
 			    enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
@@ -352,7 +356,7 @@ transport_init_session_tags(unsigned int tag_num, unsigned int tag_size,
 		return ERR_PTR(-EINVAL);
 	}
 
-	se_sess = transport_alloc_session(sup_prot_ops);
+	se_sess = transport_alloc_session(tfo, sup_prot_ops);
 	if (IS_ERR(se_sess))
 		return se_sess;
 
@@ -465,9 +469,10 @@ target_setup_session(struct se_portal_group *tpg,
 	 * of I/O descriptor tags, go ahead and perform that setup now..
 	 */
 	if (tag_num != 0)
-		sess = transport_init_session_tags(tag_num, tag_size, prot_op);
+		sess = transport_init_session_tags(tpg->se_tpg_tfo, tag_num,
+						   tag_size, prot_op);
 	else
-		sess = transport_alloc_session(prot_op);
+		sess = transport_alloc_session(tpg->se_tpg_tfo, prot_op);
 
 	if (IS_ERR(sess))
 		return sess;
@@ -591,6 +596,7 @@ void target_release_session(struct se_session *se_sess)
 	idr_remove(&se_sess_idr, se_sess->sid);
 	spin_unlock_irqrestore(&se_sess_idr_lock, flags);
 
+	kfree(se_sess->attrs);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 
@@ -653,9 +659,9 @@ void transport_deregister_session(struct se_session *se_sess)
 
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
 	list_del(&se_sess->sess_list);
-	se_sess->fabric_sess_ptr = NULL;
 
 	spin_lock(&se_sess->configfs_lock);
+	se_sess->fabric_sess_ptr = NULL;
 	se_sess->se_tpg = NULL;
 	spin_unlock(&se_sess->configfs_lock);
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d3bb76c..d78e316 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -611,6 +611,7 @@ struct se_session {
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
 	int			sid;
+	struct configfs_attribute **attrs;
 	struct config_group	group;
 	struct config_item_type	cit;
 };
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 36077d6..7eacfdd 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -56,6 +56,7 @@ struct target_core_fabric_ops {
 	int (*check_stop_free)(struct se_cmd *);
 	void (*release_cmd)(struct se_cmd *);
 	void (*close_session)(struct se_session *);
+	int (*test_session)(struct se_session *, u8 timeout);
 	/*
 	 * Used only for SCSI fabrics that contain multi-value TransportIDs
 	 * (like iSCSI).  All other SCSI fabrics should set this to NULL.
@@ -116,7 +117,8 @@ struct se_session *target_setup_session(struct se_portal_group *,
 void target_remove_session(struct se_session *);
 
 void transport_init_session(struct se_session *);
-struct se_session *transport_alloc_session(enum target_prot_op);
+struct se_session *transport_alloc_session(
+		const struct target_core_fabric_ops *tfo, enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
 void	__transport_register_session(struct se_portal_group *,
@@ -128,7 +130,8 @@ void	transport_free_session(struct se_session *);
 void	target_put_nacl(struct se_node_acl *);
 void	transport_deregister_session_configfs(struct se_session *);
 void	transport_deregister_session(struct se_session *);
-int	target_fabric_init_session(struct se_session *);
+int	target_fabric_init_session(const struct target_core_fabric_ops *tfo,
+				   struct se_session *);
 int	target_fabric_register_session(struct se_portal_group *,
 				       struct se_session *);
 void	target_fabric_unregister_session(struct se_session *);
-- 
2.7.2


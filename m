From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:20 +0000
Subject: [PATCH 04/15] target/iscsi: move session_index to common se_session
Message-Id: <1531696591-8558-5-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The next patches will make session$SID dir for each session
so move the iscsi session session_index to the se_session.

This differs from the previous code in that it now uses
idr_alloc_cyclic to help prevent apps from confusing
a reused sid with a previous session.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c          |  8 --------
 drivers/target/iscsi/iscsi_target_configfs.c |  4 +---
 drivers/target/iscsi/iscsi_target_login.c    | 21 ---------------------
 drivers/target/iscsi/iscsi_target_stat.c     |  3 +--
 drivers/target/target_core_transport.c       | 25 ++++++++++++++++++++++++-
 include/target/iscsi/iscsi_target_core.h     |  2 --
 include/target/target_core_base.h            |  1 +
 7 files changed, 27 insertions(+), 37 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d547dcd..6d81a59 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -57,9 +57,7 @@ static DEFINE_SPINLOCK(tiqn_lock);
 static DEFINE_MUTEX(np_lock);
 
 static struct idr tiqn_idr;
-struct idr sess_idr;
 struct mutex auth_id_lock;
-spinlock_t sess_idr_lock;
 
 struct iscsit_global *iscsit_global;
 
@@ -698,9 +696,7 @@ static int __init iscsi_target_init_module(void)
 
 	spin_lock_init(&iscsit_global->ts_bitmap_lock);
 	mutex_init(&auth_id_lock);
-	spin_lock_init(&sess_idr_lock);
 	idr_init(&tiqn_idr);
-	idr_init(&sess_idr);
 
 	ret = target_register_template(&iscsi_ops);
 	if (ret)
@@ -4373,10 +4369,6 @@ int iscsit_close_session(struct iscsi_session *sess)
 	pr_debug("Decremented number of active iSCSI Sessions on"
 		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
 
-	spin_lock(&sess_idr_lock);
-	idr_remove(&sess_idr, sess->session_index);
-	spin_unlock(&sess_idr_lock);
-
 	kfree(sess->sess_ops);
 	sess->sess_ops = NULL;
 	spin_unlock_bh(&se_tpg->session_lock);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 1fcd9bc..39af194 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1357,9 +1357,7 @@ static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
 
 static u32 lio_sess_get_index(struct se_session *se_sess)
 {
-	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
-
-	return sess->session_index;
+	return se_sess->sid;
 }
 
 static u32 lio_sess_get_initiator_sid(
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 923b1a9..d6a4b93 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -336,22 +336,6 @@ static int iscsi_login_zero_tsih_s1(
 	timer_setup(&sess->time2retain_timer,
 		    iscsit_handle_time2retain_timeout, 0);
 
-	idr_preload(GFP_KERNEL);
-	spin_lock_bh(&sess_idr_lock);
-	ret = idr_alloc(&sess_idr, NULL, 0, 0, GFP_NOWAIT);
-	if (ret >= 0)
-		sess->session_index = ret;
-	spin_unlock_bh(&sess_idr_lock);
-	idr_preload_end();
-
-	if (ret < 0) {
-		pr_err("idr_alloc() for sess_idr failed\n");
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		kfree(sess);
-		return -ENOMEM;
-	}
-
 	sess->creation_time = get_jiffies_64();
 	/*
 	 * The FFP CmdSN window values will be allocated from the TPG's
@@ -1163,11 +1147,6 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 		goto old_sess_out;
 	if (conn->sess->se_sess)
 		transport_free_session(conn->sess->se_sess);
-	if (conn->sess->session_index != 0) {
-		spin_lock_bh(&sess_idr_lock);
-		idr_remove(&sess_idr, conn->sess->session_index);
-		spin_unlock_bh(&sess_idr_lock);
-	}
 	kfree(conn->sess->sess_ops);
 	kfree(conn->sess);
 	conn->sess = NULL;
diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index df0a398..b1a41bf5 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -638,8 +638,7 @@ static ssize_t iscsi_stat_sess_indx_show(struct config_item *item, char *page)
 	if (se_sess) {
 		sess = se_sess->fabric_sess_ptr;
 		if (sess)
-			ret = snprintf(page, PAGE_SIZE, "%u\n",
-					sess->session_index);
+			ret = snprintf(page, PAGE_SIZE, "%u\n", se_sess->sid);
 	}
 	spin_unlock_bh(&se_nacl->nacl_sess_lock);
 
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 75ddbbb..97a1ee5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -55,6 +55,8 @@
 
 static struct workqueue_struct *target_completion_wq;
 static struct kmem_cache *se_sess_cache;
+static DEFINE_SPINLOCK(se_sess_idr_lock);
+static DEFINE_IDR(se_sess_idr);
 struct kmem_cache *se_ua_cache;
 struct kmem_cache *t10_pr_reg_cache;
 struct kmem_cache *t10_alua_lu_gp_cache;
@@ -247,6 +249,8 @@ EXPORT_SYMBOL(transport_init_session);
 struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
+	unsigned long flags;
+	int ret;
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!se_sess) {
@@ -257,6 +261,20 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 	transport_init_session(se_sess);
 	se_sess->sup_prot_ops = sup_prot_ops;
 
+	idr_preload(GFP_KERNEL);
+	spin_lock_irqsave(&se_sess_idr_lock, flags);
+	ret = idr_alloc_cyclic(&se_sess_idr, NULL, 1, 0, GFP_NOWAIT);
+	if (ret >= 0)
+		se_sess->sid = ret;
+	spin_unlock_irqrestore(&se_sess_idr_lock, flags);
+	idr_preload_end();
+
+	if (ret < 0) {
+		pr_err("Unable to allocate session index.\n");
+		kmem_cache_free(se_sess_cache, se_sess);
+		return ERR_PTR(ret);
+	}
+
 	return se_sess;
 }
 EXPORT_SYMBOL(transport_alloc_session);
@@ -544,6 +562,7 @@ EXPORT_SYMBOL(transport_deregister_session_configfs);
 void transport_free_session(struct se_session *se_sess)
 {
 	struct se_node_acl *se_nacl = se_sess->se_node_acl;
+	unsigned long flags;
 
 	/*
 	 * Drop the se_node_acl->nacl_kref obtained from within
@@ -552,7 +571,6 @@ void transport_free_session(struct se_session *se_sess)
 	if (se_nacl) {
 		struct se_portal_group *se_tpg = se_nacl->se_tpg;
 		const struct target_core_fabric_ops *se_tfo = se_tpg->se_tpg_tfo;
-		unsigned long flags;
 
 		se_sess->se_node_acl = NULL;
 
@@ -583,6 +601,11 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
+
+	spin_lock_irqsave(&se_sess_idr_lock, flags);
+	idr_remove(&se_sess_idr, se_sess->sid);
+	spin_unlock_irqrestore(&se_sess_idr_lock, flags);
+
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index f2e6abe..10031dc 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -655,8 +655,6 @@ struct iscsi_session {
 	/* LIO specific session ID */
 	u32			sid;
 	char			auth_type[8];
-	/* unique within the target */
-	int			session_index;
 	/* Used for session reference counting */
 	int			session_usage_count;
 	int			session_waiting_on_uc;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7a4ee78..d5efde8 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -609,6 +609,7 @@ struct se_session {
 	wait_queue_head_t	cmd_list_wq;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	int			sid;
 };
 
 struct se_device;
-- 
2.7.2


From: Mike Christie <michael.christie@oracle.com>
Date: Sat, 27 Jun 2020 04:35:08 +0000
Subject: [RFC PATCH 09/10] target: add helper to close session synchronously
Message-Id: <1593232509-13720-10-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

We need to be able to delete sessions from userspace like is done for
the ACL path or is done for other objects like tpg, lun, etc. This patch
adds a helper function that calls the fabric module close_session
callback and then waits for the removal to complete. It will be used
in the next patch so userspace can remove sessions before deleting
TPGs/ACLs.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 90 ++++++++++++++++++++++++++++++++++
 include/target/target_core_base.h      |  2 +
 3 files changed, 93 insertions(+)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index e92dcf2..0af3844 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -155,6 +155,7 @@ void	transport_dump_dev_info(struct se_device *, struct se_lun *,
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
 void	target_release_session(struct se_session *);
+int	target_close_session_sync(struct se_portal_group *, int);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 8d11a8c..942b0c5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -650,6 +650,7 @@ static int target_release_res(struct se_device *dev, void *data)
 void transport_deregister_session(struct se_session *se_sess)
 {
 	struct se_portal_group *se_tpg = se_sess->se_tpg;
+	struct completion *removal_comp;
 	unsigned long flags;
 
 	if (!se_tpg) {
@@ -660,6 +661,8 @@ void transport_deregister_session(struct se_session *se_sess)
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
 	list_del(&se_sess->sess_list);
 	se_sess->se_tpg = NULL;
+	removal_comp = se_sess->removal_comp;
+	se_sess->removal_comp = NULL;
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 
 	/*
@@ -680,11 +683,98 @@ void transport_deregister_session(struct se_session *se_sess)
 	 */
 
 	transport_free_session(se_sess);
+
+	if (removal_comp)
+		complete(removal_comp);
 }
 EXPORT_SYMBOL(transport_deregister_session);
 
+/**
+ * target_close_session_sync - Request fabric remove session and wait removal
+ * @se_tpg: se_portal_group that is the parent of the sess to remove
+ * @sid: session id
+ */
+int target_close_session_sync(struct se_portal_group *se_tpg, int sid)
+{
+	DECLARE_COMPLETION_ONSTACK(removal_comp);
+	struct se_session *se_sess;
+	unsigned long flags;
+	int ret;
+
+retry:
+	spin_lock_irqsave(&se_tpg->session_lock, flags);
+	list_for_each_entry(se_sess, &se_tpg->tpg_sess_list, sess_list) {
+		if (se_sess->sid = sid) {
+			config_group_get(&se_sess->group);
+			goto found;
+		}
+	}
+	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+	return -ENODEV;
+
+found:
+	if (!se_sess->tfo->close_session) {
+		pr_err("Session %d does not support configfs session removal.",
+		       se_sess->sid);
+		return -EINVAL;
+	}
+
+	if (se_sess->sess_tearing_down || se_sess->sess_remove_running ||
+	    se_sess->removal_comp) {
+		spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+		config_group_put(&se_sess->group);
+		/*
+		 * Either the transport started a removal already or another
+		 * caller of this function did. Wait for it to be torn down,
+		 * so caller knows it's safe to proceed with operations like
+		 * parent removals when this returns.
+		 */
+		msleep(250);
+		goto retry;
+	}
+
+	se_sess->removal_comp = &removal_comp;
+	pr_debug("Closing session-%d\n", se_sess->sid);
+	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+
+	ret = se_sess->tfo->close_session(se_sess);
+	if (ret < 0) {
+		pr_debug("Close for session-%d failed %d\n", se_sess->sid, ret);
+		if (ret != -ENODEV) {
+			spin_lock_irqsave(&se_tpg->session_lock, flags);
+			se_sess->removal_comp = NULL;
+			spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+			goto put_sess;
+		}
+		/*
+		 * Raced with fabric specific nexus interface, but we set our
+		 * compeltion before they called target_remove_session, so we
+		 * can just wait below for them to call complete.
+		 */
+	}
+
+	wait_for_completion(&removal_comp);
+
+put_sess:
+	config_group_put(&se_sess->group);
+	return ret;
+}
+
 void target_remove_session(struct se_session *se_sess)
 {
+	struct se_portal_group *se_tpg = se_sess->se_tpg;
+	unsigned long flags;
+
+	pr_debug("Removing session-%d\n", se_sess->sid);
+
+	spin_lock_irqsave(&se_tpg->session_lock, flags);
+	if (se_sess->sess_remove_running) {
+		spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+		return;
+	}
+	se_sess->sess_remove_running = 1;
+	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
+
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d6aca0c..690fff2 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -609,12 +609,14 @@ static inline struct se_node_acl *fabric_stat_to_nacl(struct config_item *item)
 
 struct se_session {
 	unsigned		sess_tearing_down:1;
+	unsigned		sess_remove_running:1;
 	u64			sess_bin_isid;
 	enum target_prot_op	sup_prot_ops;
 	enum target_prot_type	sess_prot_type;
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
+	struct completion	*removal_comp;
 	struct percpu_ref	cmd_count;
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
-- 
1.8.3.1

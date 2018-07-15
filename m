From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:26 +0000
Subject: [PATCH 10/15] target: add lock around session fields exported in configfs
Message-Id: <1531696591-8558-11-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The next patches will export the initiator port info and
add a file to test a session. This patch adds locking
around the fields that will be exported in the session's
configfs dir.

It also moves the setting of se_tpg/fabric_sess_ptr to the
end of registration so we know that when they are set
the session has been full registered.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_transport.c | 13 +++++++++++--
 include/target/target_core_base.h      |  1 +
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0efb3dc..04ef13c 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -238,6 +238,7 @@ void transport_init_session(struct se_session *se_sess)
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
+	spin_lock_init(&se_sess->configfs_lock);
 	init_waitqueue_head(&se_sess->cmd_list_wq);
 }
 EXPORT_SYMBOL(transport_init_session);
@@ -377,7 +378,6 @@ void __transport_register_session(
 	unsigned char buf[PR_REG_ISID_LEN];
 	unsigned long flags;
 
-	se_sess->se_tpg = se_tpg;
 	se_sess->fabric_sess_ptr = fabric_sess_ptr;
 	/*
 	 * Used by struct se_node_acl's under ConfigFS to locate active se_session-t
@@ -426,6 +426,10 @@ void __transport_register_session(
 	}
 	list_add_tail(&se_sess->sess_list, &se_tpg->tpg_sess_list);
 
+	spin_lock(&se_sess->configfs_lock);
+	se_sess->se_tpg = se_tpg;
+	spin_unlock(&se_sess->configfs_lock);
+
 	pr_debug("TARGET_CORE[%s]: Registered fabric_sess_ptr: %p\n",
 		se_tpg->se_tpg_tfo->get_fabric_name(), se_sess->fabric_sess_ptr);
 }
@@ -603,7 +607,9 @@ void transport_free_session(struct se_session *se_sess)
 		struct se_portal_group *se_tpg = se_nacl->se_tpg;
 		const struct target_core_fabric_ops *se_tfo = se_tpg->se_tpg_tfo;
 
+		spin_lock_irqsave(&se_sess->configfs_lock, flags);
 		se_sess->se_node_acl = NULL;
+		spin_unlock_irqrestore(&se_sess->configfs_lock, flags);
 
 		/*
 		 * Also determine if we need to drop the extra ->cmd_kref if
@@ -647,8 +653,11 @@ void transport_deregister_session(struct se_session *se_sess)
 
 	spin_lock_irqsave(&se_tpg->session_lock, flags);
 	list_del(&se_sess->sess_list);
-	se_sess->se_tpg = NULL;
 	se_sess->fabric_sess_ptr = NULL;
+
+	spin_lock(&se_sess->configfs_lock);
+	se_sess->se_tpg = NULL;
+	spin_unlock(&se_sess->configfs_lock);
 	spin_unlock_irqrestore(&se_tpg->session_lock, flags);
 
 	pr_debug("TARGET_CORE[%s]: Deregistered fabric_sess\n",
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 01caaa3..d3bb76c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -606,6 +606,7 @@ struct se_session {
 	struct list_head	sess_acl_list;
 	struct list_head	sess_cmd_list;
 	spinlock_t		sess_cmd_lock;
+	spinlock_t		configfs_lock;
 	wait_queue_head_t	cmd_list_wq;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
-- 
2.7.2


From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:42 +0000
Subject: [PATCH 05/17] target/core: Make sure that target_wait_for_sess_cmds() waits long enough
Message-Id: <20180917213554.987-6-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

A session must only be released after all code that accesses the session
structure has finished. Make sure that this is the case by introducing a
new command counter per session that is only decremented after the
.release_cmd() callback has finished.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_transport.c | 27 +++++++++++++++++---------
 include/target/target_core_base.h      |  1 +
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 94e9d03af99d..54ccd8f56a57 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -224,6 +224,13 @@ void transport_subsystem_check_init(void)
 	sub_api_initialized = 1;
 }
 
+static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
+{
+	struct se_session *sess = container_of(ref, typeof(*sess), cmd_count);
+
+	wake_up(&sess->cmd_list_wq);
+}
+
 /**
  * transport_init_session - initialize a session object
  * @se_sess: Session object pointer.
@@ -237,7 +244,8 @@ int transport_init_session(struct se_session *se_sess)
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
 	init_waitqueue_head(&se_sess->cmd_list_wq);
-	return 0;
+	return percpu_ref_init(&se_sess->cmd_count,
+			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
 }
 EXPORT_SYMBOL(transport_init_session);
 
@@ -587,6 +595,7 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
+	percpu_ref_exit(&se_sess->cmd_count);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
@@ -2730,6 +2739,7 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 	}
 	se_cmd->transport_state |= CMD_T_PRE_EXECUTE;
 	list_add_tail(&se_cmd->se_cmd_list, &se_sess->sess_cmd_list);
+	percpu_ref_get(&se_sess->cmd_count);
 out:
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 
@@ -2760,8 +2770,6 @@ static void target_release_cmd_kref(struct kref *kref)
 	if (se_sess) {
 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 		list_del_init(&se_cmd->se_cmd_list);
-		if (list_empty(&se_sess->sess_cmd_list))
-			wake_up(&se_sess->cmd_list_wq);
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 	}
 
@@ -2769,6 +2777,8 @@ static void target_release_cmd_kref(struct kref *kref)
 	se_cmd->se_tfo->release_cmd(se_cmd);
 	if (compl)
 		complete(compl);
+
+	percpu_ref_put(&se_sess->cmd_count);
 }
 
 /**
@@ -2897,6 +2907,8 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
 	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
 	se_sess->sess_tearing_down = 1;
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
+
+	percpu_ref_kill_and_confirm(&se_sess->cmd_count, NULL);
 }
 EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
 
@@ -2911,17 +2923,14 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
 
 	WARN_ON_ONCE(!se_sess->sess_tearing_down);
 
-	spin_lock_irq(&se_sess->sess_cmd_lock);
 	do {
-		ret = wait_event_interruptible_lock_irq_timeout(
-				se_sess->cmd_list_wq,
-				list_empty(&se_sess->sess_cmd_list),
-				se_sess->sess_cmd_lock, 180 * HZ);
+		ret = wait_event_timeout(se_sess->cmd_list_wq,
+				percpu_ref_is_zero(&se_sess->cmd_count),
+				180 * HZ);
 		list_for_each_entry(cmd, &se_sess->sess_cmd_list, se_cmd_list)
 			target_show_cmd("session shutdown: still waiting for ",
 					cmd);
 	} while (ret <= 0);
-	spin_unlock_irq(&se_sess->sess_cmd_lock);
 }
 EXPORT_SYMBOL(target_wait_for_sess_cmds);
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 7a4ee7852ca4..2cfd3b4573b0 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -602,6 +602,7 @@ struct se_session {
 	struct se_node_acl	*se_node_acl;
 	struct se_portal_group *se_tpg;
 	void			*fabric_sess_ptr;
+	struct percpu_ref	cmd_count;
 	struct list_head	sess_list;
 	struct list_head	sess_acl_list;
 	struct list_head	sess_cmd_list;
-- 
2.18.0

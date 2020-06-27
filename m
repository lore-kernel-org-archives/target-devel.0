From: Mike Christie <michael.christie@oracle.com>
Date: Sat, 27 Jun 2020 04:35:00 +0000
Subject: [RFC PATCH 01/10] target: add common session id
Message-Id: <1593232509-13720-2-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The iscsi target and lio core, use a unique session id for a
couple uses like scsiAttIntrPortIndex, and transport specifics
like logging sessions under a tpgt.

This adds a common id that is managed by lio core, which lio
core and all transports can use. It will also then be used
for in the next patches for the session identifier value used
for the configfs dir name.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---

V3:
This is actually the 3rd version of this patch. Bart, in one
version you requested that it be per tpg or target. I did that
but then I reversed here.

Userspace apps would prefer that it's module wide, so that they
can have a single lookup table when exporting a device through
multiple targets. Also to keep compat with the old iscsi mod
use cases, we needed it to be module wide.

 drivers/target/target_core_transport.c | 22 +++++++++++++++++++---
 include/target/target_core_base.h      |  1 +
 2 files changed, 20 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 90ecdd7..3d06f52 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -50,6 +50,8 @@
 struct kmem_cache *t10_alua_lba_map_cache;
 struct kmem_cache *t10_alua_lba_map_mem_cache;
 
+static DEFINE_IDA(se_sess_ida);
+
 static void transport_complete_task_attr(struct se_cmd *cmd);
 static void translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason);
 static void transport_handle_queue_full(struct se_cmd *cmd,
@@ -153,6 +155,7 @@ int init_se_kmem_caches(void)
 
 void release_se_kmem_caches(void)
 {
+	ida_destroy(&se_sess_ida);
 	destroy_workqueue(target_completion_wq);
 	kmem_cache_destroy(se_sess_cache);
 	kmem_cache_destroy(se_ua_cache);
@@ -251,14 +254,26 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
+
+	ret = ida_simple_get(&se_sess_ida, 1, 0, GFP_KERNEL);
 	if (ret < 0) {
-		kmem_cache_free(se_sess_cache, se_sess);
-		return ERR_PTR(ret);
+		pr_err("Unable to allocate session index.\n");
+		goto free_sess;
 	}
+	se_sess->sid = ret;
+
+	ret = transport_init_session(se_sess);
+	if (ret < 0)
+		goto free_ida;
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
+
+free_ida:
+	ida_simple_remove(&se_sess_ida, se_sess->sid);
+free_sess:
+	kmem_cache_free(se_sess_cache, se_sess);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(transport_alloc_session);
 
@@ -580,6 +595,7 @@ void transport_free_session(struct se_session *se_sess)
 		kvfree(se_sess->sess_cmd_map);
 	}
 	percpu_ref_exit(&se_sess->cmd_count);
+	ida_simple_remove(&se_sess_ida, se_sess->sid);
 	kmem_cache_free(se_sess_cache, se_sess);
 }
 EXPORT_SYMBOL(transport_free_session);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 18c3f27..adea3bd 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -623,6 +623,7 @@ struct se_session {
 	wait_queue_head_t	cmd_list_wq;
 	void			*sess_cmd_map;
 	struct sbitmap_queue	sess_tag_pool;
+	int			sid;
 };
 
 struct se_device;
-- 
1.8.3.1

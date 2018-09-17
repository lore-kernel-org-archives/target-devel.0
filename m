From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:41 +0000
Subject: [PATCH 04/17] target/core: Change the return type of transport_init_session from void to int
Message-Id: <20180917213554.987-5-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch does not change any functionality but makes the next patch in
this series easier to read.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_transport.c | 10 ++++++++--
 drivers/target/target_core_xcopy.c     |  6 +++++-
 include/target/target_core_fabric.h    |  2 +-
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2c0d8626d57d..94e9d03af99d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -230,13 +230,14 @@ void transport_subsystem_check_init(void)
  *
  * The caller must have zero-initialized @se_sess before calling this function.
  */
-void transport_init_session(struct se_session *se_sess)
+int transport_init_session(struct se_session *se_sess)
 {
 	INIT_LIST_HEAD(&se_sess->sess_list);
 	INIT_LIST_HEAD(&se_sess->sess_acl_list);
 	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
 	spin_lock_init(&se_sess->sess_cmd_lock);
 	init_waitqueue_head(&se_sess->cmd_list_wq);
+	return 0;
 }
 EXPORT_SYMBOL(transport_init_session);
 
@@ -247,6 +248,7 @@ EXPORT_SYMBOL(transport_init_session);
 struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
+	int ret;
 
 	se_sess = kmem_cache_zalloc(se_sess_cache, GFP_KERNEL);
 	if (!se_sess) {
@@ -254,7 +256,11 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	transport_init_session(se_sess);
+	ret = transport_init_session(se_sess);
+	if (ret < 0) {
+		kfree(se_sess);
+		return ERR_PTR(ret);
+	}
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 70adcfdca8d1..124495f953fa 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -479,6 +479,8 @@ static const struct target_core_fabric_ops xcopy_pt_tfo = {
 
 int target_xcopy_setup_pt(void)
 {
+	int ret;
+
 	xcopy_wq = alloc_workqueue("xcopy_wq", WQ_MEM_RECLAIM, 0);
 	if (!xcopy_wq) {
 		pr_err("Unable to allocate xcopy_wq\n");
@@ -496,7 +498,9 @@ int target_xcopy_setup_pt(void)
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_list);
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_sess_list);
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
-	transport_init_session(&xcopy_pt_sess);
+	ret = transport_init_session(&xcopy_pt_sess);
+	if (ret < 0)
+		return ret;
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index f4147b398431..eb9d0923c55c 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -116,7 +116,7 @@ struct se_session *target_setup_session(struct se_portal_group *,
 				struct se_session *, void *));
 void target_remove_session(struct se_session *);
 
-void transport_init_session(struct se_session *);
+int transport_init_session(struct se_session *se_sess);
 struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
-- 
2.18.0

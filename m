From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:52:52 +0000
Subject: [PATCH 05/20] target: Introduce transport_init_session()
Message-Id: <20180622215307.8758-6-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Other than initializing xcopy_pt_sess.sess_wait_list, this patch
does not change any functionality.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_transport.c | 22 +++++++++++++++++-----
 drivers/target/target_core_xcopy.c     |  5 +----
 include/target/target_core_fabric.h    |  1 +
 3 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 880e07f40099..595b2f12ca6a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -224,6 +224,22 @@ void transport_subsystem_check_init(void)
 	sub_api_initialized = 1;
 }
 
+/**
+ * transport_init_session - initialize a session object
+ * @se_sess: Session object pointer.
+ *
+ * The caller must have zero-initialized @se_sess before calling this function.
+ */
+void transport_init_session(struct se_session *se_sess)
+{
+	INIT_LIST_HEAD(&se_sess->sess_list);
+	INIT_LIST_HEAD(&se_sess->sess_acl_list);
+	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
+	INIT_LIST_HEAD(&se_sess->sess_wait_list);
+	spin_lock_init(&se_sess->sess_cmd_lock);
+}
+EXPORT_SYMBOL(transport_init_session);
+
 /**
  * transport_alloc_session - allocate a session object and initialize it
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
@@ -238,11 +254,7 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	INIT_LIST_HEAD(&se_sess->sess_list);
-	INIT_LIST_HEAD(&se_sess->sess_acl_list);
-	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
-	INIT_LIST_HEAD(&se_sess->sess_wait_list);
-	spin_lock_init(&se_sess->sess_cmd_lock);
+	transport_init_session(se_sess);
 	se_sess->sup_prot_ops = sup_prot_ops;
 
 	return se_sess;
diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 9ee89e00cd77..2718a933c0c6 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -497,10 +497,7 @@ int target_xcopy_setup_pt(void)
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_list);
 	INIT_LIST_HEAD(&xcopy_pt_nacl.acl_sess_list);
 	memset(&xcopy_pt_sess, 0, sizeof(struct se_session));
-	INIT_LIST_HEAD(&xcopy_pt_sess.sess_list);
-	INIT_LIST_HEAD(&xcopy_pt_sess.sess_acl_list);
-	INIT_LIST_HEAD(&xcopy_pt_sess.sess_cmd_list);
-	spin_lock_init(&xcopy_pt_sess.sess_cmd_lock);
+	transport_init_session(&xcopy_pt_sess);
 
 	xcopy_pt_nacl.se_tpg = &xcopy_pt_tpg;
 	xcopy_pt_nacl.nacl_sess = &xcopy_pt_sess;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 010df9d5b977..84a681b6e5ca 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -115,6 +115,7 @@ struct se_session *target_alloc_session(struct se_portal_group *,
 		int (*callback)(struct se_portal_group *,
 				struct se_session *, void *));
 
+void transport_init_session(struct se_session *);
 struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
-- 
2.17.1


From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:52:51 +0000
Subject: [PATCH 04/20] target: Rename transport_init_session() into transport_alloc_session()
Message-Id: <20180622215307.8758-5-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/target/iscsi/iscsi_target_login.c |  2 +-
 drivers/target/target_core_transport.c    | 26 +++++++++++++++++++----
 include/target/target_core_fabric.h       |  2 +-
 3 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 99501785cdc1..923b1a9fc3dc 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -369,7 +369,7 @@ static int iscsi_login_zero_tsih_s1(
 		return -ENOMEM;
 	}
 
-	sess->se_sess = transport_init_session(TARGET_PROT_NORMAL);
+	sess->se_sess = transport_alloc_session(TARGET_PROT_NORMAL);
 	if (IS_ERR(sess->se_sess)) {
 		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5e8329c5ddd0..880e07f40099 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -224,7 +224,11 @@ void transport_subsystem_check_init(void)
 	sub_api_initialized = 1;
 }
 
-struct se_session *transport_init_session(enum target_prot_op sup_prot_ops)
+/**
+ * transport_alloc_session - allocate a session object and initialize it
+ * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
+ */
+struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
 
@@ -243,8 +247,15 @@ struct se_session *transport_init_session(enum target_prot_op sup_prot_ops)
 
 	return se_sess;
 }
-EXPORT_SYMBOL(transport_init_session);
+EXPORT_SYMBOL(transport_alloc_session);
 
+/**
+ * transport_alloc_session_tags - allocate target driver private data
+ * @se_sess:  Session pointer.
+ * @tag_num:  Maximum number of in-flight commands between initiator and target.
+ * @tag_size: Size in bytes of the private data a target driver associates with
+ *	      each command.
+ */
 int transport_alloc_session_tags(struct se_session *se_sess,
 			         unsigned int tag_num, unsigned int tag_size)
 {
@@ -274,6 +285,13 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 }
 EXPORT_SYMBOL(transport_alloc_session_tags);
 
+/**
+ * transport_init_session_tags - allocate a session and target driver private data
+ * @tag_num:  Maximum number of in-flight commands between initiator and target.
+ * @tag_size: Size in bytes of the private data a target driver associates with
+ *	      each command.
+ * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
+ */
 struct se_session *transport_init_session_tags(unsigned int tag_num,
 					       unsigned int tag_size,
 					       enum target_prot_op sup_prot_ops)
@@ -292,7 +310,7 @@ struct se_session *transport_init_session_tags(unsigned int tag_num,
 		return ERR_PTR(-EINVAL);
 	}
 
-	se_sess = transport_init_session(sup_prot_ops);
+	se_sess = transport_alloc_session(sup_prot_ops);
 	if (IS_ERR(se_sess))
 		return se_sess;
 
@@ -402,7 +420,7 @@ target_alloc_session(struct se_portal_group *tpg,
 	if (tag_num != 0)
 		sess = transport_init_session_tags(tag_num, tag_size, prot_op);
 	else
-		sess = transport_init_session(prot_op);
+		sess = transport_alloc_session(prot_op);
 
 	if (IS_ERR(sess))
 		return sess;
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index b297aa0d9651..010df9d5b977 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -115,7 +115,7 @@ struct se_session *target_alloc_session(struct se_portal_group *,
 		int (*callback)(struct se_portal_group *,
 				struct se_session *, void *));
 
-struct se_session *transport_init_session(enum target_prot_op);
+struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
 struct se_session *transport_init_session_tags(unsigned int, unsigned int,
-- 
2.17.1


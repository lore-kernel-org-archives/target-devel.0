From: Mike Christie <mchristi@redhat.com>
Date: Thu, 02 Aug 2018 17:12:22 +0000
Subject: [PATCH 3/8] target: make transport_init_session_tags static
Message-Id: <1533229947-6277-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

transport_init_session_tags is only called from target_core_transport.c
so make it static.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 7 +++----
 include/target/target_core_fabric.h    | 2 --
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b419d4f..8044b81 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -304,9 +304,9 @@ EXPORT_SYMBOL(transport_alloc_session_tags);
  *	      each command.
  * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
  */
-struct se_session *transport_init_session_tags(unsigned int tag_num,
-					       unsigned int tag_size,
-					       enum target_prot_op sup_prot_ops)
+static struct se_session *
+transport_init_session_tags(unsigned int tag_num, unsigned int tag_size,
+			    enum target_prot_op sup_prot_ops)
 {
 	struct se_session *se_sess;
 	int rc;
@@ -334,7 +334,6 @@ struct se_session *transport_init_session_tags(unsigned int tag_num,
 
 	return se_sess;
 }
-EXPORT_SYMBOL(transport_init_session_tags);
 
 /*
  * Called with spin_lock_irqsave(&struct se_portal_group->session_lock called.
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index f61aa71..d0d0642 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -119,8 +119,6 @@ void transport_init_session(struct se_session *);
 struct se_session *transport_alloc_session(enum target_prot_op);
 int transport_alloc_session_tags(struct se_session *, unsigned int,
 		unsigned int);
-struct se_session *transport_init_session_tags(unsigned int, unsigned int,
-		enum target_prot_op);
 void	__transport_register_session(struct se_portal_group *,
 		struct se_node_acl *, struct se_session *, void *);
 void	transport_register_session(struct se_portal_group *,
-- 
2.7.2


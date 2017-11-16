From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 06:14:13 +0000
Subject: [PATCH-4.1.y 1/7] target: Obtain se_node_acl->acl_kref during get_initiator_node_acl
Message-Id: <1510812859-15101-2-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Mike Christie <michaelc@cs.wisc.edu>

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 21aaa23b0ebbd19334fa461370c03cbb076b3295 upstream.

This patch addresses a long standing race where obtaining
se_node_acl->acl_kref in __transport_register_session()
happens a bit too late, and leaves open the potential
for core_tpg_del_initiator_node_acl() to hit a NULL
pointer dereference.

Instead, take ->acl_kref in core_tpg_get_initiator_node_acl()
while se_portal_group->acl_node_mutex is held, and move the
final target_put_nacl() from transport_deregister_session()
into transport_free_session() so that fabric driver login
failure handling using the modern method to still work
as expected.

Also, update core_tpg_get_initiator_node_acl() to take
an extra reference for dynamically generated acls for
demo-mode, before returning to fabric caller.  Also
update iscsi-target sendtargets special case handling
to use target_tpg_has_node_acl() when checking if
demo_mode_discovery = true during discovery lookup.

Note the existing wait_for_completion(&acl->acl_free_comp)
in core_tpg_del_initiator_node_acl() does not change.

Cc: Sagi Grimberg <sagig@mellanox.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Andy Grover <agrover@redhat.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/iscsi/iscsi_target.c    |  2 +-
 drivers/target/target_core_tpg.c       | 44 ++++++++++++++++++++++++++++++++--
 drivers/target/target_core_transport.c | 18 +++++++++-----
 include/target/target_core_fabric.h    |  2 ++
 4 files changed, 57 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 7444640a..d6cb9e8 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3449,7 +3449,7 @@ iscsit_build_sendtargets_response(struct iscsi_cmd *cmd,
 
 			if ((tpg->tpg_attrib.generate_node_acls = 0) &&
 			    (tpg->tpg_attrib.demo_mode_discovery = 0) &&
-			    (!core_tpg_get_initiator_node_acl(&tpg->tpg_se_tpg,
+			    (!target_tpg_has_node_acl(&tpg->tpg_se_tpg,
 				cmd->conn->sess->sess_ops->InitiatorName))) {
 				continue;
 			}
diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index 47f0644..6c350f0 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -110,9 +110,21 @@ struct se_node_acl *core_tpg_get_initiator_node_acl(
 	unsigned char *initiatorname)
 {
 	struct se_node_acl *acl;
-
+	/*
+	 * Obtain se_node_acl->acl_kref using fabric driver provided
+	 * initiatorname[] during node acl endpoint lookup driven by
+	 * new se_session login.
+	 *
+	 * The reference is held until se_session shutdown -> release
+	 * occurs via fabric driver invoked transport_deregister_session()
+	 * or transport_free_session() code.
+	 */
 	spin_lock_irq(&tpg->acl_node_lock);
 	acl = __core_tpg_get_initiator_node_acl(tpg, initiatorname);
+	if (acl) {
+		if (!kref_get_unless_zero(&acl->acl_kref))
+			acl = NULL;
+	}
 	spin_unlock_irq(&tpg->acl_node_lock);
 
 	return acl;
@@ -254,6 +266,25 @@ static int core_create_device_list_for_node(struct se_node_acl *nacl)
 	return 0;
 }
 
+bool target_tpg_has_node_acl(struct se_portal_group *tpg,
+			     const char *initiatorname)
+{
+	struct se_node_acl *acl;
+	bool found = false;
+
+	spin_lock_irq(&tpg->acl_node_lock);
+	list_for_each_entry(acl, &tpg->acl_node_list, acl_list) {
+		if (!strcmp(acl->initiatorname, initiatorname)) {
+			found = true;
+			break;
+		}
+	}
+	spin_unlock_irq(&tpg->acl_node_lock);
+
+	return found;
+}
+EXPORT_SYMBOL(target_tpg_has_node_acl);
+
 /*	core_tpg_check_initiator_node_acl()
  *
  *
@@ -274,10 +305,19 @@ struct se_node_acl *core_tpg_check_initiator_node_acl(
 	acl =  tpg->se_tpg_tfo->tpg_alloc_fabric_acl(tpg);
 	if (!acl)
 		return NULL;
+	/*
+	 * When allocating a dynamically generated node_acl, go ahead
+	 * and take the extra kref now before returning to the fabric
+	 * driver caller.
+	 *
+	 * Note this reference will be released at session shutdown
+	 * time within transport_free_session() code.
+	 */
+	kref_init(&acl->acl_kref);
+	kref_get(&acl->acl_kref);
 
 	INIT_LIST_HEAD(&acl->acl_list);
 	INIT_LIST_HEAD(&acl->acl_sess_list);
-	kref_init(&acl->acl_kref);
 	init_completion(&acl->acl_free_comp);
 	spin_lock_init(&acl->device_list_lock);
 	spin_lock_init(&acl->nacl_sess_lock);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b7d27b8..3bf46bf 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -359,7 +359,6 @@ void __transport_register_session(
 					&buf[0], PR_REG_ISID_LEN);
 			se_sess->sess_bin_isid = get_unaligned_be64(&buf[0]);
 		}
-		kref_get(&se_nacl->acl_kref);
 
 		spin_lock_irq(&se_nacl->nacl_sess_lock);
 		/*
@@ -456,6 +455,7 @@ void target_put_nacl(struct se_node_acl *nacl)
 {
 	kref_put(&nacl->acl_kref, target_complete_nacl);
 }
+EXPORT_SYMBOL(target_put_nacl);
 
 void transport_deregister_session_configfs(struct se_session *se_sess)
 {
@@ -488,6 +488,15 @@ EXPORT_SYMBOL(transport_deregister_session_configfs);
 
 void transport_free_session(struct se_session *se_sess)
 {
+	struct se_node_acl *se_nacl = se_sess->se_node_acl;
+	/*
+	 * Drop the se_node_acl->nacl_kref obtained from within
+	 * core_tpg_get_initiator_node_acl().
+	 */
+	if (se_nacl) {
+		se_sess->se_node_acl = NULL;
+		target_put_nacl(se_nacl);
+	}
 	if (se_sess->sess_cmd_map) {
 		percpu_ida_destroy(&se_sess->sess_tag_pool);
 		if (is_vmalloc_addr(se_sess->sess_cmd_map))
@@ -505,7 +514,6 @@ void transport_deregister_session(struct se_session *se_sess)
 	const struct target_core_fabric_ops *se_tfo;
 	struct se_node_acl *se_nacl;
 	unsigned long flags;
-	bool comp_nacl = true;
 
 	if (!se_tpg) {
 		transport_free_session(se_sess);
@@ -533,9 +541,9 @@ void transport_deregister_session(struct se_session *se_sess)
 			spin_unlock_irqrestore(&se_tpg->acl_node_lock, flags);
 			core_tpg_wait_for_nacl_pr_ref(se_nacl);
 			core_free_device_list_for_node(se_nacl, se_tpg);
+			se_sess->se_node_acl = NULL;
 			se_tfo->tpg_release_fabric_acl(se_tpg, se_nacl);
 
-			comp_nacl = false;
 			spin_lock_irqsave(&se_tpg->acl_node_lock, flags);
 		}
 	}
@@ -546,10 +554,8 @@ void transport_deregister_session(struct se_session *se_sess)
 	/*
 	 * If last kref is dropping now for an explicit NodeACL, awake sleeping
 	 * ->acl_free_comp caller to wakeup configfs se_node_acl->acl_group
-	 * removal context.
+	 * removal context from within transport_free_session() code.
 	 */
-	if (se_nacl && comp_nacl)
-		target_put_nacl(se_nacl);
 
 	transport_free_session(se_sess);
 }
diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
index 24c8d9d..419a8c8 100644
--- a/include/target/target_core_fabric.h
+++ b/include/target/target_core_fabric.h
@@ -171,6 +171,8 @@ int	transport_lookup_tmr_lun(struct se_cmd *, u32);
 
 struct se_node_acl *core_tpg_get_initiator_node_acl(struct se_portal_group *tpg,
 		unsigned char *);
+bool	target_tpg_has_node_acl(struct se_portal_group *tpg,
+		const char *);
 struct se_node_acl *core_tpg_check_initiator_node_acl(struct se_portal_group *,
 		unsigned char *);
 void	core_tpg_clear_object_luns(struct se_portal_group *);
-- 
1.8.5.3


From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 29 Apr 2020 09:44:37 +0000
Subject: [RFC PATCH 04/11] scsi: target/core: Add RTPI field to target port
Message-Id: <20200429094443.43937-5-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>

SAM-5 4.6.5.2 (Relative Port Identifier attribute) defines the attribute
as unique across SCSI target ports.

The change introduces RTPI attribute to se_portal group. The value is
auto-incremented and unique across all SCSI target ports. It also limits
number of SCSI target ports to 65535.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_tpg.c  | 80 +++++++++++++++++++++++++++++--
 include/target/target_core_base.h |  4 ++
 2 files changed, 80 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d3896c3f2f95..e9f6b0aadbcf 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -31,6 +31,10 @@
 #include "target_core_ua.h"
 
 extern struct se_device *g_lun0_dev;
+static u16 g_tpg_count;
+static u16 g_tpg_rtpi_counter = 1;
+static LIST_HEAD(g_tpg_list);
+static DEFINE_MUTEX(g_tpg_mutex);
 
 /*	__core_tpg_get_initiator_node_acl():
  *
@@ -439,6 +443,60 @@ static void core_tpg_lun_ref_release(struct percpu_ref *ref)
 	complete(&lun->lun_shutdown_comp);
 }
 
+static int core_tpg_register_rtpi(struct se_portal_group *se_tpg)
+{
+	struct se_portal_group *tpg;
+	int ret;
+
+	/*
+	 * Allocate the next RELATIVE TARGET PORT IDENTIFIER.
+	 * Here is the table from SPC-4 4.3.4:
+	 *
+	 *    Table 34 -- Relative target port identifier values
+	 *
+	 * Value		Description
+	 * 0h			Reserved
+	 * 1h			Relative port 1, historically known as port A
+	 * 2h			Relative port 2, historically known as port B
+	 * 3h to FFFFh		Relative port 3 through 65 535
+	 */
+	ret = mutex_lock_interruptible(&g_tpg_mutex);
+	if (ret < 0)
+		return ret;
+
+	if (g_tpg_count = 0xffff) {
+		mutex_unlock(&g_tpg_mutex);
+		pr_warn("Reached g_tpg_count = 0xffff\n");
+		return -ENOSPC;
+	}
+again:
+	se_tpg->tpg_rtpi = g_tpg_rtpi_counter++;
+	if (!se_tpg->tpg_rtpi)
+		goto again;
+
+	list_for_each_entry(tpg, &g_tpg_list, tpg_list) {
+		/*
+		 * Make sure RELATIVE TARGET PORT IDENTIFIER is unique
+		 * for 16-bit wrap..
+		 */
+		if (se_tpg->tpg_rtpi = tpg->tpg_rtpi)
+			goto again;
+	}
+	list_add(&se_tpg->tpg_list, &g_tpg_list);
+	g_tpg_count++;
+	mutex_unlock(&g_tpg_mutex);
+
+	return 0;
+}
+
+static void core_tpg_deregister_rtpi(struct se_portal_group *se_tpg)
+{
+	mutex_lock(&g_tpg_mutex);
+	list_del(&se_tpg->tpg_list);
+	g_tpg_count--;
+	mutex_unlock(&g_tpg_mutex);
+}
+
 /* Does not change se_wwn->priv. */
 int core_tpg_register(
 	struct se_wwn *se_wwn,
@@ -471,6 +529,7 @@ int core_tpg_register(
 	se_tpg->proto_id = proto_id;
 	se_tpg->se_tpg_wwn = se_wwn;
 	atomic_set(&se_tpg->tpg_pr_ref_count, 0);
+	INIT_LIST_HEAD(&se_tpg->tpg_list);
 	INIT_LIST_HEAD(&se_tpg->acl_node_list);
 	INIT_LIST_HEAD(&se_tpg->tpg_sess_list);
 	spin_lock_init(&se_tpg->session_lock);
@@ -478,9 +537,15 @@ int core_tpg_register(
 	mutex_init(&se_tpg->acl_node_mutex);
 
 	if (se_tpg->proto_id >= 0) {
+		ret = core_tpg_register_rtpi(se_tpg);
+		if (ret < 0)
+			return ret;
+
 		se_tpg->tpg_virt_lun0 = core_tpg_alloc_lun(se_tpg, 0);
-		if (IS_ERR(se_tpg->tpg_virt_lun0))
-			return PTR_ERR(se_tpg->tpg_virt_lun0);
+		if (IS_ERR(se_tpg->tpg_virt_lun0)) {
+			ret = PTR_ERR(se_tpg->tpg_virt_lun0);
+			goto out_deregister_rtpi;
+		}
 
 		ret = core_tpg_add_lun(se_tpg, se_tpg->tpg_virt_lun0,
 				true, g_lun0_dev);
@@ -489,15 +554,20 @@ int core_tpg_register(
 	}
 
 	pr_debug("TARGET_CORE[%s]: Allocated portal_group for endpoint: %s, "
-		 "Proto: %d, Portal Tag: %u\n", se_tpg->se_tpg_tfo->fabric_name,
+		 "Proto: %d, Portal Tag: %u, RTPI: %#2x\n",
+		se_tpg->se_tpg_tfo->fabric_name,
 		se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) ?
 		se_tpg->se_tpg_tfo->tpg_get_wwn(se_tpg) : NULL,
-		se_tpg->proto_id, se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg));
+		se_tpg->proto_id,
+		se_tpg->se_tpg_tfo->tpg_get_tag(se_tpg),
+		se_tpg->tpg_rtpi);
 
 	return 0;
 
 out_free_lun0:
 	kfree(se_tpg->tpg_virt_lun0);
+out_deregister_rtpi:
+	core_tpg_deregister_rtpi(se_tpg);
 	return ret;
 }
 EXPORT_SYMBOL(core_tpg_register);
@@ -537,6 +607,8 @@ int core_tpg_deregister(struct se_portal_group *se_tpg)
 		kfree_rcu(se_tpg->tpg_virt_lun0, rcu_head);
 	}
 
+	core_tpg_deregister_rtpi(se_tpg);
+
 	return 0;
 }
 EXPORT_SYMBOL(core_tpg_deregister);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 922b3086e408..cd7c29f46acc 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -875,6 +875,8 @@ struct se_portal_group {
 	 * Negative values can be used by fabric drivers for internal use TPGs.
 	 */
 	int			proto_id;
+	/* RELATIVE TARGET PORT IDENTIFIER */
+	u16			tpg_rtpi;
 	/* Used for PR SPEC_I_PT=1 and REGISTER_AND_MOVE */
 	atomic_t		tpg_pr_ref_count;
 	/* Spinlock for adding/removing ACLed Nodes */
@@ -882,6 +884,8 @@ struct se_portal_group {
 	/* Spinlock for adding/removing sessions */
 	spinlock_t		session_lock;
 	struct mutex		tpg_lun_mutex;
+	/* List of all SCSI target ports */
+	struct list_head	tpg_list;
 	/* linked list for initiator ACL list */
 	struct list_head	acl_node_list;
 	struct hlist_head	tpg_lun_hlist;
-- 
2.26.1

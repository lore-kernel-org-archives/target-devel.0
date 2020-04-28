From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Apr 2020 06:11:05 +0000
Subject: [PATCH 07/11] target: add sysfs support
Message-Id: <20200428061109.3042-8-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200428061109.3042-1-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

configfs does not work well when the kernel is initiating the creation
of an object we want to export info for and the objects above/below it
are created by the user. There are races/bugs like seen with this patch
and the issue the original bug was trying to fix:

commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Aug 29 23:13:30 2019 -0400

    configfs_register_group() shouldn't be (and isn't) called in
rmdirable parts

The problem is that for many drivers like qla2xxx, iscsi, etc, session
creation is done by the kernel when there is a login initiated by an
initiator, but we need a common way to export the systems sessions so
tools like targetcli can report basic info like what initaitors are
logged in and daemons like tcmu-runner can track sessions for load
balancing and PGRs.

This patch begins to add a sysfs interface that will initially be used
to export LIO's sessions. The general layout will mirror the lio
configfs tree:

scsi_target/
├── $fabric_driver
│   └── $target_name
│       ├── tpgt_1
│       │   └── sessions
│       └── tpgt_2
│           └── sessions
└── sessions

iscsi example:

scsi_target/
├── iscsi
│   └── iqn.1999-09.com.tcmu:ceph
│       ├── tpgt_1
│       │   └── sessions
│       └── tpgt_2
│           └── sessions
└── sessions

This initial patch adds only adds the upper layer dirs above the
sessions.


Signed-off-by: Mike Christie <mchristi@redhat.com>
---

V2:
- rename top level dir to scsi_target

V3:
- delay tpg deletion to allow fabric modules time to remove their
  sessions.
- Added root sessions dir for easier lookup if userspace has the
  session id.

 drivers/target/target_core_configfs.c        | 30 +++++++++++++++++++++
 drivers/target/target_core_fabric_configfs.c | 40 ++++++++++++++++++++++++++++
 drivers/target/target_core_internal.h        |  1 +
 include/target/target_core_base.h            |  4 +++
 4 files changed, 75 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index e6e1755..20aa58b 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -63,6 +63,9 @@
 	pr_debug("Setup generic %s\n", __stringify(_name));		\
 }
 
+static struct kobject *tcm_core_kobj;
+static struct kobject *tcm_core_sessions_kobj;
+
 extern struct t10_alua_lu_gp *default_lu_gp;
 
 static LIST_HEAD(g_tf_list);
@@ -245,6 +248,11 @@ static struct config_group *target_core_register_fabric(
 	}
 	pr_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
 			" %s\n", tf->tf_ops->fabric_name);
+
+	tf->kobj = kobject_create_and_add(name, tcm_core_kobj);
+	if (!tf->kobj)
+		goto dec_tf;
+
 	/*
 	 * On a successful target_core_get_fabric() look, the returned
 	 * struct target_fabric_configfs *tf will contain a usage reference.
@@ -261,6 +269,10 @@ static struct config_group *target_core_register_fabric(
 	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric: %s\n",
 		 config_item_name(&tf->tf_group.cg_item));
 	return &tf->tf_group;
+
+dec_tf:
+	atomic_dec(&tf->tf_access_cnt);
+	return ERR_PTR(-EINVAL);
 }
 
 /*
@@ -283,6 +295,9 @@ static void target_core_deregister_fabric(
 	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
 			" %s\n", config_item_name(item));
 
+	kobject_del(tf->kobj);
+	kobject_put(tf->kobj);
+
 	configfs_remove_default_groups(&tf->tf_group);
 	config_item_put(item);
 }
@@ -3536,6 +3551,15 @@ static int __init target_core_init_configfs(void)
 
 	target_init_dbroot();
 
+	tcm_core_kobj = kobject_create_and_add("scsi_target", NULL);
+	if (!tcm_core_kobj)
+		goto out;
+
+	tcm_core_sessions_kobj = kobject_create_and_add("sessions",
+							tcm_core_kobj);
+	if (!tcm_core_sessions_kobj)
+		goto out;
+
 	return 0;
 
 out:
@@ -3553,6 +3577,12 @@ static int __init target_core_init_configfs(void)
 
 static void __exit target_core_exit_configfs(void)
 {
+	kobject_del(tcm_core_sessions_kobj);
+	kobject_put(tcm_core_sessions_kobj);
+
+	kobject_del(tcm_core_kobj);
+	kobject_put(tcm_core_kobj);
+
 	configfs_remove_default_groups(&alua_lu_gps_group);
 	configfs_remove_default_groups(&alua_group);
 	configfs_remove_default_groups(&target_core_hbagroup);
diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
index ee85602..efa01b3 100644
--- a/drivers/target/target_core_fabric_configfs.c
+++ b/drivers/target/target_core_fabric_configfs.c
@@ -807,8 +807,23 @@ static void target_fabric_tpg_release(struct config_item *item)
 			struct se_portal_group, tpg_group);
 	struct se_wwn *wwn = se_tpg->se_tpg_wwn;
 	struct target_fabric_configfs *tf = wwn->wwn_tf;
+	struct kobject *sess_kobj, *tpg_kobj;
+
+	/*
+	 * Some fabric modules remove the session from the drop_tpg
+	 * callout, so remove these parent dirs until after the session
+	 * is removed.
+	 */
+	sess_kobj = se_tpg->sessions_kobj;
+	tpg_kobj = se_tpg->kobj;
 
 	tf->tf_ops->fabric_drop_tpg(se_tpg);
+
+	kobject_del(sess_kobj);
+	kobject_put(sess_kobj);
+
+	kobject_del(tpg_kobj);
+	kobject_put(tpg_kobj);
 }
 
 static struct configfs_item_operations target_fabric_tpg_base_item_ops = {
@@ -838,6 +853,14 @@ static struct config_group *target_fabric_make_tpg(
 	if (!se_tpg || IS_ERR(se_tpg))
 		return ERR_PTR(-EINVAL);
 
+	se_tpg->kobj = kobject_create_and_add(name, wwn->kobj);
+	if (!se_tpg->kobj)
+		goto drop_tpg;
+
+	se_tpg->sessions_kobj = kobject_create_and_add("sessions", se_tpg->kobj);
+	if (!se_tpg->sessions_kobj)
+		goto del_tpg_kobj;
+
 	config_group_init_type_name(&se_tpg->tpg_group, name,
 			&tf->tf_tpg_base_cit);
 
@@ -872,6 +895,13 @@ static struct config_group *target_fabric_make_tpg(
 			&se_tpg->tpg_group);
 
 	return &se_tpg->tpg_group;
+
+del_tpg_kobj:
+	kobject_del(se_tpg->kobj);
+	kobject_put(se_tpg->kobj);
+drop_tpg:
+	tf->tf_ops->fabric_drop_tpg(se_tpg);
+	return ERR_PTR(-EINVAL);
 }
 
 static void target_fabric_drop_tpg(
@@ -927,6 +957,7 @@ static struct config_group *target_fabric_make_wwn(
 	struct target_fabric_configfs *tf = container_of(group,
 				struct target_fabric_configfs, tf_group);
 	struct se_wwn *wwn;
+	int ret;
 
 	if (!tf->tf_ops->fabric_make_wwn) {
 		pr_err("tf->tf_ops.fabric_make_wwn is NULL\n");
@@ -938,6 +969,9 @@ static struct config_group *target_fabric_make_wwn(
 		return ERR_PTR(-EINVAL);
 
 	wwn->wwn_tf = tf;
+	wwn->kobj = kobject_create_and_add(name, tf->kobj);
+	if (!wwn->kobj)
+		goto drop_wwn;
 
 	config_group_init_type_name(&wwn->wwn_group, name, &tf->tf_tpg_cit);
 
@@ -948,6 +982,10 @@ static struct config_group *target_fabric_make_wwn(
 	if (tf->tf_ops->add_wwn_groups)
 		tf->tf_ops->add_wwn_groups(wwn);
 	return &wwn->wwn_group;
+
+drop_wwn:
+	tf->tf_ops->fabric_drop_wwn(wwn);
+	return ERR_PTR(ret);
 }
 
 static void target_fabric_drop_wwn(
@@ -957,6 +995,8 @@ static void target_fabric_drop_wwn(
 	struct se_wwn *wwn = container_of(to_config_group(item),
 				struct se_wwn, wwn_group);
 
+	kobject_del(wwn->kobj);
+	kobject_put(wwn->kobj);
 	configfs_remove_default_groups(&wwn->wwn_group);
 	config_item_put(item);
 }
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 5e016aa..aea50f1 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -27,6 +27,7 @@ struct target_backend {
 struct target_fabric_configfs {
 	atomic_t		tf_access_cnt;
 	struct list_head	tf_list;
+	struct kobject		*kobj;
 	struct config_group	tf_group;
 	struct config_group	tf_disc_group;
 	const struct target_core_fabric_ops *tf_ops;
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index d4a588d..16d2a4c 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -8,6 +8,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/semaphore.h>     /* struct semaphore */
 #include <linux/completion.h>
+#include <linux/kobject.h>
 
 #define TARGET_CORE_VERSION		"v5.0"
 
@@ -897,6 +898,8 @@ struct se_portal_group {
 	/* Pointer to $FABRIC_MOD dependent code */
 	const struct target_core_fabric_ops *se_tpg_tfo;
 	struct se_wwn		*se_tpg_wwn;
+	struct kobject		*kobj;
+	struct kobject		*sessions_kobj;
 	struct config_group	tpg_group;
 	struct config_group	tpg_lun_group;
 	struct config_group	tpg_np_group;
@@ -935,6 +938,7 @@ struct se_wwn {
 	void			*priv;
 	struct config_group	wwn_group;
 	struct config_group	fabric_stat_group;
+	struct kobject		*kobj;
 };
 
 static inline void atomic_inc_mb(atomic_t *v)
-- 
1.8.3.1

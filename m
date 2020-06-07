From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 07 Jun 2020 20:35:59 +0000
Subject: [PATCH 12/17] target: hook most target users into sysfs API
Message-Id: <1591562164-9766-13-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

This hooks lio core and all the targets but iscsi into the sysfs API.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/Makefile                |  1 +
 drivers/target/target_core_configfs.c  |  3 +++
 drivers/target/target_core_internal.h  |  1 +
 drivers/target/target_core_transport.c | 38 ++++++++++++++++++++++++++++------
 4 files changed, 37 insertions(+), 6 deletions(-)

diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 4563474..4a7246e 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -1,6 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 
 target_core_mod-y		:= target_core_configfs.o \
+				   target_core_sysfs.o \
 				   target_core_device.o \
 				   target_core_fabric_configfs.o \
 				   target_core_fabric_lib.o \
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index ff82b21f..c23552b 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3537,6 +3537,7 @@ static int __init target_core_init_configfs(void)
 		goto out;
 
 	target_init_dbroot();
+	target_sysfs_init();
 
 	return 0;
 
@@ -3555,6 +3556,8 @@ static int __init target_core_init_configfs(void)
 
 static void __exit target_core_exit_configfs(void)
 {
+	target_sysfs_exit();
+
 	configfs_remove_default_groups(&alua_lu_gps_group);
 	configfs_remove_default_groups(&alua_group);
 	configfs_remove_default_groups(&target_core_hbagroup);
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 93bf5fed..23d9a0e 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -157,6 +157,7 @@ void	transport_dump_dev_info(struct se_device *, struct se_lun *,
 bool	target_check_wce(struct se_device *dev);
 bool	target_check_fua(struct se_device *dev);
 void	__target_execute_cmd(struct se_cmd *, bool);
+void	__target_free_session(struct se_session *se_sess);
 
 /* target_core_stat.c */
 void	target_stat_setup_dev_default_groups(struct se_device *);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 5d6d736..34da12a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -22,6 +22,7 @@
 #include <linux/module.h>
 #include <linux/ratelimit.h>
 #include <linux/vmalloc.h>
+#include <linux/device.h>
 #include <asm/unaligned.h>
 #include <net/sock.h>
 #include <net/tcp.h>
@@ -251,14 +252,27 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
 				" se_sess_cache\n");
 		return ERR_PTR(-ENOMEM);
 	}
-	ret = transport_init_session(se_sess);
-	if (ret < 0) {
+
+	ret = target_sysfs_init_session(se_sess);
+	if (ret) {
 		kmem_cache_free(se_sess_cache, se_sess);
 		return ERR_PTR(ret);
 	}
-	se_sess->sup_prot_ops = sup_prot_ops;
+	/*
+	 * After this point we switch from handlng the freeing of the sess
+	 * to using the se_sess->dev refcounting.
+	 */
 
+	ret = transport_init_session(se_sess);
+	if (ret < 0)
+		goto put_dev;
+
+	se_sess->sup_prot_ops = sup_prot_ops;
 	return se_sess;
+
+put_dev:
+	put_device(&se_sess->dev);
+	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL(transport_alloc_session);
 
@@ -457,6 +471,10 @@ struct se_session *
 		rc = -EACCES;
 		goto free_sess;
 	}
+
+	rc = target_sysfs_add_session(tpg, sess);
+	if (rc)
+		goto free_sess;
 	/*
 	 * Go ahead and perform any remaining fabric setup that is
 	 * required before transport_register_session().
@@ -464,12 +482,14 @@ struct se_session *
 	if (callback != NULL) {
 		rc = callback(tpg, sess, private);
 		if (rc)
-			goto free_sess;
+			goto rm_sysfs;
 	}
 
 	transport_register_session(tpg, sess->se_node_acl, sess, private);
 	return sess;
 
+rm_sysfs:
+	target_sysfs_remove_session(sess);
 free_sess:
 	transport_free_session(sess);
 	return ERR_PTR(rc);
@@ -597,12 +617,17 @@ void transport_free_session(struct se_session *se_sess)
 		sbitmap_queue_free(&se_sess->sess_tag_pool);
 		kvfree(se_sess->sess_cmd_map);
 	}
-	target_free_transport_id(se_sess->tpt_id);
 	percpu_ref_exit(&se_sess->cmd_count);
-	kmem_cache_free(se_sess_cache, se_sess);
+	put_device(&se_sess->dev);
 }
 EXPORT_SYMBOL(transport_free_session);
 
+void __target_free_session(struct se_session *se_sess)
+{
+	target_free_transport_id(se_sess->tpt_id);
+	kmem_cache_free(se_sess_cache, se_sess);
+}
+
 static int target_release_res(struct se_device *dev, void *data)
 {
 	struct se_session *sess = data;
@@ -651,6 +676,7 @@ void transport_deregister_session(struct se_session *se_sess)
 
 void target_remove_session(struct se_session *se_sess)
 {
+	target_sysfs_remove_session(se_sess);
 	transport_deregister_session_configfs(se_sess);
 	transport_deregister_session(se_sess);
 }
-- 
1.8.3.1

From: Lee Duncan <lduncan@suse.com>
Date: Fri, 06 Apr 2018 18:31:41 +0000
Subject: [PATCHv2] target: prefer dbroot of /etc/target over /var/target
Message-Id: <20180406183141.20089-1-lduncan@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The target database root directory, dbroot, has
defaulted to /var/target for a while, but its
main client, targetcli-fb, has been moving it
to /etc/target for quite some time. With the
plethora of target drivers now appearing, it has
become more difficult to initialize this attribute
before use by any child drivers.

If the directory /etc/target exists, use that as
the DB root. Otherwise, fall back to using
/var/target.

The ability to override this dbroot attribute
still exists via sysfs.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/target/target_core_configfs.c | 25 +++++++++++++++++++++++++
 drivers/target/target_core_internal.h |  1 +
 2 files changed, 26 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 3f4bf126eed0..5ccef7d597fa 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -155,6 +155,8 @@ static ssize_t target_core_item_dbroot_store(struct config_item *item,
 
 	mutex_unlock(&g_tf_lock);
 
+	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
+
 	return read_bytes;
 }
 
@@ -3213,6 +3215,27 @@ void target_setup_backend_cits(struct target_backend *tb)
 	target_core_setup_dev_stat_cit(tb);
 }
 
+static void target_init_dbroot(void)
+{
+	struct file *fp;
+
+	snprintf(db_root_stage, DB_ROOT_LEN, DB_ROOT_PREFERRED);
+	fp = filp_open(db_root_stage, O_RDONLY, 0);
+	if (IS_ERR(fp)) {
+		pr_err("db_root: cannot open: %s\n", db_root_stage);
+		return;
+	}
+	if (!S_ISDIR(file_inode(fp)->i_mode)) {
+		filp_close(fp, NULL);
+		pr_err("db_root: not a valid directory: %s\n", db_root_stage);
+		return;
+	}
+	filp_close(fp, NULL);
+
+	strncpy(db_root, db_root_stage, DB_ROOT_LEN);
+	pr_debug("Target_Core_ConfigFS: db_root set to %s\n", db_root);
+}
+
 static int __init target_core_init_configfs(void)
 {
 	struct configfs_subsystem *subsys = &target_core_fabrics;
@@ -3293,6 +3316,8 @@ static int __init target_core_init_configfs(void)
 	if (ret < 0)
 		goto out;
 
+	target_init_dbroot();
+
 	return 0;
 
 out:
diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 1d5afc3ae017..dead30b1d32c 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -166,6 +166,7 @@ extern struct se_portal_group xcopy_pt_tpg;
 /* target_core_configfs.c */
 #define DB_ROOT_LEN		4096
 #define	DB_ROOT_DEFAULT		"/var/target"
+#define	DB_ROOT_PREFERRED	"/etc/target"
 
 extern char db_root[];
 
-- 
2.13.6


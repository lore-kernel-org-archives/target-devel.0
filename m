From: Lee Duncan <lduncan@suse.com>
Date: Wed, 04 Apr 2018 19:47:03 +0000
Subject: [PATCH] target: change default dbroot to /etc/target
Message-Id: <20180404194703.31888-1-lduncan@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The dbroot (target PR database root directory) is
configurable but default to /var/target, a historic
value. But the reason for adding configurability
was to move the target directory out of /var. This
is because the File Hierarchy Standard v3.0 mandates
that this "target" directory not be in /var. See
https://refspecs.linuxfoundation.org/FHS_3.0/fhs-3.0.pdf

This change moves the default from /var/target to
/etc/target, but this value is still configurable,
so those wishing to continue to use /var/target
can still do so.

Signed-off-by: Lee Duncan <lduncan@suse.com>
---
 drivers/target/target_core_internal.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
index 1d5afc3ae017..34eccef975b7 100644
--- a/drivers/target/target_core_internal.h
+++ b/drivers/target/target_core_internal.h
@@ -165,7 +165,7 @@ extern struct se_portal_group xcopy_pt_tpg;
 
 /* target_core_configfs.c */
 #define DB_ROOT_LEN		4096
-#define	DB_ROOT_DEFAULT		"/var/target"
+#define	DB_ROOT_DEFAULT		"/etc/target"
 
 extern char db_root[];
 
-- 
2.13.6


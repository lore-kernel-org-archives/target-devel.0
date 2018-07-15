From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:17 +0000
Subject: [PATCH 01/15] configfs: fix registered group removal
Message-Id: <1531696591-8558-2-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch fixes a bug where configfs_register_group had added
a group in a tree, and userspace has done a rmdir on a dir somewhere
above that group and we hit a kernel crash. The problem is configfs_rmdir
will detach everything under it and unlink groups on the default_groups
list. It will not unlink groups added with configfs_register_group so when
configfs_unregister_group is called to drop its references to the group/items
we crash when we try to access the freed dentrys.

The patch just adds a check for if a rmdir has been done above
us and if so just does the unlink part of unregistration.

Sorry if you are getting this multiple times. I thouhgt I sent
this to some of you and lkml, but I do not see it.

Signed-off-by: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Joel Becker <jlbec@evilplan.org>
---
 fs/configfs/dir.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 577cff2..45cdbb5 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -1777,6 +1777,15 @@ void configfs_unregister_group(struct config_group *group)
 	struct dentry *dentry = group->cg_item.ci_dentry;
 	struct dentry *parent = group->cg_item.ci_parent->ci_dentry;
 
+	mutex_lock(&subsys->su_mutex);
+	if (!group->cg_item.ci_parent->ci_group)
+		/*
+		 * The parent has already been unlinked and detached
+		 * due to a rmdir.
+		 */
+		goto unlink_group;
+	mutex_unlock(&subsys->su_mutex);
+
 	inode_lock_nested(d_inode(parent), I_MUTEX_PARENT);
 	spin_lock(&configfs_dirent_lock);
 	configfs_detach_prep(dentry, NULL);
@@ -1791,6 +1800,7 @@ void configfs_unregister_group(struct config_group *group)
 	dput(dentry);
 
 	mutex_lock(&subsys->su_mutex);
+unlink_group:
 	unlink_group(group);
 	mutex_unlock(&subsys->su_mutex);
 }
-- 
2.7.2


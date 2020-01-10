From: Amol Grover <frextrite@gmail.com>
Date: Fri, 10 Jan 2020 12:56:03 +0000
Subject: [PATCH 1/3] drivers: target: target_core_device: Pass lockdep expression to RCU lists
Message-Id: <20200110124403.27882-1-frextrite@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, Joel Fernandes <joel@joelfernandes.org>, linux-kernel-mentees@lists.linuxfoundation.org

nacl->lun_entry_hlist is traversed with hlist_for_each_entry_rcu
outside an RCU read-side critical section but under the
protection of nacl->lun_entry_mutex.

Hence, add the corresponding lockdep expression to the list traversal
primitive to silence false-positive lockdep warnings, and
harden RCU lists.

Add macro for the corresponding lockdep expression to make the code
clean and concise.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/target_core_device.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2d19f0e332b0..2d1277a83916 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -36,6 +36,9 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+#define lun_entry_mutex_held() \
+	lockdep_is_held(&nacl->lun_entry_mutex)
+
 static DEFINE_MUTEX(device_mutex);
 static LIST_HEAD(device_list);
 static DEFINE_IDR(devices_idr);
@@ -247,9 +250,10 @@ void core_free_device_list_for_node(
 	struct se_dev_entry *deve;
 
 	mutex_lock(&nacl->lun_entry_mutex);
-	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+							lun_entry_mutex_held()) {
 		struct se_lun *lun = rcu_dereference_check(deve->se_lun,
-					lockdep_is_held(&nacl->lun_entry_mutex));
+							lun_entry_mutex_held());
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
 	}
 	mutex_unlock(&nacl->lun_entry_mutex);
@@ -276,7 +280,8 @@ struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *nacl, u64 mapped_
 {
 	struct se_dev_entry *deve;
 
-	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+				rcu_read_lock_held() || lun_entry_mutex_held())
 		if (deve->mapped_lun = mapped_lun)
 			return deve;
 
@@ -339,7 +344,7 @@ int core_enable_device_list_for_node(
 	orig = target_nacl_find_deve(nacl, mapped_lun);
 	if (orig && orig->se_lun) {
 		struct se_lun *orig_lun = rcu_dereference_check(orig->se_lun,
-					lockdep_is_held(&nacl->lun_entry_mutex));
+							lun_entry_mutex_held());
 
 		if (orig_lun != lun) {
 			pr_err("Existing orig->se_lun doesn't match new lun"
@@ -460,9 +465,10 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
 
 		mutex_lock(&nacl->lun_entry_mutex);
-		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+							lun_entry_mutex_held()) {
 			struct se_lun *tmp_lun = rcu_dereference_check(deve->se_lun,
-					lockdep_is_held(&nacl->lun_entry_mutex));
+							lun_entry_mutex_held());
 
 			if (lun != tmp_lun)
 				continue;
-- 
2.24.1

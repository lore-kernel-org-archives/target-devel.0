From: Amol Grover <frextrite@gmail.com>
Date: Fri, 17 Jan 2020 13:50:53 +0000
Subject: [PATCH v3 1/3] drivers: target: target_core_device: Pass lockdep expression to RCU lists
Message-Id: <20200117133854.32550-1-frextrite@gmail.com>
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

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
v3:
- Remove rcu_read_lock_held() from lockdep expression since it is
  implicitly checked for.
- Remove unintended macro usage.

v2:
- Fix sparse error
  CHECK: Alignment should match open parenthesis

 drivers/target/target_core_device.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 2d19f0e332b0..306c626183d5 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -247,7 +247,8 @@ void core_free_device_list_for_node(
 	struct se_dev_entry *deve;
 
 	mutex_lock(&nacl->lun_entry_mutex);
-	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+				 lockdep_is_held(&nacl->lun_entry_mutex)) {
 		struct se_lun *lun = rcu_dereference_check(deve->se_lun,
 					lockdep_is_held(&nacl->lun_entry_mutex));
 		core_disable_device_list_for_node(lun, deve, nacl, tpg);
@@ -276,7 +277,8 @@ struct se_dev_entry *target_nacl_find_deve(struct se_node_acl *nacl, u64 mapped_
 {
 	struct se_dev_entry *deve;
 
-	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link)
+	hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+				 lockdep_is_held(&nacl->lun_entry_mutex))
 		if (deve->mapped_lun = mapped_lun)
 			return deve;
 
@@ -460,7 +462,8 @@ void core_clear_lun_from_tpg(struct se_lun *lun, struct se_portal_group *tpg)
 	list_for_each_entry(nacl, &tpg->acl_node_list, acl_list) {
 
 		mutex_lock(&nacl->lun_entry_mutex);
-		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link) {
+		hlist_for_each_entry_rcu(deve, &nacl->lun_entry_hlist, link,
+					 lockdep_is_held(&nacl->lun_entry_mutex)) {
 			struct se_lun *tmp_lun = rcu_dereference_check(deve->se_lun,
 					lockdep_is_held(&nacl->lun_entry_mutex));
 
-- 
2.24.1

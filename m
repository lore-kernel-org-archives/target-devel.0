From: Amol Grover <frextrite@gmail.com>
Date: Fri, 10 Jan 2020 17:17:58 +0000
Subject: [PATCH v2 2/3] drivers: target: target_core_tpg: Pass lockdep expression to RCU lists
Message-Id: <20200110170558.23466-2-frextrite@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200110170558.23466-1-frextrite@gmail.com>
In-Reply-To: <20200110170558.23466-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, Joel Fernandes <joel@joelfernandes.org>, linux-kernel-mentees@lists.linuxfoundation.org

tpg->tpg_lun_hlist is traversed with hlist_for_each_entry_rcu
outside an RCU read-side critical section but under the
protection of tpg->tpg_lun_mutex.

Hence, add the corresponding lockdep expression to the list traversal
primitive to silence false-positive lockdep warnings, and
harden RCU lists.

Add macro for the corresponding lockdep expression to make the code
clean and concise.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/target_core_tpg.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d24e0a3ba3ff..0d89b738ca6e 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -30,6 +30,9 @@
 #include "target_core_pr.h"
 #include "target_core_ua.h"
 
+#define tpg_lun_mutex_held() \
+	lockdep_is_held(&tpg->tpg_lun_mutex)
+
 extern struct se_device *g_lun0_dev;
 
 /*	__core_tpg_get_initiator_node_acl():
@@ -110,12 +113,12 @@ void core_tpg_add_node_to_devs(
 	struct se_device *dev;
 
 	mutex_lock(&tpg->tpg_lun_mutex);
-	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link) {
+	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link,
+				 tpg_lun_mutex_held()) {
 		if (lun_orig && lun != lun_orig)
 			continue;
 
-		dev = rcu_dereference_check(lun->lun_se_dev,
-					    lockdep_is_held(&tpg->tpg_lun_mutex));
+		dev = rcu_dereference_check(lun->lun_se_dev, tpg_lun_mutex_held());
 		/*
 		 * By default in LIO-Target $FABRIC_MOD,
 		 * demo_mode_write_protect is ON, or READ_ONLY;
-- 
2.24.1

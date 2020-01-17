From: Amol Grover <frextrite@gmail.com>
Date: Fri, 17 Jan 2020 13:50:55 +0000
Subject: [PATCH v3 2/3] drivers: target: target_core_tpg: Pass lockdep expression to RCU lists
Message-Id: <20200117133854.32550-2-frextrite@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200117133854.32550-1-frextrite@gmail.com>
In-Reply-To: <20200117133854.32550-1-frextrite@gmail.com>
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

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/target_core_tpg.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_tpg.c b/drivers/target/target_core_tpg.c
index d24e0a3ba3ff..7aa0240a7948 100644
--- a/drivers/target/target_core_tpg.c
+++ b/drivers/target/target_core_tpg.c
@@ -110,7 +110,8 @@ void core_tpg_add_node_to_devs(
 	struct se_device *dev;
 
 	mutex_lock(&tpg->tpg_lun_mutex);
-	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link) {
+	hlist_for_each_entry_rcu(lun, &tpg->tpg_lun_hlist, link,
+				 lockdep_is_held(&tpg->tpg_lun_mutex)) {
 		if (lun_orig && lun != lun_orig)
 			continue;
 
-- 
2.24.1

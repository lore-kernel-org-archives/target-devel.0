From: Amol Grover <frextrite@gmail.com>
Date: Fri, 17 Jan 2020 13:50:57 +0000
Subject: [PATCH v3 3/3] drivers: target: tcm_fc: tfc_sess: Pass lockdep expression to RCU lists
Message-Id: <20200117133854.32550-3-frextrite@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200117133854.32550-1-frextrite@gmail.com>
In-Reply-To: <20200117133854.32550-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Paul E . McKenney" <paulmck@kernel.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, Joel Fernandes <joel@joelfernandes.org>, linux-kernel-mentees@lists.linuxfoundation.org

head is traversed with hlist_for_each_entry_rcu
outside an RCU read-side critical section but under the
protection of ft_lport_lock.

Hence, add the corresponding lockdep expression to the list traversal
primitive to silence false-positive lockdep warnings, and
harden RCU lists.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4fd6a1de947c..bb70f61237a6 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -170,7 +170,8 @@ static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
 	}
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash,
+				 lockdep_is_held(&ft_lport_lock)) {
 		if (sess->port_id = port_id) {
 			kref_get(&sess->kref);
 			rcu_read_unlock();
@@ -215,7 +216,8 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	ft_format_wwn(&initiatorname[0], TRANSPORT_IQN_LEN, rdata->ids.port_name);
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash)
+	hlist_for_each_entry_rcu(sess, head, hash,
+				 lockdep_is_held(&ft_lport_lock))
 		if (sess->port_id = port_id)
 			return sess;
 
@@ -264,7 +266,8 @@ static struct ft_sess *ft_sess_delete(struct ft_tport *tport, u32 port_id)
 	struct ft_sess *sess;
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash,
+				 lockdep_is_held(&ft_lport_lock)) {
 		if (sess->port_id = port_id) {
 			ft_sess_unhash(sess);
 			return sess;
@@ -291,7 +294,8 @@ static void ft_sess_delete_all(struct ft_tport *tport)
 
 	for (head = tport->hash;
 	     head < &tport->hash[FT_SESS_HASH_SIZE]; head++) {
-		hlist_for_each_entry_rcu(sess, head, hash) {
+		hlist_for_each_entry_rcu(sess, head, hash,
+					 lockdep_is_held(&ft_lport_lock)) {
 			ft_sess_unhash(sess);
 			ft_close_sess(sess);	/* release from table */
 		}
-- 
2.24.1

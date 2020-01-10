From: Amol Grover <frextrite@gmail.com>
Date: Fri, 10 Jan 2020 12:56:06 +0000
Subject: [PATCH 3/3] drivers: target: tcm_fc: tfc_sess: Pass lockdep expression to RCU lists
Message-Id: <20200110124403.27882-3-frextrite@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200110124403.27882-1-frextrite@gmail.com>
In-Reply-To: <20200110124403.27882-1-frextrite@gmail.com>
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

Add macro for the corresponding lockdep expression to make the code
clean and concise.

Signed-off-by: Amol Grover <frextrite@gmail.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 4fd6a1de947c..8e9598010fb9 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -32,6 +32,9 @@
 		 (lport)->host->host_no,	   \
 		 (lport)->port_id, ##args )
 
+#define ft_lport_lock_held() \
+	lockdep_is_held(&ft_lport_lock)
+
 static void ft_sess_delete_all(struct ft_tport *);
 
 /*
@@ -45,7 +48,7 @@ static struct ft_tport *ft_tport_get(struct fc_lport *lport)
 	int i;
 
 	tport = rcu_dereference_protected(lport->prov[FC_TYPE_FCP],
-					  lockdep_is_held(&ft_lport_lock));
+							ft_lport_lock_held());
 	if (tport && tport->tpg)
 		return tport;
 
@@ -170,7 +173,7 @@ static struct ft_sess *ft_sess_get(struct fc_lport *lport, u32 port_id)
 	}
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash, ft_lport_lock_held()) {
 		if (sess->port_id = port_id) {
 			kref_get(&sess->kref);
 			rcu_read_unlock();
@@ -215,7 +218,7 @@ static struct ft_sess *ft_sess_create(struct ft_tport *tport, u32 port_id,
 	ft_format_wwn(&initiatorname[0], TRANSPORT_IQN_LEN, rdata->ids.port_name);
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash)
+	hlist_for_each_entry_rcu(sess, head, hash, ft_lport_lock_held())
 		if (sess->port_id = port_id)
 			return sess;
 
@@ -264,7 +267,7 @@ static struct ft_sess *ft_sess_delete(struct ft_tport *tport, u32 port_id)
 	struct ft_sess *sess;
 
 	head = &tport->hash[ft_sess_hash(port_id)];
-	hlist_for_each_entry_rcu(sess, head, hash) {
+	hlist_for_each_entry_rcu(sess, head, hash, ft_lport_lock_held()) {
 		if (sess->port_id = port_id) {
 			ft_sess_unhash(sess);
 			return sess;
@@ -291,7 +294,7 @@ static void ft_sess_delete_all(struct ft_tport *tport)
 
 	for (head = tport->hash;
 	     head < &tport->hash[FT_SESS_HASH_SIZE]; head++) {
-		hlist_for_each_entry_rcu(sess, head, hash) {
+		hlist_for_each_entry_rcu(sess, head, hash, ft_lport_lock_held()) {
 			ft_sess_unhash(sess);
 			ft_close_sess(sess);	/* release from table */
 		}
@@ -454,7 +457,7 @@ static void ft_prlo(struct fc_rport_priv *rdata)
 
 	mutex_lock(&ft_lport_lock);
 	tport = rcu_dereference_protected(rdata->local_port->prov[FC_TYPE_FCP],
-					  lockdep_is_held(&ft_lport_lock));
+							ft_lport_lock_held());
 
 	if (!tport) {
 		mutex_unlock(&ft_lport_lock);
-- 
2.24.1

From: Hou Pu <houpu@bytedance.com>
Date: Wed, 29 Jul 2020 13:03:43 +0000
Subject: [PATCH] iscsi-target: fix hang in iscsit_access_np() when getting tpg->np_login_sem
Message-Id: <20200729130343.24976-1-houpu@bytedance.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, michael.christie@oracle.com
Cc: Hou Pu <houpu@bytedance.com>, stable@vger.kernel.org

The iscsi target login thread might stuck in following stack:

cat /proc/`pidof iscsi_np`/stack
[<0>] down_interruptible+0x42/0x50
[<0>] iscsit_access_np+0xe3/0x167
[<0>] iscsi_target_locate_portal+0x695/0x8ac
[<0>] __iscsi_target_login_thread+0x855/0xb82
[<0>] iscsi_target_login_thread+0x2f/0x5a
[<0>] kthread+0xfa/0x130
[<0>] ret_from_fork+0x1f/0x30

This could be reproduced by following steps:
1. Initiator A try to login iqn1-tpg1 on port 3260. After finishing
   PDU exchange in the login thread and before the negotiation is
   finished, at this time the network link is down. In a production
   environment, this could happen. I could emulated it by bring
   the network card down in the initiator node by ifconfig eth0 down.
   (Now A could never finish this login. And tpg->np_login_sem is
   hold by it).
2. Initiator B try to login iqn2-tpg1 on port 3260. After finishing
   PDU exchange in the login thread. The target expect to process
   remaining login PDUs in workqueue context.
3. Initiator A' try to re-login to iqn1-tpg1 on port 3260 from
   a new socket. It will wait for tpg->np_login_sem with
   np->np_login_timer loaded to wait for at most 15 second.
   (Because the lock is held by A. A never gets a change to
   release tpg->np_login_sem. so A' should finally get timeout).
4. Before A' got timeout. Initiator B gets negotiation failed and
   calls iscsi_target_login_drop()->iscsi_target_login_sess_out().
   The np->np_login_timer is canceled. And initiator A' will hang
   there forever. Because A' is now in the login thread. All other
   login requests could not be serviced.

Fix this by moving iscsi_stop_login_thread_timer() out of
iscsi_target_login_sess_out(). Also remove iscsi_np parameter
from iscsi_target_login_sess_out().

Cc: stable@vger.kernel.org
Signed-off-by: Hou Pu <houpu@bytedance.com>
---
 drivers/target/iscsi/iscsi_target_login.c | 6 +++---
 drivers/target/iscsi/iscsi_target_login.h | 3 +--
 drivers/target/iscsi/iscsi_target_nego.c  | 3 +--
 3 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 85748e338858..893d1b406c29 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -1149,7 +1149,7 @@ void iscsit_free_conn(struct iscsi_conn *conn)
 }
 
 void iscsi_target_login_sess_out(struct iscsi_conn *conn,
-		struct iscsi_np *np, bool zero_tsih, bool new_sess)
+				 bool zero_tsih, bool new_sess)
 {
 	if (!new_sess)
 		goto old_sess_out;
@@ -1167,7 +1167,6 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 	conn->sess = NULL;
 
 old_sess_out:
-	iscsi_stop_login_thread_timer(np);
 	/*
 	 * If login negotiation fails check if the Time2Retain timer
 	 * needs to be restarted.
@@ -1407,8 +1406,9 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 new_sess_out:
 	new_sess = true;
 old_sess_out:
+	iscsi_stop_login_thread_timer(np);
 	tpg_np = conn->tpg_np;
-	iscsi_target_login_sess_out(conn, np, zero_tsih, new_sess);
+	iscsi_target_login_sess_out(conn, zero_tsih, new_sess);
 	new_sess = false;
 
 	if (tpg) {
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 3b8e3639ff5d..fc95e6150253 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -22,8 +22,7 @@ extern int iscsit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
 extern void iscsit_free_conn(struct iscsi_conn *);
 extern int iscsit_start_kthreads(struct iscsi_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
-extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
-				bool, bool);
+extern void iscsi_target_login_sess_out(struct iscsi_conn *, bool, bool);
 extern int iscsi_target_login_thread(void *);
 extern void iscsi_handle_login_thread_timeout(struct timer_list *t);
 
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 685d771b51d4..e32d93b92742 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -535,12 +535,11 @@ static bool iscsi_target_sk_check_and_clear(struct iscsi_conn *conn, unsigned in
 
 static void iscsi_target_login_drop(struct iscsi_conn *conn, struct iscsi_login *login)
 {
-	struct iscsi_np *np = login->np;
 	bool zero_tsih = login->zero_tsih;
 
 	iscsi_remove_failed_auth_entry(conn);
 	iscsi_target_nego_release(conn);
-	iscsi_target_login_sess_out(conn, np, zero_tsih, true);
+	iscsi_target_login_sess_out(conn, zero_tsih, true);
 }
 
 struct conn_timeout {
-- 
2.11.0

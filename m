From: Mike Christie <mchristi@redhat.com>
Date: Mon, 13 Aug 2018 22:54:56 +0000
Subject: Re: BUG in slab_free after iSCSI login timeout
Message-Id: <5B720C40.4040805@redhat.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------090800010504050302050402"
List-Id: <target-devel.vger.kernel.org>
References: <20180811093655.42922d8e@gmail.com>
In-Reply-To: <20180811093655.42922d8e@gmail.com>
To: target-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090800010504050302050402
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 08/13/2018 04:42 PM, Mike Christie wrote:
> On 08/13/2018 02:48 PM, Mike Christie wrote:
>> On 08/11/2018 10:51 PM, Vincent Pelletier wrote:
>>> On Sun, 12 Aug 2018 02:55:31 +0000, Vincent Pelletier
>>> <plr.vincent@gmail.com> wrote:
>>>> Aug 12 04:44:53 boke kernel: [   64.737069] BUG: KASAN: use-after-free in iscsi_target_login_sess_out.cold.11+0x58/0x123 [iscsi_target_mod]
>>>> Aug 12 04:44:53 boke kernel: [   64.771148] BUG: KASAN: double-free or invalid-free in iscsi_target_login_sess_out.cold.11+0x103/0x123 [iscsi_target_mod]
>>>
>>> If I'm reading the code correctly, the double-free would be
>>> iscsi_login_init_conn and iscsi_target_login_sess_out both calling
>>> kfree(conn->conn_ops), with the latter called by
>>> __iscsi_target_login_thread precisely when the former fails (returns
>>> NULL after freeing).
>>>
>>
>> I think I fixed that with this patch:
>>
>> https://www.spinics.net/lists/target-devel/msg17018.html
>>
>> It fixes a mix of problems double free of the ops, session and reference
>> after free.
> 
> Ignore this. I see you said conn. My patch fixed basically the same
> issue but with the session.

Could you try the attached patch? I have done a couple login/logout
tests only, but have not yet completed testing.


--------------090800010504050302050402
Content-Type: text/x-patch;
 name="0001-iscsi-target-fix-conn_ops-double-free.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-iscsi-target-fix-conn_ops-double-free.patch"

From b6d6e8da919b775e9a0dae64628f4e32ec705feb Mon Sep 17 00:00:00 2001
From: Mike Christie <mchristi@redhat.com>
Date: Mon, 13 Aug 2018 17:52:18 -0500
Subject: [PATCH] iscsi target: fix conn_ops double free

If iscsi_login_init_conn fails it can free conn_ops.
__iscsi_target_login_thread will then call iscsi_target_login_sess_out
which will also free it.

This prevents the bug by moving the non login-only items that need to
be allocated/setup to new functions iscsit_alloc/free_conn. These alloc
function is then called in __iscsi_target_login_thread and the free
unction is only called if the alloc function is successfull.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c       |   9 +--
 drivers/target/iscsi/iscsi_target_login.c | 101 ++++++++++++++++--------------
 drivers/target/iscsi/iscsi_target_login.h |   2 +-
 3 files changed, 57 insertions(+), 55 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 8e22379..a4ecc9d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4211,22 +4211,15 @@ int iscsit_close_connection(
 		crypto_free_ahash(tfm);
 	}
 
-	free_cpumask_var(conn->conn_cpumask);
-
-	kfree(conn->conn_ops);
-	conn->conn_ops = NULL;
-
 	if (conn->sock)
 		sock_release(conn->sock);
 
 	if (conn->conn_transport->iscsit_free_conn)
 		conn->conn_transport->iscsit_free_conn(conn);
 
-	iscsit_put_transport(conn->conn_transport);
-
 	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
 	conn->conn_state = TARG_CONN_STATE_FREE;
-	kfree(conn);
+	iscsit_free_conn(conn);
 
 	spin_lock_bh(&sess->conn_lock);
 	atomic_dec(&sess->nconn);
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 923b1a9..e1bdfd5 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -67,13 +67,6 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsi_conn *conn)
 		goto out_req_buf;
 	}
 
-	conn->conn_ops = kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL);
-	if (!conn->conn_ops) {
-		pr_err("Unable to allocate memory for"
-			" struct iscsi_conn_ops.\n");
-		goto out_rsp_buf;
-	}
-
 	init_waitqueue_head(&conn->queues_wq);
 	INIT_LIST_HEAD(&conn->conn_list);
 	INIT_LIST_HEAD(&conn->conn_cmd_list);
@@ -94,18 +87,10 @@ static struct iscsi_login *iscsi_login_init_conn(struct iscsi_conn *conn)
 	spin_lock_init(&conn->response_queue_lock);
 	spin_lock_init(&conn->state_lock);
 
-	if (!zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL)) {
-		pr_err("Unable to allocate conn->conn_cpumask\n");
-		goto out_conn_ops;
-	}
 	conn->conn_login = login;
 
 	return login;
 
-out_conn_ops:
-	kfree(conn->conn_ops);
-out_rsp_buf:
-	kfree(login->rsp_buf);
 out_req_buf:
 	kfree(login->req_buf);
 out_login:
@@ -1150,6 +1135,55 @@ int iscsit_put_login_tx(struct iscsi_conn *conn, struct iscsi_login *login,
 	return 0;
 }
 
+static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
+{
+	struct iscsi_conn *conn;
+
+	conn = kzalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
+	if (!conn) {
+		pr_err("Could not allocate memory for new connection\n");
+		return NULL;
+	}
+	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
+	conn->conn_state = TARG_CONN_STATE_FREE;
+
+	timer_setup(&conn->nopin_response_timer,
+		    iscsit_handle_nopin_response_timeout, 0);
+	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
+
+	if (iscsit_conn_set_transport(conn, np->np_transport) < 0)
+		goto free_conn;
+
+	conn->conn_ops = kzalloc(sizeof(struct iscsi_conn_ops), GFP_KERNEL);
+	if (!conn->conn_ops) {
+		pr_err("Unable to allocate memory for struct iscsi_conn_ops.\n");
+		goto put_transport;
+	}
+
+	if (!zalloc_cpumask_var(&conn->conn_cpumask, GFP_KERNEL)) {
+		pr_err("Unable to allocate conn->conn_cpumask\n");
+		goto free_mask;
+	}
+
+	return conn;
+
+free_mask:
+	free_cpumask_var(conn->conn_cpumask);
+put_transport:
+	iscsit_put_transport(conn->conn_transport);
+free_conn:
+	kfree(conn);
+	return NULL;
+}
+
+void iscsit_free_conn(struct iscsi_conn *conn)
+{
+	free_cpumask_var(conn->conn_cpumask);
+	kfree(conn->conn_ops);
+	iscsit_put_transport(conn->conn_transport);
+	kfree(conn);
+}
+
 void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 		struct iscsi_np *np, bool zero_tsih, bool new_sess)
 {
@@ -1203,10 +1237,6 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 		crypto_free_ahash(tfm);
 	}
 
-	free_cpumask_var(conn->conn_cpumask);
-
-	kfree(conn->conn_ops);
-
 	if (conn->param_list) {
 		iscsi_release_param_list(conn->param_list);
 		conn->param_list = NULL;
@@ -1224,8 +1254,7 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 	if (conn->conn_transport->iscsit_free_conn)
 		conn->conn_transport->iscsit_free_conn(conn);
 
-	iscsit_put_transport(conn->conn_transport);
-	kfree(conn);
+	iscsit_free_conn(conn);
 }
 
 static int __iscsi_target_login_thread(struct iscsi_np *np)
@@ -1255,31 +1284,16 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 	}
 	spin_unlock_bh(&np->np_thread_lock);
 
-	conn = kzalloc(sizeof(struct iscsi_conn), GFP_KERNEL);
+	conn = iscsit_alloc_conn(np);
 	if (!conn) {
-		pr_err("Could not allocate memory for"
-			" new connection\n");
 		/* Get another socket */
 		return 1;
 	}
-	pr_debug("Moving to TARG_CONN_STATE_FREE.\n");
-	conn->conn_state = TARG_CONN_STATE_FREE;
-
-	timer_setup(&conn->nopin_response_timer,
-		    iscsit_handle_nopin_response_timeout, 0);
-	timer_setup(&conn->nopin_timer, iscsit_handle_nopin_timeout, 0);
-
-	if (iscsit_conn_set_transport(conn, np->np_transport) < 0) {
-		kfree(conn);
-		return 1;
-	}
 
 	rc = np->np_transport->iscsit_accept_np(np, conn);
 	if (rc == -ENOSYS) {
 		complete(&np->np_restart_comp);
-		iscsit_put_transport(conn->conn_transport);
-		kfree(conn);
-		conn = NULL;
+		iscsit_free_conn(conn);
 		goto exit;
 	} else if (rc < 0) {
 		spin_lock_bh(&np->np_thread_lock);
@@ -1287,17 +1301,13 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 			np->np_thread_state = ISCSI_NP_THREAD_ACTIVE;
 			spin_unlock_bh(&np->np_thread_lock);
 			complete(&np->np_restart_comp);
-			iscsit_put_transport(conn->conn_transport);
-			kfree(conn);
-			conn = NULL;
+			iscsit_free_conn(conn);
 			/* Get another socket */
 			return 1;
 		}
 		spin_unlock_bh(&np->np_thread_lock);
-		iscsit_put_transport(conn->conn_transport);
-		kfree(conn);
-		conn = NULL;
-		goto out;
+		iscsit_free_conn(conn);
+		return 1;
 	}
 	/*
 	 * Perform the remaining iSCSI connection initialization items..
@@ -1447,7 +1457,6 @@ static int __iscsi_target_login_thread(struct iscsi_np *np)
 		tpg_np = NULL;
 	}
 
-out:
 	return 1;
 
 exit:
diff --git a/drivers/target/iscsi/iscsi_target_login.h b/drivers/target/iscsi/iscsi_target_login.h
index 74ac3ab..3b8e363 100644
--- a/drivers/target/iscsi/iscsi_target_login.h
+++ b/drivers/target/iscsi/iscsi_target_login.h
@@ -19,7 +19,7 @@ extern int iscsi_target_setup_login_socket(struct iscsi_np *,
 extern int iscsit_accept_np(struct iscsi_np *, struct iscsi_conn *);
 extern int iscsit_get_login_rx(struct iscsi_conn *, struct iscsi_login *);
 extern int iscsit_put_login_tx(struct iscsi_conn *, struct iscsi_login *, u32);
-extern void iscsit_free_conn(struct iscsi_np *, struct iscsi_conn *);
+extern void iscsit_free_conn(struct iscsi_conn *);
 extern int iscsit_start_kthreads(struct iscsi_conn *);
 extern void iscsi_post_login_handler(struct iscsi_np *, struct iscsi_conn *, u8);
 extern void iscsi_target_login_sess_out(struct iscsi_conn *, struct iscsi_np *,
-- 
1.8.3.1


--------------090800010504050302050402--

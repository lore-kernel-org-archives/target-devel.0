From: Bart Van Assche <bvanassche@acm.org>
Date: Sun, 09 Feb 2020 17:29:36 +0000
Subject: Re: IOZONE fails intermittently while toggling the interface
Message-Id: <d397e15d-ab3b-5446-a1e8-c06a1f6c66e8@acm.org>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------DE860A0EB28FA851911169E4"
List-Id: <target-devel.vger.kernel.org>
References: <CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com>
In-Reply-To: <CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com>
To: target-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------DE860A0EB28FA851911169E4
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 2020-02-07 06:00, Dakshaja Uppalapati wrote:
> While testing iser with kernel 5.5, I see attached soft lockups.
> Logged in and ran iozone on mounted disks. While the traffic is running, toggled the initiators interface down to up for 13 secs.
> I see the attached hung task warnings in the target dmesg. 
> # iozone -a -I -+d -g 32m
> 
> The same test with kernel-5.4 runs fine. I have suspected the following three commits which are all correlated, so removed these commits from 5.5 kernel, rebuilt the kernel and ran the same test then no issue is seen. Iozone is running successfully.
> 
> 80647a89eaf3f2: scsi: target: core: Release SPC-2 reservations when closing a session
> e9d3009cb936b: scsi: target: iscsi: Wait for all commands to finish before freeing a session
> 04060db41178c: scsi: RDMA/isert: Fix a recently introduced regression related to logout
> 
> I am trying to root cause the issue. Please do suggest me if you want me to  check some thing specific.

Does the attached patch help?

Thanks,

Bart.

--------------DE860A0EB28FA851911169E4
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-RDMA-isert-Really-fix-logout.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-RDMA-isert-Really-fix-logout.patch"

From 855af6a1c94f8319867ac944d2e0d97c2c06742c Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 7 Feb 2020 19:57:35 -0800
Subject: [PATCH] RDMA/isert: Really fix logout

Commit 04060db41178 moved the isert_put_unsol_pending_cmds() call from
before target_wait_for_sess_cmds() to after that call. However, a comment
above isert_put_unsol_pending_cmds() is as follows: "We might still have
commands that are waiting for unsolicited dataouts messages. We must put
the extra reference on those before blocking on the
target_wait_for_session_cmds()". Make sure that
isert_put_unsol_pending_cmds() is again called before
target_wait_for_sess_cmds().

Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Rahul Kundu <rahul.kundu@chelsio.com>
Cc: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reported-by: Dakshaja Uppalapati <dakshaja@chelsio.com>
Fixes: 04060db41178 ("scsi: RDMA/isert: Fix a recently introduced regression related to logout")
---
 drivers/infiniband/ulp/isert/ib_isert.c | 15 ++++++++++++---
 drivers/target/iscsi/iscsi_target.c     |  3 +++
 include/target/iscsi/iscsi_transport.h  |  1 +
 3 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b273e421e910..65111025cd87 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2582,7 +2582,7 @@ isert_wait4logout(struct isert_conn *isert_conn)
  *
  * We might still have commands that are waiting for unsolicited
  * dataouts messages. We must put the extra reference on those
- * before blocking on the target_wait_for_session_cmds
+ * before blocking on the target_wait_for_sess_cmds().
  */
 static void
 isert_put_unsol_pending_cmds(struct iscsi_conn *conn)
@@ -2610,11 +2610,11 @@ isert_put_unsol_pending_cmds(struct iscsi_conn *conn)
 	}
 }
 
-static void isert_wait_conn(struct iscsi_conn *conn)
+static void isert_close_conn(struct iscsi_conn *conn)
 {
 	struct isert_conn *isert_conn = conn->context;
 
-	isert_info("Starting conn %p\n", isert_conn);
+	isert_info("Closing conn %p\n", isert_conn);
 
 	mutex_lock(&isert_conn->mutex);
 	isert_conn_terminate(isert_conn);
@@ -2622,6 +2622,14 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
+}
+
+static void isert_wait_conn(struct iscsi_conn *conn)
+{
+	struct isert_conn *isert_conn = conn->context;
+
+	isert_info("Waiting for logout on conn %p\n", isert_conn);
+
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
@@ -2653,6 +2661,7 @@ static struct iscsit_transport iser_target_transport = {
 	.iscsit_setup_np	= isert_setup_np,
 	.iscsit_accept_np	= isert_accept_np,
 	.iscsit_free_np		= isert_free_np,
+	.iscsit_close_conn	= isert_close_conn,
 	.iscsit_wait_conn	= isert_wait_conn,
 	.iscsit_free_conn	= isert_free_conn,
 	.iscsit_get_login_rx	= isert_get_login_rx,
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b94ed4e30770..0e6449c87924 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4226,6 +4226,9 @@ int iscsit_close_connection(
 	atomic_set(&conn->connection_reinstatement, 1);
 	spin_unlock_bh(&conn->state_lock);
 
+	if (conn->conn_transport->iscsit_close_conn)
+		conn->conn_transport->iscsit_close_conn(conn);
+
 	/*
 	 * If any other processes are accessing this connection pointer we
 	 * must wait until they have completed.
diff --git a/include/target/iscsi/iscsi_transport.h b/include/target/iscsi/iscsi_transport.h
index 75bee29fd7dd..f5a370b9e5b3 100644
--- a/include/target/iscsi/iscsi_transport.h
+++ b/include/target/iscsi/iscsi_transport.h
@@ -14,6 +14,7 @@ struct iscsit_transport {
 	int (*iscsit_setup_np)(struct iscsi_np *, struct sockaddr_storage *);
 	int (*iscsit_accept_np)(struct iscsi_np *, struct iscsi_conn *);
 	void (*iscsit_free_np)(struct iscsi_np *);
+	void (*iscsit_close_conn)(struct iscsi_conn *);
 	void (*iscsit_wait_conn)(struct iscsi_conn *);
 	void (*iscsit_free_conn)(struct iscsi_conn *);
 	int (*iscsit_get_login_rx)(struct iscsi_conn *, struct iscsi_login *);

--------------DE860A0EB28FA851911169E4--

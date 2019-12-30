From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 30 Dec 2019 16:56:52 +0000
Subject: Re: Trace seen on target during iSER login
Message-Id: <53ca2c5e-25e1-9762-9a8e-0036c02fdb3b@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <BYAPR12MB3080466CC0D6B968D3525F5BEF270@BYAPR12MB3080.namprd12.prod.outlook.com>
In-Reply-To: <BYAPR12MB3080466CC0D6B968D3525F5BEF270@BYAPR12MB3080.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rahul Kundu <rahul.kundu@chelsio.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc: Potnuri Bharat Teja <bharat@chelsio.com>, Nirranjan Kirubaharan <nirranjan@chelsio.com>, Sagi Grimberg <sagi@grimberg.me>

On 2019-12-29 23:21, Rahul Kundu wrote:
> Below is the patch diff which removes redundant function calls added by the above commit, but I am not sure whether this is the ideal fix:
> ========================================================> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 7251a87bb576..503a76e9cc62 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4234,8 +4234,6 @@ int iscsit_close_connection(
>          * must wait until they have completed.
>          */
>         iscsit_check_conn_usage_count(conn);
> -       target_sess_cmd_list_set_waiting(sess->se_sess);
> -       target_wait_for_sess_cmds(sess->se_sess);
> 
>         ahash_request_free(conn->conn_tx_hash);
>         if (conn->conn_rx_hash) {

I don't like the above change because it would reintroduce the issue fixed by
commit e9d3009cb936. How about the patch below?

Thanks,

Bart.


From f25182525499b52db6be00b34dbfd3662d29e403 Mon Sep 17 00:00:00 2001
From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 30 Dec 2019 07:48:20 -0800
Subject: [PATCH] RDMA/isert: Fix a recently introduced regression related to
 logout

iscsit_close_connection() calls isert_wait_conn(). Due to commit
e9d3009cb936 both functions call target_wait_for_sess_cmds() although
that last function should be called only once. Fix this by removing
the target_wait_for_sess_cmds() call from isert_wait_conn() and by
only calling isert_wait_conn() after target_wait_for_sess_cmds().

Reported-by: Rahul Kundu <rahul.kundu@chelsio.com>
Fixes: e9d3009cb936 ("scsi: target: iscsi: Wait for all commands to finish before freeing a session").
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/infiniband/ulp/isert/ib_isert.c | 12 ------------
 drivers/target/iscsi/iscsi_target.c     |  6 +++---
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index a1a035270cab..b273e421e910 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2575,17 +2575,6 @@ isert_wait4logout(struct isert_conn *isert_conn)
 	}
 }

-static void
-isert_wait4cmds(struct iscsi_conn *conn)
-{
-	isert_info("iscsi_conn %p\n", conn);
-
-	if (conn->sess) {
-		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
-		target_wait_for_sess_cmds(conn->sess->se_sess);
-	}
-}
-
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2633,7 +2622,6 @@ static void isert_wait_conn(struct iscsi_conn *conn)

 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
-	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);

 	queue_work(isert_release_wq, &isert_conn->release_work);
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 7251a87bb576..b94ed4e30770 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4149,9 +4149,6 @@ int iscsit_close_connection(
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);

-	if (conn->conn_transport->iscsit_wait_conn)
-		conn->conn_transport->iscsit_wait_conn(conn);
-
 	/*
 	 * During Connection recovery drop unacknowledged out of order
 	 * commands for this connection, and prepare the other commands
@@ -4237,6 +4234,9 @@ int iscsit_close_connection(
 	target_sess_cmd_list_set_waiting(sess->se_sess);
 	target_wait_for_sess_cmds(sess->se_sess);

+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	ahash_request_free(conn->conn_tx_hash);
 	if (conn->conn_rx_hash) {
 		struct crypto_ahash *tfm;

From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 11 Feb 2020 03:47:41 +0000
Subject: Re: IOZONE fails intermittently while toggling the interface
Message-Id: <16017b1b-b69f-242d-cee4-7117b3b3742e@acm.org>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------0E4FE9B39418730D79C7DCA9"
List-Id: <target-devel.vger.kernel.org>
References: <CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com>
In-Reply-To: <CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com>
To: target-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------0E4FE9B39418730D79C7DCA9
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 2020-02-10 06:19, Dakshaja Uppalapati wrote:
> I had run the test multiple times with the given patch, attached traces are seen.

Thanks for having tested the patch I had shared. Can you test the
attached patch on top of v5.6-rc1? It reverts the following two patches:
* e9d3009cb936 ("scsi: target: iscsi: Wait for all commands to finish
before freeing a session") # v5.5-rc1.
* 04060db41178 ("scsi: RDMA/isert: Fix a recently introduced regression
related to logout") # v5.5

Thanks,

Bart.

--------------0E4FE9B39418730D79C7DCA9
Content-Type: text/x-patch; charset=UTF-8;
 name="revert-recent-iscsi-and-iser-patches.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="revert-recent-iscsi-and-iser-patches.patch"

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b273e421e910..a1a035270cab 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2575,6 +2575,17 @@ isert_wait4logout(struct isert_conn *isert_conn)
 	}
 }
 
+static void
+isert_wait4cmds(struct iscsi_conn *conn)
+{
+	isert_info("iscsi_conn %p\n", conn);
+
+	if (conn->sess) {
+		target_sess_cmd_list_set_waiting(conn->sess->se_sess);
+		target_wait_for_sess_cmds(conn->sess->se_sess);
+	}
+}
+
 /**
  * isert_put_unsol_pending_cmds() - Drop commands waiting for
  *     unsolicitate dataout
@@ -2622,6 +2633,7 @@ static void isert_wait_conn(struct iscsi_conn *conn)
 
 	ib_drain_qp(isert_conn->qp);
 	isert_put_unsol_pending_cmds(conn);
+	isert_wait4cmds(conn);
 	isert_wait4logout(isert_conn);
 
 	queue_work(isert_release_wq, &isert_conn->release_work);
diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index b94ed4e30770..09e55ea0bf5d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -1165,9 +1165,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		hdr->cmdsn, be32_to_cpu(hdr->data_length), payload_length,
 		conn->cid);
 
-	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
-		return iscsit_add_reject_cmd(cmd,
-				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
+	target_get_sess_cmd(&cmd->se_cmd, true);
 
 	cmd->sense_reason = transport_lookup_cmd_lun(&cmd->se_cmd,
 						     scsilun_to_int(&hdr->lun));
@@ -2004,9 +2002,7 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 			      conn->sess->se_sess, 0, DMA_NONE,
 			      TCM_SIMPLE_TAG, cmd->sense_buffer + 2);
 
-	if (target_get_sess_cmd(&cmd->se_cmd, true) < 0)
-		return iscsit_add_reject_cmd(cmd,
-				ISCSI_REASON_WAITING_FOR_LOGOUT, buf);
+	target_get_sess_cmd(&cmd->se_cmd, true);
 
 	/*
 	 * TASK_REASSIGN for ERL=2 / connection stays inside of
@@ -4149,6 +4145,9 @@ int iscsit_close_connection(
 	iscsit_stop_nopin_response_timer(conn);
 	iscsit_stop_nopin_timer(conn);
 
+	if (conn->conn_transport->iscsit_wait_conn)
+		conn->conn_transport->iscsit_wait_conn(conn);
+
 	/*
 	 * During Connection recovery drop unacknowledged out of order
 	 * commands for this connection, and prepare the other commands
@@ -4231,11 +4230,6 @@ int iscsit_close_connection(
 	 * must wait until they have completed.
 	 */
 	iscsit_check_conn_usage_count(conn);
-	target_sess_cmd_list_set_waiting(sess->se_sess);
-	target_wait_for_sess_cmds(sess->se_sess);
-
-	if (conn->conn_transport->iscsit_wait_conn)
-		conn->conn_transport->iscsit_wait_conn(conn);
 
 	ahash_request_free(conn->conn_tx_hash);
 	if (conn->conn_rx_hash) {
diff --git a/include/scsi/iscsi_proto.h b/include/scsi/iscsi_proto.h
index 533f56733ba8..b71b5c4f418c 100644
--- a/include/scsi/iscsi_proto.h
+++ b/include/scsi/iscsi_proto.h
@@ -627,7 +627,6 @@ struct iscsi_reject {
 #define ISCSI_REASON_BOOKMARK_INVALID	9
 #define ISCSI_REASON_BOOKMARK_NO_RESOURCES	10
 #define ISCSI_REASON_NEGOTIATION_RESET	11
-#define ISCSI_REASON_WAITING_FOR_LOGOUT	12
 
 /* Max. number of Key=Value pairs in a text message */
 #define MAX_KEY_VALUE_PAIRS	8192

--------------0E4FE9B39418730D79C7DCA9--

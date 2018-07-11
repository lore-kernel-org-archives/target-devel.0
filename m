From: Varun Prakash <varun@chelsio.com>
Date: Wed, 11 Jul 2018 16:45:43 +0000
Subject: [PATCH] target: iscsi: cxgbit: fix max iso npdu calculation
Message-Id: <1531326823-11862-1-git-send-email-varun@chelsio.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

- rounddown CXGBIT_MAX_ISO_PAYLOAD by csk->emss before
calculating max_iso_npdu to get max TCP payload
in multiple of mss.

- call cxgbit_set_digest() before cxgbit_set_iso_npdu()
to set csk->submode, it is used in calculating
number of iso pdus.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 514986b..25eb389 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -652,6 +652,7 @@ static int cxgbit_set_iso_npdu(struct cxgbit_sock *csk)
 	struct iscsi_param *param;
 	u32 mrdsl, mbl;
 	u32 max_npdu, max_iso_npdu;
+	u32 max_iso_payload;
 
 	if (conn->login->leading_connection) {
 		param = iscsi_find_param_from_key(MAXBURSTLENGTH,
@@ -670,8 +671,10 @@ static int cxgbit_set_iso_npdu(struct cxgbit_sock *csk)
 	mrdsl = conn_ops->MaxRecvDataSegmentLength;
 	max_npdu = mbl / mrdsl;
 
-	max_iso_npdu = CXGBIT_MAX_ISO_PAYLOAD /
-			(ISCSI_HDR_LEN + mrdsl +
+	max_iso_payload = rounddown(CXGBIT_MAX_ISO_PAYLOAD, csk->emss);
+
+	max_iso_npdu = max_iso_payload /
+		       (ISCSI_HDR_LEN + mrdsl +
 			cxgbit_digest_len[csk->submode]);
 
 	csk->max_iso_npdu = min(max_npdu, max_iso_npdu);
@@ -741,6 +744,9 @@ static int cxgbit_set_params(struct iscsi_conn *conn)
 	if (conn_ops->MaxRecvDataSegmentLength > cdev->mdsl)
 		conn_ops->MaxRecvDataSegmentLength = cdev->mdsl;
 
+	if (cxgbit_set_digest(csk))
+		return -1;
+
 	if (conn->login->leading_connection) {
 		param = iscsi_find_param_from_key(ERRORRECOVERYLEVEL,
 						  conn->param_list);
@@ -764,7 +770,7 @@ static int cxgbit_set_params(struct iscsi_conn *conn)
 			if (is_t5(cdev->lldi.adapter_type))
 				goto enable_ddp;
 			else
-				goto enable_digest;
+				return 0;
 		}
 
 		if (test_bit(CDEV_ISO_ENABLE, &cdev->flags)) {
@@ -781,10 +787,6 @@ static int cxgbit_set_params(struct iscsi_conn *conn)
 		}
 	}
 
-enable_digest:
-	if (cxgbit_set_digest(csk))
-		return -1;
-
 	return 0;
 }
 
-- 
2.0.2


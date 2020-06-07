From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 07 Jun 2020 20:35:54 +0000
Subject: [PATCH 07/17] iscsi target: setup transport_id
Message-Id: <1591562164-9766-8-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The iscsi target does its own session setup. This patch updates the
driver so it sets up the transport id.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/target/iscsi/iscsi_target_nego.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 685d771..c44613a2 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1032,6 +1032,20 @@ static void iscsi_initiatorname_tolower(
 	}
 }
 
+static int iscsi_setup_i_tpt_id(struct iscsi_session *sess, char *iname)
+{
+	char isid_buf[13];
+
+	sprintf(isid_buf, "%6phN", sess->isid);
+
+	sess->se_sess->tpt_id = target_create_transport_id(SCSI_PROTOCOL_ISCSI,
+							   iname, isid_buf);
+	if (!sess->se_sess->tpt_id)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * Processes the first Login Request..
  */
@@ -1260,11 +1274,21 @@ int iscsi_target_locate_portal(
 	tag_size = sizeof(struct iscsi_cmd) + conn->conn_transport->priv_size;
 
 	ret = transport_alloc_session_tags(sess->se_sess, tag_num, tag_size);
-	if (ret < 0) {
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				    ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		ret = -1;
+	if (ret < 0)
+		goto return_oom;
+
+	if (conn->tpg != iscsit_global->discovery_tpg) {
+		if (iscsi_setup_i_tpt_id(sess, i_buf))
+			/* tags and nacl released when session is freed */
+			goto return_oom;
 	}
+
+	goto out;
+
+return_oom:
+	iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
+			    ISCSI_LOGIN_STATUS_NO_RESOURCES);
+	ret = -1;
 out:
 	kfree(tmpbuf);
 	return ret;
-- 
1.8.3.1

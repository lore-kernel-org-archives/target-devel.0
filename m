From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Apr 2020 06:11:01 +0000
Subject: [PATCH 03/11] iscsi target: setup transport_id
Message-Id: <20200428061109.3042-4-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200428061109.3042-1-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

The iscsi target does its own session setup. This patch updates the
driver so it sets up the transport id.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 37 ++++++++++++++++++++++++++++----
 1 file changed, 33 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 685d771..dce2fe2 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1032,6 +1032,25 @@ static void iscsi_initiatorname_tolower(
 	}
 }
 
+static int iscsi_setup_i_tpid(struct iscsi_session *sess, char *iname)
+{
+	struct t10_transport_id tpid;
+	char isid_buf[13];
+
+	sprintf(isid_buf, "%6phN", sess->isid);
+
+	memset(&tpid, 0, sizeof(tpid));
+	tpid.proto = SCSI_PROTOCOL_ISCSI;
+	tpid.name = iname;
+	tpid.session_id = isid_buf;
+
+	sess->se_sess->tpid = target_cp_transport_id(&tpid);
+	if (!sess->se_sess->tpid)
+		return -ENOMEM;
+
+	return 0;
+}
+
 /*
  * Processes the first Login Request..
  */
@@ -1260,11 +1279,21 @@ int iscsi_target_locate_portal(
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
+		if (iscsi_setup_i_tpid(sess, i_buf))
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

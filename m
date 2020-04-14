From: Mike Christie <mchristi@redhat.com>
Date: Tue, 14 Apr 2020 05:15:13 +0000
Subject: [RFC PATCH 4/5] iscsi target: use session sysfs helpers
Message-Id: <20200414051514.7296-5-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
In-Reply-To: <20200414051514.7296-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

The iscsi target login process breaks up session allocation and
registration, so it does not use target_setup_session like every one
else. This converts iscsi to use the session sysfs helpers and drops its
session id to use the common one.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c          |  4 ++--
 drivers/target/iscsi/iscsi_target_configfs.c |  4 +---
 drivers/target/iscsi/iscsi_target_login.c    | 16 ++--------------
 drivers/target/iscsi/iscsi_target_nego.c     | 20 ++++++++++++++++----
 drivers/target/iscsi/iscsi_target_stat.c     |  3 +--
 include/target/iscsi/iscsi_target_core.h     |  2 --
 6 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 59379d6..e8ea597 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -49,7 +49,6 @@
 static DEFINE_MUTEX(np_lock);
 
 static struct idr tiqn_idr;
-DEFINE_IDA(sess_ida);
 struct mutex auth_id_lock;
 
 struct iscsit_global *iscsit_global;
@@ -4359,6 +4358,8 @@ int iscsit_close_session(struct iscsi_session *sess)
 	iscsit_stop_time2retain_timer(sess);
 	spin_unlock_bh(&se_tpg->session_lock);
 
+	target_sysfs_remove_session(sess->se_sess);
+
 	/*
 	 * transport_deregister_session_configfs() will clear the
 	 * struct se_node_acl->nacl_sess pointer now as a iscsi_np process context
@@ -4403,7 +4404,6 @@ int iscsit_close_session(struct iscsi_session *sess)
 	pr_debug("Decremented number of active iSCSI Sessions on"
 		" iSCSI TPG: %hu to %u\n", tpg->tpgt, tpg->nsessions);
 
-	ida_free(&sess_ida, sess->session_index);
 	kfree(sess->sess_ops);
 	sess->sess_ops = NULL;
 	spin_unlock_bh(&se_tpg->session_lock);
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 0fa1d57..e9e06bb 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1344,9 +1344,7 @@ static int iscsi_get_cmd_state(struct se_cmd *se_cmd)
 
 static u32 lio_sess_get_index(struct se_session *se_sess)
 {
-	struct iscsi_session *sess = se_sess->fabric_sess_ptr;
-
-	return sess->session_index;
+	return se_sess->sid;
 }
 
 static u32 lio_sess_get_initiator_sid(
diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index 731ee67..619ea09 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -257,7 +257,6 @@ static int iscsi_login_zero_tsih_s1(
 {
 	struct iscsi_session *sess = NULL;
 	struct iscsi_login_req *pdu = (struct iscsi_login_req *)buf;
-	int ret;
 
 	sess = kzalloc(sizeof(struct iscsi_session), GFP_KERNEL);
 	if (!sess) {
@@ -291,15 +290,6 @@ static int iscsi_login_zero_tsih_s1(
 	timer_setup(&sess->time2retain_timer,
 		    iscsit_handle_time2retain_timeout, 0);
 
-	ret = ida_alloc(&sess_ida, GFP_KERNEL);
-	if (ret < 0) {
-		pr_err("Session ID allocation failed %d\n", ret);
-		iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
-				ISCSI_LOGIN_STATUS_NO_RESOURCES);
-		goto free_sess;
-	}
-
-	sess->session_index = ret;
 	sess->creation_time = get_jiffies_64();
 	/*
 	 * The FFP CmdSN window values will be allocated from the TPG's
@@ -313,7 +303,7 @@ static int iscsi_login_zero_tsih_s1(
 				ISCSI_LOGIN_STATUS_NO_RESOURCES);
 		pr_err("Unable to allocate memory for"
 				" struct iscsi_sess_ops.\n");
-		goto free_id;
+		goto free_ops;
 	}
 
 	sess->se_sess = transport_alloc_session(TARGET_PROT_NORMAL);
@@ -327,8 +317,6 @@ static int iscsi_login_zero_tsih_s1(
 
 free_ops:
 	kfree(sess->sess_ops);
-free_id:
-	ida_free(&sess_ida, sess->session_index);
 free_sess:
 	kfree(sess);
 	conn->sess = NULL;
@@ -1183,8 +1171,8 @@ void iscsi_target_login_sess_out(struct iscsi_conn *conn,
 	if (!zero_tsih || !conn->sess)
 		goto old_sess_out;
 
+	target_sysfs_remove_session(conn->sess->se_sess);
 	transport_free_session(conn->sess->se_sess);
-	ida_free(&sess_ida, conn->sess->session_index);
 	kfree(conn->sess->sess_ops);
 	kfree(conn->sess);
 	conn->sess = NULL;
diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 685d771..17e12f3 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -1260,11 +1260,23 @@ int iscsi_target_locate_portal(
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
+		ret = target_sysfs_add_session(&conn->tpg->tpg_se_tpg,
+						sess->se_sess, NULL);
+		if (ret)
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
diff --git a/drivers/target/iscsi/iscsi_target_stat.c b/drivers/target/iscsi/iscsi_target_stat.c
index 35e75a3..8167fdc 100644
--- a/drivers/target/iscsi/iscsi_target_stat.c
+++ b/drivers/target/iscsi/iscsi_target_stat.c
@@ -630,8 +630,7 @@ static ssize_t iscsi_stat_sess_indx_show(struct config_item *item, char *page)
 	if (se_sess) {
 		sess = se_sess->fabric_sess_ptr;
 		if (sess)
-			ret = snprintf(page, PAGE_SIZE, "%u\n",
-					sess->session_index);
+			ret = snprintf(page, PAGE_SIZE, "%u\n", se_sess->sid);
 	}
 	spin_unlock_bh(&se_nacl->nacl_sess_lock);
 
diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
index 591cd9e..443c5af 100644
--- a/include/target/iscsi/iscsi_target_core.h
+++ b/include/target/iscsi/iscsi_target_core.h
@@ -657,8 +657,6 @@ struct iscsi_session {
 	/* LIO specific session ID */
 	u32			sid;
 	char			auth_type[8];
-	/* unique within the target */
-	int			session_index;
 	/* Used for session reference counting */
 	int			session_usage_count;
 	int			session_waiting_on_uc;
-- 
1.8.3.1

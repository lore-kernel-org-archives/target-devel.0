From: Mike Christie <mchristi@redhat.com>
Date: Sun, 28 Apr 2019 04:17:20 +0000
Subject: [PATCH 2/2] iscsi target: Fix CHAP negotiation setup
Message-Id: <20190428041720.9119-3-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If the user has disabled authentication and not setup CHAP, we will
still try to use CHAP if the initiator sends CHAP,None. The login
will then fail because the user didn't setup CHAP. This patch just
has us detect when CHAP/authentication has been turned off so we
negotiate for None instead of CHAP.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 41 +++++++++++++++++++++++++++++++-
 1 file changed, 40 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 7d794be..055c1cc 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -828,6 +828,45 @@ static int iscsi_target_do_authentication(
 	return 0;
 }
 
+static struct iscsi_param *iscsi_target_init_auth_param(struct iscsi_conn *conn)
+{
+	struct iscsi_session *sess = conn->sess;
+	struct iscsi_node_auth *auth;
+	struct iscsi_portal_group *iscsi_tpg;
+	struct se_node_acl *se_nacl;
+	struct iscsi_param *param;
+
+	param = iscsi_find_param_from_key(AUTHMETHOD, conn->param_list);
+	if (!param)
+		return NULL;
+
+	if (sess->sess_ops->SessionType) {
+		iscsi_tpg = iscsit_global->discovery_tpg;
+	} else {
+		se_nacl = conn->sess->se_sess->se_node_acl;
+
+		iscsi_tpg = container_of(se_nacl->se_tpg,
+					 struct iscsi_portal_group, tpg_se_tpg);
+	}
+
+	auth = iscsi_target_get_auth_from_conn(conn);
+	if (!auth)
+		return NULL;
+	/*
+	 * If we have CHAP,None but have not setup any CHAP values and have
+	 * disabled enforcement then use None. If the user has partially setup
+	 * CHAP then still use CHAP, so login fails and we do not allow access
+	 * due to user misconfiguration.
+	 */
+	if (strstr("CHAP,None", param->value) && !auth->naf_flags &&
+	    !iscsi_tpg->tpg_attrib.authentication) {
+		if (iscsi_update_param_value(param, NONE) < 0)
+			return NULL;
+	}
+
+	return param;
+}
+
 static int iscsi_target_handle_csg_zero(
 	struct iscsi_conn *conn,
 	struct iscsi_login *login)
@@ -842,7 +881,7 @@ static int iscsi_target_handle_csg_zero(
 	login_rsp = (struct iscsi_login_rsp *) login->rsp;
 	payload_length = ntoh24(login_req->dlength);
 
-	param = iscsi_find_param_from_key(AUTHMETHOD, conn->param_list);
+	param = iscsi_target_init_auth_param(conn);
 	if (!param)
 		return -1;
 
-- 
1.8.3.1

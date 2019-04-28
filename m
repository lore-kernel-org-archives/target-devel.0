From: Mike Christie <mchristi@redhat.com>
Date: Sun, 28 Apr 2019 04:17:19 +0000
Subject: [PATCH 1/2] iscsi target: make function to get auth from conn
Message-Id: <20190428041720.9119-2-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Move the code to go from iscsi conn to iscsi node auth to a helper
function which will also be used in the next patch.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_nego.c | 35 +++++++++++++++++++++-----------
 1 file changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
index 8a5e8d1..7d794be 100644
--- a/drivers/target/iscsi/iscsi_target_nego.c
+++ b/drivers/target/iscsi/iscsi_target_nego.c
@@ -103,13 +103,8 @@ int extract_param(
 	return 0;
 }
 
-static u32 iscsi_handle_authentication(
-	struct iscsi_conn *conn,
-	char *in_buf,
-	char *out_buf,
-	int in_length,
-	int *out_length,
-	unsigned char *authtype)
+static struct iscsi_node_auth *iscsi_target_get_auth_from_conn(
+		struct iscsi_conn *conn)
 {
 	struct iscsi_session *sess = conn->sess;
 	struct iscsi_node_auth *auth;
@@ -125,25 +120,24 @@ static u32 iscsi_handle_authentication(
 		if (!se_nacl) {
 			pr_err("Unable to locate struct se_node_acl for"
 					" CHAP auth\n");
-			return -1;
+			return NULL;
 		}
 		iscsi_nacl = container_of(se_nacl, struct iscsi_node_acl,
 				se_node_acl);
 		if (!iscsi_nacl) {
 			pr_err("Unable to locate struct iscsi_node_acl for"
 					" CHAP auth\n");
-			return -1;
+			return NULL;
 		}
 
 		if (se_nacl->dynamic_node_acl) {
 			iscsi_tpg = container_of(se_nacl->se_tpg,
-					struct iscsi_portal_group, tpg_se_tpg);
-
+						 struct iscsi_portal_group,
+						 tpg_se_tpg);
 			auth = &iscsi_tpg->tpg_demo_auth;
 		} else {
 			iscsi_nacl = container_of(se_nacl, struct iscsi_node_acl,
 						  se_node_acl);
-
 			auth = &iscsi_nacl->node_auth;
 		}
 	} else {
@@ -153,6 +147,23 @@ static u32 iscsi_handle_authentication(
 		auth = &iscsit_global->discovery_acl.node_auth;
 	}
 
+	return auth;
+}
+
+static u32 iscsi_handle_authentication(
+	struct iscsi_conn *conn,
+	char *in_buf,
+	char *out_buf,
+	int in_length,
+	int *out_length,
+	unsigned char *authtype)
+{
+	struct iscsi_node_auth *auth;
+
+	auth = iscsi_target_get_auth_from_conn(conn);
+	if (!auth)
+		return -1;
+
 	if (strstr("CHAP", authtype))
 		strcpy(conn->sess->auth_type, "CHAP");
 	else
-- 
1.8.3.1

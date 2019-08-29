From: Maurizio Lombardi <mlombard@redhat.com>
Date: Thu, 29 Aug 2019 15:59:27 +0000
Subject: [PATCH 2/4] target-iscsi: remove unneeded function
Message-Id: <20190829155929.27701-3-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190829155929.27701-1-mlombard@redhat.com>
In-Reply-To: <20190829155929.27701-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cleech@redhat.com
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The digest type validy is already checked by chap_server_open(), therefore
we can remove the chap_got_response() function.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 26 +-----------------------
 1 file changed, 1 insertion(+), 25 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 3d1e94333835..77dac8086927 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -473,30 +473,6 @@ static int chap_server_compute_hash(
 	return auth_ret;
 }
 
-static int chap_got_response(
-	struct iscsi_conn *conn,
-	struct iscsi_node_auth *auth,
-	char *nr_in_ptr,
-	char *nr_out_ptr,
-	unsigned int *nr_out_len)
-{
-	struct iscsi_chap *chap = conn->auth_protocol;
-
-	switch (chap->digest_type) {
-	case CHAP_DIGEST_MD5:
-	case CHAP_DIGEST_SHA:
-	case CHAP_DIGEST_SHA3_256:
-		if (chap_server_compute_hash(conn, auth, nr_in_ptr,
-				nr_out_ptr, nr_out_len) < 0)
-			return -1;
-		return 0;
-	default:
-		pr_err("Unknown CHAP digest type %d!\n",
-				chap->digest_type);
-		return -1;
-	}
-}
-
 u32 chap_main_loop(
 	struct iscsi_conn *conn,
 	struct iscsi_node_auth *auth,
@@ -515,7 +491,7 @@ u32 chap_main_loop(
 		return 0;
 	} else if (chap->chap_state = CHAP_STAGE_SERVER_AIC) {
 		convert_null_to_semi(in_text, *in_len);
-		if (chap_got_response(conn, auth, in_text, out_text,
+		if (chap_server_compute_hash(conn, auth, in_text, out_text,
 				out_len) < 0) {
 			chap_close(conn);
 			return 2;
-- 
Maurizio Lombardi

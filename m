From: Vincent Pelletier <plr.vincent@gmail.com>
Date: Wed, 15 Aug 2018 12:08:53 +0000
Subject: iscsi target: Let initiator decide whether it wants to authenticate target
Message-Id: <97479a0ccf17d8ad7a8ba7a0f7e8190da6ddc72e.1534334933.git.plr.vincent@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Do not fail authentication after target is happy with initiator's
credentials, when target is configured to authenticate itself to an
initiator but current initiator did not provide required values.
Also, downgrade "Could not find CHAP_I." to a debug level message, as it
will happen normally in such case.

Signed-off-by: Vincent Pelletier <plr.vincent@gmail.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index 4e680d753941..8598eb00830a 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -290,18 +290,21 @@ static int chap_server_compute_md5(
 		pr_debug("[server] MD5 Digests match, CHAP connection"
 				" successful.\n\n");
 	/*
-	 * One way authentication has succeeded, return now if mutual
-	 * authentication is not enabled.
+	 * One way authentication has succeeded
+	 */
+	auth_ret = 0;
+	*nr_out_len = 0;
+	/*
+	 * Return now if mutual authentication is not enabled.
 	 */
 	if (!auth->authenticate_target) {
-		auth_ret = 0;
 		goto out;
 	}
 	/*
 	 * Get CHAP_I.
 	 */
 	if (extract_param(nr_in_ptr, "CHAP_I", 10, identifier, &type) < 0) {
-		pr_err("Could not find CHAP_I.\n");
+		pr_debug("Could not find CHAP_I.\n");
 		goto out;
 	}
 
@@ -407,7 +410,7 @@ static int chap_server_compute_md5(
 			response);
 	*nr_out_len += 1;
 	pr_debug("[server] Sending CHAP_R=0x%s\n", response);
-	auth_ret = 0;
+	chap->chap_state = CHAP_STAGE_SERVER_NR;
 out:
 	kzfree(desc);
 	if (tfm)
@@ -462,10 +465,6 @@ u32 chap_main_loop(
 			chap_close(conn);
 			return 2;
 		}
-		if (auth->authenticate_target)
-			chap->chap_state = CHAP_STAGE_SERVER_NR;
-		else
-			*out_len = 0;
 		chap_close(conn);
 		return 1;
 	}
-- 
2.18.0

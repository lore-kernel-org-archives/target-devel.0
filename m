From: Maurizio Lombardi <mlombard@redhat.com>
Date: Fri, 13 Mar 2020 16:12:53 +0000
Subject: [PATCH 3/3] iscsi target: calling iscsit_stop_session() inside iscsit_close_session() has no effect
Message-Id: <20200313161253.5507-4-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

iscsit_close_session() can only be called when nconn is zero (otherwise
a kernel panic is triggered); if nconn is zero then
iscsit_stop_session() does nothing and exits, so calling it
makes no sense.

We still need to call iscsit_check_session_usage_count() because
this function will sleep if the session's refcount is not zero and
we don't want to destroy the session structure if
it's still being referenced.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9e90edc875f1..14f4842e3517 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -4385,8 +4385,7 @@ int iscsit_close_session(struct iscsi_session *sess)
 	 * restart the timer and exit.
 	 */
 	if (!in_interrupt()) {
-		if (iscsit_check_session_usage_count(sess) == 1)
-			iscsit_stop_session(sess, 1, 1);
+		iscsit_check_session_usage_count(sess);
 	} else {
 		if (iscsit_check_session_usage_count(sess) == 2) {
 			atomic_set(&sess->session_logout, 0);
-- 
2.21.0

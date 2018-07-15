From: Mike Christie <mchristi@redhat.com>
Date: Sun, 15 Jul 2018 23:16:29 +0000
Subject: [PATCH 13/15] iscsi target: check nopin_response_timeout before starting timer
Message-Id: <1531696591-8558-14-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The next patch will use a iscsi nop as a ping/test IO. For
that nop we will allow the user to specify a timeout value
that may be different from the hard coded or acl
nopin_response_timeout value.

This patch adds checks so if the nopin_response_timeout is
turned off we do not accidentally turn it on for the
user initiated test nop.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 5a645b5..c51c14e 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -955,7 +955,8 @@ void iscsit_mod_nopin_response_timer(struct iscsi_conn *conn)
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	spin_lock_bh(&conn->nopin_timer_lock);
-	if (!(conn->nopin_response_timer_flags & ISCSI_TF_RUNNING)) {
+	if (!na->nopin_response_timeout ||
+	    !(conn->nopin_response_timer_flags & ISCSI_TF_RUNNING)) {
 		spin_unlock_bh(&conn->nopin_timer_lock);
 		return;
 	}
@@ -974,7 +975,8 @@ void iscsit_start_nopin_response_timer(struct iscsi_conn *conn)
 	struct iscsi_node_attrib *na = iscsit_tpg_get_node_attrib(sess);
 
 	spin_lock_bh(&conn->nopin_timer_lock);
-	if (conn->nopin_response_timer_flags & ISCSI_TF_RUNNING) {
+	if (!na->nopin_response_timeout ||
+	    conn->nopin_response_timer_flags & ISCSI_TF_RUNNING) {
 		spin_unlock_bh(&conn->nopin_timer_lock);
 		return;
 	}
-- 
2.7.2


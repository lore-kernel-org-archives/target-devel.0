From: David Disseldorp <ddiss@suse.de>
Date: Thu, 12 Sep 2019 09:55:46 +0000
Subject: [PATCH 2/3] target: fix SendTargets=All string compares
Message-Id: <20190912095547.22427-3-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

strncmp is currently used for "SendTargets" key and "All" value matching
without checking for trailing garbage. This means that Text request PDUs
with garbage such as "SendTargetsPlease=All" and "SendTargets=Alle" are
processed successfully as if they were "SendTargets=All" requests.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index d19e051f2bc2..09e55ea0bf5d 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -2189,24 +2189,22 @@ iscsit_process_text_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 		}
 		goto empty_sendtargets;
 	}
-	if (strncmp("SendTargets", text_in, 11) != 0) {
+	if (strncmp("SendTargets=", text_in, 12) != 0) {
 		pr_err("Received Text Data that is not"
 			" SendTargets, cannot continue.\n");
 		goto reject;
 	}
+	/* '=' confirmed in strncmp */
 	text_ptr = strchr(text_in, '=');
-	if (!text_ptr) {
-		pr_err("No \"=\" separator found in Text Data,"
-			"  cannot continue.\n");
-		goto reject;
-	}
-	if (!strncmp("=All", text_ptr, 4)) {
+	BUG_ON(!text_ptr);
+	if (!strncmp("=All", text_ptr, 5)) {
 		cmd->cmd_flags |= ICF_SENDTARGETS_ALL;
 	} else if (!strncmp("=iqn.", text_ptr, 5) ||
 		   !strncmp("=eui.", text_ptr, 5)) {
 		cmd->cmd_flags |= ICF_SENDTARGETS_SINGLE;
 	} else {
-		pr_err("Unable to locate valid SendTargets=%s value\n", text_ptr);
+		pr_err("Unable to locate valid SendTargets%s value\n",
+		       text_ptr);
 		goto reject;
 	}
 
-- 
2.16.4

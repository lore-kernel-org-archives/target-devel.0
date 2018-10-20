From: Roland Dreier <roland@kernel.org>
Date: Sat, 20 Oct 2018 16:45:04 +0000
Subject: [PATCH 1/2] target: Set response length for REPORT TARGET PORT GROUPS
Message-Id: <20181020164504.8644-1-roland@kernel.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Roland Dreier <roland@purestorage.com>

One more place where we can return the length we actually fill in.

Signed-off-by: Roland Dreier <roland@purestorage.com>
---
 drivers/target/target_core_alua.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index e46ca968009c..4f134b0c3e29 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -268,7 +268,7 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	}
 	transport_kunmap_data_sg(cmd);
 
-	target_complete_cmd(cmd, GOOD);
+	target_complete_cmd_with_length(cmd, GOOD, rd_len + 4);
 	return 0;
 }
 
-- 
2.19.1

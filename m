From: David Disseldorp <ddiss@suse.de>
Date: Tue, 09 Oct 2018 11:37:06 +0000
Subject: [PATCH 4/4] target: log NOP ping timeouts as errors
Message-Id: <20181009113706.27696-5-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Events resulting in connection outages like this should be logged as
errors.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/iscsi/iscsi_target_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 49be1e41290c..b20e87f0795f 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -925,7 +925,7 @@ void iscsit_handle_nopin_response_timeout(struct timer_list *t)
 		return;
 	}
 
-	pr_debug("Did not receive response to NOPIN on CID: %hu on"
+	pr_err("Did not receive response to NOPIN on CID: %hu on"
 		" SID: %u, failing connection.\n", conn->cid,
 			conn->sess->sid);
 	conn->nopin_response_timer_flags &= ~ISCSI_TF_RUNNING;
-- 
2.13.7

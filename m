From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 05 Nov 2018 17:23:17 +0000
Subject: [PATCH] target/core: Make it safe to pass NULL as third argument to compare_and_write_callback()
Message-Id: <20181105172317.248955-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Fixes: aa73237dcb2d ("scsi: target/core: Always call transport_complete_callback() upon failure")
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---

Hi Martin,

This patch fixes a bug that was introduced during the merge window. Please consider
this patch for a v4.20-rc<n> kernel.

 drivers/target/target_core_sbc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index 1ac1f7d2e6c9..7c8433e32906 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -480,7 +480,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	if (cmd->scsi_status) {
 		pr_debug("compare_and_write_callback: non zero scsi_status:"
 			" 0x%02x\n", cmd->scsi_status);
-		*post_ret = 1;
+		if (post_ret)
+			*post_ret = 1;
 		if (cmd->scsi_status = SAM_STAT_CHECK_CONDITION)
 			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 		goto out;
-- 
2.19.1.930.g4563a0d9d0-goog

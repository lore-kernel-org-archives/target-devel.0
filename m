From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:40 +0000
Subject: [PATCH 03/17] target/core: Remove an unused data member from struct xcopy_pt_cmd
Message-Id: <20180917213554.987-4-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

A value is assigned to the xcopy_op member of struct xcopy_pt_cmd
but that value is never used. Hence remove the xcopy_op member.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_xcopy.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 2718a933c0c6..70adcfdca8d1 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -391,7 +391,6 @@ static int target_xcopy_parse_segment_descriptors(struct se_cmd *se_cmd,
 struct xcopy_pt_cmd {
 	bool remote_port;
 	struct se_cmd se_cmd;
-	struct xcopy_op *xcopy_op;
 	struct completion xpt_passthrough_sem;
 	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
 };
@@ -596,8 +595,6 @@ static int target_xcopy_setup_pt_cmd(
 	 * X-COPY PUSH or X-COPY PULL based upon where the CDB was received.
 	 */
 	target_xcopy_init_pt_lun(se_dev, cmd, remote_port);
-
-	xpt_cmd->xcopy_op = xop;
 	target_xcopy_setup_pt_port(xpt_cmd, xop, remote_port);
 
 	cmd->tag = 0;
-- 
2.18.0

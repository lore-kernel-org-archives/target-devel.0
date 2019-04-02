From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:08 +0000
Subject: [PATCH 04/11] target/core: Remove a set-but-not-used member variable from the XCOPY implementation
Message-Id: <20190402195815.254796-5-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch does not change any functionality.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_xcopy.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 9be1418e919f..d97be766e4ac 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -389,7 +389,6 @@ static int target_xcopy_parse_segment_descriptors(struct se_cmd *se_cmd,
  */
 
 struct xcopy_pt_cmd {
-	bool remote_port;
 	struct se_cmd se_cmd;
 	struct completion xpt_passthrough_sem;
 	unsigned char sense_buffer[TRANSPORT_SENSE_BUFFER];
@@ -520,9 +519,7 @@ static void target_xcopy_setup_pt_port(
 		 * when CDB is received on local source port, and READs blocks to
 		 * WRITE on remote destination port.
 		 */
-		if (remote_port) {
-			xpt_cmd->remote_port = remote_port;
-		} else {
+		if (!remote_port) {
 			pt_cmd->se_lun = ec_cmd->se_lun;
 			pt_cmd->se_dev = ec_cmd->se_dev;
 
@@ -539,9 +536,7 @@ static void target_xcopy_setup_pt_port(
 		 * blocks from the remote source port to WRITE on local
 		 * destination port.
 		 */
-		if (remote_port) {
-			xpt_cmd->remote_port = remote_port;
-		} else {
+		if (!remote_port) {
 			pt_cmd->se_lun = ec_cmd->se_lun;
 			pt_cmd->se_dev = ec_cmd->se_dev;
 
-- 
2.21.0.196.g041f5ea1cf98

From: Mike Christie <mchristi@redhat.com>
Date: Wed, 25 Oct 2017 16:47:22 +0000
Subject: [PATCH 12/20] tcmu: release blocks for partially setup cmds
Message-Id: <1508950050-10120-13-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If we cannot setup a cmd because we run out of ring space
or global pages release the blocks before sleeping. This
prevents a deadlock where dev0 has waiting_blocks set and
needs N blocks, but dev1 to devX have each allocated N / X blocks
and also hit the global block limit so they went to sleep.

find_free_blocks is not able to take the sleeping dev's
blocks becaause their waiting_blocks is set and even
if it was not the block returned by find_last_bit could equal
dbi_max. The latter will probably never happen because
DATA_BLOCK_BITS is so high but in the next patches
DATA_BLOCK_BITS and TCMU_GLOBAL_MAX_BLOCKS will be settable so
it might be lower and could happen.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5c4029c..dff7b14 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -841,6 +841,13 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 		int ret;
 		DEFINE_WAIT(__wait);
 
+		/*
+		 * Don't leave commands partially setup because the unmap
+		 * thread might need the blocks to make forward progress.
+		 */
+		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
+		tcmu_cmd_reset_dbi_cur(tcmu_cmd);
+
 		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
 
 		pr_debug("sleeping for ring space\n");
-- 
2.7.2


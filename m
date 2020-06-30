From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 30 Jun 2020 10:47:04 +0000
Subject: [RFC PATCH 3/8] scsi: target: tcmu: Use priv pointer in se_cmd
Message-Id: <20200630104709.23066-4-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

We initialize and clean up the se_cmd's priv pointer
under cmd_ring_lock to point to the corresponding tcmu_cmd.

In the patch that implements tmr_notify callback in
tcmu we will use the priv pointer.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 82e476d48194..c900e3dd25aa 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -541,6 +541,8 @@ tcmu_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 
 static inline void tcmu_free_cmd(struct tcmu_cmd *tcmu_cmd)
 {
+	if (tcmu_cmd->se_cmd)
+		tcmu_cmd->se_cmd->priv = NULL;
 	kfree(tcmu_cmd->dbi);
 	kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 }
@@ -1109,10 +1111,11 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	mutex_lock(&udev->cmdr_lock);
+	se_cmd->priv = tcmu_cmd;
 	ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
-	mutex_unlock(&udev->cmdr_lock);
 	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
+	mutex_unlock(&udev->cmdr_lock);
 	return scsi_ret;
 }
 
@@ -1179,7 +1182,6 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		target_complete_cmd(cmd->se_cmd, entry->rsp.scsi_status);
 
 out:
-	cmd->se_cmd = NULL;
 	tcmu_cmd_free_data(cmd, cmd->dbi_cnt);
 	tcmu_free_cmd(cmd);
 }
@@ -1285,6 +1287,7 @@ static void tcmu_check_expired_ring_cmd(struct tcmu_cmd *cmd)
 	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
 	list_del_init(&cmd->queue_entry);
 	se_cmd = cmd->se_cmd;
+	se_cmd->priv = NULL;
 	cmd->se_cmd = NULL;
 
 	pr_debug("Timing out inflight cmd %u on dev %s.\n",
-- 
2.12.3

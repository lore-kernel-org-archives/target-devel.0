From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 30 Jun 2020 10:47:05 +0000
Subject: [RFC PATCH 4/8] scsi: target: tcmu: Do not queue aborted commands
Message-Id: <20200630104709.23066-5-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

If tcmu receives an already aborted command, tcmu_queue_cmd()
should reject it.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_user.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c900e3dd25aa..be95518a31dd 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1103,8 +1103,8 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 	struct se_device *se_dev = se_cmd->se_dev;
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 	struct tcmu_cmd *tcmu_cmd;
-	sense_reason_t scsi_ret;
-	int ret;
+	sense_reason_t scsi_ret = TCM_CHECK_CONDITION_ABORT_CMD;
+	int ret = -1;
 
 	tcmu_cmd = tcmu_alloc_cmd(se_cmd);
 	if (!tcmu_cmd)
@@ -1112,7 +1112,8 @@ tcmu_queue_cmd(struct se_cmd *se_cmd)
 
 	mutex_lock(&udev->cmdr_lock);
 	se_cmd->priv = tcmu_cmd;
-	ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
+	if (!(se_cmd->transport_state & CMD_T_ABORTED))
+		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
 	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
 	mutex_unlock(&udev->cmdr_lock);
-- 
2.12.3

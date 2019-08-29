From: Sasha Levin <sashal@kernel.org>
Date: Thu, 29 Aug 2019 18:15:17 +0000
Subject: [PATCH AUTOSEL 4.19 17/45] scsi: target: tcmu: avoid use-after-free after command timeout
Message-Id: <20190829181547.8280-17-sashal@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190829181547.8280-1-sashal@kernel.org>
In-Reply-To: <20190829181547.8280-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Mike Christie <mchristi@redhat.com>, Damien Le Moal <damien.lemoal@wdc.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Dmitry Fomichev <dmitry.fomichev@wdc.com>

[ Upstream commit a86a75865ff4d8c05f355d1750a5250aec89ab15 ]

In tcmu_handle_completion() function, the variable called read_len is
always initialized with a value taken from se_cmd structure. If this
function is called to complete an expired (timed out) out command, the
session command pointed by se_cmd is likely to be already deallocated by
the target core at that moment. As the result, this access triggers a
use-after-free warning from KASAN.

This patch fixes the code not to touch se_cmd when completing timed out
TCMU commands. It also resets the pointer to se_cmd at the time when the
TCMU_CMD_BIT_EXPIRED flag is set because it is going to become invalid
after calling target_complete_cmd() later in the same function,
tcmu_check_expired_cmd().

Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Acked-by: Mike Christie <mchristi@redhat.com>
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c46efa47d68a5..7159e8363b83b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1143,14 +1143,16 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 	struct se_cmd *se_cmd = cmd->se_cmd;
 	struct tcmu_dev *udev = cmd->tcmu_dev;
 	bool read_len_valid = false;
-	uint32_t read_len = se_cmd->data_length;
+	uint32_t read_len;
 
 	/*
 	 * cmd has been completed already from timeout, just reclaim
 	 * data area space and free cmd
 	 */
-	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
+	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+		WARN_ON_ONCE(se_cmd);
 		goto out;
+	}
 
 	list_del_init(&cmd->queue_entry);
 
@@ -1163,6 +1165,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
 		goto done;
 	}
 
+	read_len = se_cmd->data_length;
 	if (se_cmd->data_direction = DMA_FROM_DEVICE &&
 	    (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) && entry->rsp.read_len) {
 		read_len_valid = true;
@@ -1318,6 +1321,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		 */
 		scsi_status = SAM_STAT_CHECK_CONDITION;
 		list_del_init(&cmd->queue_entry);
+		cmd->se_cmd = NULL;
 	} else {
 		list_del_init(&cmd->queue_entry);
 		idr_remove(&udev->commands, id);
@@ -2036,6 +2040,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 
 		idr_remove(&udev->commands, i);
 		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
+			WARN_ON(!cmd->se_cmd);
 			list_del_init(&cmd->queue_entry);
 			if (err_level = 1) {
 				/*
-- 
2.20.1

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Sat, 23 May 2020 10:11:29 +0000
Subject: [PATCH] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
Message-Id: <20200523101129.GB98132@mwanda>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

The pr_debug() dereferences "cmd" after we already freed it by calling
tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.

Fixes: 61fb24822166 ("scsi: target: tcmu: Userspace must not complete queued commands")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/target/target_core_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 904d8a8373f2..28fb9441de7a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1292,13 +1292,13 @@ static void tcmu_check_expired_queue_cmd(struct tcmu_cmd *cmd)
 	if (!time_after(jiffies, cmd->deadline))
 		return;
 
+	pr_debug("Timing out queued cmd %p on dev %s.\n",
+		  cmd, cmd->tcmu_dev->name);
+
 	list_del_init(&cmd->queue_entry);
 	se_cmd = cmd->se_cmd;
 	tcmu_free_cmd(cmd);
 
-	pr_debug("Timing out queued cmd %p on dev %s.\n",
-		  cmd, cmd->tcmu_dev->name);
-
 	target_complete_cmd(se_cmd, SAM_STAT_TASK_SET_FULL);
 }
 
-- 
2.26.2

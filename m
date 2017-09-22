From: Allen Pais <allen.lkml@gmail.com>
Date: Fri, 22 Sep 2017 10:20:53 +0000
Subject: [PATCH 4/5] iscsi-target: use setup_timer() helper.
Message-Id: <1506074934-15062-5-git-send-email-allen.lkml@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <1506074934-15062-1-git-send-email-allen.lkml@gmail.com>
In-Reply-To: <1506074934-15062-1-git-send-email-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, target-devel@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>

   Use setup_timer function instead of initializing timer with the
   function and data fields.

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/target/iscsi/iscsi_target_erl1.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
index fe9b7f1..858d9c6 100644
--- a/drivers/target/iscsi/iscsi_target_erl1.c
+++ b/drivers/target/iscsi/iscsi_target_erl1.c
@@ -1264,10 +1264,9 @@ void iscsit_start_dataout_timer(
 	pr_debug("Starting DataOUT timer for ITT: 0x%08x on"
 		" CID: %hu.\n", cmd->init_task_tag, conn->cid);
 
-	init_timer(&cmd->dataout_timer);
+	setup_timer(&cmd->dataout_timer, iscsit_handle_dataout_timeout,
+		    (unsigned long)cmd);
 	cmd->dataout_timer.expires = (get_jiffies_64() + na->dataout_timeout * HZ);
-	cmd->dataout_timer.data = (unsigned long)cmd;
-	cmd->dataout_timer.function = iscsit_handle_dataout_timeout;
 	cmd->dataout_timer_flags &= ~ISCSI_TF_STOP;
 	cmd->dataout_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&cmd->dataout_timer);
-- 
2.7.4


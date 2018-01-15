From: Mike Christie <mchristi@redhat.com>
Date: Mon, 15 Jan 2018 20:37:59 +0000
Subject: [PATCH 1/1] tcmu: fix cmd user after free
Message-Id: <1516048679-8704-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If we are failing the command due to a qfull timeout we are
also freeing the tcmu command, so we cannot access it later
to get the se_cmd.

Note: The clearing of cmd->se_cmd is not needed. We do not check
it later for something like determining if the command was failed
due to a timeout. As a result I am dropping it.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 60c8a87..49b76ee 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1146,6 +1146,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 		return 0;
 
 	is_running = list_empty(&cmd->cmdr_queue_entry);
+	se_cmd = cmd->se_cmd;
 
 	if (is_running) {
 		/*
@@ -1171,8 +1172,6 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 	pr_debug("Timing out cmd %u on dev %s that is %s.\n",
 		 id, udev->name, is_running ? "inflight" : "queued");
 
-	se_cmd = cmd->se_cmd;
-	cmd->se_cmd = NULL;
 	target_complete_cmd(se_cmd, scsi_status);
 	return 0;
 }
-- 
1.8.3.1


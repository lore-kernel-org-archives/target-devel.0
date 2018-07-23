From: Mike Christie <mchristi@redhat.com>
Date: Mon, 23 Jul 2018 19:07:43 +0000
Subject: [PATCH 1/9] target_core_user: fix double unlock
Message-Id: <1532372871-7128-2-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The caller of queue_cmd_ring grabs and releases the lock, so
the tcmu_setup_cmd_timer failure handling inside queue_cmd_ring
should not call mutex_unlock.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 847707a..fafe65f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1066,7 +1066,6 @@ static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 				   &udev->cmd_timer);
 	if (ret) {
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-		mutex_unlock(&udev->cmdr_lock);
 
 		*scsi_err = TCM_OUT_OF_RESOURCES;
 		return -1;
-- 
1.8.3.1


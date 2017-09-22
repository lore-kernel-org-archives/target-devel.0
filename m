From: Allen Pais <allen.lkml@gmail.com>
Date: Fri, 22 Sep 2017 10:20:54 +0000
Subject: [PATCH 5/5] iscsi-target: use setup_timer() helper.
Message-Id: <1506074934-15062-6-git-send-email-allen.lkml@gmail.com>
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
 drivers/target/iscsi/iscsi_target_util.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 1e36f83..97697a9 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -949,11 +949,10 @@ void iscsit_start_nopin_response_timer(struct iscsi_conn *conn)
 		return;
 	}
 
-	init_timer(&conn->nopin_response_timer);
+	setup_timer(&conn->nopin_response_timer,
+		    iscsit_handle_nopin_response_timeout, (unsigned long)conn);
 	conn->nopin_response_timer.expires  		(get_jiffies_64() + na->nopin_response_timeout * HZ);
-	conn->nopin_response_timer.data = (unsigned long)conn;
-	conn->nopin_response_timer.function = iscsit_handle_nopin_response_timeout;
 	conn->nopin_response_timer_flags &= ~ISCSI_TF_STOP;
 	conn->nopin_response_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&conn->nopin_response_timer);
-- 
2.7.4


From: Allen Pais <allen.lkml@gmail.com>
Date: Fri, 22 Sep 2017 10:20:51 +0000
Subject: [PATCH 2/5] iscsi-target: use setup_timer() helper.
Message-Id: <1506074934-15062-3-git-send-email-allen.lkml@gmail.com>
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
 drivers/target/iscsi/iscsi_target_login.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
index dc13afb..e608fd5 100644
--- a/drivers/target/iscsi/iscsi_target_login.c
+++ b/drivers/target/iscsi/iscsi_target_login.c
@@ -866,10 +866,9 @@ static void iscsi_start_login_thread_timer(struct iscsi_np *np)
 	 * point we do not have access to ISCSI_TPG_ATTRIB(tpg)->login_timeout
 	 */
 	spin_lock_bh(&np->np_thread_lock);
-	init_timer(&np->np_login_timer);
+	setup_timer(&np->np_login_timer, iscsi_handle_login_thread_timeout,
+		    (unsigned long)np);
 	np->np_login_timer.expires = (get_jiffies_64() + TA_LOGIN_TIMEOUT * HZ);
-	np->np_login_timer.data = (unsigned long)np;
-	np->np_login_timer.function = iscsi_handle_login_thread_timeout;
 	np->np_login_timer_flags &= ~ISCSI_TF_STOP;
 	np->np_login_timer_flags |= ISCSI_TF_RUNNING;
 	add_timer(&np->np_login_timer);
-- 
2.7.4


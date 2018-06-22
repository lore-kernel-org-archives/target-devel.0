From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:52:50 +0000
Subject: [PATCH 03/20] target: Move a list_del_init() statement
Message-Id: <20180622215307.8758-4-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch does not change any functionality but makes the next
patch easier to read.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_transport.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 89dd475d0a8f..5e8329c5ddd0 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2697,6 +2697,7 @@ static void target_release_cmd_kref(struct kref *kref)
 
 	if (se_sess) {
 		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
+		list_del_init(&se_cmd->se_cmd_list);
 
 		spin_lock(&se_cmd->t_state_lock);
 		fabric_stop = (se_cmd->transport_state & CMD_T_FABRIC_STOP) &&
@@ -2704,13 +2705,11 @@ static void target_release_cmd_kref(struct kref *kref)
 		spin_unlock(&se_cmd->t_state_lock);
 
 		if (se_cmd->cmd_wait_set || fabric_stop) {
-			list_del_init(&se_cmd->se_cmd_list);
 			spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 			target_free_cmd_mem(se_cmd);
 			complete(&se_cmd->cmd_wait_comp);
 			return;
 		}
-		list_del_init(&se_cmd->se_cmd_list);
 		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
 	}
 
-- 
2.17.1


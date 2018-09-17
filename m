From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:38 +0000
Subject: [PATCH 01/17] target/core: Fix spelling in two source code comments
Message-Id: <20180917213554.987-2-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_transport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 86c0156e6c88..2c0d8626d57d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2012,7 +2012,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 	 * Determine if frontend context caller is requesting the stopping of
 	 * this command for frontend exceptions.
 	 *
-	 * If the received CDB has aleady been aborted stop processing it here.
+	 * If the received CDB has already been aborted stop processing it here.
 	 */
 	spin_lock_irq(&cmd->t_state_lock);
 	if (__transport_check_aborted_status(cmd, 1)) {
@@ -2516,7 +2516,7 @@ transport_generic_new_cmd(struct se_cmd *cmd)
 	}
 
 	/*
-	 * Determine is the TCM fabric module has already allocated physical
+	 * Determine if the TCM fabric module has already allocated physical
 	 * memory, and is directly calling transport_generic_map_mem_to_cmd()
 	 * beforehand.
 	 */
-- 
2.18.0

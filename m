From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:44 +0000
Subject: [PATCH 07/17] target/core: Use system workqueues for TMF
Message-Id: <20180917213554.987-8-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

A quote from SAM-5: "The order in which task management requests
are processed is not specified by the SCSI architecture model.
The SCSI architecture model does not require in-order delivery of
such task management requests or processing by the task manager
in the order received. To guarantee the processing order of task
management requests referencing sent to a specific logical unit,
an application client should not have more than one such task
management request pending to that logical unit." This means that
it is safe to use the system workqueues instead of tmr_wq for
processing TMFs. An intended side effect of this patch is that it
enables concurrent processing of TMFs.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_device.c    | 16 ----------------
 drivers/target/target_core_transport.c |  2 +-
 include/target/target_core_base.h      |  1 -
 3 files changed, 1 insertion(+), 18 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 47b5ef153135..2340dab5ac2f 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -986,18 +986,6 @@ int target_configure_device(struct se_device *dev)
 	if (ret)
 		goto out_destroy_device;
 
-	/*
-	 * Startup the struct se_device processing thread
-	 */
-	dev->tmr_wq = alloc_workqueue("tmr-%s", WQ_MEM_RECLAIM | WQ_UNBOUND, 1,
-				      dev->transport->name);
-	if (!dev->tmr_wq) {
-		pr_err("Unable to create tmr workqueue for %s\n",
-			dev->transport->name);
-		ret = -ENOMEM;
-		goto out_free_alua;
-	}
-
 	/*
 	 * Setup work_queue for QUEUE_FULL
 	 */
@@ -1026,8 +1014,6 @@ int target_configure_device(struct se_device *dev)
 
 	return 0;
 
-out_free_alua:
-	core_alua_free_lu_gp_mem(dev);
 out_destroy_device:
 	dev->transport->destroy_device(dev);
 out_free_index:
@@ -1046,8 +1032,6 @@ void target_free_device(struct se_device *dev)
 	WARN_ON(!list_empty(&dev->dev_sep_list));
 
 	if (target_dev_configured(dev)) {
-		destroy_workqueue(dev->tmr_wq);
-
 		dev->transport->destroy_device(dev);
 
 		mutex_lock(&device_mutex);
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 54ccd8f56a57..ec3cb16b9e0e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3445,7 +3445,7 @@ int transport_generic_handle_tmr(
 	}
 
 	INIT_WORK(&cmd->work, target_tmr_work);
-	queue_work(cmd->se_dev->tmr_wq, &cmd->work);
+	schedule_work(&cmd->work);
 	return 0;
 }
 EXPORT_SYMBOL(transport_generic_handle_tmr);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2cfd3b4573b0..d084479fbe18 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -796,7 +796,6 @@ struct se_device {
 	struct t10_pr_registration *dev_pr_res_holder;
 	struct list_head	dev_sep_list;
 	struct list_head	dev_tmr_list;
-	struct workqueue_struct *tmr_wq;
 	struct work_struct	qf_work_queue;
 	struct list_head	delayed_cmd_list;
 	struct list_head	state_list;
-- 
2.18.0

From: Mike Christie <mchristi@redhat.com>
Date: Wed, 25 Oct 2017 16:47:26 +0000
Subject: [PATCH 16/20] tcmu: fix tcmu_irqcontrol and unmap race
Message-Id: <1508950050-10120-17-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If the unmap thread has passed the find_free_blocks call
but has not yet hit the prepare_to_wait we will miss
any tcmu_irqcontrol wake_up calls. This patch replaces
the our kthread use with a work_struct which will handle
this for us and allow use to remove the race checks for
the time out and queueing wake up calls.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 72 +++++++--------------------------------
 1 file changed, 12 insertions(+), 60 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5eb919a..4fe5249 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -32,7 +32,7 @@
 #include <linux/highmem.h>
 #include <linux/configfs.h>
 #include <linux/mutex.h>
-#include <linux/kthread.h>
+#include <linux/workqueue.h>
 #include <net/genetlink.h>
 #include <scsi/scsi_common.h>
 #include <scsi/scsi_proto.h>
@@ -179,9 +179,6 @@ struct tcmu_cmd {
 	unsigned long flags;
 };
 
-static struct task_struct *unmap_thread;
-static wait_queue_head_t unmap_wait;
-
 static DEFINE_SPINLOCK(timed_out_udevs_lock);
 static LIST_HEAD(timed_out_udevs);
 
@@ -203,6 +200,7 @@ static DEFINE_SPINLOCK(root_udev_waiter_lock);
 static LIST_HEAD(root_udev_waiter);
 
 static atomic_t global_db_count = ATOMIC_INIT(0);
+struct work_struct tcmu_unmap_work;
 
 static struct kmem_cache *tcmu_cmd_cache;
 
@@ -822,7 +820,7 @@ static int add_to_cmdr_queue(struct tcmu_cmd *tcmu_cmd)
 		pr_debug("adding %s to block waiter list\n", udev->name);
 
 		list_add_tail(&udev->waiter, &root_udev_waiter);
-		wake_up(&unmap_wait);
+		schedule_work(&tcmu_unmap_work);
 	}
 	spin_unlock(&root_udev_waiter_lock);
 	return 0;
@@ -1165,7 +1163,7 @@ static void tcmu_device_timedout(unsigned long data)
 		list_add_tail(&udev->timedout_entry, &timed_out_udevs);
 	spin_unlock(&timed_out_udevs_lock);
 
-	wake_up(&unmap_wait);
+	schedule_work(&tcmu_unmap_work);
 }
 
 static int tcmu_attach_hba(struct se_hba *hba, u32 host_id)
@@ -1284,7 +1282,7 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 	 * of it.
 	 */
 	if (!list_empty(&tcmu_dev->waiter)) {
-		wake_up(&unmap_wait);
+		schedule_work(&tcmu_unmap_work);
 	} else {
 		tcmu_handle_completions(tcmu_dev);
 		run_cmdr_queue(tcmu_dev);
@@ -2296,50 +2294,11 @@ static void check_timedout_devices(void)
 	spin_unlock_bh(&timed_out_udevs_lock);
 }
 
-static int unmap_thread_fn(void *data)
+static void tcmu_unmap_work_fn(struct work_struct *work)
 {
-	bool drained = true;
-	bool has_block_waiters;
-	bool has_timed_out_devs;
-
-	while (!kthread_should_stop()) {
-		DEFINE_WAIT(__wait);
-
-		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
-		/*
-		 * If we had space left, check if devs were added/readded
-		 * while the lock was dropped.
-		 */
-		spin_lock(&root_udev_waiter_lock);
-		has_block_waiters = true;
-		if (list_empty(&root_udev_waiter))
-			has_block_waiters = false;
-		spin_unlock(&root_udev_waiter_lock);
-
-		spin_lock_bh(&timed_out_udevs_lock);
-		has_timed_out_devs = true;
-		if (list_empty(&timed_out_udevs))
-			has_timed_out_devs = false;
-		spin_unlock_bh(&timed_out_udevs_lock);
-
-		/*
-		 * Handle race where new waiters were added and we still
-		 * had space (were at least able to drain the queue on
-		 * the previous run).
-		 */
-		if ((!drained || !has_block_waiters) && !has_timed_out_devs)
-			schedule();
-
-		finish_wait(&unmap_wait, &__wait);
-
-		check_timedout_devices();
-
-		find_free_blocks();
-
-		drained = run_cmdr_queues();
-	}
-
-	return 0;
+	check_timedout_devices();
+	find_free_blocks();
+	run_cmdr_queues();
 }
 
 static int __init tcmu_module_init(void)
@@ -2348,6 +2307,8 @@ static int __init tcmu_module_init(void)
 
 	BUILD_BUG_ON((sizeof(struct tcmu_cmd_entry) % TCMU_OP_ALIGN_SIZE) != 0);
 
+	INIT_WORK(&tcmu_unmap_work, tcmu_unmap_work_fn);
+
 	tcmu_cmd_cache = kmem_cache_create("tcmu_cmd_cache",
 				sizeof(struct tcmu_cmd),
 				__alignof__(struct tcmu_cmd),
@@ -2393,17 +2354,8 @@ static int __init tcmu_module_init(void)
 	if (ret)
 		goto out_attrs;
 
-	init_waitqueue_head(&unmap_wait);
-	unmap_thread = kthread_run(unmap_thread_fn, NULL, "tcmu_unmap");
-	if (IS_ERR(unmap_thread)) {
-		ret = PTR_ERR(unmap_thread);
-		goto out_unreg_transport;
-	}
-
 	return 0;
 
-out_unreg_transport:
-	target_backend_unregister(&tcmu_ops);
 out_attrs:
 	kfree(tcmu_attrs);
 out_unreg_genl:
@@ -2418,7 +2370,7 @@ static int __init tcmu_module_init(void)
 
 static void __exit tcmu_module_exit(void)
 {
-	kthread_stop(unmap_thread);
+	cancel_work_sync(&tcmu_unmap_work);
 	target_backend_unregister(&tcmu_ops);
 	kfree(tcmu_attrs);
 	genl_unregister_family(&tcmu_genl_family);
-- 
2.7.2


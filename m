From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Oct 2017 07:14:02 +0000
Subject: [PATCH 07/17] tcmu: fix dev root_udev_waiter_mutex errors
Message-Id: <1508310852-15366-8-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This fixes the following bugs:

1. You cannot sleep after calling prepare_to_wait, so you
cannot use a mutex.

2. If the unmap thread is running and we have not done
the prepare_to_wait when a wake_up(&unmap_wait)
is done, then we will miss the wake up. We need to check
if a waiter has been added after setting the process state
and before calling schedule.

Note: there is a similar race with tcmu_irqconrol. One of the
next patches will fix that code path.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 72 +++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 29 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 5ce0034..0c71572 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -197,17 +197,7 @@ static LIST_HEAD(timed_out_udevs);
 static DEFINE_MUTEX(root_udev_mutex);
 static LIST_HEAD(root_udev);
 
-/*
- * To avoid dead lock, the mutex locks order should always be:
- *
- * mutex_lock(&root_udev_waiter_mutex);
- * ...
- * mutex_lock(&tcmu_dev->cmdr_lock);
- * mutex_unlock(&tcmu_dev->cmdr_lock);
- * ...
- * mutex_unlock(&root_udev_waiter_mutex);
- */
-static DEFINE_MUTEX(root_udev_waiter_mutex);
+static DEFINE_SPINLOCK(root_udev_waiter_lock);
 /* The data blocks global pool waiter list */
 static LIST_HEAD(root_udev_waiter);
 
@@ -860,19 +850,19 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
 
 		pr_debug("sleeping for ring space\n");
-		mutex_unlock(&udev->cmdr_lock);
-
 		/*
 		 * Try to insert the current udev to waiter list and
 		 * then wake up the unmap thread
 		 */
 		if (is_waiting_blocks) {
-			mutex_lock(&root_udev_waiter_mutex);
-			list_add_tail(&udev->waiter, &root_udev_waiter);
-			mutex_unlock(&root_udev_waiter_mutex);
+			spin_lock(&root_udev_waiter_lock);
+			if (list_empty(&udev->waiter))
+				list_add_tail(&udev->waiter, &root_udev_waiter);
+			spin_unlock(&root_udev_waiter_lock);
 
 			wake_up(&unmap_wait);
 		}
+		mutex_unlock(&udev->cmdr_lock);
 
 		if (udev->cmd_time_out)
 			ret = schedule_timeout(
@@ -1170,6 +1160,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	mutex_init(&udev->cmdr_lock);
 
 	INIT_LIST_HEAD(&udev->timedout_entry);
+	INIT_LIST_HEAD(&udev->waiter);
 	idr_init(&udev->commands);
 
 	setup_timer(&udev->timeout, tcmu_device_timedout,
@@ -1694,12 +1685,10 @@ static void tcmu_destroy_device(struct se_device *dev)
 	list_del(&udev->node);
 	mutex_unlock(&root_udev_mutex);
 
-	mutex_lock(&root_udev_waiter_mutex);
-	mutex_lock(&udev->cmdr_lock);
-	if (is_in_waiter_list(udev))
+	spin_lock(&root_udev_waiter_lock);
+	if (!list_empty(&udev->waiter))
 		list_del(&udev->waiter);
-	mutex_unlock(&udev->cmdr_lock);
-	mutex_unlock(&root_udev_waiter_mutex);
+	spin_unlock(&root_udev_waiter_lock);
 
 	tcmu_netlink_event(udev, TCMU_CMD_REMOVED_DEVICE, 0, NULL);
 
@@ -2100,29 +2089,43 @@ static uint32_t find_free_blocks(void)
 
 static void run_cmdr_queues(uint32_t *free_blocks)
 {
-	struct tcmu_dev *udev, *tmp;
+	struct tcmu_dev *udev, *tmp_udev;
+	LIST_HEAD(devs);
 
 	/*
 	 * Try to wake up the udevs who are waiting
 	 * for the global data pool blocks.
 	 */
-	mutex_lock(&root_udev_waiter_mutex);
-	list_for_each_entry_safe(udev, tmp, &root_udev_waiter, waiter) {
+	spin_lock(&root_udev_waiter_lock);
+	list_splice_init(&root_udev_waiter, &devs);
+
+	list_for_each_entry_safe(udev, tmp_udev, &devs, waiter) {
+		list_del_init(&udev->waiter);
+		spin_unlock(&root_udev_waiter_lock);
+
 		mutex_lock(&udev->cmdr_lock);
 		if (udev->waiting_blocks < *free_blocks) {
+			spin_lock(&root_udev_waiter_lock);
+			if (list_empty(&udev->waiter))
+				list_add_tail(&udev->waiter, &root_udev_waiter);
+			spin_unlock(&root_udev_waiter_lock);
+
 			mutex_unlock(&udev->cmdr_lock);
-			break;
+			goto resplice;
 		}
 
 		*free_blocks -= udev->waiting_blocks;
 		udev->waiting_blocks = 0;
 		mutex_unlock(&udev->cmdr_lock);
 
-		list_del(&udev->waiter);
-
 		wake_up(&udev->wait_cmdr);
 	}
-	mutex_unlock(&root_udev_waiter_mutex);
+	spin_unlock(&root_udev_waiter_lock);
+
+resplice:
+	spin_lock(&root_udev_waiter_lock);
+	list_splice(&devs, &root_udev_waiter);
+	spin_unlock(&root_udev_waiter_lock);
 }
 
 static void check_timedout_devices(void)
@@ -2149,6 +2152,7 @@ static void check_timedout_devices(void)
 static int unmap_thread_fn(void *data)
 {
 	uint32_t free_blocks = 0;
+	bool has_block_waiters;
 	bool has_timed_out_devs;
 
 	while (!kthread_should_stop()) {
@@ -2156,13 +2160,23 @@ static int unmap_thread_fn(void *data)
 
 		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
 
+		/*
+		 * If we had space left, check if devs were added/readded
+		 * while the lock was dropped.
+		 */
+		spin_lock(&root_udev_waiter_lock);
+		has_block_waiters = true;
+		if (list_empty(&root_udev_waiter))
+			has_block_waiters = false;
+		spin_unlock(&root_udev_waiter_lock);
+
 		spin_lock_bh(&timed_out_udevs_lock);
 		has_timed_out_devs = true;
 		if (list_empty(&timed_out_udevs))
 			has_timed_out_devs = false;
 		spin_unlock_bh(&timed_out_udevs_lock);
 
-		if (!has_timed_out_devs)
+		if ((!free_blocks || !has_block_waiters) && !has_timed_out_devs)
 			schedule();
 
 		finish_wait(&unmap_wait, &__wait);
-- 
2.7.2


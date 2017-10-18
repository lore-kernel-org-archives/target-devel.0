From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Oct 2017 07:13:59 +0000
Subject: [PATCH 04/17] tcmu: move expired command completion to unmap thread
Message-Id: <1508310852-15366-5-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This moves the expired command completion handling to
the unmap thread, so the next patch can use a mutex
in tcmu_check_expired_cmd.

Notes:
tcmu_device_timedout's use of spin_lock_irq was not needed.
The commands_lock is used between thread context (tcmu_queue_cmd_ring
and tcmu_irqcontrol) and timer/bh context. In the timer/bh context
bhs are disabled, so you need to use the _bh lock calls from the
thread context callers.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 62 ++++++++++++++++++++++++++++++++-------
 1 file changed, 51 insertions(+), 11 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index c40a043..40a9cf6 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -145,6 +145,7 @@ struct tcmu_dev {
 
 	struct timer_list timeout;
 	unsigned int cmd_time_out;
+	struct list_head timedout_entry;
 
 	spinlock_t nl_cmd_lock;
 	struct tcmu_nl_cmd curr_nl_cmd;
@@ -180,6 +181,10 @@ struct tcmu_cmd {
 
 static struct task_struct *unmap_thread;
 static wait_queue_head_t unmap_wait;
+
+static DEFINE_SPINLOCK(timed_out_udevs_lock);
+static LIST_HEAD(timed_out_udevs);
+
 /*
  * To avoid dead lock, the mutex locks order should always be:
  *
@@ -1116,19 +1121,15 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 static void tcmu_device_timedout(unsigned long data)
 {
 	struct tcmu_dev *udev = (struct tcmu_dev *)data;
-	unsigned long flags;
 
-	spin_lock_irqsave(&udev->commands_lock, flags);
-	idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
-	spin_unlock_irqrestore(&udev->commands_lock, flags);
+	pr_debug("%s cmd timeout has expired\n", udev->name);
 
-	/* Try to wake up the ummap thread */
-	wake_up(&unmap_wait);
+	spin_lock(&timed_out_udevs_lock);
+	if (list_empty(&udev->timedout_entry))
+		list_add_tail(&udev->timedout_entry, &timed_out_udevs);
+	spin_unlock(&timed_out_udevs_lock);
 
-	/*
-	 * We don't need to wakeup threads on wait_cmdr since they have their
-	 * own timeout.
-	 */
+	wake_up(&unmap_wait);
 }
 
 static int tcmu_attach_hba(struct se_hba *hba, u32 host_id)
@@ -1172,6 +1173,7 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	init_waitqueue_head(&udev->wait_cmdr);
 	mutex_init(&udev->cmdr_lock);
 
+	INIT_LIST_HEAD(&udev->timedout_entry);
 	idr_init(&udev->commands);
 	spin_lock_init(&udev->commands_lock);
 
@@ -1396,6 +1398,11 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	vfree(udev->mb_addr);
 	udev->mb_addr = NULL;
 
+	spin_lock_bh(&timed_out_udevs_lock);
+	if (!list_empty(&udev->timedout_entry))
+		list_del(&udev->timedout_entry);
+	spin_unlock_bh(&timed_out_udevs_lock);
+
 	/* Upper layer should drain all requests before calling this */
 	spin_lock_irq(&udev->commands_lock);
 	idr_for_each_entry(&udev->commands, cmd, i) {
@@ -2047,23 +2054,56 @@ static struct target_backend_ops tcmu_ops = {
 	.tb_dev_attrib_attrs	= NULL,
 };
 
+static void check_timedout_devices(void)
+{
+	struct tcmu_dev *udev, *tmp_dev;
+	LIST_HEAD(devs);
+
+	spin_lock_bh(&timed_out_udevs_lock);
+	list_splice_init(&timed_out_udevs, &devs);
+
+	list_for_each_entry_safe(udev, tmp_dev, &devs, timedout_entry) {
+		list_del_init(&udev->timedout_entry);
+		spin_unlock_bh(&timed_out_udevs_lock);
+
+		spin_lock(&udev->commands_lock);
+		idr_for_each(&udev->commands, tcmu_check_expired_cmd, NULL);
+		spin_unlock(&udev->commands_lock);
+
+		spin_lock_bh(&timed_out_udevs_lock);
+	}
+	spin_unlock_bh(&timed_out_udevs_lock);
+}
+
 static int unmap_thread_fn(void *data)
 {
 	struct tcmu_dev *udev, *tmp;
 	loff_t off;
 	uint32_t start, end, block;
 	static uint32_t free_blocks;
+	bool has_timed_out_devs;
 
 	while (!kthread_should_stop()) {
 		DEFINE_WAIT(__wait);
 
 		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
-		schedule();
+
+		spin_lock_bh(&timed_out_udevs_lock);
+		has_timed_out_devs = true;
+		if (list_empty(&timed_out_udevs))
+			has_timed_out_devs = false;
+		spin_unlock_bh(&timed_out_udevs_lock);
+
+		if (!has_timed_out_devs)
+			schedule();
+
 		finish_wait(&unmap_wait, &__wait);
 
 		if (kthread_should_stop())
 			break;
 
+		check_timedout_devices();
+
 		mutex_lock(&root_udev_mutex);
 		list_for_each_entry(udev, &root_udev, node) {
 			mutex_lock(&udev->cmdr_lock);
-- 
2.7.2


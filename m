From: Mike Christie <mchristi@redhat.com>
Date: Wed, 25 Oct 2017 16:47:27 +0000
Subject: [PATCH 17/20] tcmu: run the unmap thread/wq if waiters.
Message-Id: <1508950050-10120-18-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If tcmu_dev 1 took exactly TCMU_GLOBAL_MAX_BLOCKS and then
tcmu_dev 2 tried to allocate blocks dev 2 would be put
on the waiter list. Later when dev 1's commands complete
tcmu_irqcontrol would see that dev 1 is not on the waiter list
and so it only runs the dev 1's queue. dev 2 could then be
starved.

This patch adds a check if we hit the global limit and have
waiters in tcmu_irqcontrol. In this case we will then put
the completing dev on the waiter list of needed and then
wake up the unmapping thread/wq.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 47 ++++++++++++++++++++++++++-------------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 4fe5249..1433838 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1271,23 +1271,41 @@ static bool run_cmdr_queue(struct tcmu_dev *udev)
 	return drained;
 }
 
+static bool tcmu_waiting_on_dev_blocks(struct tcmu_dev *udev)
+{
+	return list_empty(&udev->waiter) && !list_empty(&udev->cmdr_queue);
+}
+
 static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 {
-	struct tcmu_dev *tcmu_dev = container_of(info, struct tcmu_dev, uio_info);
+	struct tcmu_dev *udev = container_of(info, struct tcmu_dev, uio_info);
+	bool run_local = true;
 
-	mutex_lock(&tcmu_dev->cmdr_lock);
-	/*
-	 * If the current udev is also in waiter list, this will
-	 * make sure that the other waiters in list be fed ahead
-	 * of it.
-	 */
-	if (!list_empty(&tcmu_dev->waiter)) {
-		schedule_work(&tcmu_unmap_work);
-	} else {
-		tcmu_handle_completions(tcmu_dev);
-		run_cmdr_queue(tcmu_dev);
+	mutex_lock(&udev->cmdr_lock);
+
+	if (atomic_read(&global_db_count) = TCMU_GLOBAL_MAX_BLOCKS) {
+		spin_lock(&root_udev_waiter_lock);
+		if (!list_empty(&root_udev_waiter)) {
+			/*
+			 * If we only hit the per block limit then make sure
+			 * we are added to the global list so we get run
+			 * after the other waiters.
+			 */
+			if (tcmu_waiting_on_dev_blocks(udev))
+				list_add_tail(&udev->waiter, &root_udev_waiter);
+
+			run_local = false;
+			schedule_work(&tcmu_unmap_work);
+		}
+		spin_unlock(&root_udev_waiter_lock);
 	}
-	mutex_unlock(&tcmu_dev->cmdr_lock);
+
+	if (run_local) {
+		tcmu_handle_completions(udev);
+		run_cmdr_queue(udev);
+	}
+
+	mutex_unlock(&udev->cmdr_lock);
 
 	return 0;
 }
@@ -2186,8 +2204,7 @@ static uint32_t find_free_blocks(void)
 		/* Release the block pages */
 		tcmu_blocks_release(&udev->data_blocks, start, end);
 
-		if (list_empty(&udev->waiter) &&
-		    !list_empty(&udev->cmdr_queue)) {
+		if (tcmu_waiting_on_dev_blocks(udev)) {
 			/*
 			 * if we had to take pages from a dev that hit its
 			 * DATA_BLOCK_BITS limit put it on the waiter
-- 
2.7.2


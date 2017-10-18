From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Oct 2017 07:14:01 +0000
Subject: [PATCH 06/17] tcmu: split unmap_thread_fn
Message-Id: <1508310852-15366-7-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Separate unmap_thread_fn to make it easier to read.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 149 +++++++++++++++++++++-----------------
 1 file changed, 81 insertions(+), 68 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a222d15..5ce0034 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2047,6 +2047,84 @@ static struct target_backend_ops tcmu_ops = {
 	.tb_dev_attrib_attrs	= NULL,
 };
 
+static uint32_t find_free_blocks(void)
+{
+	struct tcmu_dev *udev;
+	loff_t off;
+	uint32_t start, end, block, free_blocks = 0;
+
+	mutex_lock(&root_udev_mutex);
+	list_for_each_entry(udev, &root_udev, node) {
+		mutex_lock(&udev->cmdr_lock);
+
+		/* Try to complete the finished commands first */
+		tcmu_handle_completions(udev);
+
+		/* Skip the udevs waiting the global pool or in idle */
+		if (is_in_waiter_list(udev) || !udev->dbi_thresh) {
+			mutex_unlock(&udev->cmdr_lock);
+			continue;
+		}
+
+		end = udev->dbi_max + 1;
+		block = find_last_bit(udev->data_bitmap, end);
+		if (block = udev->dbi_max) {
+			/*
+			 * The last bit is dbi_max, so there is
+			 * no need to shrink any blocks.
+			 */
+			mutex_unlock(&udev->cmdr_lock);
+			continue;
+		} else if (block = end) {
+			/* The current udev will goto idle state */
+			udev->dbi_thresh = start = 0;
+			udev->dbi_max = 0;
+		} else {
+			udev->dbi_thresh = start = block + 1;
+			udev->dbi_max = block;
+		}
+
+		/* Here will truncate the data area from off */
+		off = udev->data_off + start * DATA_BLOCK_SIZE;
+		unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
+
+		/* Release the block pages */
+		tcmu_blocks_release(&udev->data_blocks, start, end);
+		mutex_unlock(&udev->cmdr_lock);
+
+		free_blocks += end - start;
+	}
+	mutex_unlock(&root_udev_mutex);
+	return free_blocks;
+}
+
+static void run_cmdr_queues(uint32_t *free_blocks)
+{
+	struct tcmu_dev *udev, *tmp;
+
+	/*
+	 * Try to wake up the udevs who are waiting
+	 * for the global data pool blocks.
+	 */
+	mutex_lock(&root_udev_waiter_mutex);
+	list_for_each_entry_safe(udev, tmp, &root_udev_waiter, waiter) {
+		mutex_lock(&udev->cmdr_lock);
+		if (udev->waiting_blocks < *free_blocks) {
+			mutex_unlock(&udev->cmdr_lock);
+			break;
+		}
+
+		*free_blocks -= udev->waiting_blocks;
+		udev->waiting_blocks = 0;
+		mutex_unlock(&udev->cmdr_lock);
+
+		list_del(&udev->waiter);
+
+		wake_up(&udev->wait_cmdr);
+	}
+	mutex_unlock(&root_udev_waiter_mutex);
+}
+
 static void check_timedout_devices(void)
 {
 	struct tcmu_dev *udev, *tmp_dev;
@@ -2070,10 +2148,7 @@ static void check_timedout_devices(void)
 
 static int unmap_thread_fn(void *data)
 {
-	struct tcmu_dev *udev, *tmp;
-	loff_t off;
-	uint32_t start, end, block;
-	static uint32_t free_blocks;
+	uint32_t free_blocks = 0;
 	bool has_timed_out_devs;
 
 	while (!kthread_should_stop()) {
@@ -2097,70 +2172,8 @@ static int unmap_thread_fn(void *data)
 
 		check_timedout_devices();
 
-		mutex_lock(&root_udev_mutex);
-		list_for_each_entry(udev, &root_udev, node) {
-			mutex_lock(&udev->cmdr_lock);
-
-			/* Try to complete the finished commands first */
-			tcmu_handle_completions(udev);
-
-			/* Skip the udevs waiting the global pool or in idle */
-			if (is_in_waiter_list(udev) || !udev->dbi_thresh) {
-				mutex_unlock(&udev->cmdr_lock);
-				continue;
-			}
-
-			end = udev->dbi_max + 1;
-			block = find_last_bit(udev->data_bitmap, end);
-			if (block = udev->dbi_max) {
-				/*
-				 * The last bit is dbi_max, so there is
-				 * no need to shrink any blocks.
-				 */
-				mutex_unlock(&udev->cmdr_lock);
-				continue;
-			} else if (block = end) {
-				/* The current udev will goto idle state */
-				udev->dbi_thresh = start = 0;
-				udev->dbi_max = 0;
-			} else {
-				udev->dbi_thresh = start = block + 1;
-				udev->dbi_max = block;
-			}
-
-			/* Here will truncate the data area from off */
-			off = udev->data_off + start * DATA_BLOCK_SIZE;
-			unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
-
-			/* Release the block pages */
-			tcmu_blocks_release(&udev->data_blocks, start, end);
-			mutex_unlock(&udev->cmdr_lock);
-
-			free_blocks += end - start;
-		}
-		mutex_unlock(&root_udev_mutex);
-
-		/*
-		 * Try to wake up the udevs who are waiting
-		 * for the global data pool blocks.
-		 */
-		mutex_lock(&root_udev_waiter_mutex);
-		list_for_each_entry_safe(udev, tmp, &root_udev_waiter, waiter) {
-			mutex_lock(&udev->cmdr_lock);
-			if (udev->waiting_blocks < free_blocks) {
-				mutex_unlock(&udev->cmdr_lock);
-				break;
-			}
-
-			free_blocks -= udev->waiting_blocks;
-			udev->waiting_blocks = 0;
-			mutex_unlock(&udev->cmdr_lock);
-
-			list_del(&udev->waiter);
-
-			wake_up(&udev->wait_cmdr);
-		}
-		mutex_unlock(&root_udev_waiter_mutex);
+		free_blocks += find_free_blocks();
+		run_cmdr_queues(&free_blocks);
 	}
 
 	return 0;
-- 
2.7.2


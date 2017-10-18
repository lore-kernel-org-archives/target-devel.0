From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Oct 2017 07:13:58 +0000
Subject: [PATCH 03/17] tcmu: merge common block release code
Message-Id: <1508310852-15366-4-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Have unmap_thread_fn use tcmu_blocks_release.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 24 ++++++++----------------
 1 file changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 529d30f..c40a043 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1370,21 +1370,19 @@ static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
 	return -EINVAL;
 }
 
-static void tcmu_blocks_release(struct tcmu_dev *udev)
+static void tcmu_blocks_release(struct radix_tree_root *blocks,
+				int start, int end)
 {
 	int i;
 	struct page *page;
 
-	/* Try to release all block pages */
-	mutex_lock(&udev->cmdr_lock);
-	for (i = 0; i <= udev->dbi_max; i++) {
-		page = radix_tree_delete(&udev->data_blocks, i);
+	for (i = start; i < end; i++) {
+		page = radix_tree_delete(blocks, i);
 		if (page) {
 			__free_page(page);
 			atomic_dec(&global_db_count);
 		}
 	}
-	mutex_unlock(&udev->cmdr_lock);
 }
 
 static void tcmu_dev_kref_release(struct kref *kref)
@@ -1408,7 +1406,9 @@ static void tcmu_dev_kref_release(struct kref *kref)
 	spin_unlock_irq(&udev->commands_lock);
 	WARN_ON(!all_expired);
 
-	tcmu_blocks_release(udev);
+	mutex_lock(&udev->cmdr_lock);
+	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
+	mutex_unlock(&udev->cmdr_lock);
 
 	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
 }
@@ -2053,8 +2053,6 @@ static int unmap_thread_fn(void *data)
 	loff_t off;
 	uint32_t start, end, block;
 	static uint32_t free_blocks;
-	struct page *page;
-	int i;
 
 	while (!kthread_should_stop()) {
 		DEFINE_WAIT(__wait);
@@ -2102,13 +2100,7 @@ static int unmap_thread_fn(void *data)
 			unmap_mapping_range(udev->inode->i_mapping, off, 0, 1);
 
 			/* Release the block pages */
-			for (i = start; i < end; i++) {
-				page = radix_tree_delete(&udev->data_blocks, i);
-				if (page) {
-					__free_page(page);
-					atomic_dec(&global_db_count);
-				}
-			}
+			tcmu_blocks_release(&udev->data_blocks, start, end);
 			mutex_unlock(&udev->cmdr_lock);
 
 			free_blocks += end - start;
-- 
2.7.2


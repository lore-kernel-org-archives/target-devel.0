From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Oct 2017 07:14:05 +0000
Subject: [PATCH 10/17] tcmu: take blocks from devs waiting on blocks
Message-Id: <1508310852-15366-11-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

We could end up where all the devs with waiting_blocks
set hold all the blocks. find_free_blocks will always
fail. This just adds a force round where if the first
round fails, we then take pages from all devs.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index b5cdbeb..0bc8217 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2040,10 +2040,12 @@ static struct target_backend_ops tcmu_ops = {
 static uint32_t find_free_blocks(void)
 {
 	struct tcmu_dev *udev;
+	bool force = false;
 	loff_t off;
 	uint32_t start, end, block, free_blocks = 0;
 
 	mutex_lock(&root_udev_mutex);
+retry:
 	list_for_each_entry(udev, &root_udev, node) {
 		mutex_lock(&udev->cmdr_lock);
 
@@ -2051,7 +2053,7 @@ static uint32_t find_free_blocks(void)
 		tcmu_handle_completions(udev);
 
 		/* Skip the udevs waiting the global pool or in idle */
-		if (udev->waiting_blocks || !udev->dbi_thresh) {
+		if (!force && (udev->waiting_blocks || !udev->dbi_thresh)) {
 			mutex_unlock(&udev->cmdr_lock);
 			continue;
 		}
@@ -2080,10 +2082,35 @@ static uint32_t find_free_blocks(void)
 
 		/* Release the block pages */
 		tcmu_blocks_release(&udev->data_blocks, start, end);
+
+		if (list_empty(&udev->waiter)) {
+			/*
+			 * if we had to take pages from a dev that hit its
+			 * DATA_BLOCK_BITS limit put it on the waiter
+			 * list so it gets rescheduled when pages are free.
+			 */
+			spin_lock(&root_udev_waiter_lock);
+			list_add_tail(&udev->waiter, &root_udev_waiter);
+			spin_unlock(&root_udev_waiter_lock);
+		}
+
 		mutex_unlock(&udev->cmdr_lock);
 
+		pr_debug("Freed %u blocks from %s. Forced %d\n", end - start,
+			 udev->name, force);
+
 		free_blocks += end - start;
 	}
+
+	if (!force && !free_blocks) {
+		/*
+		 * if all pages were held by devs with waiting_blocks > 0
+		 * then we have to force the release to prevent deadlock.
+		 */
+		force = true;
+		goto retry;
+	}
+
 	mutex_unlock(&root_udev_mutex);
 	return free_blocks;
 }
-- 
2.7.2


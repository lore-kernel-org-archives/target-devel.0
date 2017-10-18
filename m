From: Mike Christie <mchristi@redhat.com>
Date: Wed, 18 Oct 2017 07:14:03 +0000
Subject: [PATCH 08/17] tcmu: drop is_in_waiter_list
Message-Id: <1508310852-15366-9-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

No need for the wrapper.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 0c71572..8a22d60 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -343,11 +343,6 @@ static struct genl_family tcmu_genl_family __ro_after_init = {
 #define tcmu_cmd_set_dbi(cmd, index) ((cmd)->dbi[(cmd)->dbi_cur++] = (index))
 #define tcmu_cmd_get_dbi(cmd) ((cmd)->dbi[(cmd)->dbi_cur++])
 
-static inline bool is_in_waiter_list(struct tcmu_dev *udev)
-{
-	return !!udev->waiting_blocks;
-}
-
 static void tcmu_cmd_free_data(struct tcmu_cmd *tcmu_cmd, uint32_t len)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
@@ -844,7 +839,6 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 
 	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
 		int ret;
-		bool is_waiting_blocks = is_in_waiter_list(udev);
 		DEFINE_WAIT(__wait);
 
 		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
@@ -854,7 +848,7 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 		 * Try to insert the current udev to waiter list and
 		 * then wake up the unmap thread
 		 */
-		if (is_waiting_blocks) {
+		if (udev->waiting_blocks) {
 			spin_lock(&root_udev_waiter_lock);
 			if (list_empty(&udev->waiter))
 				list_add_tail(&udev->waiter, &root_udev_waiter);
@@ -1184,7 +1178,7 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 	 * make sure that the other waiters in list be fed ahead
 	 * of it.
 	 */
-	if (is_in_waiter_list(tcmu_dev)) {
+	if (tcmu_dev->waiting_blocks) {
 		wake_up(&unmap_wait);
 	} else {
 		tcmu_handle_completions(tcmu_dev);
@@ -2050,7 +2044,7 @@ static uint32_t find_free_blocks(void)
 		tcmu_handle_completions(udev);
 
 		/* Skip the udevs waiting the global pool or in idle */
-		if (is_in_waiter_list(udev) || !udev->dbi_thresh) {
+		if (udev->waiting_blocks || !udev->dbi_thresh) {
 			mutex_unlock(&udev->cmdr_lock);
 			continue;
 		}
-- 
2.7.2


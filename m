From: xiubli@redhat.com
Date: Thu, 07 Jun 2018 06:31:36 +0000
Subject: [PATCH] tcmu: remove useless code and clean up the code style.
Message-Id: <1528353096-115725-1-git-send-email-xiubli@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Since the TCMU_RING_SIZE macro is not using here will discard it
and at the same time clean up the code style.

Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 drivers/target/target_core_user.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 4f26bdc..2c63936 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -79,14 +79,10 @@
 #define DATA_BLOCK_SIZE PAGE_SIZE
 #define DATA_BLOCK_SHIFT PAGE_SHIFT
 #define DATA_BLOCK_BITS_DEF (256 * 1024)
-#define DATA_SIZE (DATA_BLOCK_BITS * DATA_BLOCK_SIZE)
 
 #define TCMU_MBS_TO_BLOCKS(_mbs) (_mbs << (20 - DATA_BLOCK_SHIFT))
 #define TCMU_BLOCKS_TO_MBS(_blocks) (_blocks >> (20 - DATA_BLOCK_SHIFT))
 
-/* The total size of the ring is 8M + 256K * PAGE_SIZE */
-#define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
-
 /*
  * Default number of global data blocks(512K * PAGE_SIZE)
  * when the unmap thread will be started.
@@ -279,7 +275,7 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 	if (!info->attrs[TCMU_ATTR_CMD_STATUS] ||
 	    !info->attrs[TCMU_ATTR_DEVICE_ID]) {
 		printk(KERN_ERR "TCMU_ATTR_CMD_STATUS or TCMU_ATTR_DEVICE_ID not set, doing nothing\n");
-                return -EINVAL;
+		return -EINVAL;
         }
 
 	dev_id = nla_get_u32(info->attrs[TCMU_ATTR_DEVICE_ID]);
@@ -309,7 +305,7 @@ static int tcmu_genl_cmd_done(struct genl_info *info, int completed_cmd)
 
 	spin_unlock(&udev->nl_cmd_lock);
 	if (!is_removed)
-		 target_undepend_item(&dev->dev_group.cg_item);
+		target_undepend_item(&dev->dev_group.cg_item);
 	if (!ret)
 		complete(&nl_cmd->complete);
 	return ret;
-- 
1.8.3.1


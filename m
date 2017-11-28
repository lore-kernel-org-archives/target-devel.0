From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Nov 2017 18:40:38 +0000
Subject: [PATCH 12/15] tcmu: simplify dbi thresh handling
Message-Id: <1511894441-8626-13-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

We do not really save a lot by trying to increase thresh
a multiple of the existing value. This just simplifies the
code by increasing it to whatever is needed for the command
being executed.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 22 +++-------------------
 1 file changed, 3 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 68d1d72..2679e4d 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -79,7 +79,6 @@
 #define DATA_BLOCK_SIZE PAGE_SIZE
 #define DATA_BLOCK_BITS (256 * 1024)
 #define DATA_SIZE (DATA_BLOCK_BITS * DATA_BLOCK_SIZE)
-#define DATA_BLOCK_INIT_BITS 128
 
 /* The total size of the ring is 8M + 256K * PAGE_SIZE */
 #define TCMU_RING_SIZE (CMDR_SIZE + DATA_SIZE)
@@ -700,7 +699,6 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 	if ((space * DATA_BLOCK_SIZE) < data_needed) {
 		unsigned long blocks_left = DATA_BLOCK_BITS - udev->dbi_thresh +
 						space;
-		unsigned long grow;
 
 		if (blocks_left < blocks_needed) {
 			pr_debug("no data space: only %lu available, but ask for %zu\n",
@@ -709,23 +707,9 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 			return false;
 		}
 
-		/* Try to expand the thresh */
-		if (!udev->dbi_thresh) {
-			/* From idle state */
-			uint32_t init_thresh = DATA_BLOCK_INIT_BITS;
-
-			udev->dbi_thresh = max(blocks_needed, init_thresh);
-		} else {
-			/*
-			 * Grow the data area by max(blocks needed,
-			 * dbi_thresh / 2), but limited to the max
-			 * DATA_BLOCK_BITS size.
-			 */
-			grow = max(blocks_needed, udev->dbi_thresh / 2);
-			udev->dbi_thresh += grow;
-			if (udev->dbi_thresh > DATA_BLOCK_BITS)
-				udev->dbi_thresh = DATA_BLOCK_BITS;
-		}
+		udev->dbi_thresh += blocks_needed;
+		if (udev->dbi_thresh > DATA_BLOCK_BITS)
+			udev->dbi_thresh = DATA_BLOCK_BITS;
 	}
 
 	return tcmu_get_empty_blocks(udev, cmd);
-- 
1.8.3.1


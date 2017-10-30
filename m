From: Mike Christie <mchristi@redhat.com>
Date: Mon, 30 Oct 2017 03:44:32 +0000
Subject: [PATCH 12/19] tcmu: fix free block calculation
Message-Id: <1509335079-5276-13-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1509335079-5276-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: Mike Christie <mchristi@redhat.com>

The blocks_left calculation does not account for free blocks
between 0 and thresh, so we could be queueing/waiting when
there are enough blocks free.

This has us add in the blocks between 0 and thresh as well as
at the end from thresh to DATA_BLOCK_BITS.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 76f0e5a..b7eeb25 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -636,7 +636,7 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 
 static inline size_t spc_bitmap_free(unsigned long *bitmap, uint32_t thresh)
 {
-	return DATA_BLOCK_SIZE * (thresh - bitmap_weight(bitmap, thresh));
+	return thresh - bitmap_weight(bitmap, thresh);
 }
 
 /*
@@ -676,8 +676,9 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 
 	/* try to check and get the data blocks as needed */
 	space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
-	if (space < data_needed) {
-		unsigned long blocks_left = DATA_BLOCK_BITS - udev->dbi_thresh;
+	if ((space * DATA_BLOCK_SIZE) < data_needed) {
+		unsigned long blocks_left = DATA_BLOCK_BITS - udev->dbi_thresh +
+						space;
 		unsigned long grow;
 
 		if (blocks_left < blocks_needed) {
-- 
1.8.3.1


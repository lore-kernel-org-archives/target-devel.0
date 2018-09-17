From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:39 +0000
Subject: [PATCH 02/17] target/core: Use the SECTOR_SHIFT constant
Message-Id: <20180917213554.987-3-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of duplicating the SECTOR_SHIFT definition from <linux/blkdev.h>,
use it. This patch does not change any functionality.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_iblock.c | 4 ++--
 drivers/target/target_core_iblock.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index ce1321a5cb7b..1bc9b14236d8 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -514,7 +514,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		}
 
 		/* Always in 512 byte units for Linux/Block */
-		block_lba += sg->length >> IBLOCK_LBA_SHIFT;
+		block_lba += sg->length >> SECTOR_SHIFT;
 		sectors -= 1;
 	}
 
@@ -757,7 +757,7 @@ iblock_execute_rw(struct se_cmd *cmd, struct scatterlist *sgl, u32 sgl_nents,
 		}
 
 		/* Always in 512 byte units for Linux/Block */
-		block_lba += sg->length >> IBLOCK_LBA_SHIFT;
+		block_lba += sg->length >> SECTOR_SHIFT;
 		sg_num--;
 	}
 
diff --git a/drivers/target/target_core_iblock.h b/drivers/target/target_core_iblock.h
index 9cc3843404d4..cefc641145b3 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -9,7 +9,6 @@
 #define IBLOCK_VERSION		"4.0"
 
 #define IBLOCK_MAX_CDBS		16
-#define IBLOCK_LBA_SHIFT	9
 
 struct iblock_req {
 	refcount_t pending;
-- 
2.18.0

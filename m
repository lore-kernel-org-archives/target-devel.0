From: Sasha Levin <sashal@kernel.org>
Date: Tue, 03 Sep 2019 16:24:36 +0000
Subject: [PATCH AUTOSEL 4.19 124/167] scsi: target/core: Use the SECTOR_SHIFT constant
Message-Id: <20190903162519.7136-124-sashal@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>, Nicholas Bellinger <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 80b045b385cfef10939c913fbfeb19ce5491c1f2 ]

Instead of duplicating the SECTOR_SHIFT definition from <linux/blkdev.h>,
use it. This patch does not change any functionality.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_iblock.c | 4 ++--
 drivers/target/target_core_iblock.h | 1 -
 2 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index ce1321a5cb7bf..1bc9b14236d8b 100644
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
index 9cc3843404d44..cefc641145b3b 100644
--- a/drivers/target/target_core_iblock.h
+++ b/drivers/target/target_core_iblock.h
@@ -9,7 +9,6 @@
 #define IBLOCK_VERSION		"4.0"
 
 #define IBLOCK_MAX_CDBS		16
-#define IBLOCK_LBA_SHIFT	9
 
 struct iblock_req {
 	refcount_t pending;
-- 
2.20.1

From: Israel Rukshin <israelr@mellanox.com>
Date: Wed, 11 Dec 2019 15:36:02 +0000
Subject: [PATCH] scsi: target/iblock: Fix protection error with sectors greater than 512B
Message-Id: <1576078562-15240-1-git-send-email-israelr@mellanox.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Target-devel <target-devel@vger.kernel.org>, Linux-scsi <linux-scsi@vger.kernel.org>
Cc: Israel Rukshin <israelr@mellanox.com>, Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

The sector size of the block layer is 512 bytes, but integrity interval
size might be different (in case of 4K block size of the media). At the
initiator side the virtual start sector is the one that was originally
submitted by the block layer (512 bytes) for the Reftag usage. The
initiator converts the Reftag to integrity interval units and sends it to
the target. So the target virtual start sector should be calculated at
integrity interval units. prepare_fn() and complete_fn() don't remap
correctly the Reftag when using incorrect units of the virtual start
sector, which leads to the following protection error at the device:

"blk_update_request: protection error, dev sdb, sector 2048 op 0x0:(READ)
flags 0x10000 phys_seg 1 prio class 0"

To fix that, set the seed in integrity interval units.

Signed-off-by: Israel Rukshin <israelr@mellanox.com>
Reviewed-by: Max Gurtovoy <maxg@mellanox.com>
---
 drivers/target/target_core_iblock.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 6949ea8..51ffd5c 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -646,7 +646,9 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 	}
 
 	bip->bip_iter.bi_size = bio_integrity_bytes(bi, bio_sectors(bio));
-	bip_set_seed(bip, bio->bi_iter.bi_sector);
+	/* virtual start sector must be in integrity interval units */
+	bip_set_seed(bip, bio->bi_iter.bi_sector >>
+				  (bi->interval_exp - SECTOR_SHIFT));
 
 	pr_debug("IBLOCK BIP Size: %u Sector: %llu\n", bip->bip_iter.bi_size,
 		 (unsigned long long)bip->bip_iter.bi_sector);
-- 
1.8.3.1

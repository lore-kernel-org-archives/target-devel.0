From: Christopher Unkel <cunkel@drivescale.com>
Date: Tue, 20 Oct 2020 22:44:55 +0000
Subject: [PATCH] scsi: target/iblock: compute lbppbe relative to advertised pb size
Message-Id: <20201020224455.10949-1-cunkel@drivescale.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch fixes a bug where adjusting the offered (logical) block size
of a target incorrectly increases the advertised phyiscal block size by
the same factor.  For example, if the underlying device has 512 byte
logical block size and 4k physical block size, setting block_size in
configfs to 4096 results in the initiator seeing a device with 4k
physical block size and 32k logical block size, instead of 4k for both.

---
The physical block size is passed to the client as a shift relative to
the logical block size.  The iblock target was computing this relative
to the underlying hardware block size, while the client can only
interpret it relative to the advertised logical block size.  If the
block_size attribute is set to be different than the default value of
hw_block_size, the advertised physical block size is wrong.

Instead compute lbppbe relative to the block_size attribute.

Signed-off-by: Christopher Unkel <cunkel@drivescale.com>
---
 drivers/target/target_core_iblock.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index f2bd2e207e0b..6940d2acc609 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -815,8 +815,16 @@ static unsigned int iblock_get_lbppbe(struct se_device *dev)
 {
 	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
 	struct block_device *bd = ib_dev->ibd_bd;
-	int logs_per_phys = bdev_physical_block_size(bd) / bdev_logical_block_size(bd);
+	unsigned int pbsz = bdev_physical_block_size(bd);
 
+	/* compute relative to advertised block size as that is how
+	 * the other end will interpret it
+	 */
+	unsigned int lbsz = dev->dev_attrib.block_size;
+	int logs_per_phys = pbsz / lbsz;
+
+	if (!logs_per_phys)
+		return 0;
 	return ilog2(logs_per_phys);
 }
 
-- 
2.17.1

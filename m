From: Christoph Hellwig <hch@lst.de>
Date: Thu, 03 Sep 2020 05:41:02 +0000
Subject: [PATCH 7/9] target/iblock: fix holder printing in iblock_show_configfs_dev_params
Message-Id: <20200903054104.228829-8-hch@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200903054104.228829-1-hch@lst.de>
In-Reply-To: <20200903054104.228829-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

bd_contains is never NULL for an open block device.  In addition ibd_bd
is always set to a block device that was exclusively opened by the
target code, so the holder is guranteed to be ib_dev as well.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_iblock.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 1c181d31f4c872..f2bd2e207e0b36 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -611,9 +611,8 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
 	bl += sprintf(b + bl, "        ");
 	if (bd) {
 		bl += sprintf(b + bl, "Major: %d Minor: %d  %s\n",
-			MAJOR(bd->bd_dev), MINOR(bd->bd_dev), (!bd->bd_contains) ?
-			"" : (bd->bd_holder = ib_dev) ?
-			"CLAIMED: IBLOCK" : "CLAIMED: OS");
+			MAJOR(bd->bd_dev), MINOR(bd->bd_dev),
+			"CLAIMED: IBLOCK");
 	} else {
 		bl += sprintf(b + bl, "Major: 0 Minor: 0\n");
 	}
-- 
2.28.0

From: Christoph Hellwig <hch@lst.de>
Date: Thu, 03 Sep 2020 05:41:04 +0000
Subject: [PATCH 9/9] vsprintf: use bd_partno in bdev_name
Message-Id: <20200903054104.228829-10-hch@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200903054104.228829-1-hch@lst.de>
In-Reply-To: <20200903054104.228829-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

No need to go through the hd_struct to find the partition number.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 lib/vsprintf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/vsprintf.c b/lib/vsprintf.c
index afb9521ddf9197..14c9a6af1b239a 100644
--- a/lib/vsprintf.c
+++ b/lib/vsprintf.c
@@ -940,13 +940,13 @@ char *bdev_name(char *buf, char *end, struct block_device *bdev,
 
 	hd = bdev->bd_disk;
 	buf = string(buf, end, hd->disk_name, spec);
-	if (bdev->bd_part->partno) {
+	if (bdev->bd_partno) {
 		if (isdigit(hd->disk_name[strlen(hd->disk_name)-1])) {
 			if (buf < end)
 				*buf = 'p';
 			buf++;
 		}
-		buf = number(buf, end, bdev->bd_part->partno, spec);
+		buf = number(buf, end, bdev->bd_partno, spec);
 	}
 	return buf;
 }
-- 
2.28.0

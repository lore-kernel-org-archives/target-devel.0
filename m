From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Thu, 18 Jun 2020 13:16:31 +0000
Subject: [PATCH 1/2 v2] scsi: target: tcmu: Optimize use of flush_dcache_page
Message-Id: <20200618131632.32748-2-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>, Bodo Stroesser <bstroesser@ts.fujitsu.com>

(scatter|gather)_data_area() need to flush dcache after
writing data to or before reading data from a page in
uio data area.
The two routines are able to handle data transfer to/from
such a page in fragments and flush the cache after each
fragment was copied by calling the wrapper
tcmu_flush_dcache_range().

That means:
1) flush_dcache_page() can be called multiple times for
   the same page.
2) Calling flush_dcache_page() indirectly using the
   wrapper does not make sense, because each call of the
   wrapper is for one single page only and the calling
   routine already has the correct page pointer.

Therefore I changed (scatter|gather)_data_area() such,
that instead of calling tcmu_flush_dcache_range()
before/after each memcpy, it now calls flush_dcache_page()
before unmapping a page (when writing is complete for
that page) or after mapping a page (when starting to read
the page).

After this change only calls to tcmu_flush_dcache_range()
for addresses in vmalloc'ed command ring are left over.
This is a good preparation for the second patch of the series.

The patch was tested on ARM with kernel 4.19.118 and 5.7.2

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Tested-by: JiangYu <lnsyyj@hotmail.com>
Tested-by: Daniel Meyerholt <dxm523@gmail.com>
---
 drivers/target/target_core_user.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 560bfec933bc..a65e9671ae7a 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -676,8 +676,10 @@ static void scatter_data_area(struct tcmu_dev *udev,
 		from = kmap_atomic(sg_page(sg)) + sg->offset;
 		while (sg_remaining > 0) {
 			if (block_remaining = 0) {
-				if (to)
+				if (to) {
+					flush_dcache_page(page);
 					kunmap_atomic(to);
+				}
 
 				block_remaining = DATA_BLOCK_SIZE;
 				dbi = tcmu_cmd_get_dbi(tcmu_cmd);
@@ -722,7 +724,6 @@ static void scatter_data_area(struct tcmu_dev *udev,
 				memcpy(to + offset,
 				       from + sg->length - sg_remaining,
 				       copy_bytes);
-				tcmu_flush_dcache_range(to, copy_bytes);
 			}
 
 			sg_remaining -= copy_bytes;
@@ -731,8 +732,10 @@ static void scatter_data_area(struct tcmu_dev *udev,
 		kunmap_atomic(from - sg->offset);
 	}
 
-	if (to)
+	if (to) {
+		flush_dcache_page(page);
 		kunmap_atomic(to);
+	}
 }
 
 static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
@@ -778,13 +781,13 @@ static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
 				dbi = tcmu_cmd_get_dbi(cmd);
 				page = tcmu_get_block_page(udev, dbi);
 				from = kmap_atomic(page);
+				flush_dcache_page(page);
 			}
 			copy_bytes = min_t(size_t, sg_remaining,
 					block_remaining);
 			if (read_len < copy_bytes)
 				copy_bytes = read_len;
 			offset = DATA_BLOCK_SIZE - block_remaining;
-			tcmu_flush_dcache_range(from, copy_bytes);
 			memcpy(to + sg->length - sg_remaining, from + offset,
 					copy_bytes);
 
-- 
2.12.3

From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 01 Jul 2019 17:12:28 +0000
Subject: [PATCH] scsi: target/iblock: Fix overrun in WRITE SAME emulation
Message-Id: <20190701171226.81654-1-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

WRITE SAME corrupts data on the block device behind iblock if the
command is emulated. The emulation code issues (M - 1) * N times more
bios than requested, where M is the number of 512 blocks per real block
size and N is the NUMBER OF LOGICAL BLOCKS specified in WRITE SAME
command. So, for a device with 4k blocks, 7 * N more LBAs gets written
after the requested range.

The issue happens because the number of 512 byte sectors to be written
is decreased one by one while the real bios are typically from 1 to 8
512 byte sectors per bio.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index f4a075303e9a..6949ea8bc387 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -502,7 +502,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 
 		/* Always in 512 byte units for Linux/Block */
 		block_lba += sg->length >> SECTOR_SHIFT;
-		sectors -= 1;
+		sectors -= sg->length >> SECTOR_SHIFT;
 	}
 
 	iblock_submit_bios(&list);
-- 
2.22.0

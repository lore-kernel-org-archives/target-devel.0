From: Sasha Levin <sashal@kernel.org>
Date: Thu, 07 May 2020 14:28:02 +0000
Subject: [PATCH AUTOSEL 5.4 08/35] scsi: target/iblock: fix WRITE SAME zeroing
Message-Id: <20200507142830.26239-8-sashal@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200507142830.26239-1-sashal@kernel.org>
In-Reply-To: <20200507142830.26239-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: David Disseldorp <ddiss@suse.de>, Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: David Disseldorp <ddiss@suse.de>

[ Upstream commit 1d2ff149b263c9325875726a7804a0c75ef7112e ]

SBC4 specifies that WRITE SAME requests with the UNMAP bit set to zero
"shall perform the specified write operation to each LBA specified by the
command".  Commit 2237498f0b5c ("target/iblock: Convert WRITE_SAME to
blkdev_issue_zeroout") modified the iblock backend to call
blkdev_issue_zeroout() when handling WRITE SAME requests with UNMAP=0 and a
zero data segment.

The iblock blkdev_issue_zeroout() call incorrectly provides a flags
parameter of 0 (bool false), instead of BLKDEV_ZERO_NOUNMAP.  The bool
false parameter reflects the blkdev_issue_zeroout() API prior to commit
ee472d835c26 ("block: add a flags argument to (__)blkdev_issue_zeroout")
which was merged shortly before 2237498f0b5c.

Link: https://lore.kernel.org/r/20200419163109.11689-1-ddiss@suse.de
Fixes: 2237498f0b5c ("target/iblock: Convert WRITE_SAME to blkdev_issue_zeroout")
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: David Disseldorp <ddiss@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_iblock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 51ffd5c002dee..1c181d31f4c87 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -432,7 +432,7 @@ iblock_execute_zero_out(struct block_device *bdev, struct se_cmd *cmd)
 				target_to_linux_sector(dev, cmd->t_task_lba),
 				target_to_linux_sector(dev,
 					sbc_get_write_same_sectors(cmd)),
-				GFP_KERNEL, false);
+				GFP_KERNEL, BLKDEV_ZERO_NOUNMAP);
 	if (ret)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-- 
2.20.1

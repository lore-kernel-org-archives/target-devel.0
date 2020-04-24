From: Sasha Levin <sashal@kernel.org>
Date: Fri, 24 Apr 2020 12:23:45 +0000
Subject: [PATCH AUTOSEL 4.19 08/18] scsi: target: tcmu: reset_ring should reset TCMU_DEV_BIT_BROKEN
Message-Id: <20200424122355.10453-8-sashal@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200424122355.10453-1-sashal@kernel.org>
In-Reply-To: <20200424122355.10453-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>, Mike Christie <mchristi@redhat.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

[ Upstream commit 066f79a5fd6d1b9a5cc57b5cd445b3e4bb68a5b2 ]

In case command ring buffer becomes inconsistent, tcmu sets device flag
TCMU_DEV_BIT_BROKEN.  If the bit is set, tcmu rejects new commands from LIO
core with TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE, and no longer processes
completions from the ring.  The reset_ring attribute can be used to
completely clean up the command ring, so after reset_ring the ring no
longer is inconsistent.

Therefore reset_ring also should reset bit TCMU_DEV_BIT_BROKEN to allow
normal processing.

Link: https://lore.kernel.org/r/20200409101026.17872-1-bstroesser@ts.fujitsu.com
Acked-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7ee0a75ce4526..eff1e36ca03c2 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -2067,6 +2067,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
 	mb->cmd_tail = 0;
 	mb->cmd_head = 0;
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
+	clear_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
 
 	del_timer(&udev->cmd_timer);
 
-- 
2.20.1

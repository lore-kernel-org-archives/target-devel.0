From: Sasha Levin <sashal@kernel.org>
Date: Fri, 22 Nov 2019 05:24:59 +0000
Subject: [PATCH AUTOSEL 4.19 001/219] scsi: target/tcmu: Fix queue_cmd_ring() declaration
Message-Id: <20191122052837.357-1-sashal@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191122051903.31749-1-sashal@kernel.org>
In-Reply-To: <20191122051903.31749-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>, David Disseldorp <ddiss@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>, Mike Christie <mchristi@redhat.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit e7f411049f5164ee6db6c3434c07302846f09990 ]

This patch does not change any functionality but avoids that sparse
complains about the queue_cmd_ring() function and its callers.

Fixes: 6fd0ce79724d ("tcmu: prep queue_cmd_ring to be used by unmap wq")
Reviewed-by: David Disseldorp <ddiss@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 7159e8363b83b..7ee0a75ce4526 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -962,7 +962,7 @@ static int add_to_qfull_queue(struct tcmu_cmd *tcmu_cmd)
  *  0 success
  *  1 internally queued to wait for ring memory to free.
  */
-static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
+static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
-- 
2.20.1

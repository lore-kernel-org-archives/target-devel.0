From: Mike Christie <mchristi@redhat.com>
Date: Wed, 25 Oct 2017 16:47:28 +0000
Subject: [PATCH 18/20] tcmu: simplify scatter_data_area error handling
Message-Id: <1508950050-10120-19-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

scatter_data_area always returns 0, so stop checking
for errors.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 1433838..2220cd0 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -533,7 +533,7 @@ static inline size_t iov_tail(struct iovec *iov)
 	return (size_t)iov->iov_base + iov->iov_len;
 }
 
-static int scatter_data_area(struct tcmu_dev *udev,
+static void scatter_data_area(struct tcmu_dev *udev,
 	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
 	unsigned int data_nents, struct iovec **iov,
 	int *iov_cnt, bool copy_data)
@@ -607,8 +607,6 @@ static int scatter_data_area(struct tcmu_dev *udev,
 
 	if (to)
 		kunmap_atomic(to);
-
-	return 0;
 }
 
 static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
@@ -925,33 +923,18 @@ static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction = DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
-	ret = scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
-				se_cmd->t_data_nents, &iov, &iov_cnt,
-				copy_to_data_area);
-	if (ret) {
-		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-
-		pr_err("tcmu: alloc and scatter data failed\n");
-		*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		return -1;
-	}
+	scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
+			  se_cmd->t_data_nents, &iov, &iov_cnt,
+			  copy_to_data_area);
 	entry->req.iov_cnt = iov_cnt;
 
 	/* Handle BIDI commands */
 	iov_cnt = 0;
 	if (se_cmd->se_cmd_flags & SCF_BIDI) {
 		iov++;
-		ret = scatter_data_area(udev, tcmu_cmd,
-					se_cmd->t_bidi_data_sg,
-					se_cmd->t_bidi_data_nents,
-					&iov, &iov_cnt, false);
-		if (ret) {
-			tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-
-			pr_err("tcmu: alloc and scatter bidi data failed\n");
-			*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-			return -1;
-		}
+		scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
+				  se_cmd->t_bidi_data_nents, &iov, &iov_cnt,
+				  false);
 	}
 	entry->req.iov_bidi_cnt = iov_cnt;
 
-- 
2.7.2


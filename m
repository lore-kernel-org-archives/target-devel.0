From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Nov 2017 18:40:34 +0000
Subject: [PATCH 08/15] tcmu: simplify scatter_data_area error handling
Message-Id: <1511894441-8626-9-git-send-email-mchristi@redhat.com>
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
index c7541f0..965f462 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -520,7 +520,7 @@ static inline size_t iov_tail(struct iovec *iov)
 	return (size_t)iov->iov_base + iov->iov_len;
 }
 
-static int scatter_data_area(struct tcmu_dev *udev,
+static void scatter_data_area(struct tcmu_dev *udev,
 	struct tcmu_cmd *tcmu_cmd, struct scatterlist *data_sg,
 	unsigned int data_nents, struct iovec **iov,
 	int *iov_cnt, bool copy_data)
@@ -573,8 +573,6 @@ static int scatter_data_area(struct tcmu_dev *udev,
 	}
 	if (to)
 		kunmap_atomic(to);
-
-	return 0;
 }
 
 static void gather_data_area(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
@@ -864,33 +862,18 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	iov_cnt = 0;
 	copy_to_data_area = (se_cmd->data_direction = DMA_TO_DEVICE
 		|| se_cmd->se_cmd_flags & SCF_BIDI);
-	ret = scatter_data_area(udev, tcmu_cmd, se_cmd->t_data_sg,
-				se_cmd->t_data_nents, &iov, &iov_cnt,
-				copy_to_data_area);
-	if (ret) {
-		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-		mutex_unlock(&udev->cmdr_lock);
-
-		pr_err("tcmu: alloc and scatter data failed\n");
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
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
-			mutex_unlock(&udev->cmdr_lock);
-
-			pr_err("tcmu: alloc and scatter bidi data failed\n");
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		}
+		scatter_data_area(udev, tcmu_cmd, se_cmd->t_bidi_data_sg,
+				  se_cmd->t_bidi_data_nents, &iov, &iov_cnt,
+				  false);
 	}
 	entry->req.iov_bidi_cnt = iov_cnt;
 
-- 
1.8.3.1


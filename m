From: Varun Prakash <varun@chelsio.com>
Date: Sat, 11 Aug 2018 15:52:29 +0000
Subject: [PATCH] scsi: target: iscsi: cxgbit: use pr_debug() instead of pr_info()
Message-Id: <1534002029-9281-1-git-send-email-varun@chelsio.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

DDP programming happens in data path and it can fail because
of lack of resources so use pr_debug() instead of pr_info()
for this case.

Signed-off-by: Varun Prakash <varun@chelsio.com>
---
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
index 768cce0..76a2626 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_ddp.c
@@ -207,8 +207,8 @@ cxgbit_ddp_reserve(struct cxgbit_sock *csk, struct cxgbi_task_tag_info *ttinfo,
 	ret = dma_map_sg(&ppm->pdev->dev, sgl, sgcnt, DMA_FROM_DEVICE);
 	sgl->offset = sg_offset;
 	if (!ret) {
-		pr_info("%s: 0x%x, xfer %u, sgl %u dma mapping err.\n",
-			__func__, 0, xferlen, sgcnt);
+		pr_debug("%s: 0x%x, xfer %u, sgl %u dma mapping err.\n",
+			 __func__, 0, xferlen, sgcnt);
 		goto rel_ppods;
 	}
 
@@ -250,8 +250,8 @@ cxgbit_get_r2t_ttt(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
 
 	ret = cxgbit_ddp_reserve(csk, ttinfo, cmd->se_cmd.data_length);
 	if (ret < 0) {
-		pr_info("csk 0x%p, cmd 0x%p, xfer len %u, sgcnt %u no ddp.\n",
-			csk, cmd, cmd->se_cmd.data_length, ttinfo->nents);
+		pr_debug("csk 0x%p, cmd 0x%p, xfer len %u, sgcnt %u no ddp.\n",
+			 csk, cmd, cmd->se_cmd.data_length, ttinfo->nents);
 
 		ttinfo->sgl = NULL;
 		ttinfo->nents = 0;
-- 
2.0.2

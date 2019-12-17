From: Aditya Pakki <pakki001@umn.edu>
Date: Tue, 17 Dec 2019 21:22:13 +0000
Subject: [PATCH] scsi: libfc: remove unnecessary assertion on ep variable
Message-Id: <20191217212214.30722-1-pakki001@umn.edu>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: pakki001@umn.edu
Cc: kjlu@umn.edu, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ira Weiny <ira.weiny@intel.com>, Allison Randal <allison@lohutok.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

In ft_recv_write_data(), the pointer ep is dereferenced first and
then asserts for NULL. The patch removes the unnecessary assertion.

Signed-off-by: Aditya Pakki <pakki001@umn.edu>
---
 drivers/target/tcm_fc/tfc_io.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
index 1354a157e9af..6a38ff936389 100644
--- a/drivers/target/tcm_fc/tfc_io.c
+++ b/drivers/target/tcm_fc/tfc_io.c
@@ -221,7 +221,6 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
 	ep = fc_seq_exch(seq);
 	lport = ep->lp;
 	if (cmd->was_ddp_setup) {
-		BUG_ON(!ep);
 		BUG_ON(!lport);
 		/*
 		 * Since DDP (Large Rx offload) was setup for this request,
-- 
2.20.1

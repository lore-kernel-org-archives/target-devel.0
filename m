From: Allen Pais <allen.cryptic@gmail.com>
Date: Mon, 17 Aug 2020 08:54:38 +0000
Subject: [PATCH 1/8] scsi: aic94xx: convert tasklets to use new tasklet_setup() API
Message-Id: <20200817085409.25268-2-allen.cryptic@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200817085409.25268-1-allen.cryptic@gmail.com>
In-Reply-To: <20200817085409.25268-1-allen.cryptic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jejb@linux.ibm.com, martin.petersen@oracle.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com
Cc: keescook@chromium.org, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Allen Pais <allen.lkml@gmail.com>, Romain Perier <romain.perier@gmail.com>

From: Allen Pais <allen.lkml@gmail.com>

In preparation for unconditionally passing the
struct tasklet_struct pointer to all tasklet
callbacks, switch to using the new tasklet_setup()
and from_tasklet() to pass the tasklet pointer explicitly.

Signed-off-by: Romain Perier <romain.perier@gmail.com>
Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/scsi/aic94xx/aic94xx_hwi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_hwi.c b/drivers/scsi/aic94xx/aic94xx_hwi.c
index 9256ab7b2522..1e4d32246cb9 100644
--- a/drivers/scsi/aic94xx/aic94xx_hwi.c
+++ b/drivers/scsi/aic94xx/aic94xx_hwi.c
@@ -248,7 +248,7 @@ static void asd_get_max_scb_ddb(struct asd_ha_struct *asd_ha)
 
 /* ---------- Done List initialization ---------- */
 
-static void asd_dl_tasklet_handler(unsigned long);
+static void asd_dl_tasklet_handler(struct tasklet_struct *t);
 
 static int asd_init_dl(struct asd_ha_struct *asd_ha)
 {
@@ -261,8 +261,7 @@ static int asd_init_dl(struct asd_ha_struct *asd_ha)
 	asd_ha->seq.dl = asd_ha->seq.actual_dl->vaddr;
 	asd_ha->seq.dl_toggle = ASD_DEF_DL_TOGGLE;
 	asd_ha->seq.dl_next = 0;
-	tasklet_init(&asd_ha->seq.dl_tasklet, asd_dl_tasklet_handler,
-		     (unsigned long) asd_ha);
+	tasklet_setup(&asd_ha->seq.dl_tasklet, asd_dl_tasklet_handler);
 
 	return 0;
 }
@@ -711,9 +710,9 @@ static void asd_chip_reset(struct asd_ha_struct *asd_ha)
 
 /* ---------- Done List Routines ---------- */
 
-static void asd_dl_tasklet_handler(unsigned long data)
+static void asd_dl_tasklet_handler(struct tasklet_struct *t)
 {
-	struct asd_ha_struct *asd_ha = (struct asd_ha_struct *) data;
+	struct asd_ha_struct *asd_ha = from_tasklet(asd_ha, t, seq.dl_tasklet);
 	struct asd_seq_data *seq = &asd_ha->seq;
 	unsigned long flags;
 
-- 
2.17.1

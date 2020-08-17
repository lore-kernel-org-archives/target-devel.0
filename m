From: Allen Pais <allen.cryptic@gmail.com>
Date: Mon, 17 Aug 2020 08:55:20 +0000
Subject: [PATCH 6/8] scsi: mvsas: convert tasklets to use new tasklet_setup() API
Message-Id: <20200817085409.25268-7-allen.cryptic@gmail.com>
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
 drivers/scsi/mvsas/mv_init.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index 978f5283c883..53b2d463fa13 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -147,13 +147,14 @@ static void mvs_free(struct mvs_info *mvi)
 }
 
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
-static void mvs_tasklet(unsigned long opaque)
+static void mvs_tasklet(struct tasklet_struct *t)
 {
 	u32 stat;
 	u16 core_nr, i = 0;
 
 	struct mvs_info *mvi;
-	struct sas_ha_struct *sha = (struct sas_ha_struct *)opaque;
+	struct mvs_prv_info *mpi = from_tasklet(mpi, t, mv_tasklet);
+	struct sas_ha_struct *sha = pci_get_drvdata(mpi->mvi[0]->pdev);
 
 	core_nr = ((struct mvs_prv_info *)sha->lldd_ha)->n_host;
 	mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[0];
@@ -564,8 +565,7 @@ static int mvs_pci_init(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} while (nhost < chip->n_host);
 	mpi = (struct mvs_prv_info *)(SHOST_TO_SAS_HA(shost)->lldd_ha);
 #ifdef CONFIG_SCSI_MVSAS_TASKLET
-	tasklet_init(&(mpi->mv_tasklet), mvs_tasklet,
-		     (unsigned long)SHOST_TO_SAS_HA(shost));
+	tasklet_setup(&(mpi->mv_tasklet), mvs_tasklet);
 #endif
 
 	mvs_post_sas_ha_init(shost, chip);
-- 
2.17.1

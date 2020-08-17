From: Allen Pais <allen.cryptic@gmail.com>
Date: Mon, 17 Aug 2020 08:54:27 +0000
Subject: [PATCH 0/8] scsi: convert tasklets to use new tasklet_setup()
Message-Id: <20200817085409.25268-1-allen.cryptic@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jejb@linux.ibm.com, martin.petersen@oracle.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com
Cc: keescook@chromium.org, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org, megaraidlinux.pdl@broadcom.com, Allen Pais <allen.lkml@gmail.com>

From: Allen Pais <allen.lkml@gmail.com>

Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
introduced a new tasklet initialization API. This series converts 
all the scsi drivers to use the new tasklet_setup() API

Allen Pais (8):
  scsi: aic94xx: convert tasklets to use new tasklet_setup() API
  scsi: esas2r: convert tasklets to use new tasklet_setup() API
  scsi: ibmvscsi: convert tasklets to use new tasklet_setup() API
  scsi: isci: convert tasklets to use new tasklet_setup() API
  scsi: megaraid: convert tasklets to use new tasklet_setup() API
  scsi: mvsas: convert tasklets to use new tasklet_setup() API
  scsi: pm8001: convert tasklets to use new tasklet_setup() API
  scsi: pmcraid: convert tasklets to use new tasklet_setup() API

 drivers/scsi/aic94xx/aic94xx_hwi.c          |  9 ++--
 drivers/scsi/esas2r/esas2r.h                |  2 +-
 drivers/scsi/esas2r/esas2r_init.c           |  4 +-
 drivers/scsi/esas2r/esas2r_main.c           |  4 +-
 drivers/scsi/ibmvscsi/ibmvfc.c              |  6 +--
 drivers/scsi/ibmvscsi/ibmvscsi.c            |  8 +--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c    |  7 ++-
 drivers/scsi/isci/host.c                    |  4 +-
 drivers/scsi/isci/host.h                    |  2 +-
 drivers/scsi/isci/init.c                    |  3 +-
 drivers/scsi/megaraid/megaraid_mbox.c       |  9 ++--
 drivers/scsi/megaraid/megaraid_sas.h        |  2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 16 +++---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 14 +++---
 drivers/scsi/mvsas/mv_init.c                |  8 +--
 drivers/scsi/pm8001/pm8001_init.c           | 55 ++++++++++++---------
 drivers/scsi/pm8001/pm8001_sas.h            |  6 ++-
 drivers/scsi/pmcraid.c                      | 29 +++++------
 drivers/scsi/pmcraid.h                      |  9 +++-
 19 files changed, 104 insertions(+), 93 deletions(-)

-- 
2.17.1

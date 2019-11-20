From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 20 Nov 2019 22:27:22 +0000
Subject: [PATCH v2 14/15] scsi: qla2xxx: Add debug dump of LOGO payload and ELS IOCB
Message-Id: <20191120222723.27779-15-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191120222723.27779-1-r.bolshakov@yadro.com>
In-Reply-To: <20191120222723.27779-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Quinn Tran <qutran@marvell.com>, Himanshu Madhani <hmadhani@marvell.com>

The change adds a way to debug LOGO ELS, likewise PLOGI.

Cc: Quinn Tran <qutran@marvell.com>
Cc: Himanshu Madhani <hmadhani@marvell.com>
Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 12b37b711ae8..cd2e0f89e9b5 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -2627,6 +2627,10 @@ qla24xx_els_dcmd_iocb(scsi_qla_host_t *vha, int els_opcode,
 
 	memcpy(elsio->u.els_logo.els_logo_pyld, &logo_pyld,
 	    sizeof(struct els_logo_payload));
+	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0x3075, "LOGO buffer:");
+	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0x010a,
+		       elsio->u.els_logo.els_logo_pyld,
+		       sizeof(*elsio->u.els_logo.els_logo_pyld));
 
 	rval = qla2x00_start_sp(sp);
 	if (rval != QLA_SUCCESS) {
@@ -2704,6 +2708,11 @@ qla24xx_els_logo_iocb(srb_t *sp, struct els_entry_24xx *els_iocb)
 		els_iocb->rx_byte_count = 0;
 		els_iocb->rx_address = 0;
 		els_iocb->rx_len = 0;
+		ql_dbg(ql_dbg_io + ql_dbg_buffer, vha, 0x3076,
+		       "LOGO ELS IOCB:");
+		ql_dump_buffer(ql_log_info, vha, 0x010b,
+			       els_iocb,
+			       sizeof(*els_iocb));
 	}
 
 	sp->vha->qla_stats.control_requests++;
-- 
2.24.0

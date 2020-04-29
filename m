From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 29 Apr 2020 09:44:35 +0000
Subject: [RFC PATCH 02/11] scsi: target/core: Set MULTIP bit for se_device with multiple ports
Message-Id: <20200429094443.43937-3-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>, Konstantin Vinogradov <k.vinogradov@yadro.com>, Ivan Efremov <i.efremov@yadro.com>

SAM-5 4.8.3 (SCSI target device with multiple SCSI ports structure)
obligates to set MULTIP bit when there's multiple SCSI target ports:

> Each device server shall indicate the presence of multiple SCSI target
> ports by setting the MULTIP bit to one in its standard INQUIRY data
> (see SPC-4).

The change sets MULTIP bit automatically to indicate the presence of
multiple SCSI target ports within standard inquiry response data if
there are multiple target ports in all target port groups of the
se_device.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
Signed-off-by: Konstantin Vinogradov <k.vinogradov@yadro.com>
Signed-off-by: Ivan Efremov <i.efremov@yadro.com>
---
 drivers/target/target_core_spc.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index ca5579ebc81d..633dee9ac877 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -53,6 +53,8 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	struct se_lun *lun = cmd->se_lun;
 	struct se_device *dev = cmd->se_dev;
 	struct se_session *sess = cmd->se_sess;
+	struct t10_alua_tg_pt_gp *tg_pt_gp;
+	u64 dev_ports = 0;
 
 	/* Set RMB (removable media) for tape devices */
 	if (dev->transport->get_device_type(dev) = TYPE_TAPE)
@@ -93,6 +95,21 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 			buf[5] |= 0x1;
 	}
 
+	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
+	list_for_each_entry(tg_pt_gp, &dev->t10_alua.tg_pt_gps_list,
+			    tg_pt_gp_list) {
+		dev_ports += tg_pt_gp->tg_pt_gp_members;
+		/* Exact number of ports does not matter for MULTIP bit */
+		if (dev_ports > 1)
+			break;
+	}
+	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
+	/*
+	 * Set MULTIP bit to indicate presence of multiple SCSI target ports
+	 */
+	if (dev_ports > 1)
+		buf[6] |= 0x10;
+
 	buf[7] = 0x2; /* CmdQue=1 */
 
 	/*
-- 
2.26.1

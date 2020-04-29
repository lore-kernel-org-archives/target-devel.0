From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Wed, 29 Apr 2020 09:44:44 +0000
Subject: [RFC PATCH 11/11] scsi: target/core: Show peer ports in RTPG response
Message-Id: <20200429094443.43937-12-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200429094443.43937-1-r.bolshakov@yadro.com>
In-Reply-To: <20200429094443.43937-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>, David Disseldorp <ddiss@suse.de>
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>

The change makes peer ports visible in the response to REPORT TARGET
PORT GROUPS command. RTPI values of real SCSI target ports and peer
ports for each target port descriptor list are sorted in ascending
order.

Signed-off-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_alua.c     | 32 +++++++++++++++++++++++----
 drivers/target/target_core_configfs.c |  2 ++
 2 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
index 81ed79500376..f7d88181d683 100644
--- a/drivers/target/target_core_alua.c
+++ b/drivers/target/target_core_alua.c
@@ -18,6 +18,7 @@
 #include <linux/fcntl.h>
 #include <linux/file.h>
 #include <linux/fs.h>
+#include <linux/sort.h>
 #include <scsi/scsi_proto.h>
 #include <asm/unaligned.h>
 
@@ -127,6 +128,11 @@ target_emulate_report_referrals(struct se_cmd *cmd)
 	return 0;
 }
 
+static int cmp_rtpi(const void *a, const void *b)
+{
+	return *(u16 *)a - *(u16 *)b;
+}
+
 /*
  * REPORT_TARGET_PORT_GROUPS
  *
@@ -138,7 +144,11 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 	struct se_device *dev = cmd->se_dev;
 	struct t10_alua_tg_pt_gp *tg_pt_gp;
 	struct se_lun *lun;
+	struct t10_alua_tg_pt_gp_peer *peer;
 	unsigned char *buf;
+	u8 port_cnt;
+	u16 *ports = NULL;
+	int i = 0;
 	u32 rd_len = 0, off;
 	int ext_hdr = (cmd->t_task_cdb[1] & 0x20);
 
@@ -209,12 +219,24 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 		/*
 		 * TARGET PORT COUNT
 		 */
-		buf[off++] = (tg_pt_gp->tg_pt_gp_members & 0xff);
+		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+		port_cnt = (tg_pt_gp->tg_pt_gp_members & 0xff);
+		buf[off++] = port_cnt;
 		rd_len += 8;
+		ports = kcalloc(tg_pt_gp->tg_pt_gp_members, sizeof(u16),
+				GFP_ATOMIC);
 
-		spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+		i = 0;
 		list_for_each_entry(lun, &tg_pt_gp->tg_pt_gp_lun_list,
-				lun_tg_pt_gp_link) {
+				    lun_tg_pt_gp_link)
+			ports[i++] = lun->lun_tpg->tpg_rtpi;
+
+		list_for_each_entry(peer, &tg_pt_gp->tg_pt_gp_peer_list,
+				    tg_pt_gp_peer_list)
+			ports[i++] = peer->tg_pt_gp_peer_rtpi;
+
+		sort(ports, port_cnt, sizeof(*ports), cmp_rtpi, NULL);
+		for (i = 0; i < port_cnt; i++) {
 			/*
 			 * Start Target Port descriptor format
 			 *
@@ -224,10 +246,12 @@ target_emulate_report_target_port_groups(struct se_cmd *cmd)
 			/*
 			 * Set RELATIVE TARGET PORT IDENTIFIER
 			 */
-			put_unaligned_be16(lun->lun_tpg->tpg_rtpi, &buf[off]);
+			put_unaligned_be16(ports[i], &buf[off]);
 			off += 2;
 			rd_len += 4;
 		}
+		kfree(ports);
+		ports = NULL;
 		spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	}
 	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index c43f244f8bd6..4026debe30ca 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -3161,6 +3161,7 @@ target_core_alua_tg_pt_gp_peers_make(struct config_group *group,
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
 	list_add_tail(&peer_port->tg_pt_gp_peer_list,
 		      &tg_pt_gp->tg_pt_gp_peer_list);
+	tg_pt_gp->tg_pt_gp_members++;
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 	mutex_unlock(&g_rtpi_mutex);
 
@@ -3181,6 +3182,7 @@ static void target_core_alua_tg_pt_gp_peers_drop(struct config_group *group,
 	struct t10_alua_tg_pt_gp *tg_pt_gp = container_of(group,
 			struct t10_alua_tg_pt_gp, tg_pt_gp_peers_group);
 	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
+	tg_pt_gp->tg_pt_gp_members--;
 	list_del(&peer_port->tg_pt_gp_peer_list);
 	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
 
-- 
2.26.1

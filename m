From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 07 Jun 2020 20:35:52 +0000
Subject: [PATCH 05/17] vhost scsi: use target_parse_emulated_name
Message-Id: <1591562164-9766-6-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>

Use target_parse_emulated_name so the acl and SCSI names are
properly formatted.

Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/vhost/scsi.c | 69 +++++++++-------------------------------------------
 1 file changed, 11 insertions(+), 58 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 15aabc2..37f66f8 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1938,7 +1938,8 @@ static int vhost_scsi_nexus_cb(struct se_portal_group *se_tpg,
 }
 
 static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
-				const char *name)
+				const char *tpt_id_name,
+				const char *acl_name)
 {
 	struct vhost_scsi_nexus *tv_nexus;
 
@@ -1964,8 +1965,8 @@ static int vhost_scsi_make_nexus(struct vhost_scsi_tpg *tpg,
 					VHOST_SCSI_DEFAULT_TAGS,
 					sizeof(struct vhost_scsi_cmd),
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					(unsigned char *)name,
-					(unsigned char *)name, tv_nexus,
+					(unsigned char *)tpt_id_name,
+					(unsigned char *)acl_name, tv_nexus,
 					vhost_scsi_nexus_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		mutex_unlock(&tpg->tv_tpg_mutex);
@@ -2056,7 +2057,7 @@ static ssize_t vhost_scsi_tpg_nexus_store(struct config_item *item,
 	struct vhost_scsi_tpg *tpg = container_of(se_tpg,
 				struct vhost_scsi_tpg, se_tpg);
 	struct vhost_scsi_tport *tport_wwn = tpg->tport;
-	unsigned char i_port[VHOST_SCSI_NAMELEN], *ptr, *port_ptr;
+	unsigned char i_port[VHOST_SCSI_NAMELEN], *tpt_id_name;
 	int ret;
 	/*
 	 * Shutdown the active I_T nexus if 'NULL' is passed..
@@ -2065,62 +2066,14 @@ static ssize_t vhost_scsi_tpg_nexus_store(struct config_item *item,
 		ret = vhost_scsi_drop_nexus(tpg);
 		return (!ret) ? count : ret;
 	}
-	/*
-	 * Otherwise make sure the passed virtual Initiator port WWN matches
-	 * the fabric protocol_id set in vhost_scsi_make_tport(), and call
-	 * vhost_scsi_make_nexus().
-	 */
-	if (strlen(page) >= VHOST_SCSI_NAMELEN) {
-		pr_err("Emulated NAA Sas Address: %s, exceeds"
-				" max: %d\n", page, VHOST_SCSI_NAMELEN);
-		return -EINVAL;
-	}
-	snprintf(&i_port[0], VHOST_SCSI_NAMELEN, "%s", page);
 
-	ptr = strstr(i_port, "naa.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_SAS) {
-			pr_err("Passed SAS Initiator Port %s does not"
-				" match target port protoid: %s\n", i_port,
-				vhost_scsi_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "fc.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_FCP) {
-			pr_err("Passed FCP Initiator Port %s does not"
-				" match target port protoid: %s\n", i_port,
-				vhost_scsi_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[3]; /* Skip over "fc." */
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "iqn.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_ISCSI) {
-			pr_err("Passed iSCSI Initiator Port %s does not"
-				" match target port protoid: %s\n", i_port,
-				vhost_scsi_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	pr_err("Unable to locate prefix for emulated Initiator Port:"
-			" %s\n", i_port);
-	return -EINVAL;
-	/*
-	 * Clear any trailing newline for the NAA WWN
-	 */
-check_newline:
-	if (i_port[strlen(i_port)-1] = '\n')
-		i_port[strlen(i_port)-1] = '\0';
+	ret = target_parse_emulated_name(tport_wwn->tport_proto_id, page,
+					 i_port, VHOST_SCSI_NAMELEN,
+					 &tpt_id_name);
+	if (ret)
+		return ret;
 
-	ret = vhost_scsi_make_nexus(tpg, port_ptr);
+	ret = vhost_scsi_make_nexus(tpg, tpt_id_name, i_port);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

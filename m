From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 07 Jun 2020 20:35:53 +0000
Subject: [PATCH 06/17] xen scsiback: use target_parse_emulated_name
Message-Id: <1591562164-9766-7-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>

Use target_parse_emulated_name so the acl and SCSI names are
properly formatted.

Cc: Juergen Gross <jgross@suse.com>
Signed-off-by: Mike Christie <michael.christie@oracle.com>
Acked-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/xen/xen-scsiback.c | 66 ++++++++--------------------------------------
 1 file changed, 11 insertions(+), 55 deletions(-)

diff --git a/drivers/xen/xen-scsiback.c b/drivers/xen/xen-scsiback.c
index 93cb386..f70b6da 100644
--- a/drivers/xen/xen-scsiback.c
+++ b/drivers/xen/xen-scsiback.c
@@ -1509,7 +1509,8 @@ static int scsiback_alloc_sess_cb(struct se_portal_group *se_tpg,
 }
 
 static int scsiback_make_nexus(struct scsiback_tpg *tpg,
-				const char *name)
+				const char *tpt_id_name,
+				const char *acl_name)
 {
 	struct scsiback_nexus *tv_nexus;
 	int ret = 0;
@@ -1530,8 +1531,9 @@ static int scsiback_make_nexus(struct scsiback_tpg *tpg,
 	tv_nexus->tvn_se_sess = target_setup_session(&tpg->se_tpg,
 						     VSCSI_DEFAULT_SESSION_TAGS,
 						     sizeof(struct vscsibk_pend),
-						     TARGET_PROT_NORMAL, name,
-						     name, tv_nexus,
+						     TARGET_PROT_NORMAL,
+						     tpt_id_name, acl_name,
+						     tv_nexus,
 						     scsiback_alloc_sess_cb);
 	if (IS_ERR(tv_nexus->tvn_se_sess)) {
 		kfree(tv_nexus);
@@ -1619,7 +1621,7 @@ static ssize_t scsiback_tpg_nexus_store(struct config_item *item,
 	struct scsiback_tpg *tpg = container_of(se_tpg,
 				struct scsiback_tpg, se_tpg);
 	struct scsiback_tport *tport_wwn = tpg->tport;
-	unsigned char i_port[VSCSI_NAMELEN], *ptr, *port_ptr;
+	unsigned char i_port[VSCSI_NAMELEN], *tpt_id_name;
 	int ret;
 	/*
 	 * Shutdown the active I_T nexus if 'NULL' is passed.
@@ -1628,59 +1630,13 @@ static ssize_t scsiback_tpg_nexus_store(struct config_item *item,
 		ret = scsiback_drop_nexus(tpg);
 		return (!ret) ? count : ret;
 	}
-	/*
-	 * Otherwise make sure the passed virtual Initiator port WWN matches
-	 * the fabric protocol_id set in scsiback_make_tport(), and call
-	 * scsiback_make_nexus().
-	 */
-	if (strlen(page) >= VSCSI_NAMELEN) {
-		pr_err("Emulated NAA Sas Address: %s, exceeds max: %d\n",
-			page, VSCSI_NAMELEN);
-		return -EINVAL;
-	}
-	snprintf(&i_port[0], VSCSI_NAMELEN, "%s", page);
 
-	ptr = strstr(i_port, "naa.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_SAS) {
-			pr_err("Passed SAS Initiator Port %s does not match target port protoid: %s\n",
-				i_port, scsiback_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "fc.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_FCP) {
-			pr_err("Passed FCP Initiator Port %s does not match target port protoid: %s\n",
-				i_port, scsiback_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[3]; /* Skip over "fc." */
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "iqn.");
-	if (ptr) {
-		if (tport_wwn->tport_proto_id != SCSI_PROTOCOL_ISCSI) {
-			pr_err("Passed iSCSI Initiator Port %s does not match target port protoid: %s\n",
-				i_port, scsiback_dump_proto_id(tport_wwn));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	pr_err("Unable to locate prefix for emulated Initiator Port: %s\n",
-		i_port);
-	return -EINVAL;
-	/*
-	 * Clear any trailing newline for the NAA WWN
-	 */
-check_newline:
-	if (i_port[strlen(i_port) - 1] = '\n')
-		i_port[strlen(i_port) - 1] = '\0';
+	ret = target_parse_emulated_name(tport_wwn->tport_proto_id, page,
+					 i_port, VSCSI_NAMELEN, &tpt_id_name);
+	if (ret)
+		return ret;
 
-	ret = scsiback_make_nexus(tpg, port_ptr);
+	ret = scsiback_make_nexus(tpg, tpt_id_name, i_port);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

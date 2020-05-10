From: Mike Christie <mchristi@redhat.com>
Date: Sun, 10 May 2020 21:57:33 +0000
Subject: [PATCH 04/15] tcm loop: use target_parse_emulated_name
Message-Id: <20200510215744.21999-5-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

Use target_parse_emulated_name so the acl and SCSI names are properly
formatted.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/loopback/tcm_loop.c | 65 ++++++--------------------------------
 1 file changed, 10 insertions(+), 55 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 74aded7..64e5f1f 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -725,7 +725,8 @@ static int tcm_loop_alloc_sess_cb(struct se_portal_group *se_tpg,
 
 static int tcm_loop_make_nexus(
 	struct tcm_loop_tpg *tl_tpg,
-	const char *name)
+	const char *tpt_id_name,
+	const char *acl_name)
 {
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
 	struct tcm_loop_nexus *tl_nexus;
@@ -742,7 +743,7 @@ static int tcm_loop_make_nexus(
 
 	tl_nexus->se_sess = target_setup_session(&tl_tpg->tl_se_tpg, 0, 0,
 					TARGET_PROT_DIN_PASS | TARGET_PROT_DOUT_PASS,
-					name, name, tl_nexus,
+					tpt_id_name, acl_name, tl_nexus,
 					tcm_loop_alloc_sess_cb);
 	if (IS_ERR(tl_nexus->se_sess)) {
 		ret = PTR_ERR(tl_nexus->se_sess);
@@ -751,7 +752,7 @@ static int tcm_loop_make_nexus(
 	}
 
 	pr_debug("TCM_Loop_ConfigFS: Established I_T Nexus to emulated %s Initiator Port: %s\n",
-		 tcm_loop_dump_proto_id(tl_hba), name);
+		 tcm_loop_dump_proto_id(tl_hba), acl_name);
 	return 0;
 }
 
@@ -814,7 +815,7 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 	struct tcm_loop_tpg *tl_tpg = container_of(se_tpg,
 			struct tcm_loop_tpg, tl_se_tpg);
 	struct tcm_loop_hba *tl_hba = tl_tpg->tl_hba;
-	unsigned char i_port[TL_WWN_ADDR_LEN], *ptr, *port_ptr;
+	unsigned char i_port[TL_WWN_ADDR_LEN], *tpt_id_name;
 	int ret;
 	/*
 	 * Shutdown the active I_T nexus if 'NULL' is passed..
@@ -823,59 +824,13 @@ static ssize_t tcm_loop_tpg_nexus_store(struct config_item *item,
 		ret = tcm_loop_drop_nexus(tl_tpg);
 		return (!ret) ? count : ret;
 	}
-	/*
-	 * Otherwise make sure the passed virtual Initiator port WWN matches
-	 * the fabric protocol_id set in tcm_loop_make_scsi_hba(), and call
-	 * tcm_loop_make_nexus()
-	 */
-	if (strlen(page) >= TL_WWN_ADDR_LEN) {
-		pr_err("Emulated NAA Sas Address: %s, exceeds max: %d\n",
-		       page, TL_WWN_ADDR_LEN);
-		return -EINVAL;
-	}
-	snprintf(&i_port[0], TL_WWN_ADDR_LEN, "%s", page);
 
-	ptr = strstr(i_port, "naa.");
-	if (ptr) {
-		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_SAS) {
-			pr_err("Passed SAS Initiator Port %s does not match target port protoid: %s\n",
-			       i_port, tcm_loop_dump_proto_id(tl_hba));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "fc.");
-	if (ptr) {
-		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_FCP) {
-			pr_err("Passed FCP Initiator Port %s does not match target port protoid: %s\n",
-			       i_port, tcm_loop_dump_proto_id(tl_hba));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[3]; /* Skip over "fc." */
-		goto check_newline;
-	}
-	ptr = strstr(i_port, "iqn.");
-	if (ptr) {
-		if (tl_hba->tl_proto_id != SCSI_PROTOCOL_ISCSI) {
-			pr_err("Passed iSCSI Initiator Port %s does not match target port protoid: %s\n",
-			       i_port, tcm_loop_dump_proto_id(tl_hba));
-			return -EINVAL;
-		}
-		port_ptr = &i_port[0];
-		goto check_newline;
-	}
-	pr_err("Unable to locate prefix for emulated Initiator Port: %s\n",
-	       i_port);
-	return -EINVAL;
-	/*
-	 * Clear any trailing newline for the NAA WWN
-	 */
-check_newline:
-	if (i_port[strlen(i_port)-1] = '\n')
-		i_port[strlen(i_port)-1] = '\0';
+	ret = target_parse_emulated_name(tl_hba->tl_proto_id, page, i_port,
+					 TL_WWN_ADDR_LEN, &tpt_id_name);
+	if (ret)
+		return ret;
 
-	ret = tcm_loop_make_nexus(tl_tpg, port_ptr);
+	ret = tcm_loop_make_nexus(tl_tpg, tpt_id_name, i_port);
 	if (ret < 0)
 		return ret;
 
-- 
1.8.3.1

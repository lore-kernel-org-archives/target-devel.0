From: David Disseldorp <ddiss@suse.de>
Date: Thu, 21 Jun 2018 17:05:08 +0000
Subject: [PATCH v2] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <20180621170508.13099-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The new emulate_pr backstore attribute allows for Persistent Reservation
and SCSI2 RESERVE/RELEASE support to be completely disabled. This can be
useful for scenarios such as:
- Ensuring ATS (Compare & Write) usage on recent VMware ESXi initiators.
- Allowing clustered (e.g. tcm-user) backends to block such requests,
  avoiding the multi-node reservation state propagation.

When explicitly disabled, PR and RESERVE/RELEASE requests receive
Invalid Command Operation Code response sense data.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_configfs.c | 29 ++++++++++++++++++++++-------
 drivers/target/target_core_device.c   | 13 +++++++++++++
 drivers/target/target_core_pr.c       | 22 ++++++++++++++++++++++
 include/target/target_core_base.h     |  3 +++
 4 files changed, 60 insertions(+), 7 deletions(-)

Changes since v1:
* block Reservation request passthrough when emulate_pr=0
* fix some style issues
* add an emulate_pr check to pgr_support_show()

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 5ccef7d597fa..a57898a8875a 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -532,6 +532,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(emulate_tpu);
 DEF_CONFIGFS_ATTRIB_SHOW(emulate_tpws);
 DEF_CONFIGFS_ATTRIB_SHOW(emulate_caw);
 DEF_CONFIGFS_ATTRIB_SHOW(emulate_3pc);
+DEF_CONFIGFS_ATTRIB_SHOW(emulate_pr);
 DEF_CONFIGFS_ATTRIB_SHOW(pi_prot_type);
 DEF_CONFIGFS_ATTRIB_SHOW(hw_pi_prot_type);
 DEF_CONFIGFS_ATTRIB_SHOW(pi_prot_format);
@@ -592,6 +593,7 @@ static ssize_t _name##_store(struct config_item *item, const char *page,	\
 DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_fua_write);
 DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_caw);
 DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_3pc);
+DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_pr);
 DEF_CONFIGFS_ATTRIB_STORE_BOOL(enforce_pr_isids);
 DEF_CONFIGFS_ATTRIB_STORE_BOOL(is_nonrot);
 
@@ -1100,9 +1102,13 @@ static ssize_t pgr_support_show(struct config_item *item, char *page)
 {
 	struct se_dev_attrib *da = to_attrib(item);
 	u8 flags = da->da_dev->transport->transport_flags;
+	int pgr_support = 1;
 
-	return snprintf(page, PAGE_SIZE, "%d\n",
-			flags & TRANSPORT_FLAG_PASSTHROUGH_PGR ? 0 : 1);
+	if (!da->da_dev->dev_attrib.emulate_pr ||
+	    (flags & TRANSPORT_FLAG_PASSTHROUGH))
+		pgr_support = 0;
+
+	return snprintf(page, PAGE_SIZE, "%d\n", pgr_support);
 }
 
 CONFIGFS_ATTR(, emulate_model_alias);
@@ -1116,6 +1122,7 @@ CONFIGFS_ATTR(, emulate_tpu);
 CONFIGFS_ATTR(, emulate_tpws);
 CONFIGFS_ATTR(, emulate_caw);
 CONFIGFS_ATTR(, emulate_3pc);
+CONFIGFS_ATTR(, emulate_pr);
 CONFIGFS_ATTR(, pi_prot_type);
 CONFIGFS_ATTR_RO(, hw_pi_prot_type);
 CONFIGFS_ATTR(, pi_prot_format);
@@ -1156,6 +1163,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_emulate_tpws,
 	&attr_emulate_caw,
 	&attr_emulate_3pc,
+	&attr_emulate_pr,
 	&attr_pi_prot_type,
 	&attr_hw_pi_prot_type,
 	&attr_pi_prot_format,
@@ -1427,6 +1435,9 @@ static ssize_t target_pr_res_holder_show(struct config_item *item, char *page)
 	struct se_device *dev = pr_to_dev(item);
 	int ret;
 
+	if (!dev->dev_attrib.emulate_pr)
+		return sprintf(page, "SPC_RESERVATIONS_DISABLED\n");
+
 	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return sprintf(page, "Passthrough\n");
 
@@ -1567,12 +1578,14 @@ static ssize_t target_pr_res_type_show(struct config_item *item, char *page)
 {
 	struct se_device *dev = pr_to_dev(item);
 
+	if (!dev->dev_attrib.emulate_pr)
+		return sprintf(page, "SPC_RESERVATIONS_DISABLED\n");
 	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return sprintf(page, "SPC_PASSTHROUGH\n");
-	else if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
+	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return sprintf(page, "SPC2_RESERVATIONS\n");
-	else
-		return sprintf(page, "SPC3_PERSISTENT_RESERVATIONS\n");
+
+	return sprintf(page, "SPC3_PERSISTENT_RESERVATIONS\n");
 }
 
 static ssize_t target_pr_res_aptpl_active_show(struct config_item *item,
@@ -1580,7 +1593,8 @@ static ssize_t target_pr_res_aptpl_active_show(struct config_item *item,
 {
 	struct se_device *dev = pr_to_dev(item);
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (!dev->dev_attrib.emulate_pr ||
+	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH))
 		return 0;
 
 	return sprintf(page, "APTPL Bit Status: %s\n",
@@ -1592,7 +1606,8 @@ static ssize_t target_pr_res_aptpl_metadata_show(struct config_item *item,
 {
 	struct se_device *dev = pr_to_dev(item);
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (!dev->dev_attrib.emulate_pr ||
+	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH))
 		return 0;
 
 	return sprintf(page, "Ready to process PR APTPL metadata..\n");
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index e27db4d45a9d..e443ce5bf311 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -806,6 +806,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.emulate_tpws = DA_EMULATE_TPWS;
 	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
 	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
+	dev->dev_attrib.emulate_pr = DA_EMULATE_PR;
 	dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE0_PROT;
 	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
 	dev->dev_attrib.force_pr_aptpl = DA_FORCE_PR_APTPL;
@@ -1172,6 +1173,18 @@ passthrough_parse_cdb(struct se_cmd *cmd,
 	}
 
 	/*
+	 * With emulate_pr disabled, all reservation requests should fail,
+	 * regardless of whether or not TRANSPORT_FLAG_PASSTHROUGH_PGR is set.
+	 */
+	if (!dev->dev_attrib.emulate_pr &&
+	    ((cdb[0] = PERSISTENT_RESERVE_IN) ||
+	     (cdb[0] = PERSISTENT_RESERVE_OUT) ||
+	     (cdb[0] = RELEASE || cdb[0] = RELEASE_10) ||
+	     (cdb[0] = RESERVE || cdb[0] = RESERVE_10))) {
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
+	/*
 	 * For PERSISTENT RESERVE IN/OUT, RELEASE, and RESERVE we need to
 	 * emulate the response, since tcmu does not have the information
 	 * required to process these commands.
diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index 01ac306131c1..874ca3f0ee1b 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -208,6 +208,11 @@ target_scsi2_reservation_release(struct se_cmd *cmd)
 	struct se_portal_group *tpg;
 	int rc;
 
+	if (!dev->dev_attrib.emulate_pr) {
+		pr_err("failing SCSI2 RELEASE with emulate_pr disabled\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	if (!sess || !sess->se_tpg)
 		goto out;
 	rc = target_check_scsi2_reservation_conflict(cmd);
@@ -255,6 +260,11 @@ target_scsi2_reservation_reserve(struct se_cmd *cmd)
 	sense_reason_t ret = 0;
 	int rc;
 
+	if (!dev->dev_attrib.emulate_pr) {
+		pr_err("failing SCSI2 RESERVE with emulate_pr disabled\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	if ((cmd->t_task_cdb[1] & 0x01) &&
 	    (cmd->t_task_cdb[1] & 0x02)) {
 		pr_err("LongIO and Obsolete Bits set, returning ILLEGAL_REQUEST\n");
@@ -3560,6 +3570,11 @@ target_scsi3_emulate_pr_out(struct se_cmd *cmd)
 	int spec_i_pt = 0, all_tg_pt = 0, unreg = 0;
 	sense_reason_t ret;
 
+	if (!dev->dev_attrib.emulate_pr) {
+		pr_err("failing PROUT with emulate_pr disabled\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	/*
 	 * Following spc2r20 5.5.1 Reservations overview:
 	 *
@@ -4040,6 +4055,11 @@ target_scsi3_emulate_pr_in(struct se_cmd *cmd)
 {
 	sense_reason_t ret;
 
+	if (!cmd->se_dev->dev_attrib.emulate_pr) {
+		pr_err("failing PRIN with emulate_pr disabled\n");
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	/*
 	 * Following spc2r20 5.5.1 Reservations overview:
 	 *
@@ -4090,6 +4110,8 @@ target_check_reservation(struct se_cmd *cmd)
 		return 0;
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
 		return 0;
+	if (!dev->dev_attrib.emulate_pr)
+		return 0;
 	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return 0;
 
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 922a39f45abc..bca3713e0658 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -87,6 +87,8 @@
 #define DA_EMULATE_3PC				1
 /* No Emulation for PSCSI by default */
 #define DA_EMULATE_ALUA				0
+/* Emulate SCSI2 RESERVE/RELEASE and Persistent Reservations by default */
+#define DA_EMULATE_PR				1
 /* Enforce SCSI Initiator Port TransportID with 'ISID' for PR */
 #define DA_ENFORCE_PR_ISIDS			1
 /* Force SPC-3 PR Activate Persistence across Target Power Loss */
@@ -666,6 +668,7 @@ struct se_dev_attrib {
 	int		emulate_tpws;
 	int		emulate_caw;
 	int		emulate_3pc;
+	int		emulate_pr;
 	int		pi_prot_format;
 	enum target_prot_type pi_prot_type;
 	enum target_prot_type hw_pi_prot_type;
-- 
2.13.7


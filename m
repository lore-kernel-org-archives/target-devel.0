From: David Disseldorp <ddiss@suse.de>
Date: Wed, 07 Nov 2018 13:11:07 +0000
Subject: [PATCH v5] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <20181107131107.7426-1-ddiss@suse.de>
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
 drivers/target/target_core_configfs.c | 24 ++++++++++++++++++------
 drivers/target/target_core_device.c   | 13 +++++++++++++
 drivers/target/target_core_pr.c       |  2 ++
 drivers/target/target_core_spc.c      |  8 ++++++++
 include/target/target_core_base.h     |  3 +++
 5 files changed, 44 insertions(+), 6 deletions(-)

Changes since v4:
* keep pgr_support attribute independent of emulate_pr

Changes since v3:
* rebase against current mainline

Changes since v2:
* handle target_pr_res_aptpl_metadata_store()
* use common error path for spc_parse_cdb() and passthrough_parse_cdb()
  checks
* drop erroneous TRANSPORT_FLAG_PASSTHROUGH_PGR ->
  TRANSPORT_FLAG_PASSTHROUGH changes

Changes since v1:
* block Reservation request passthrough when emulate_pr=0
* fix some style issues
* add an emulate_pr check to pgr_support_show()

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f6b1549f4142..70b9f6755c36 100644
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
 
@@ -1116,6 +1118,7 @@ CONFIGFS_ATTR(, emulate_tpu);
 CONFIGFS_ATTR(, emulate_tpws);
 CONFIGFS_ATTR(, emulate_caw);
 CONFIGFS_ATTR(, emulate_3pc);
+CONFIGFS_ATTR(, emulate_pr);
 CONFIGFS_ATTR(, pi_prot_type);
 CONFIGFS_ATTR_RO(, hw_pi_prot_type);
 CONFIGFS_ATTR(, pi_prot_format);
@@ -1156,6 +1159,7 @@ struct configfs_attribute *sbc_attrib_attrs[] = {
 	&attr_emulate_tpws,
 	&attr_emulate_caw,
 	&attr_emulate_3pc,
+	&attr_emulate_pr,
 	&attr_pi_prot_type,
 	&attr_hw_pi_prot_type,
 	&attr_pi_prot_format,
@@ -1427,6 +1431,9 @@ static ssize_t target_pr_res_holder_show(struct config_item *item, char *page)
 	struct se_device *dev = pr_to_dev(item);
 	int ret;
 
+	if (!dev->dev_attrib.emulate_pr)
+		return sprintf(page, "SPC_RESERVATIONS_DISABLED\n");
+
 	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return sprintf(page, "Passthrough\n");
 
@@ -1567,12 +1574,14 @@ static ssize_t target_pr_res_type_show(struct config_item *item, char *page)
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
@@ -1580,7 +1589,8 @@ static ssize_t target_pr_res_aptpl_active_show(struct config_item *item,
 {
 	struct se_device *dev = pr_to_dev(item);
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (!dev->dev_attrib.emulate_pr ||
+	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
 		return 0;
 
 	return sprintf(page, "APTPL Bit Status: %s\n",
@@ -1592,7 +1602,8 @@ static ssize_t target_pr_res_aptpl_metadata_show(struct config_item *item,
 {
 	struct se_device *dev = pr_to_dev(item);
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (!dev->dev_attrib.emulate_pr ||
+	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
 		return 0;
 
 	return sprintf(page, "Ready to process PR APTPL metadata..\n");
@@ -1638,7 +1649,8 @@ static ssize_t target_pr_res_aptpl_metadata_store(struct config_item *item,
 	u16 tpgt = 0;
 	u8 type = 0;
 
-	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
+	if (!dev->dev_attrib.emulate_pr ||
+	    (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR))
 		return count;
 	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
 		return count;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 47b5ef153135..3274a5fa825c 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -805,6 +805,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	dev->dev_attrib.emulate_tpws = DA_EMULATE_TPWS;
 	dev->dev_attrib.emulate_caw = DA_EMULATE_CAW;
 	dev->dev_attrib.emulate_3pc = DA_EMULATE_3PC;
+	dev->dev_attrib.emulate_pr = DA_EMULATE_PR;
 	dev->dev_attrib.pi_prot_type = TARGET_DIF_TYPE0_PROT;
 	dev->dev_attrib.enforce_pr_isids = DA_ENFORCE_PR_ISIDS;
 	dev->dev_attrib.force_pr_aptpl = DA_FORCE_PR_APTPL;
@@ -1159,6 +1160,18 @@ passthrough_parse_cdb(struct se_cmd *cmd,
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
index 10db5656fd5d..91a2927acd36 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -4095,6 +4095,8 @@ target_check_reservation(struct se_cmd *cmd)
 		return 0;
 	if (dev->se_hba->hba_flags & HBA_FLAGS_INTERNAL_USE)
 		return 0;
+	if (!dev->dev_attrib.emulate_pr)
+		return 0;
 	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
 		return 0;
 
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index f459118bc11b..5c49eb6f4929 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -1281,6 +1281,14 @@ spc_parse_cdb(struct se_cmd *cmd, unsigned int *size)
 	struct se_device *dev = cmd->se_dev;
 	unsigned char *cdb = cmd->t_task_cdb;
 
+	if (!dev->dev_attrib.emulate_pr &&
+	    ((cdb[0] = PERSISTENT_RESERVE_IN) ||
+	     (cdb[0] = PERSISTENT_RESERVE_OUT) ||
+	     (cdb[0] = RELEASE || cdb[0] = RELEASE_10) ||
+	     (cdb[0] = RESERVE || cdb[0] = RESERVE_10))) {
+		return TCM_UNSUPPORTED_SCSI_OPCODE;
+	}
+
 	switch (cdb[0]) {
 	case MODE_SELECT:
 		*size = cdb[4];
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e3bdb0550a59..c15054116b86 100644
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
@@ -664,6 +666,7 @@ struct se_dev_attrib {
 	int		emulate_tpws;
 	int		emulate_caw;
 	int		emulate_3pc;
+	int		emulate_pr;
 	int		pi_prot_format;
 	enum target_prot_type pi_prot_type;
 	enum target_prot_type hw_pi_prot_type;
-- 
2.13.7

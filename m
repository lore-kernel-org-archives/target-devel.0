From: David Disseldorp <ddiss@suse.de>
Date: Fri, 30 Nov 2018 23:34:20 +0000
Subject: [PATCH v5 2/5] target: consistently null-terminate t10_wwn strings
Message-Id: <20181130233423.26556-3-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

In preparation for supporting user provided vendor strings, add an extra
byte to the vendor, model and revision arrays in struct t10_wwn. This
ensures that the full INQUIRY data can be carried in the arrays along
with a null-terminator.

Change a number of array readers and writers so that they account for
explicit null-termination:
- The pscsi_set_inquiry_info() and emulate_model_alias_store() codepaths
  don't currently explicitly null-terminate; fix this.
- Existing t10_wwn field dumps use for-loops which step over
  null-terminators for right-padding.
  + Use printf with width specifiers instead.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_configfs.c | 14 +++++++---
 drivers/target/target_core_device.c   | 49 ++++++++++++-----------------------
 drivers/target/target_core_pscsi.c    | 18 ++++++++-----
 drivers/target/target_core_spc.c      |  7 ++---
 drivers/target/target_core_stat.c     | 32 +++++------------------
 include/target/target_core_base.h     | 14 +++++++---
 6 files changed, 61 insertions(+), 73 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f6b1549f4142..34872f24e8bf 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -613,12 +613,17 @@ static void dev_set_t10_wwn_model_alias(struct se_device *dev)
 	const char *configname;
 
 	configname = config_item_name(&dev->dev_group.cg_item);
-	if (strlen(configname) >= 16) {
+	if (strlen(configname) >= INQUIRY_MODEL_LEN) {
 		pr_warn("dev[%p]: Backstore name '%s' is too long for "
 			"INQUIRY_MODEL, truncating to 16 bytes\n", dev,
 			configname);
 	}
-	snprintf(&dev->t10_wwn.model[0], 16, "%s", configname);
+	/*
+	 * XXX We can't use sizeof(dev->t10_wwn.model) (INQUIRY_MODEL_LEN + 1)
+	 * here without potentially breaking existing setups, so continue to
+	 * truncate one byte shorter than what can be carried in INQUIRY.
+	 */
+	strlcpy(dev->t10_wwn.model, configname, INQUIRY_MODEL_LEN);
 }
 
 static ssize_t emulate_model_alias_store(struct config_item *item,
@@ -640,11 +645,12 @@ static ssize_t emulate_model_alias_store(struct config_item *item,
 	if (ret < 0)
 		return ret;
 
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
 	if (flag) {
 		dev_set_t10_wwn_model_alias(dev);
 	} else {
-		strncpy(&dev->t10_wwn.model[0],
-			dev->transport->inquiry_prod, 16);
+		strlcpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
+			sizeof(dev->t10_wwn.model));
 	}
 	da->emulate_model_alias = flag;
 	return count;
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 47b5ef153135..5512871f50e4 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -720,36 +720,17 @@ void core_dev_free_initiator_node_lun_acl(
 static void scsi_dump_inquiry(struct se_device *dev)
 {
 	struct t10_wwn *wwn = &dev->t10_wwn;
-	char buf[17];
-	int i, device_type;
+	int device_type = dev->transport->get_device_type(dev);
+
 	/*
 	 * Print Linux/SCSI style INQUIRY formatting to the kernel ring buffer
 	 */
-	for (i = 0; i < 8; i++)
-		if (wwn->vendor[i] >= 0x20)
-			buf[i] = wwn->vendor[i];
-		else
-			buf[i] = ' ';
-	buf[i] = '\0';
-	pr_debug("  Vendor: %s\n", buf);
-
-	for (i = 0; i < 16; i++)
-		if (wwn->model[i] >= 0x20)
-			buf[i] = wwn->model[i];
-		else
-			buf[i] = ' ';
-	buf[i] = '\0';
-	pr_debug("  Model: %s\n", buf);
-
-	for (i = 0; i < 4; i++)
-		if (wwn->revision[i] >= 0x20)
-			buf[i] = wwn->revision[i];
-		else
-			buf[i] = ' ';
-	buf[i] = '\0';
-	pr_debug("  Revision: %s\n", buf);
-
-	device_type = dev->transport->get_device_type(dev);
+	pr_debug("  Vendor: %-" __stringify(INQUIRY_VENDOR_LEN) "s\n",
+		wwn->vendor);
+	pr_debug("  Model: %-" __stringify(INQUIRY_MODEL_LEN) "s\n",
+		wwn->model);
+	pr_debug("  Revision: %-" __stringify(INQUIRY_REVISION_LEN) "s\n",
+		wwn->revision);
 	pr_debug("  Type:   %s ", scsi_device_type(device_type));
 }
 
@@ -1008,12 +989,16 @@ int target_configure_device(struct se_device *dev)
 	 * anything virtual (IBLOCK, FILEIO, RAMDISK), but not for TCM/pSCSI
 	 * passthrough because this is being provided by the backend LLD.
 	 */
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
 	if (!(dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)) {
-		strncpy(&dev->t10_wwn.vendor[0], "LIO-ORG", 8);
-		strncpy(&dev->t10_wwn.model[0],
-			dev->transport->inquiry_prod, 16);
-		strncpy(&dev->t10_wwn.revision[0],
-			dev->transport->inquiry_rev, 4);
+		strlcpy(dev->t10_wwn.vendor, "LIO-ORG",
+			sizeof(dev->t10_wwn.vendor));
+		strlcpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
+			sizeof(dev->t10_wwn.model));
+		strlcpy(dev->t10_wwn.revision, dev->transport->inquiry_rev,
+			sizeof(dev->t10_wwn.revision));
 	}
 
 	scsi_dump_inquiry(dev);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 47d76c862014..1002829f2038 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -190,9 +190,15 @@ pscsi_set_inquiry_info(struct scsi_device *sdev, struct t10_wwn *wwn)
 	/*
 	 * Use sdev->inquiry from drivers/scsi/scsi_scan.c:scsi_alloc_sdev()
 	 */
-	memcpy(&wwn->vendor[0], &buf[8], sizeof(wwn->vendor));
-	memcpy(&wwn->model[0], &buf[16], sizeof(wwn->model));
-	memcpy(&wwn->revision[0], &buf[32], sizeof(wwn->revision));
+	BUILD_BUG_ON(sizeof(wwn->vendor) != INQUIRY_VENDOR_LEN + 1);
+	snprintf(wwn->vendor, sizeof(wwn->vendor),
+		 "%." __stringify(INQUIRY_VENDOR_LEN) "s", &buf[8]);
+	BUILD_BUG_ON(sizeof(wwn->model) != INQUIRY_MODEL_LEN + 1);
+	snprintf(wwn->model, sizeof(wwn->model),
+		 "%." __stringify(INQUIRY_MODEL_LEN) "s", &buf[16]);
+	BUILD_BUG_ON(sizeof(wwn->revision) != INQUIRY_REVISION_LEN + 1);
+	snprintf(wwn->revision, sizeof(wwn->revision),
+		 "%." __stringify(INQUIRY_REVISION_LEN) "s", &buf[32]);
 }
 
 static int
@@ -826,21 +832,21 @@ static ssize_t pscsi_show_configfs_dev_params(struct se_device *dev, char *b)
 	if (sd) {
 		bl += sprintf(b + bl, "        ");
 		bl += sprintf(b + bl, "Vendor: ");
-		for (i = 0; i < 8; i++) {
+		for (i = 0; i < INQUIRY_VENDOR_LEN; i++) {
 			if (ISPRINT(sd->vendor[i]))   /* printable character? */
 				bl += sprintf(b + bl, "%c", sd->vendor[i]);
 			else
 				bl += sprintf(b + bl, " ");
 		}
 		bl += sprintf(b + bl, " Model: ");
-		for (i = 0; i < 16; i++) {
+		for (i = 0; i < INQUIRY_MODEL_LEN; i++) {
 			if (ISPRINT(sd->model[i]))   /* printable character ? */
 				bl += sprintf(b + bl, "%c", sd->model[i]);
 			else
 				bl += sprintf(b + bl, " ");
 		}
 		bl += sprintf(b + bl, " Rev: ");
-		for (i = 0; i < 4; i++) {
+		for (i = 0; i < INQUIRY_REVISION_LEN; i++) {
 			if (ISPRINT(sd->rev[i]))   /* printable character ? */
 				bl += sprintf(b + bl, "%c", sd->rev[i]);
 			else
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c37dd36ec77d..8ffe712cb44d 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -113,12 +113,13 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	 * unused bytes at the end of the field (i.e., highest offset) and the
 	 * unused bytes shall be filled with ASCII space characters (20h).
 	 */
-	memset(&buf[8], 0x20, 8 + 16 + 4);
+	memset(&buf[8], 0x20,
+	       INQUIRY_VENDOR_LEN + INQUIRY_MODEL_LEN + INQUIRY_REVISION_LEN);
 	memcpy(&buf[8], "LIO-ORG", sizeof("LIO-ORG") - 1);
 	memcpy(&buf[16], dev->t10_wwn.model,
-	       strnlen(dev->t10_wwn.model, 16));
+	       strnlen(dev->t10_wwn.model, INQUIRY_MODEL_LEN));
 	memcpy(&buf[32], dev->t10_wwn.revision,
-	       strnlen(dev->t10_wwn.revision, 4));
+	       strnlen(dev->t10_wwn.revision, INQUIRY_REVISION_LEN));
 	buf[4] = 31; /* Set additional length to 31 */
 
 	return 0;
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index f0db91ebd735..87fd2b11fe3b 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -246,43 +246,25 @@ static ssize_t target_stat_lu_lu_name_show(struct config_item *item, char *page)
 static ssize_t target_stat_lu_vend_show(struct config_item *item, char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
-	int i;
-	char str[sizeof(dev->t10_wwn.vendor)+1];
 
-	/* scsiLuVendorId */
-	for (i = 0; i < sizeof(dev->t10_wwn.vendor); i++)
-		str[i] = ISPRINT(dev->t10_wwn.vendor[i]) ?
-			dev->t10_wwn.vendor[i] : ' ';
-	str[i] = '\0';
-	return snprintf(page, PAGE_SIZE, "%s\n", str);
+	return snprintf(page, PAGE_SIZE, "%-" __stringify(INQUIRY_VENDOR_LEN)
+			"s\n", dev->t10_wwn.vendor);
 }
 
 static ssize_t target_stat_lu_prod_show(struct config_item *item, char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
-	int i;
-	char str[sizeof(dev->t10_wwn.model)+1];
 
-	/* scsiLuProductId */
-	for (i = 0; i < sizeof(dev->t10_wwn.model); i++)
-		str[i] = ISPRINT(dev->t10_wwn.model[i]) ?
-			dev->t10_wwn.model[i] : ' ';
-	str[i] = '\0';
-	return snprintf(page, PAGE_SIZE, "%s\n", str);
+	return snprintf(page, PAGE_SIZE, "%-" __stringify(INQUIRY_MODEL_LEN)
+			"s\n", dev->t10_wwn.model);
 }
 
 static ssize_t target_stat_lu_rev_show(struct config_item *item, char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
-	int i;
-	char str[sizeof(dev->t10_wwn.revision)+1];
-
-	/* scsiLuRevisionId */
-	for (i = 0; i < sizeof(dev->t10_wwn.revision); i++)
-		str[i] = ISPRINT(dev->t10_wwn.revision[i]) ?
-			dev->t10_wwn.revision[i] : ' ';
-	str[i] = '\0';
-	return snprintf(page, PAGE_SIZE, "%s\n", str);
+
+	return snprintf(page, PAGE_SIZE, "%-" __stringify(INQUIRY_REVISION_LEN)
+			"s\n", dev->t10_wwn.revision);
 }
 
 static ssize_t target_stat_lu_dev_type_show(struct config_item *item, char *page)
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e3bdb0550a59..497853a09fee 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -46,6 +46,10 @@
 /* Used by transport_get_inquiry_vpd_device_ident() */
 #define INQUIRY_VPD_DEVICE_IDENTIFIER_LEN	254
 
+#define INQUIRY_VENDOR_LEN			8
+#define INQUIRY_MODEL_LEN			16
+#define INQUIRY_REVISION_LEN			4
+
 /* Attempts before moving from SHORT to LONG */
 #define PYX_TRANSPORT_WINDOW_CLOSED_THRESHOLD	3
 #define PYX_TRANSPORT_WINDOW_CLOSED_WAIT_SHORT	3  /* In milliseconds */
@@ -314,9 +318,13 @@ struct t10_vpd {
 };
 
 struct t10_wwn {
-	char vendor[8];
-	char model[16];
-	char revision[4];
+	/*
+	 * SCSI left aligned strings may not be null terminated. +1 to ensure a
+	 * null terminator is always present.
+	 */
+	char vendor[INQUIRY_VENDOR_LEN + 1];
+	char model[INQUIRY_MODEL_LEN + 1];
+	char revision[INQUIRY_REVISION_LEN + 1];
 	char unit_serial[INQUIRY_VPD_SERIAL_LEN];
 	spinlock_t t10_vpd_lock;
 	struct se_device *t10_dev;
-- 
2.13.7

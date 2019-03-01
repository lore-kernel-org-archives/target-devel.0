From: Alan Adamson <alan.adamson@oracle.com>
Date: Fri, 01 Mar 2019 22:44:20 +0000
Subject: [PATCH] scsi: target: add device product id and revision configfs attributes
Message-Id: <1551480260-1265-1-git-send-email-alan.adamson@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The product_id and revision attributes will allow for the modification
of the T10 Model and Revision strings returned in inquiry responses.
Its value can be viewed and modified via the ConfigFS path at:

target/core/$backstore/$name/wwn/product_id
target/core/$backstore/$name/wwn/revision

Signed-off-by: Alan Adamson <alan.adamson@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 drivers/target/target_core_configfs.c | 157 ++++++++++++++++++++++++++++++----
 1 file changed, 142 insertions(+), 15 deletions(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 8e7fffbb8802..a405733e30d9 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1231,6 +1231,29 @@ static struct t10_wwn *to_t10_wwn(struct config_item *item)
 	return container_of(to_config_group(item), struct t10_wwn, t10_wwn_group);
 }
 
+static ssize_t target_check_inquiry_data(char *buf)
+{
+	size_t len;
+	int i;
+
+	len = strlen(buf);
+
+	/*
+	 * SPC 4.3.1:
+	 * ASCII data fields shall contain only ASCII printable characters
+	 * (i.e., code values 20h to 7Eh) and may be terminated with one or
+	 * more ASCII null (00h) characters.
+	 */
+	for (i = 0; i < len; i++) {
+		if ((buf[i] < 0x20) || (buf[i] > 0x7E)) {
+			pr_err("Emulated T10 Inquiry Data contains non-ASCII-printable characters\n");
+			return -EINVAL;
+		}
+	}
+
+	return len;
+}
+
 /*
  * STANDARD and VPD page 0x83 T10 Vendor Identification
  */
@@ -1248,8 +1271,7 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
 	unsigned char buf[INQUIRY_VENDOR_LEN + 2];
 	char *stripped = NULL;
-	size_t len;
-	int i;
+	size_t len, ret;
 
 	len = strlcpy(buf, page, sizeof(buf));
 	if (len < sizeof(buf)) {
@@ -1264,19 +1286,10 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 		return -EOVERFLOW;
 	}
 
-	/*
-	 * SPC 4.3.1:
-	 * ASCII data fields shall contain only ASCII printable characters (i.e.,
-	 * code values 20h to 7Eh) and may be terminated with one or more ASCII
-	 * null (00h) characters.
-	 */
-	for (i = 0; i < len; i++) {
-		if ((stripped[i] < 0x20) || (stripped[i] > 0x7E)) {
-			pr_err("Emulated T10 Vendor Identification contains"
-				" non-ASCII-printable characters\n");
-			return -EINVAL;
-		}
-	}
+	ret = target_check_inquiry_data(stripped);
+
+	if (ret < 0)
+		return ret;
 
 	/*
 	 * Check to see if any active exports exist.  If they do exist, fail
@@ -1299,6 +1312,116 @@ static ssize_t target_wwn_vendor_id_store(struct config_item *item,
 	return count;
 }
 
+static ssize_t target_wwn_product_id_show(struct config_item *item,
+		char *page)
+{
+	return sprintf(page, "%s\n", &to_t10_wwn(item)->model[0]);
+}
+
+static ssize_t target_wwn_product_id_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct t10_wwn *t10_wwn = to_t10_wwn(item);
+	struct se_device *dev = t10_wwn->t10_dev;
+	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
+	unsigned char buf[INQUIRY_MODEL_LEN + 2];
+	char *stripped = NULL;
+	size_t len, ret;
+
+	len = strlcpy(buf, page, sizeof(buf));
+	if (len < sizeof(buf)) {
+		/* Strip any newline added from userspace. */
+		stripped = strstrip(buf);
+		len = strlen(stripped);
+	}
+	if (len > INQUIRY_MODEL_LEN) {
+		pr_err("Emulated T10 Vendor exceeds INQUIRY_MODEL_LEN: "
+			 __stringify(INQUIRY_MODEL_LEN)
+			"\n");
+		return -EOVERFLOW;
+	}
+
+	ret = target_check_inquiry_data(stripped);
+
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Check to see if any active exports exist.  If they do exist, fail
+	 * here as changing this information on the fly (underneath the
+	 * initiator side OS dependent multipath code) could cause negative
+	 * effects.
+	 */
+	if (dev->export_count) {
+		pr_err("Unable to set T10 Model while active %d exports exist\n",
+			dev->export_count);
+		return -EINVAL;
+	}
+
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
+	strlcpy(dev->t10_wwn.model, stripped, sizeof(dev->t10_wwn.model));
+
+	pr_debug("Target_Core_ConfigFS: Set emulated T10 Model Identification: %s\n",
+		 dev->t10_wwn.model);
+
+	return count;
+}
+
+static ssize_t target_wwn_revision_show(struct config_item *item,
+		char *page)
+{
+	return sprintf(page, "%s\n", &to_t10_wwn(item)->revision[0]);
+}
+
+static ssize_t target_wwn_revision_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct t10_wwn *t10_wwn = to_t10_wwn(item);
+	struct se_device *dev = t10_wwn->t10_dev;
+	/* +2 to allow for a trailing (stripped) '\n' and null-terminator */
+	unsigned char buf[INQUIRY_REVISION_LEN + 2];
+	char *stripped = NULL;
+	size_t len, ret;
+
+	len = strlcpy(buf, page, sizeof(buf));
+	if (len < sizeof(buf)) {
+		/* Strip any newline added from userspace. */
+		stripped = strstrip(buf);
+		len = strlen(stripped);
+	}
+	if (len > INQUIRY_REVISION_LEN) {
+		pr_err("Emulated T10 Revision exceeds INQUIRY_REVISION_LEN: "
+			 __stringify(INQUIRY_REVISION_LEN)
+			"\n");
+		return -EOVERFLOW;
+	}
+
+	ret = target_check_inquiry_data(stripped);
+
+	if (ret < 0)
+		return ret;
+
+	/*
+	 * Check to see if any active exports exist.  If they do exist, fail
+	 * here as changing this information on the fly (underneath the
+	 * initiator side OS dependent multipath code) could cause negative
+	 * effects.
+	 */
+	if (dev->export_count) {
+		pr_err("Unable to set T10 Revision while active %d exports exist\n",
+			dev->export_count);
+		return -EINVAL;
+	}
+
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
+	strlcpy(dev->t10_wwn.revision, stripped, sizeof(dev->t10_wwn.revision));
+
+	pr_debug("Target_Core_ConfigFS: Set emulated T10 Revision: %s\n",
+		 dev->t10_wwn.revision);
+
+	return count;
+}
+
 /*
  * VPD page 0x80 Unit serial
  */
@@ -1446,6 +1569,8 @@ static ssize_t target_wwn_vpd_protocol_identifier_show(struct config_item *item,
 DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_scsi_target_device, 0x20);
 
 CONFIGFS_ATTR(target_wwn_, vendor_id);
+CONFIGFS_ATTR(target_wwn_, product_id);
+CONFIGFS_ATTR(target_wwn_, revision);
 CONFIGFS_ATTR(target_wwn_, vpd_unit_serial);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_protocol_identifier);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_logical_unit);
@@ -1454,6 +1579,8 @@ static ssize_t target_wwn_vpd_protocol_identifier_show(struct config_item *item,
 
 static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
 	&target_wwn_attr_vendor_id,
+	&target_wwn_attr_product_id,
+	&target_wwn_attr_revision,
 	&target_wwn_attr_vpd_unit_serial,
 	&target_wwn_attr_vpd_protocol_identifier,
 	&target_wwn_attr_vpd_assoc_logical_unit,
-- 
1.8.3.1

From: David Disseldorp <ddiss@suse.de>
Date: Mon, 19 Nov 2018 21:06:35 +0000
Subject: [PATCH v3 3/4] target: add device vendor_id configfs attribute
Message-Id: <20181119210636.22979-4-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The vendor_id attribute will allow for the modification of the T10
Vendor Identification string returned in inquiry responses. Its value
can be viewed and modified via the ConfigFS path at:
target/core/$backstore/$name/wwn/vendor_id

"LIO-ORG" remains the default value, which is set when the backstore
device is enabled.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_configfs.c | 55 +++++++++++++++++++++++++++++++++++
 include/target/target_core_base.h     |  3 +-
 2 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index f6b1549f4142..64e95376d998 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1211,6 +1211,59 @@ static struct t10_wwn *to_t10_wwn(struct config_item *item)
 }
 
 /*
+ * STANDARD and VPD page 0x80 T10 Vendor Identification
+ */
+static ssize_t target_wwn_vendor_id_show(struct config_item *item,
+		char *page)
+{
+	return sprintf(page, "T10 Vendor Identification: %."
+		       __stringify(INQUIRY_VENDOR_IDENTIFIER_LEN) "s\n",
+		       &to_t10_wwn(item)->vendor[0]);
+}
+
+static ssize_t target_wwn_vendor_id_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct t10_wwn *t10_wwn = to_t10_wwn(item);
+	struct se_device *dev = t10_wwn->t10_dev;
+	/* +1 to ensure buf is zero terminated for stripping */
+	unsigned char buf[INQUIRY_VENDOR_IDENTIFIER_LEN + 1];
+
+	if (strlen(page) > INQUIRY_VENDOR_IDENTIFIER_LEN) {
+		pr_err("Emulated T10 Vendor Identification exceeds"
+			" INQUIRY_VENDOR_IDENTIFIER_LEN: %d\n",
+			INQUIRY_VENDOR_IDENTIFIER_LEN);
+		return -EOVERFLOW;
+	}
+	strncpy(buf, page, sizeof(buf));
+	/*
+	 * Check to see if any active $FABRIC_MOD exports exist.  If they
+	 * do exist, fail here as changing this information on the fly
+	 * (underneath the initiator side OS dependent multipath code)
+	 * could cause negative effects.
+	 */
+	if (dev->export_count) {
+		pr_err("Unable to set T10 Vendor Identification while"
+			" active %d $FABRIC_MOD exports exist\n",
+			dev->export_count);
+		return -EINVAL;
+	}
+
+	/*
+	 * Assume ASCII encoding. Strip any newline added from userspace.
+	 * The result may *not* be null terminated.
+	 */
+	strncpy(dev->t10_wwn.vendor, strstrip(buf),
+		INQUIRY_VENDOR_IDENTIFIER_LEN);
+
+	pr_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identification:"
+		 " %." __stringify(INQUIRY_VENDOR_IDENTIFIER_LEN) "s\n",
+		 dev->t10_wwn.vendor);
+
+	return count;
+}
+
+/*
  * VPD page 0x80 Unit serial
  */
 static ssize_t target_wwn_vpd_unit_serial_show(struct config_item *item,
@@ -1356,6 +1409,7 @@ DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_target_port, 0x10);
 /* VPD page 0x83 Association: SCSI Target Device */
 DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_scsi_target_device, 0x20);
 
+CONFIGFS_ATTR(target_wwn_, vendor_id);
 CONFIGFS_ATTR(target_wwn_, vpd_unit_serial);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_protocol_identifier);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_logical_unit);
@@ -1363,6 +1417,7 @@ CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_target_port);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_scsi_target_device);
 
 static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
+	&target_wwn_attr_vendor_id,
 	&target_wwn_attr_vpd_unit_serial,
 	&target_wwn_attr_vpd_protocol_identifier,
 	&target_wwn_attr_vpd_assoc_logical_unit,
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index e3bdb0550a59..45be5427326d 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -45,6 +45,7 @@
 #define INQUIRY_VPD_SERIAL_LEN			254
 /* Used by transport_get_inquiry_vpd_device_ident() */
 #define INQUIRY_VPD_DEVICE_IDENTIFIER_LEN	254
+#define INQUIRY_VENDOR_IDENTIFIER_LEN		8
 
 /* Attempts before moving from SHORT to LONG */
 #define PYX_TRANSPORT_WINDOW_CLOSED_THRESHOLD	3
@@ -314,7 +315,7 @@ struct t10_vpd {
 };
 
 struct t10_wwn {
-	char vendor[8];
+	char vendor[INQUIRY_VENDOR_IDENTIFIER_LEN];
 	char model[16];
 	char revision[4];
 	char unit_serial[INQUIRY_VPD_SERIAL_LEN];
-- 
2.13.7

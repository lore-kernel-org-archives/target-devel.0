From: David Disseldorp <ddiss@suse.de>
Date: Tue, 04 Dec 2018 10:12:36 +0000
Subject: [PATCH v6 3/5] target: add device vendor_id configfs attribute
Message-Id: <20181204101238.20587-4-ddiss@suse.de>
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
Reviewed-by: Bryant G. Ly <bly@catalogicsoftware.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_configfs.c | 48 +++++++++++++++++++++++++++++++++++
 1 file changed, 48 insertions(+)

diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
index 34872f24e8bf..67303c3f9cb4 100644
--- a/drivers/target/target_core_configfs.c
+++ b/drivers/target/target_core_configfs.c
@@ -1217,6 +1217,52 @@ static struct t10_wwn *to_t10_wwn(struct config_item *item)
 }
 
 /*
+ * STANDARD and VPD page 0x80 T10 Vendor Identification
+ */
+static ssize_t target_wwn_vendor_id_show(struct config_item *item,
+		char *page)
+{
+	return sprintf(page, "%s\n", &to_t10_wwn(item)->vendor[0]);
+}
+
+static ssize_t target_wwn_vendor_id_store(struct config_item *item,
+		const char *page, size_t count)
+{
+	struct t10_wwn *t10_wwn = to_t10_wwn(item);
+	struct se_device *dev = t10_wwn->t10_dev;
+	unsigned char buf[INQUIRY_VENDOR_LEN + 1];
+
+	if (strlen(page) > INQUIRY_VENDOR_LEN) {
+		pr_err("Emulated T10 Vendor Identification exceeds"
+			" INQUIRY_VENDOR_LEN: " __stringify(INQUIRY_VENDOR_LEN)
+			"\n");
+		return -EOVERFLOW;
+	}
+	strlcpy(buf, page, sizeof(buf));
+	/*
+	 * Check to see if any active exports exist.  If they do exist, fail
+	 * here as changing this information on the fly (underneath the
+	 * initiator side OS dependent multipath code) could cause negative
+	 * effects.
+	 */
+	if (dev->export_count) {
+		pr_err("Unable to set T10 Vendor Identification while"
+			" active %d exports exist\n", dev->export_count);
+		return -EINVAL;
+	}
+
+	/* Assume ASCII encoding. Strip any newline added from userspace. */
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
+	strlcpy(dev->t10_wwn.vendor, strstrip(buf),
+		sizeof(dev->t10_wwn.vendor));
+
+	pr_debug("Target_Core_ConfigFS: Set emulated T10 Vendor Identification:"
+		 " %s\n", dev->t10_wwn.vendor);
+
+	return count;
+}
+
+/*
  * VPD page 0x80 Unit serial
  */
 static ssize_t target_wwn_vpd_unit_serial_show(struct config_item *item,
@@ -1362,6 +1408,7 @@ DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_target_port, 0x10);
 /* VPD page 0x83 Association: SCSI Target Device */
 DEF_DEV_WWN_ASSOC_SHOW(vpd_assoc_scsi_target_device, 0x20);
 
+CONFIGFS_ATTR(target_wwn_, vendor_id);
 CONFIGFS_ATTR(target_wwn_, vpd_unit_serial);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_protocol_identifier);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_logical_unit);
@@ -1369,6 +1416,7 @@ CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_target_port);
 CONFIGFS_ATTR_RO(target_wwn_, vpd_assoc_scsi_target_device);
 
 static struct configfs_attribute *target_core_dev_wwn_attrs[] = {
+	&target_wwn_attr_vendor_id,
 	&target_wwn_attr_vpd_unit_serial,
 	&target_wwn_attr_vpd_protocol_identifier,
 	&target_wwn_attr_vpd_assoc_logical_unit,
-- 
2.13.7

From: David Disseldorp <ddiss@suse.de>
Date: Thu, 29 Nov 2018 01:01:54 +0000
Subject: [PATCH v4 4/7] target: consistently null-terminate t10_wwn.revision
Message-Id: <20181129010157.12687-5-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The pscsi_set_inquiry_info() codepath doesn't currently explicitly
null-terminate t10_wwn.revision.
Add an extra byte to the t10_wwn.model buffer and perform null string
termination in all cases.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_device.c | 6 ++++--
 drivers/target/target_core_pscsi.c  | 4 +++-
 drivers/target/target_core_spc.c    | 5 +++--
 drivers/target/target_core_stat.c   | 4 ++--
 include/target/target_core_base.h   | 3 ++-
 5 files changed, 14 insertions(+), 8 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 0d7382efb2d4..b3d0bd1ab09f 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -741,7 +741,7 @@ static void scsi_dump_inquiry(struct se_device *dev)
 	buf[i] = '\0';
 	pr_debug("  Model: %s\n", buf);
 
-	for (i = 0; i < 4; i++)
+	for (i = 0; i < INQUIRY_REVISION_LEN; i++)
 		if (wwn->revision[i] >= 0x20)
 			buf[i] = wwn->revision[i];
 		else
@@ -1010,6 +1010,7 @@ int target_configure_device(struct se_device *dev)
 	 */
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
 	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
+	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
 	if (!(dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)) {
 		strncpy(&dev->t10_wwn.vendor[0], "LIO-ORG", INQUIRY_VENDOR_LEN);
 		dev->t10_wwn.vendor[INQUIRY_VENDOR_LEN] = '\0';
@@ -1017,7 +1018,8 @@ int target_configure_device(struct se_device *dev)
 			dev->transport->inquiry_prod, INQUIRY_MODEL_LEN);
 		dev->t10_wwn.model[INQUIRY_MODEL_LEN] = '\0';
 		strncpy(&dev->t10_wwn.revision[0],
-			dev->transport->inquiry_rev, 4);
+			dev->transport->inquiry_rev, INQUIRY_REVISION_LEN);
+		dev->t10_wwn.revision[INQUIRY_REVISION_LEN] = '\0';
 	}
 
 	scsi_dump_inquiry(dev);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 1633babc2d4e..5493f620b7f4 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -196,7 +196,9 @@ pscsi_set_inquiry_info(struct scsi_device *sdev, struct t10_wwn *wwn)
 	BUILD_BUG_ON(sizeof(wwn->model) != INQUIRY_MODEL_LEN + 1);
 	memcpy(&wwn->model[0], &buf[16], INQUIRY_MODEL_LEN);
 	wwn->model[INQUIRY_MODEL_LEN] = '\0';
-	memcpy(&wwn->revision[0], &buf[32], sizeof(wwn->revision));
+	BUILD_BUG_ON(sizeof(wwn->revision) != INQUIRY_REVISION_LEN + 1);
+	memcpy(&wwn->revision[0], &buf[32], INQUIRY_REVISION_LEN);
+	wwn->revision[INQUIRY_REVISION_LEN] = '\0';
 }
 
 static int
diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 78eddee4b6e6..8ffe712cb44d 100644
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
 	       strnlen(dev->t10_wwn.model, INQUIRY_MODEL_LEN));
 	memcpy(&buf[32], dev->t10_wwn.revision,
-	       strnlen(dev->t10_wwn.revision, 4));
+	       strnlen(dev->t10_wwn.revision, INQUIRY_REVISION_LEN));
 	buf[4] = 31; /* Set additional length to 31 */
 
 	return 0;
diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
index 9123c5137da5..e437ba494865 100644
--- a/drivers/target/target_core_stat.c
+++ b/drivers/target/target_core_stat.c
@@ -275,10 +275,10 @@ static ssize_t target_stat_lu_rev_show(struct config_item *item, char *page)
 {
 	struct se_device *dev = to_stat_lu_dev(item);
 	int i;
-	char str[sizeof(dev->t10_wwn.revision)+1];
+	char str[INQUIRY_REVISION_LEN+1];
 
 	/* scsiLuRevisionId */
-	for (i = 0; i < sizeof(dev->t10_wwn.revision); i++)
+	for (i = 0; i < INQUIRY_REVISION_LEN; i++)
 		str[i] = ISPRINT(dev->t10_wwn.revision[i]) ?
 			dev->t10_wwn.revision[i] : ' ';
 	str[i] = '\0';
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index cfc279686cf4..497853a09fee 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -48,6 +48,7 @@
 
 #define INQUIRY_VENDOR_LEN			8
 #define INQUIRY_MODEL_LEN			16
+#define INQUIRY_REVISION_LEN			4
 
 /* Attempts before moving from SHORT to LONG */
 #define PYX_TRANSPORT_WINDOW_CLOSED_THRESHOLD	3
@@ -323,7 +324,7 @@ struct t10_wwn {
 	 */
 	char vendor[INQUIRY_VENDOR_LEN + 1];
 	char model[INQUIRY_MODEL_LEN + 1];
-	char revision[4];
+	char revision[INQUIRY_REVISION_LEN + 1];
 	char unit_serial[INQUIRY_VPD_SERIAL_LEN];
 	spinlock_t t10_vpd_lock;
 	struct se_device *t10_dev;
-- 
2.13.7

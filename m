From: David Disseldorp <ddiss@suse.de>
Date: Tue, 04 Dec 2018 10:12:37 +0000
Subject: [PATCH v6 4/5] target: remove hardcoded T10 Vendor ID in INQUIRY response
Message-Id: <20181204101238.20587-5-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Use the value stored in t10_wwn.vendor, which defaults to "LIO-ORG", but
can be reconfigured via the vendor_id ConfigFS attribute.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Bryant G. Ly <bly@catalogicsoftware.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 drivers/target/target_core_spc.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index 8ffe712cb44d..4503f3336bc2 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -115,7 +115,8 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	 */
 	memset(&buf[8], 0x20,
 	       INQUIRY_VENDOR_LEN + INQUIRY_MODEL_LEN + INQUIRY_REVISION_LEN);
-	memcpy(&buf[8], "LIO-ORG", sizeof("LIO-ORG") - 1);
+	memcpy(&buf[8], dev->t10_wwn.vendor,
+	       strnlen(dev->t10_wwn.vendor, INQUIRY_VENDOR_LEN));
 	memcpy(&buf[16], dev->t10_wwn.model,
 	       strnlen(dev->t10_wwn.model, INQUIRY_MODEL_LEN));
 	memcpy(&buf[32], dev->t10_wwn.revision,
@@ -258,8 +259,9 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	buf[off+1] = 0x1; /* T10 Vendor ID */
 	buf[off+2] = 0x0;
 	/* left align Vendor ID and pad with spaces */
-	memset(&buf[off+4], 0x20, 8);
-	memcpy(&buf[off+4], "LIO-ORG", sizeof("LIO-ORG") - 1);
+	memset(&buf[off+4], 0x20, INQUIRY_VENDOR_LEN);
+	memcpy(&buf[off+4], dev->t10_wwn.vendor,
+	       strnlen(dev->t10_wwn.vendor, INQUIRY_VENDOR_LEN));
 	/* Extra Byte for NULL Terminator */
 	id_len++;
 	/* Identifier Length */
-- 
2.13.7

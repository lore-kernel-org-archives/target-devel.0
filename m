From: David Disseldorp <ddiss@suse.de>
Date: Wed, 05 Dec 2018 12:18:34 +0000
Subject: [PATCH v7 1/5] target: use consistent left-aligned ASCII INQUIRY data
Message-Id: <20181205121838.23982-2-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

spc5r17.pdf specifies:
  4.3.1 ASCII data field requirements
  ASCII data fields shall contain only ASCII printable characters (i.e.,
  code values 20h to 7Eh) and may be terminated with one or more ASCII
  null (00h) characters.
  ASCII data fields described as being left-aligned shall have any
  unused bytes at the end of the field (i.e., highest offset) and the
  unused bytes shall be filled with ASCII space characters (20h).

LIO currently space-pads the T10 VENDOR IDENTIFICATION and PRODUCT
IDENTIFICATION fields in the standard INQUIRY data. However, the
PRODUCT REVISION LEVEL field in the standard INQUIRY data as well as the
T10 VENDOR IDENTIFICATION field in the INQUIRY Device Identification VPD
Page are zero-terminated/zero-padded.

Fix this inconsistency by using space-padding for all of the above
fields.

Signed-off-by: David Disseldorp <ddiss@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Bryant G. Ly <bly@catalogicsoftware.com>
Reviewed-by: Lee Duncan <lduncan@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
---
 drivers/target/target_core_spc.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index f459118bc11b..c37dd36ec77d 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -108,12 +108,17 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 
 	buf[7] = 0x2; /* CmdQue=1 */
 
-	memcpy(&buf[8], "LIO-ORG ", 8);
-	memset(&buf[16], 0x20, 16);
+	/*
+	 * ASCII data fields described as being left-aligned shall have any
+	 * unused bytes at the end of the field (i.e., highest offset) and the
+	 * unused bytes shall be filled with ASCII space characters (20h).
+	 */
+	memset(&buf[8], 0x20, 8 + 16 + 4);
+	memcpy(&buf[8], "LIO-ORG", sizeof("LIO-ORG") - 1);
 	memcpy(&buf[16], dev->t10_wwn.model,
-	       min_t(size_t, strlen(dev->t10_wwn.model), 16));
+	       strnlen(dev->t10_wwn.model, 16));
 	memcpy(&buf[32], dev->t10_wwn.revision,
-	       min_t(size_t, strlen(dev->t10_wwn.revision), 4));
+	       strnlen(dev->t10_wwn.revision, 4));
 	buf[4] = 31; /* Set additional length to 31 */
 
 	return 0;
@@ -251,7 +256,9 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	buf[off] = 0x2; /* ASCII */
 	buf[off+1] = 0x1; /* T10 Vendor ID */
 	buf[off+2] = 0x0;
-	memcpy(&buf[off+4], "LIO-ORG", 8);
+	/* left align Vendor ID and pad with spaces */
+	memset(&buf[off+4], 0x20, 8);
+	memcpy(&buf[off+4], "LIO-ORG", sizeof("LIO-ORG") - 1);
 	/* Extra Byte for NULL Terminator */
 	id_len++;
 	/* Identifier Length */
-- 
2.13.7

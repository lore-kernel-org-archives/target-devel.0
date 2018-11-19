From: David Disseldorp <ddiss@suse.de>
Date: Mon, 19 Nov 2018 21:06:36 +0000
Subject: [PATCH v3 4/4] target: remove hardcoded T10 Vendor ID in INQUIRY response
Message-Id: <20181119210636.22979-5-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Use the value stored in t10_wwn.vendor, which defaults to "LIO-ORG", but
can be reconfigured via the vendor_id ConfigFS attribute.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_spc.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
index c37dd36ec77d..7e8582d7f4a4 100644
--- a/drivers/target/target_core_spc.c
+++ b/drivers/target/target_core_spc.c
@@ -114,7 +114,8 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
 	 * unused bytes shall be filled with ASCII space characters (20h).
 	 */
 	memset(&buf[8], 0x20, 8 + 16 + 4);
-	memcpy(&buf[8], "LIO-ORG", sizeof("LIO-ORG") - 1);
+	memcpy(&buf[8], dev->t10_wwn.vendor,
+	       strnlen(dev->t10_wwn.vendor, 8));
 	memcpy(&buf[16], dev->t10_wwn.model,
 	       strnlen(dev->t10_wwn.model, 16));
 	memcpy(&buf[32], dev->t10_wwn.revision,
@@ -258,7 +259,8 @@ spc_emulate_evpd_83(struct se_cmd *cmd, unsigned char *buf)
 	buf[off+2] = 0x0;
 	/* left align Vendor ID and pad with spaces */
 	memset(&buf[off+4], 0x20, 8);
-	memcpy(&buf[off+4], "LIO-ORG", sizeof("LIO-ORG") - 1);
+	memcpy(&buf[off+4], dev->t10_wwn.vendor,
+	       strnlen(dev->t10_wwn.vendor, 8));
 	/* Extra Byte for NULL Terminator */
 	id_len++;
 	/* Identifier Length */
-- 
2.13.7

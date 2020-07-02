From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 02 Jul 2020 01:43:21 +0000
Subject: [PATCH 5/7] target: fix iscsi transport id buffer setup
Message-Id: <1593654203-12442-6-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, bstroesser@ts.fujitsu.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

This fixes the following bugs with the transport id setup for iscsi:

1. Incorrectly adding NULL after initiator name for TPID format 1.

2. For TPID format 1 buffer setup we are doing off+len, off++ and
then also len+=some_value. This results in the isid going past buffer
boundaries when we then do buf[off+len]

3. The pr_reg_isid is the isid in string format which is 12 bytes, but
we are only copying 6 bytes.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
V2:
- Drop chunk that dropped format code.

 drivers/target/target_core_fabric_lib.c | 72 ++++++++++++++++-----------------
 1 file changed, 35 insertions(+), 37 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 81bc8ec..428e5a1 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -136,29 +136,22 @@ static int iscsi_get_pr_transport_id(
 
 	spin_lock_irq(&se_nacl->nacl_sess_lock);
 	/*
-	 * From spc4r17 Section 7.5.4.6: TransportID for initiator
-	 * ports using SCSI over iSCSI.
+	 * Only null terminate the last field.
 	 *
-	 * The null-terminated, null-padded (see 4.4.2) ISCSI NAME field
-	 * shall contain the iSCSI name of an iSCSI initiator node (see
-	 * RFC 3720). The first ISCSI NAME field byte containing an ASCII
-	 * null character terminates the ISCSI NAME field without regard for
-	 * the specified length of the iSCSI TransportID or the contents of
-	 * the ADDITIONAL LENGTH field.
-	 */
-	len = sprintf(&buf[off], "%s", se_nacl->initiatorname);
-	/*
-	 * Add Extra byte for NULL terminator
-	 */
-	len++;
-	/*
-	 * If there is ISID present with the registration and *format code = 1
-	 * 1, use iSCSI Initiator port TransportID format.
+	 * From spc4r37 section 7.6.4.6: TransportID for initiator ports using
+	 * SCSI over iSCSI.
 	 *
-	 * Otherwise use iSCSI Initiator device TransportID format that
-	 * does not contain the ASCII encoded iSCSI Initiator iSID value
-	 * provied by the iSCSi Initiator during the iSCSI login process.
+	 * Table 507 TPID=0 Initiator device TransportID
+	 *
+	 * The null-terminated, null-padded (see 4.3.2) ISCSI NAME field shall
+	 * contain the iSCSI name of an iSCSI initiator node (see RFC 7143).
+	 * The first ISCSI NAME field byte containing an ASCII null character
+	 * terminates the ISCSI NAME field without regard for the specified
+	 * length of the iSCSI TransportID or the contents of the ADDITIONAL
+	 * LENGTH field.
 	 */
+	len = sprintf(&buf[off], "%s", se_nacl->initiatorname);
+	off += len;
 	if ((*format_code = 1) && (pr_reg->isid_present_at_reg)) {
 		/*
 		 * Set FORMAT CODE 01b for iSCSI Initiator port TransportID
@@ -166,8 +159,12 @@ static int iscsi_get_pr_transport_id(
 		 */
 		buf[0] |= 0x40;
 		/*
-		 * From spc4r17 Section 7.5.4.6: TransportID for initiator
-		 * ports using SCSI over iSCSI.  Table 390
+		 * From spc4r37 Section 7.6.4.6
+		 *
+		 * Table 508 TPID=1 Initiator port TransportID.
+		 *
+		 * The ISCSI NAME field shall not be null-terminated
+		 * (see 4.3.2) and shall not be padded.
 		 *
 		 * The SEPARATOR field shall contain the five ASCII
 		 * characters ",i,0x".
@@ -177,23 +174,24 @@ static int iscsi_get_pr_transport_id(
 		 * (see RFC 3720) in the form of ASCII characters that are the
 		 * hexadecimal digits converted from the binary iSCSI initiator
 		 * session identifier value. The first ISCSI INITIATOR SESSION
-		 * ID field byte containing an ASCII null character
+		 * ID field byte containing an ASCII null character terminates
+		 * the ISCSI INITIATOR SESSION ID field without regard for the
+		 * specified length of the iSCSI TransportID or the contents
+		 * of the ADDITIONAL LENGTH field.
 		 */
-		buf[off+len] = 0x2c; off++; /* ASCII Character: "," */
-		buf[off+len] = 0x69; off++; /* ASCII Character: "i" */
-		buf[off+len] = 0x2c; off++; /* ASCII Character: "," */
-		buf[off+len] = 0x30; off++; /* ASCII Character: "0" */
-		buf[off+len] = 0x78; off++; /* ASCII Character: "x" */
-		len += 5;
-		buf[off+len] = pr_reg->pr_reg_isid[0]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[1]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[2]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[3]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[4]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[5]; off++;
-		buf[off+len] = '\0'; off++;
-		len += 7;
+		buf[off++] = 0x2c; /* ASCII Character: "," */
+		buf[off++] = 0x69; /* ASCII Character: "i" */
+		buf[off++] = 0x2c; /* ASCII Character: "," */
+		buf[off++] = 0x30; /* ASCII Character: "0" */
+		buf[off++] = 0x78; /* ASCII Character: "x" */
+
+		memcpy(buf + off, pr_reg->pr_reg_isid, 12);
+		off += 12;
+
+		len += 17;
 	}
+	buf[off] = '\0';
+	len += 1;
 	spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	/*
 	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
-- 
1.8.3.1

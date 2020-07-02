From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 02 Jul 2020 01:43:23 +0000
Subject: [PATCH 7/7] target: handle short iSIDs
Message-Id: <1593654203-12442-8-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, bstroesser@ts.fujitsu.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

SPC4 has:

The first ISCSI INITIATOR SESSION ID field byte containing an ASCII
null character terminates the ISCSI INITIATOR SESSION ID field without
regard for the specified length of the iSCSI TransportID or the contents
of the ADDITIONAL LENGTH field.
----------------------------------------

which sounds like we can get an iSID shorter than 12 chars. SPC and
the iSCSI RFC do not say how to handle that case other than just
cutting off the iSID. This patch just makes sure that if we get an
iSID like that, we only copy/send that string.

There is no OS that does this right now, so there was no test case.
I did test with sg utils to check it works as expected and nothing
breaks.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_lib.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 1d2762a..6600ae4 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -132,6 +132,7 @@ static int iscsi_get_pr_transport_id(
 	unsigned char *buf)
 {
 	u32 off = 4, padding = 0;
+	int isid_len;
 	u16 len = 0;
 
 	spin_lock_irq(&se_nacl->nacl_sess_lock);
@@ -184,11 +185,11 @@ static int iscsi_get_pr_transport_id(
 		buf[off++] = 0x2c; /* ASCII Character: "," */
 		buf[off++] = 0x30; /* ASCII Character: "0" */
 		buf[off++] = 0x78; /* ASCII Character: "x" */
+		len += 5;
 
-		memcpy(buf + off, pr_reg->pr_reg_isid, 12);
-		off += 12;
-
-		len += 17;
+		isid_len = sprintf(buf + off, "%s", pr_reg->pr_reg_isid);
+		off += isid_len;
+		len += isid_len;
 	}
 	buf[off] = '\0';
 	len += 1;
@@ -234,7 +235,7 @@ static int iscsi_get_pr_transport_id_len(
 	 */
 	if (pr_reg->isid_present_at_reg) {
 		len += 5; /* For ",i,0x" ASCII separator */
-		len += 12; /* For iSCSI Initiator Session ID */
+		len += strlen(pr_reg->pr_reg_isid);
 		*format_code = 1;
 	} else
 		*format_code = 0;
@@ -318,6 +319,16 @@ static char *iscsi_parse_pr_out_transport_id(
 		 * iscsi_target.c:lio_sess_get_initiator_sid()
 		 */
 		for (i = 0; i < 12; i++) {
+			/*
+			 * The first ISCSI INITIATOR SESSION ID field byte
+			 * containing an ASCII null character terminates the
+			 * ISCSI INITIATOR SESSION ID field without regard for
+			 * the specified length of the iSCSI TransportID or the
+			 * contents of the ADDITIONAL LENGTH field.
+			 */
+			if (*p = '\0')
+				break;
+
 			if (isdigit(*p)) {
 				p++;
 				continue;
-- 
1.8.3.1

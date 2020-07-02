From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 02 Jul 2020 01:43:20 +0000
Subject: [PATCH 4/7] target: fix iscsi transport id parsing
Message-Id: <1593654203-12442-5-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, bstroesser@ts.fujitsu.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The length passed in the ADDITIONAL LENGTH field includes padding and
the terminating NULL for the last field (name or isid depending on the
format), so we should not also try to calculate that and then double add
that to the returned length.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_lib.c | 22 ++++------------------
 1 file changed, 4 insertions(+), 18 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 1e031d8..81bc8ec 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -265,9 +265,7 @@ static char *iscsi_parse_pr_out_transport_id(
 	char **port_nexus_ptr)
 {
 	char *p;
-	u32 tid_len, padding;
 	int i;
-	u16 add_len;
 	u8 format_code = (buf[0] & 0xc0);
 	/*
 	 * Check for FORMAT CODE 00b or 01b from spc4r17, section 7.5.4.6:
@@ -293,23 +291,11 @@ static char *iscsi_parse_pr_out_transport_id(
 	 */
 	if (out_tid_len) {
 		/* The shift works thanks to integer promotion rules */
-		add_len = get_unaligned_be16(&buf[2]);
-
-		tid_len = strlen(&buf[4]);
-		tid_len += 4; /* Add four bytes for iSCSI Transport ID header */
-		tid_len += 1; /* Add one byte for NULL terminator */
-		padding = ((-tid_len) & 3);
-		if (padding != 0)
-			tid_len += padding;
-
-		if ((add_len + 4) != tid_len) {
-			pr_debug("LIO-Target Extracted add_len: %hu "
-				"does not match calculated tid_len: %u,"
-				" using tid_len instead\n", add_len+4, tid_len);
-			*out_tid_len = tid_len;
-		} else
-			*out_tid_len = (add_len + 4);
+		*out_tid_len = get_unaligned_be16(&buf[2]);
+		/* Add four bytes for iSCSI Transport ID header */
+		*out_tid_len += 4;
 	}
+
 	/*
 	 * Check for ',i,0x' separator between iSCSI Name and iSCSI Initiator
 	 * Session ID as defined in Table 390 - iSCSI initiator port TransportID
-- 
1.8.3.1

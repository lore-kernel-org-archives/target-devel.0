From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 06 Apr 2020 18:29:51 +0000
Subject: [PATCH] target: pr: fix PR IN, READ FULL STATUS
Message-Id: <20200406182951.17446-1-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

AFAICS there are some problems in target_core_fabric_lib.c
that afflict PERSISTENT RESERVE IN / READ FULL STATUS command.

1) Creation of the response to READ FULL STATUS fails for FC
   based reservations. Reason is the too high loop limit (< 24)
   in fc_get_pr_transport_id(). The string representation of FC
   WWPN is 23 chars long only ("11:22:33:44:55:66:77:88"). So
   when i is 23, the loop body is executed a last time for the
   ending '\0' of the string and thus hex2bin() reports an error.

2) For iSCSI based reservations that include an ISID, the
   reported TRANSPORT ID is wrong. This has two reasons:
   a) The code inserts an NULL byte between the ISCSI Name and
      the SEPARATOR
   b) Only the first 6 chars of the ISID are appended. AFAIK,
      binary ISID is 48 bits, so 12 chars might be necessary.

The last hunk in this patch fixes a minor flaw that could be
triggered by a PR OUT RESERVE on iSCSI, if TRANSPORT IDs with
and without ISID are used in the same command. I don't know, if
that ever could happen, but with the change the code is cleaner,
I think.

This patch is based on code review only. It compiles fine, but
unfortunately I wasn't able to test.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_fabric_lib.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 6b4b354c88aa..8a726076ae56 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -63,7 +63,7 @@ static int fc_get_pr_transport_id(
 	 * encoded TransportID.
 	 */
 	ptr = &se_nacl->initiatorname[0];
-	for (i = 0; i < 24; ) {
+	for (i = 0; i < 23; ) {
 		if (!strncmp(&ptr[i], ":", 1)) {
 			i++;
 			continue;
@@ -148,10 +148,6 @@ static int iscsi_get_pr_transport_id(
 	 */
 	len = sprintf(&buf[off], "%s", se_nacl->initiatorname);
 	/*
-	 * Add Extra byte for NULL terminator
-	 */
-	len++;
-	/*
 	 * If there is ISID present with the registration and *format code = 1
 	 * 1, use iSCSI Initiator port TransportID format.
 	 *
@@ -185,17 +181,15 @@ static int iscsi_get_pr_transport_id(
 		buf[off+len] = 0x30; off++; /* ASCII Character: "0" */
 		buf[off+len] = 0x78; off++; /* ASCII Character: "x" */
 		len += 5;
-		buf[off+len] = pr_reg->pr_reg_isid[0]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[1]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[2]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[3]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[4]; off++;
-		buf[off+len] = pr_reg->pr_reg_isid[5]; off++;
-		buf[off+len] = '\0'; off++;
-		len += 7;
+		len += snprintf(&buf[off+len], PR_REG_ISID_LEN, "%s",
+		                pr_reg->pr_reg_isid);
 	}
 	spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	/*
+	 * Add Extra byte for NULL terminator
+	 */
+	len++;
+	/*
 	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
 	 * in the TransportID. The additional length shall be at least 20 and
 	 * shall be a multiple of four.
@@ -224,10 +218,6 @@ static int iscsi_get_pr_transport_id_len(
 	spin_lock_irq(&se_nacl->nacl_sess_lock);
 	len = strlen(se_nacl->initiatorname);
 	/*
-	 * Add extra byte for NULL terminator
-	 */
-	len++;
-	/*
 	 * If there is ISID present with the registration, use format code:
 	 * 01b: iSCSI Initiator port TransportID format
 	 *
@@ -236,12 +226,16 @@ static int iscsi_get_pr_transport_id_len(
 	 */
 	if (pr_reg->isid_present_at_reg) {
 		len += 5; /* For ",i,0x" ASCII separator */
-		len += 7; /* For iSCSI Initiator Session ID + Null terminator */
+		len += strlen(pr_reg->pr_reg_isid); /* Initiator Session ID */
 		*format_code = 1;
 	} else
 		*format_code = 0;
 	spin_unlock_irq(&se_nacl->nacl_sess_lock);
 	/*
+	 * Add extra byte for NULL terminator
+	 */
+	len++;
+	/*
 	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
 	 * in the TransportID. The additional length shall be at least 20 and
 	 * shall be a multiple of four.
@@ -341,7 +335,8 @@ static char *iscsi_parse_pr_out_transport_id(
 			*p = tolower(*p);
 			p++;
 		}
-	}
+	} else
+		*port_nexus_ptr = NULL;
 
 	return &buf[4];
 }
-- 
2.12.3

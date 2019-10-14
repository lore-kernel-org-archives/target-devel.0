From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 14 Oct 2019 18:29:04 +0000
Subject: [PATCH] target: do not overwrite CDB byte 1
Message-Id: <12498eab-76fd-eaad-1316-c2827badb76a@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

passthrough_parse_cdb() - used by TCMU and PSCSI - attepts to
reset the LUN field of SCSI-2 CDBs (bits 5,6,7 of byte 1).
The current code is wrong, as for newer commands not having the
LUN field it overwrites relevant command bits (e.g. for SECURITY
PROTOCOL IN / OUT)
We think this code was unnecessary from the beginning or at least
it is no longer useful. So we remove it entirely.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
  drivers/target/target_core_device.c |   21 ---------------------
  1 file changed, 21 deletions(-)

--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -1075,27 +1075,6 @@ passthrough_parse_cdb(struct se_cmd *cmd
  	unsigned int size;
   	/*
-	 * Clear a lun set in the cdb if the initiator talking to use spoke
-	 * and old standards version, as we can't assume the underlying device
-	 * won't choke up on it.
-	 */
-	switch (cdb[0]) {
-	case READ_10: /* SBC - RDProtect */
-	case READ_12: /* SBC - RDProtect */
-	case READ_16: /* SBC - RDProtect */
-	case SEND_DIAGNOSTIC: /* SPC - SELF-TEST Code */
-	case VERIFY: /* SBC - VRProtect */
-	case VERIFY_16: /* SBC - VRProtect */
-	case WRITE_VERIFY: /* SBC - VRProtect */
-	case WRITE_VERIFY_12: /* SBC - VRProtect */
-	case MAINTENANCE_IN: /* SPC - Parameter Data Format for SA RTPG */
-		break;
-	default:
-		cdb[1] &= 0x1f; /* clear logical unit number */
-		break;
-	}
-
-	/*
  	 * For REPORT LUNS we always need to emulate the response, for everything
  	 * else, pass it up.
  	 */

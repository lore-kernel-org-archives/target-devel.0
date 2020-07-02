From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 02 Jul 2020 01:43:22 +0000
Subject: [PATCH 6/7] target: fix iscsi transport id buf len calculation
Message-Id: <1593654203-12442-7-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1593654203-12442-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, bstroesser@ts.fujitsu.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The isid returned to the initiator is in string format which is 12
bytes. We also only add 1 terminating NULL and not one after the
initiator name and another one after the isid.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/target/target_core_fabric_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 428e5a1..1d2762a 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -234,7 +234,7 @@ static int iscsi_get_pr_transport_id_len(
 	 */
 	if (pr_reg->isid_present_at_reg) {
 		len += 5; /* For ",i,0x" ASCII separator */
-		len += 7; /* For iSCSI Initiator Session ID + Null terminator */
+		len += 12; /* For iSCSI Initiator Session ID */
 		*format_code = 1;
 	} else
 		*format_code = 0;
-- 
1.8.3.1

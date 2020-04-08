From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Wed, 08 Apr 2020 13:26:10 +0000
Subject: [PATCH 2/2] target: fix PR IN / READ FULL STATUS for FC
Message-Id: <20200408132610.14623-3-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200408132610.14623-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, martin.petersen@oracle.com, Bodo Stroesser <bstroesser@ts.fujitsu.com>

Creation of the response to READ FULL STATUS fails for FC
based reservations. Reason is the too high loop limit (< 24)
in fc_get_pr_transport_id(). The string representation of FC
WWPN is 23 chars long only ("11:22:33:44:55:66:77:88"). So
when i is 23, the loop body is executed a last time for the
ending '\0' of the string and thus hex2bin() reports an error.

Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
---
 drivers/target/target_core_fabric_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index f5f673e128ef..1e031d81e59e 100644
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
-- 
2.12.3

From: David Disseldorp <ddiss@suse.de>
Date: Mon, 23 Mar 2020 16:54:06 +0000
Subject: [RFC PATCH 1/5] scsi: target: use #def for xcopy descriptor len
Message-Id: <20200323165410.24423-2-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200323165410.24423-1-ddiss@suse.de>
In-Reply-To: <20200323165410.24423-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org, David Disseldorp <ddiss@suse.de>

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_xcopy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 425c1070de08..7e5b13da0c20 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -134,7 +134,7 @@ static int target_xcopy_parse_tiddesc_e4(struct se_cmd *se_cmd, struct xcopy_op
 	 * Assigned designator
 	 */
 	desig_len = desc[7];
-	if (desig_len != 16) {
+	if (desig_len != XCOPY_NAA_IEEE_REGEX_LEN) {
 		pr_err("XCOPY 0xe4: invalid desig_len: %d\n", (int)desig_len);
 		return -EINVAL;
 	}
-- 
2.16.4

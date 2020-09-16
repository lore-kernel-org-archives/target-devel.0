From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date: Wed, 16 Sep 2020 23:54:31 +0000
Subject: [PATCH] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case.
Message-Id: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, michael.christie@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: ssudhakarp@gmail.com

transport_lookup_tmr_lun() uses "orig_fe_lun" member of struct se_cmd
for the lookup. Hence, update this field directly for the
TARGET_SCF_LOOKUP_LUN_FROM_TAG case.

Fixes: a36840d80027 ("target: Initialize LUN in transport_init_se_cmd()")
Reported-by: Martin Wilck <mwilck@suse.com>
Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
---
 drivers/target/target_core_transport.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 9fb0be0aa620..8dd289214dd8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1840,7 +1840,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
 	 * out unpacked_lun for the original se_cmd.
 	 */
 	if (tm_type = TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
-		if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
+		if (!target_lookup_lun_from_tag(se_sess, tag,
+						&se_cmd->orig_fe_lun))
 			goto failure;
 	}
 
-- 
1.8.3.1

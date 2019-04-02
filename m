From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:12 +0000
Subject: [PATCH 08/11] target/iscsi: Only send R2T if needed
Message-Id: <20190402195815.254796-9-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If an initiator submits more immediate data than the size derived from
the SCSI CDB, do not send any R2T to the initiator. This scenario is
triggered by the libiscsi test ALL.iSCSIResiduals.WriteVerify16Residuals
if the iSCSI target driver is modified to discard too large immediate
data buffers instead of trying to parse these as an iSCSI PDU. This
patch avoids that a negative xfer_len value is passed to
iscsit_add_r2t_to_list() if too large immediate data buffers are
handled correctly.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target.c      | 6 ++++++
 drivers/target/iscsi/iscsi_target_util.c | 2 ++
 2 files changed, 8 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 5ce6e2a40e00..828697015759 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -3121,6 +3121,12 @@ int iscsit_build_r2ts_for_cmd(
 				else
 					xfer_len = conn->sess->sess_ops->MaxBurstLength;
 			}
+
+			if ((s32)xfer_len < 0) {
+				cmd->cmd_flags |= ICF_SENT_LAST_R2T;
+				break;
+			}
+
 			cmd->r2t_offset += xfer_len;
 
 			if (cmd->r2t_offset = cmd->se_cmd.data_length)
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 3da062ccd2ab..5b26bc23016a 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -67,6 +67,8 @@ int iscsit_add_r2t_to_list(
 
 	lockdep_assert_held(&cmd->r2t_lock);
 
+	WARN_ON_ONCE((s32)xfer_len < 0);
+
 	r2t = kmem_cache_zalloc(lio_r2t_cache, GFP_ATOMIC);
 	if (!r2t) {
 		pr_err("Unable to allocate memory for struct iscsi_r2t.\n");
-- 
2.21.0.196.g041f5ea1cf98

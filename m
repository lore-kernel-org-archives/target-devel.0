From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:11 +0000
Subject: [PATCH 07/11] target/iscsi: Detect conn_cmd_list corruption early
Message-Id: <20190402195815.254796-8-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Certain behavior of an initiator can cause the target driver to
send both a reject and a SCSI response. If that happens two
target_put_sess_cmd() calls will occur without the command having
been removed from conn_cmd_list. In other words, conn_cmd_list
will get corrupted once the freed memory is reused. Although the
Linux kernel can detect list corruption if list debugging is
enabled, in this case the context in which list corruption is
detected is not related to the context that caused list corruption.
Hence add WARN_ON() statements that report the context that is
causing list corruption.

Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/iscsi_target_util.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 3ac494f63a0b..3da062ccd2ab 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -769,6 +769,8 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
 	int rc;
 
+	WARN_ON(!list_empty(&cmd->i_conn_node));
+
 	__iscsit_free_cmd(cmd, shutdown);
 	if (se_cmd) {
 		rc = transport_generic_free_cmd(se_cmd, shutdown);
-- 
2.21.0.196.g041f5ea1cf98

From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Tue, 31 Oct 2017 18:03:18 +0000
Subject: [PATCH 10/11] target/iscsi: Detect conn_cmd_list corruption early
Message-Id: <20171031180319.19258-11-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Certain behavior of the initiator can cause the target driver to
send both a reject and a SCSI response. If that happens two
target_put_sess_cmd() calls will occur without the command having
been removed from conn_cmd_list. In other words, conn_cmd_list
will get corrupted once the freed memory is reused. Although the
Linux kernel can detect list corruption if list debugging is
enabled, in this case the context in which list corruption is
detected is not related to the context that caused list corruption.
Hence add WARN_ON() statements that report the context that is
causing list corruption.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target_util.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 1e36f83b5961..70c6b9bfc04e 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -694,6 +694,8 @@ void iscsit_release_cmd(struct iscsi_cmd *cmd)
 	struct iscsi_session *sess;
 	struct se_cmd *se_cmd = &cmd->se_cmd;
 
+	WARN_ON(!list_empty(&cmd->i_conn_node));
+
 	if (cmd->conn)
 		sess = cmd->conn->sess;
 	else
@@ -716,6 +718,8 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
 {
 	struct iscsi_conn *conn = cmd->conn;
 
+	WARN_ON(!list_empty(&cmd->i_conn_node));
+
 	if (cmd->data_direction = DMA_TO_DEVICE) {
 		iscsit_stop_dataout_timer(cmd);
 		iscsit_free_r2ts_from_list(cmd);
-- 
2.14.2


From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Wed, 13 Dec 2017 23:50:29 +0000
Subject: [PATCH 11/11] target/iscsi: Reduce number of __iscsit_free_cmd() callers
Message-Id: <20171213235029.581-12-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Instead of calling __iscsit_free_cmd() from inside iscsit_aborted_task()
if a command has been aborted and from inside iscsit_free_cmd() if a
command has not been aborted, call __iscsit_free_cmd() from inside
lio_release_cmd(). The latter function is namely called for all commands
once the reference count has dropped to zero.

Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Varun Prakash <varun@chelsio.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/iscsi/iscsi_target.c          | 2 --
 drivers/target/iscsi/iscsi_target_configfs.c | 1 +
 drivers/target/iscsi/iscsi_target_util.c     | 4 +---
 3 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
index 9eb10d34682c..5b79e1d992bc 100644
--- a/drivers/target/iscsi/iscsi_target.c
+++ b/drivers/target/iscsi/iscsi_target.c
@@ -496,8 +496,6 @@ void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
 		list_del_init(&cmd->i_conn_node);
 	spin_unlock_bh(&conn->cmd_lock);
-
-	__iscsit_free_cmd(cmd, true);
 }
 EXPORT_SYMBOL(iscsit_aborted_task);
 
diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
index 0ebc4818e132..0bc346b2c27c 100644
--- a/drivers/target/iscsi/iscsi_target_configfs.c
+++ b/drivers/target/iscsi/iscsi_target_configfs.c
@@ -1546,6 +1546,7 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
 	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
 
 	pr_debug("Entering lio_release_cmd for se_cmd: %p\n", se_cmd);
+	__iscsit_free_cmd(cmd, true);
 	iscsit_release_cmd(cmd);
 }
 
diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
index 4435bf374d2d..7693bfcddf03 100644
--- a/drivers/target/iscsi/iscsi_target_util.c
+++ b/drivers/target/iscsi/iscsi_target_util.c
@@ -745,10 +745,8 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
 	__iscsit_free_cmd(cmd, shutdown);
 	if (se_cmd) {
 		rc = transport_generic_free_cmd(se_cmd, shutdown);
-		if (!rc && shutdown && se_cmd->se_sess) {
-			__iscsit_free_cmd(cmd, shutdown);
+		if (!rc && shutdown && se_cmd->se_sess)
 			target_put_sess_cmd(se_cmd);
-		}
 	} else {
 		iscsit_release_cmd(cmd);
 	}
-- 
2.15.1


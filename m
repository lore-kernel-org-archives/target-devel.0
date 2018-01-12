From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Fri, 12 Jan 2018 23:56:36 +0000
Subject: [PATCH-4.1.y 2/2] target: Avoid early CMD_T_PRE_EXECUTE failures during ABORT_TASK
Message-Id: <1515801396-31747-3-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1515801396-31747-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1515801396-31747-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>, Donald White <dew@datera.io>, Mike Christie <mchristi@redhat.com>, Hannes Reinecke <hare@suse.com>

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit 1c21a48055a67ceb693e9c2587824a8de60a217c upstream.

This patch fixes bug where early se_cmd exceptions that occur
before backend execution can result in use-after-free if/when
a subsequent ABORT_TASK occurs for the same tag.

Since an early se_cmd exception will have had se_cmd added to
se_session->sess_cmd_list via target_get_sess_cmd(), it will
not have CMD_T_COMPLETE set by the usual target_complete_cmd()
backend completion path.

This causes a subsequent ABORT_TASK + __target_check_io_state()
to signal ABORT_TASK should proceed.  As core_tmr_abort_task()
executes, it will bring the outstanding se_cmd->cmd_kref count
down to zero releasing se_cmd, after se_cmd has already been
queued with error status into fabric driver response path code.

To address this bug, introduce a CMD_T_PRE_EXECUTE bit that is
set at target_get_sess_cmd() time, and cleared immediately before
backend driver dispatch in target_execute_cmd() once CMD_T_ACTIVE
is set.

Then, check CMD_T_PRE_EXECUTE within __target_check_io_state() to
determine when an early exception has occured, and avoid aborting
this se_cmd since it will have already been queued into fabric
driver response path code.

Reported-by: Donald White <dew@datera.io>
Cc: Donald White <dew@datera.io>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_tmr.c       | 9 +++++++++
 drivers/target/target_core_transport.c | 2 ++
 include/target/target_core_base.h      | 1 +
 3 files changed, 12 insertions(+)

diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index 44510bd..03a73d5 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -137,6 +137,15 @@ static bool __target_check_io_state(struct se_cmd *se_cmd,
 		spin_unlock(&se_cmd->t_state_lock);
 		return false;
 	}
+	if (se_cmd->transport_state & CMD_T_PRE_EXECUTE) {
+		if (se_cmd->scsi_status) {
+			pr_debug("Attempted to abort io tag: %u early failure"
+				 " status: 0x%02x\n", se_cmd->se_tfo->get_task_tag(se_cmd),
+				 se_cmd->scsi_status);
+			spin_unlock(&se_cmd->t_state_lock);
+			return false;
+		}
+	}
 	if (sess->sess_tearing_down || se_cmd->cmd_wait_set) {
 		pr_debug("Attempted to abort io tag: %u already shutdown,"
 			" skipping\n", se_cmd->se_tfo->get_task_tag(se_cmd));
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 958b0dc..32593d8 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1899,6 +1899,7 @@ void target_execute_cmd(struct se_cmd *cmd)
 	}
 
 	cmd->t_state = TRANSPORT_PROCESSING;
+	cmd->transport_state &= ~CMD_T_PRE_EXECUTE;
 	cmd->transport_state |= CMD_T_ACTIVE|CMD_T_BUSY|CMD_T_SENT;
 	spin_unlock_irq(&cmd->t_state_lock);
 
@@ -2543,6 +2544,7 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
 		ret = -ESHUTDOWN;
 		goto out;
 	}
+	se_cmd->transport_state |= CMD_T_PRE_EXECUTE;
 	list_add_tail(&se_cmd->se_cmd_list, &se_sess->sess_cmd_list);
 out:
 	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index ad3c146..c654d9e 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -541,6 +541,7 @@ struct se_cmd {
 #define CMD_T_BUSY		(1 << 9)
 #define CMD_T_TAS		(1 << 10)
 #define CMD_T_FABRIC_STOP	(1 << 11)
+#define CMD_T_PRE_EXECUTE	(1 << 12)
 	spinlock_t		t_state_lock;
 	struct completion	t_transport_stop_comp;
 
-- 
1.8.5.3


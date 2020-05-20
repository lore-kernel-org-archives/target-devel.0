From: Pavel Zakharov <pavel.zakharov@delphix.com>
Date: Wed, 20 May 2020 15:50:54 +0000
Subject: Re: [PATCH] scsi: target: put lun_ref at end of tmr processing
Message-Id: <96A62932-C9F9-4BB3-88B4-9B0A879A155E@delphix.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200512161753.10625-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200512161753.10625-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

Hopefully I didn’t mess-up the recipients/Subject list as I just subscribed to target-devel and so following-up to an email I found in the archive.

Bodo, I happened to have run into the same issue and was just about to submit a similar patch when I randomly stumbled on yours.
I think we can improve on that patch by moving the call to transport_lun_remove_cmd() into transport_cmd_check_stop_to_fabric().

Here’s the patch I was about to propose. Let me know what you think.
Note that we could also do this simplification as a separate patch later if you think it’s better.

---
When ABORT and LUN RESET were made synchronous, a call to
transport_lun_remove_cmd() was acidentally removed. This caused a lun_ref
to be leaked every time an ABORT or LUN RESET was processed in
target_tmr_work().

Given that transport_lun_remove_cmd() should always be called before
transport_cmd_check_stop_to_fabric(), move that call into this function.
This ensures that the lun_ref is released before setting .se_lun to NULL.

Signed-off-by: Pavel Zakharov <pavel.zakharov@delphix.com>
---
 drivers/target/target_core_transport.c | 36 ++++++++++++--------------
 1 file changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 594b724bbf79..ec578822709a 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -653,6 +653,17 @@ static void target_remove_from_state_list(struct se_cmd *cmd)
 	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 }

+static void transport_lun_remove_cmd(struct se_cmd *cmd)
+{
+	struct se_lun *lun = cmd->se_lun;
+
+	if (!lun)
+		return;
+
+	if (cmpxchg(&cmd->lun_ref_active, true, false))
+		percpu_ref_put(&lun->lun_ref);
+}
+
 /*
  * This function is called by the target core after the target core has
  * finished processing a SCSI command or SCSI TMF. Both the regular command
@@ -664,6 +675,11 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 {
 	unsigned long flags;

+	/*
+	 * Remove cmd ref from lun if needed before clearing the se_lun.
+	 */
+	transport_lun_remove_cmd(cmd);
+
 	target_remove_from_state_list(cmd);

 	/*
@@ -698,17 +714,6 @@ static int transport_cmd_check_stop_to_fabric(struct se_cmd *cmd)
 	return cmd->se_tfo->check_stop_free(cmd);
 }

-static void transport_lun_remove_cmd(struct se_cmd *cmd)
-{
-	struct se_lun *lun = cmd->se_lun;
-
-	if (!lun)
-		return;
-
-	if (cmpxchg(&cmd->lun_ref_active, true, false))
-		percpu_ref_put(&lun->lun_ref);
-}
-
 static void target_complete_failure_work(struct work_struct *work)
 {
 	struct se_cmd *cmd = container_of(work, struct se_cmd, work);
@@ -799,8 +804,6 @@ static void target_handle_abort(struct se_cmd *cmd)

 	WARN_ON_ONCE(kref_read(&cmd->cmd_kref) == 0);

-	transport_lun_remove_cmd(cmd);
-
 	transport_cmd_check_stop_to_fabric(cmd);
 }

@@ -1726,7 +1729,6 @@ static void target_complete_tmr_failure(struct work_struct *work)
 	se_cmd->se_tmr_req->response = TMR_LUN_DOES_NOT_EXIST;
 	se_cmd->se_tfo->queue_tm_rsp(se_cmd);

-	transport_lun_remove_cmd(se_cmd);
 	transport_cmd_check_stop_to_fabric(se_cmd);
 }

@@ -1918,7 +1920,6 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 		goto queue_full;

 check_stop:
-	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;

@@ -2216,7 +2217,6 @@ static void transport_complete_qf(struct se_cmd *cmd)
 		transport_handle_queue_full(cmd, cmd->se_dev, ret, false);
 		return;
 	}
-	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 }

@@ -2311,7 +2311,6 @@ static void target_complete_ok_work(struct work_struct *work)
 		if (ret)
 			goto queue_full;

-		transport_lun_remove_cmd(cmd);
 		transport_cmd_check_stop_to_fabric(cmd);
 		return;
 	}
@@ -2337,7 +2336,6 @@ static void target_complete_ok_work(struct work_struct *work)
 			if (ret)
 				goto queue_full;

-			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2373,7 +2371,6 @@ static void target_complete_ok_work(struct work_struct *work)
 			if (ret)
 				goto queue_full;

-			transport_lun_remove_cmd(cmd);
 			transport_cmd_check_stop_to_fabric(cmd);
 			return;
 		}
@@ -2409,7 +2406,6 @@ static void target_complete_ok_work(struct work_struct *work)
 		break;
 	}

-	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;

--
2.21.1 (Apple Git-122.3)

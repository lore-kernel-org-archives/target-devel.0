From: Mike Christie <mchristi@redhat.com>
Date: Thu, 21 Jun 2018 01:32:02 +0000
Subject: Re: [PATCH 14/14] target: Fix handling of removed LUNs
Message-Id: <5B2B0012.4060704@redhat.com>
MIME-Version: 1
Content-Type: multipart/mixed; boundary="------------040807020304070305020309"
List-Id: <target-devel.vger.kernel.org>
References: <20180301222632.31507-15-bart.vanassche@wdc.com>
In-Reply-To: <20180301222632.31507-15-bart.vanassche@wdc.com>
To: target-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040807020304070305020309
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit

On 03/01/2018 04:26 PM, Bart Van Assche wrote:
> Send a valid ASC / ASCQ combination back to the initiator if a SCSI
> command is received after a LUN has been removed. This patch fixes
> the following call trace:
> 
> WARNING: CPU: 0 PID: 4 at drivers/target/target_core_transport.c:3131 translate_sense_reason+0x164/0x190 [target_core_mod]
> Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> RIP: 0010:translate_sense_reason+0x164/0x190 [target_core_mod]
> Call Trace:
> transport_send_check_condition_and_sense+0x95/0x1c0 [target_core_mod]
> transport_generic_request_failure+0x102/0x270 [target_core_mod]
> transport_generic_new_cmd+0x138/0x340 [target_core_mod]
> transport_handle_cdb_direct+0x2f/0x80 [target_core_mod]
> target_submit_cmd_map_sgls+0x212/0x2a0 [target_core_mod]
> srpt_handle_new_iu+0x244/0x680 [ib_srpt]
> __ib_process_cq+0x6d/0xc0 [ib_core]
> ib_cq_poll_work+0x18/0x50 [ib_core]
> process_one_work+0x20b/0x6a0
> worker_thread+0x35/0x380
> kthread+0x117/0x130
> ret_from_fork+0x24/0x30
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_ua.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
> index be25eb807a5f..08c1e550babd 100644
> --- a/drivers/target/target_core_ua.c
> +++ b/drivers/target/target_core_ua.c
> @@ -218,17 +218,15 @@ void core_scsi3_ua_for_check_condition(
>  		return;
>  
>  	nacl = sess->se_node_acl;
> -	if (!nacl)
> +	if (WARN_ON_ONCE(!nacl))
>  		return;
>  
>  	rcu_read_lock();
>  	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
> -	if (!deve) {
> -		rcu_read_unlock();
> -		return;
> -	}
> -	if (!atomic_read(&deve->ua_count)) {
> +	if (!deve || !atomic_read(&deve->ua_count)) {
>  		rcu_read_unlock();
> +		*asc = 0x25;
> +		*ascq = 0;
> 

Hey Bart, I figured out how to hit this. If you just queue up a UA doing
something like changing the ALUA state, then unmap the LUN while IO is
running you will hit it. You do need a little luck for the timing,
because you have to unmap the LUN right after target_scsi3_ua_check does
its target_nacl_find_deve call so it is still in the list there but not
when you call core_scsi3_ua_for_check_condition.

I was in the middle of fixing up the sense key value issue in the patch
like we discussed before (use illegal request instead of unit
attention), but it looks like there was another bug. If we have 2
commands going to the same device and they run target_scsi3_ua_check and
see ua_count=1 TCM_CHECK_CONDITION_UNIT_ATTENTION is returned for both.
They then call core_scsi3_ua_for_check_condition and one of them
deallocates a UA dropping ua_count=0. The second command then runs the
!atomic_read(&deve->ua_count) check and sees the other command has
decremented it. Or the second one might have passed the ua_count check
in core_scsi3_ua_for_check_condition and it runs the loop but nothing is
found since the first command has already removed it. We then return
bogus asc/ascq values.

In the attached patch I just return busy status for this race case. It
seemed easier than trying to add more locking and error handling.

Some notes/questions on some of the code the patch touched though.

If translate_sense_reason failed due to a short buffer it returned
-EINVAL. transport_send_check_condition_and_sense would then end up
calling transport_handle_queue_full/transport_complete_qf and that would
just end up failing the command with
TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE. Do you know if that long journey
intended or just an accident?

In this patch I fixed that so it just translated the error to
TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE immediately. If the patch is ok
and we meant to return that error code for the short buffer then I can
break that out into another patch.

--------------040807020304070305020309
Content-Type: text/x-patch;
 name="ua-error-handling.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="ua-error-handling.patch"

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 3f7ea71..7002247 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -1822,7 +1822,10 @@ void transport_generic_request_failure(struct se_cmd *cmd,
 	}
 
 	ret = transport_send_check_condition_and_sense(cmd, sense_reason, 0);
-	if (ret)
+	if (ret == -EBUSY) {
+		cmd->scsi_status = SAM_STAT_BUSY;
+		goto queue_status;
+	} else if (ret)
 		goto queue_full;
 
 check_stop:
@@ -3149,10 +3152,13 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 {
 	const struct sense_info *si;
 	u8 *buffer = cmd->sense_buffer;
-	int r = (__force int)reason;
+	int r;
 	u8 asc, ascq;
 	bool desc_format = target_sense_desc_format(cmd->se_dev);
 
+lookup_reason:
+	r = (__force int)reason;
+
 	if (r < ARRAY_SIZE(sense_info_table) && sense_info_table[r].key)
 		si = &sense_info_table[r];
 	else
@@ -3160,7 +3166,13 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 				       TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE];
 
 	if (reason == TCM_CHECK_CONDITION_UNIT_ATTENTION) {
-		core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
+		reason = core_scsi3_ua_for_check_condition(cmd, &asc, &ascq);
+		if (reason == TCM_LUN_BUSY) {
+			return -EBUSY;
+		} else if (reason != TCM_CHECK_CONDITION_UNIT_ATTENTION) {
+			goto lookup_reason;
+		}
+
 		WARN_ON_ONCE(asc == 0);
 	} else if (si->asc == 0) {
 		WARN_ON_ONCE(cmd->scsi_asc == 0);
@@ -3172,11 +3184,13 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 	}
 
 	scsi_build_sense_buffer(desc_format, buffer, si->key, asc, ascq);
-	if (si->add_sector_info)
-		return scsi_set_sense_information(buffer,
-						  cmd->scsi_sense_length,
-						  cmd->bad_sector);
-
+	if (si->add_sector_info) {
+		if (scsi_set_sense_information(buffer, cmd->scsi_sense_length,
+					       cmd->bad_sector)) {
+			reason = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			goto lookup_reason;
+		}
+	}
 	return 0;
 }
 
@@ -3197,12 +3211,16 @@ static int translate_sense_reason(struct se_cmd *cmd, sense_reason_t reason)
 	if (!from_transport) {
 		int rc;
 
+		rc = translate_sense_reason(cmd, reason);
+		if (rc) {
+			spin_lock_irqsave(&cmd->t_state_lock, flags);
+			cmd->se_cmd_flags &= ~SCF_SENT_CHECK_CONDITION;
+			spin_unlock_irqrestore(&cmd->t_state_lock, flags);
+			return rc;
+		}
 		cmd->se_cmd_flags |= SCF_EMULATED_TASK_SENSE;
 		cmd->scsi_status = SAM_STAT_CHECK_CONDITION;
 		cmd->scsi_sense_length  = TRANSPORT_SENSE_BUFFER;
-		rc = translate_sense_reason(cmd, reason);
-		if (rc)
-			return rc;
 	}
 
 	trace_target_cmd_complete(cmd);
diff --git a/drivers/target/target_core_ua.c b/drivers/target/target_core_ua.c
index be25eb8..2d43d9a 100644
--- a/drivers/target/target_core_ua.c
+++ b/drivers/target/target_core_ua.c
@@ -202,7 +202,7 @@ void core_scsi3_ua_release_all(
 	spin_unlock(&deve->ua_lock);
 }
 
-void core_scsi3_ua_for_check_condition(
+sense_reason_t core_scsi3_ua_for_check_condition(
 	struct se_cmd *cmd,
 	u8 *asc,
 	u8 *ascq)
@@ -213,24 +213,27 @@ void core_scsi3_ua_for_check_condition(
 	struct se_node_acl *nacl;
 	struct se_ua *ua = NULL, *ua_p;
 	int head = 1;
+	bool found = false;
 
 	if (!sess)
-		return;
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	nacl = sess->se_node_acl;
-	if (!nacl)
-		return;
+	if (WARN_ON_ONCE(!nacl))
+		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
 	rcu_read_lock();
 	deve = target_nacl_find_deve(nacl, cmd->orig_fe_lun);
 	if (!deve) {
 		rcu_read_unlock();
-		return;
+		return TCM_NON_EXISTENT_LUN;
 	}
+
 	if (!atomic_read(&deve->ua_count)) {
 		rcu_read_unlock();
-		return;
+		goto ua_not_found;
 	}
+
 	/*
 	 * The highest priority Unit Attentions are placed at the head of the
 	 * struct se_dev_entry->ua_list, and will be returned in CHECK_CONDITION +
@@ -246,6 +249,7 @@ void core_scsi3_ua_for_check_condition(
 		if (dev->dev_attrib.emulate_ua_intlck_ctrl != 0) {
 			*asc = ua->ua_asc;
 			*ascq = ua->ua_ascq;
+			found = true;
 			break;
 		}
 		/*
@@ -257,6 +261,7 @@ void core_scsi3_ua_for_check_condition(
 			*asc = ua->ua_asc;
 			*ascq = ua->ua_ascq;
 			head = 0;
+			found = true;
 		}
 		list_del(&ua->ua_nacl_list);
 		kmem_cache_free(se_ua_cache, ua);
@@ -266,6 +271,15 @@ void core_scsi3_ua_for_check_condition(
 	spin_unlock(&deve->ua_lock);
 	rcu_read_unlock();
 
+	if (!found) {
+ua_not_found:
+		/*
+		 * Multiple commands might have raced and hit the ua_count>0
+		 * check in target_scsi3_ua_check.
+		 */
+		return TCM_LUN_BUSY;
+	}
+
 	pr_debug("[%s]: %s UNIT ATTENTION condition with"
 		" INTLCK_CTRL: %d, mapped LUN: %llu, got CDB: 0x%02x"
 		" reported ASC: 0x%02x, ASCQ: 0x%02x\n",
@@ -273,6 +287,7 @@ void core_scsi3_ua_for_check_condition(
 		(dev->dev_attrib.emulate_ua_intlck_ctrl != 0) ? "Reporting" :
 		"Releasing", dev->dev_attrib.emulate_ua_intlck_ctrl,
 		cmd->orig_fe_lun, cmd->t_task_cdb[0], *asc, *ascq);
+	return TCM_CHECK_CONDITION_UNIT_ATTENTION;
 }
 
 int core_scsi3_ua_clear_for_request_sense(
diff --git a/drivers/target/target_core_ua.h b/drivers/target/target_core_ua.h
index 56bf34a..8a135e8 100644
--- a/drivers/target/target_core_ua.h
+++ b/drivers/target/target_core_ua.h
@@ -38,7 +38,8 @@
 extern int core_scsi3_ua_allocate(struct se_dev_entry *, u8, u8);
 extern void target_ua_allocate_lun(struct se_node_acl *, u32, u8, u8);
 extern void core_scsi3_ua_release_all(struct se_dev_entry *);
-extern void core_scsi3_ua_for_check_condition(struct se_cmd *, u8 *, u8 *);
+extern sense_reason_t core_scsi3_ua_for_check_condition(struct se_cmd *, u8 *,
+							u8 *);
 extern int core_scsi3_ua_clear_for_request_sense(struct se_cmd *,
 						u8 *, u8 *);
 

--------------040807020304070305020309--

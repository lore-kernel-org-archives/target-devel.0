From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 25 Oct 2020 23:03:17 +0000
Subject: [PATCH 6/7] target: make state_list per cpu'ish
Message-Id: <1603666998-8086-7-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

Do a state_list/execute_task_lock per cpu, so we can do submissions
from different CPUs without contention.

Note: tcm_fc was passing TARGET_SCF_USE_CPUID, but never set cpuid.
I think it wanted to set the cpuid to the CPU it was submitting
from so it will get this behavior with this patch.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |   3 -
 drivers/target/target_core_device.c    |  16 +++-
 drivers/target/target_core_tmr.c       | 166 +++++++++++++++++----------------
 drivers/target/target_core_transport.c |  22 ++---
 drivers/target/tcm_fc/tfc_cmd.c        |   2 +-
 include/target/target_core_base.h      |  14 ++-
 6 files changed, 121 insertions(+), 102 deletions(-)

diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
index c971c4f..2be24f2 100644
--- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
+++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
@@ -457,9 +457,6 @@ static int tcm_qla2xxx_handle_cmd(scsi_qla_host_t *vha, struct qla_tgt_cmd *cmd,
 	if (bidi)
 		target_flags |= TARGET_SCF_BIDI_OP;
 
-	if (se_cmd->cpuid != WORK_CPU_UNBOUND)
-		target_flags |= TARGET_SCF_USE_CPUID;
-
 	sess = cmd->sess;
 	if (!sess) {
 		pr_err("Unable to locate struct fc_port from qla_tgt_cmd\n");
diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 405d82d..55b0980 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -724,11 +724,24 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 {
 	struct se_device *dev;
 	struct se_lun *xcopy_lun;
+	int i;
 
 	dev = hba->backend->ops->alloc_device(hba, name);
 	if (!dev)
 		return NULL;
 
+	dev->queues = kcalloc(nr_cpu_ids, sizeof(*dev->queues), GFP_KERNEL);
+	if (!dev->queues) {
+		dev->transport->free_device(dev);
+		return NULL;
+	}
+
+	dev->queue_cnt = nr_cpu_ids;
+	for (i = 0; i < dev->queue_cnt; i++) {
+		INIT_LIST_HEAD(&dev->queues[i].state_list);
+		spin_lock_init(&dev->queues[i].lock);
+	}
+
 	dev->se_hba = hba;
 	dev->transport = hba->backend->ops;
 	dev->transport_flags = dev->transport->transport_flags_default;
@@ -738,9 +751,7 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
 	INIT_LIST_HEAD(&dev->dev_sep_list);
 	INIT_LIST_HEAD(&dev->dev_tmr_list);
 	INIT_LIST_HEAD(&dev->delayed_cmd_list);
-	INIT_LIST_HEAD(&dev->state_list);
 	INIT_LIST_HEAD(&dev->qf_cmd_list);
-	spin_lock_init(&dev->execute_task_lock);
 	spin_lock_init(&dev->delayed_cmd_lock);
 	spin_lock_init(&dev->dev_reservation_lock);
 	spin_lock_init(&dev->se_port_lock);
@@ -1013,6 +1024,7 @@ void target_free_device(struct se_device *dev)
 	if (dev->transport->free_prot)
 		dev->transport->free_prot(dev);
 
+	kfree(dev->queues);
 	dev->transport->free_device(dev);
 }
 
diff --git a/drivers/target/target_core_tmr.c b/drivers/target/target_core_tmr.c
index e4513ef..6e12541 100644
--- a/drivers/target/target_core_tmr.c
+++ b/drivers/target/target_core_tmr.c
@@ -121,57 +121,61 @@ void core_tmr_abort_task(
 	unsigned long flags;
 	bool rc;
 	u64 ref_tag;
-
-	spin_lock_irqsave(&dev->execute_task_lock, flags);
-	list_for_each_entry_safe(se_cmd, next, &dev->state_list, state_list) {
-
-		if (se_sess != se_cmd->se_sess)
-			continue;
-
-		/* skip task management functions, including tmr->task_cmd */
-		if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
-			continue;
-
-		ref_tag = se_cmd->tag;
-		if (tmr->ref_task_tag != ref_tag)
-			continue;
-
-		printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
-			se_cmd->se_tfo->fabric_name, ref_tag);
-
-		spin_lock(&se_sess->sess_cmd_lock);
-		rc = __target_check_io_state(se_cmd, se_sess, 0);
-		spin_unlock(&se_sess->sess_cmd_lock);
-		if (!rc)
-			continue;
-
-		list_move_tail(&se_cmd->state_list, &aborted_list);
-		se_cmd->state_active = false;
-
-		spin_unlock_irqrestore(&dev->execute_task_lock, flags);
-
-		/*
-		 * Ensure that this ABORT request is visible to the LU RESET
-		 * code.
-		 */
-		if (!tmr->tmr_dev)
-			WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) <
-					0);
-
-		if (dev->transport->tmr_notify)
-			dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
-						   &aborted_list);
-
-		list_del_init(&se_cmd->state_list);
-		target_put_cmd_and_wait(se_cmd);
-
-		printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for"
-				" ref_tag: %llu\n", ref_tag);
-		tmr->response = TMR_FUNCTION_COMPLETE;
-		atomic_long_inc(&dev->aborts_complete);
-		return;
+	int i;
+
+	for (i = 0; i < dev->queue_cnt; i++) {
+		spin_lock_irqsave(&dev->queues[i].lock, flags);
+		list_for_each_entry_safe(se_cmd, next, &dev->queues[i].state_list,
+					 state_list) {
+			if (se_sess != se_cmd->se_sess)
+				continue;
+
+			/*
+			 * skip task management functions, including
+			 * tmr->task_cmd
+			 */
+			if (se_cmd->se_cmd_flags & SCF_SCSI_TMR_CDB)
+				continue;
+
+			ref_tag = se_cmd->tag;
+			if (tmr->ref_task_tag != ref_tag)
+				continue;
+
+			printk("ABORT_TASK: Found referenced %s task_tag: %llu\n",
+			       se_cmd->se_tfo->fabric_name, ref_tag);
+
+			spin_lock(&se_sess->sess_cmd_lock);
+			rc = __target_check_io_state(se_cmd, se_sess, 0);
+			spin_unlock(&se_sess->sess_cmd_lock);
+			if (!rc)
+				continue;
+
+			list_move_tail(&se_cmd->state_list, &aborted_list);
+			se_cmd->state_active = false;
+			spin_unlock_irqrestore(&dev->queues[i].lock, flags);
+
+			/*
+			 * Ensure that this ABORT request is visible to the LU
+			 * RESET code.
+			 */
+			if (!tmr->tmr_dev)
+				WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) < 0);
+
+			if (dev->transport->tmr_notify)
+				dev->transport->tmr_notify(dev, TMR_ABORT_TASK,
+							   &aborted_list);
+
+			list_del_init(&se_cmd->state_list);
+			target_put_cmd_and_wait(se_cmd);
+
+			printk("ABORT_TASK: Sending TMR_FUNCTION_COMPLETE for ref_tag: %llu\n",
+			       ref_tag);
+			tmr->response = TMR_FUNCTION_COMPLETE;
+			atomic_long_inc(&dev->aborts_complete);
+			return;
+		}
+		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
 	}
-	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 	if (dev->transport->tmr_notify)
 		dev->transport->tmr_notify(dev, TMR_ABORT_TASK, &aborted_list);
@@ -273,7 +277,7 @@ static void core_tmr_drain_state_list(
 	struct se_session *sess;
 	struct se_cmd *cmd, *next;
 	unsigned long flags;
-	int rc;
+	int rc, i;
 
 	/*
 	 * Complete outstanding commands with TASK_ABORTED SAM status.
@@ -297,35 +301,39 @@ static void core_tmr_drain_state_list(
 	 * Note that this seems to be independent of TAS (Task Aborted Status)
 	 * in the Control Mode Page.
 	 */
-	spin_lock_irqsave(&dev->execute_task_lock, flags);
-	list_for_each_entry_safe(cmd, next, &dev->state_list, state_list) {
-		/*
-		 * For PREEMPT_AND_ABORT usage, only process commands
-		 * with a matching reservation key.
-		 */
-		if (target_check_cdb_and_preempt(preempt_and_abort_list, cmd))
-			continue;
-
-		/*
-		 * Not aborting PROUT PREEMPT_AND_ABORT CDB..
-		 */
-		if (prout_cmd = cmd)
-			continue;
-
-		sess = cmd->se_sess;
-		if (WARN_ON_ONCE(!sess))
-			continue;
-
-		spin_lock(&sess->sess_cmd_lock);
-		rc = __target_check_io_state(cmd, tmr_sess, tas);
-		spin_unlock(&sess->sess_cmd_lock);
-		if (!rc)
-			continue;
-
-		list_move_tail(&cmd->state_list, &drain_task_list);
-		cmd->state_active = false;
+	for (i = 0; i < dev->queue_cnt; i++) {
+		spin_lock_irqsave(&dev->queues[i].lock, flags);
+		list_for_each_entry_safe(cmd, next, &dev->queues[i].state_list,
+					 state_list) {
+			/*
+			 * For PREEMPT_AND_ABORT usage, only process commands
+			 * with a matching reservation key.
+			 */
+			if (target_check_cdb_and_preempt(preempt_and_abort_list,
+							 cmd))
+				continue;
+
+			/*
+			 * Not aborting PROUT PREEMPT_AND_ABORT CDB..
+			 */
+			if (prout_cmd = cmd)
+				continue;
+
+			sess = cmd->se_sess;
+			if (WARN_ON_ONCE(!sess))
+				continue;
+
+			spin_lock(&sess->sess_cmd_lock);
+			rc = __target_check_io_state(cmd, tmr_sess, tas);
+			spin_unlock(&sess->sess_cmd_lock);
+			if (!rc)
+				continue;
+
+			list_move_tail(&cmd->state_list, &drain_task_list);
+			cmd->state_active = false;
+		}
+		spin_unlock_irqrestore(&dev->queues[i].lock, flags);
 	}
-	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
 
 	if (dev->transport->tmr_notify)
 		dev->transport->tmr_notify(dev, preempt_and_abort_list ?
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index b228c66..71a6ec3 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -659,12 +659,12 @@ static void target_remove_from_state_list(struct se_cmd *cmd)
 	if (!dev)
 		return;
 
-	spin_lock_irqsave(&dev->execute_task_lock, flags);
+	spin_lock_irqsave(&dev->queues[cmd->cpuid].lock, flags);
 	if (cmd->state_active) {
 		list_del(&cmd->state_list);
 		cmd->state_active = false;
 	}
-	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
+	spin_unlock_irqrestore(&dev->queues[cmd->cpuid].lock, flags);
 }
 
 /*
@@ -875,10 +875,7 @@ void target_complete_cmd(struct se_cmd *cmd, u8 scsi_status)
 
 	INIT_WORK(&cmd->work, success ? target_complete_ok_work :
 		  target_complete_failure_work);
-	if (cmd->se_cmd_flags & SCF_USE_CPUID)
-		queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
-	else
-		queue_work(target_completion_wq, &cmd->work);
+	queue_work_on(cmd->cpuid, target_completion_wq, &cmd->work);
 }
 EXPORT_SYMBOL(target_complete_cmd);
 
@@ -906,12 +903,13 @@ static void target_add_to_state_list(struct se_cmd *cmd)
 	struct se_device *dev = cmd->se_dev;
 	unsigned long flags;
 
-	spin_lock_irqsave(&dev->execute_task_lock, flags);
+	spin_lock_irqsave(&dev->queues[cmd->cpuid].lock, flags);
 	if (!cmd->state_active) {
-		list_add_tail(&cmd->state_list, &dev->state_list);
+		list_add_tail(&cmd->state_list,
+			      &dev->queues[cmd->cpuid].state_list);
 		cmd->state_active = true;
 	}
-	spin_unlock_irqrestore(&dev->execute_task_lock, flags);
+	spin_unlock_irqrestore(&dev->queues[cmd->cpuid].lock, flags);
 }
 
 /*
@@ -1398,6 +1396,7 @@ void transport_init_se_cmd(
 	cmd->sam_task_attr = task_attr;
 	cmd->sense_buffer = sense_buffer;
 	cmd->orig_fe_lun = unpacked_lun;
+	cmd->cpuid = smp_processor_id();
 
 	cmd->state_active = false;
 }
@@ -1625,11 +1624,6 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
 				data_length, data_dir, task_attr, sense,
 				unpacked_lun);
 
-	if (flags & TARGET_SCF_USE_CPUID)
-		se_cmd->se_cmd_flags |= SCF_USE_CPUID;
-	else
-		se_cmd->cpuid = WORK_CPU_UNBOUND;
-
 	if (flags & TARGET_SCF_UNKNOWN_SIZE)
 		se_cmd->unknown_data_length = 1;
 	/*
diff --git a/drivers/target/tcm_fc/tfc_cmd.c b/drivers/target/tcm_fc/tfc_cmd.c
index a7ed566..8936a09 100644
--- a/drivers/target/tcm_fc/tfc_cmd.c
+++ b/drivers/target/tcm_fc/tfc_cmd.c
@@ -551,7 +551,7 @@ static void ft_send_work(struct work_struct *work)
 	if (target_submit_cmd(&cmd->se_cmd, cmd->sess->se_sess, fcp->fc_cdb,
 			      &cmd->ft_sense_buffer[0], scsilun_to_int(&fcp->fc_lun),
 			      ntohl(fcp->fc_dl), task_attr, data_dir,
-			      TARGET_SCF_ACK_KREF | TARGET_SCF_USE_CPUID))
+			      TARGET_SCF_ACK_KREF))
 		goto err;
 
 	pr_debug("r_ctl %x target_submit_cmd %p\n", fh->fh_r_ctl, cmd);
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 2824463..7b42dc7 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -143,7 +143,6 @@ enum se_cmd_flags_table {
 	SCF_COMPARE_AND_WRITE		= 0x00080000,
 	SCF_PASSTHROUGH_PROT_SG_TO_MEM_NOALLOC = 0x00200000,
 	SCF_ACK_KREF			= 0x00400000,
-	SCF_USE_CPUID			= 0x00800000,
 	SCF_TASK_ATTR_SET		= 0x01000000,
 	SCF_TREAT_READ_AS_NORMAL	= 0x02000000,
 };
@@ -540,6 +539,10 @@ struct se_cmd {
 	unsigned int		t_prot_nents;
 	sense_reason_t		pi_err;
 	sector_t		bad_sector;
+	/*
+	 * CPU LIO will execute the cmd on. Defaults to the CPU the cmd is
+	 * initialized on. Drivers can override.
+	 */
 	int			cpuid;
 };
 
@@ -760,6 +763,11 @@ struct se_dev_stat_grps {
 	struct config_group scsi_lu_group;
 };
 
+struct se_device_queue {
+	struct list_head	state_list;
+	spinlock_t		lock;
+};
+
 struct se_device {
 	/* RELATIVE TARGET PORT IDENTIFER Counter */
 	u16			dev_rpti_counter;
@@ -792,7 +800,6 @@ struct se_device {
 	atomic_t		dev_qf_count;
 	u32			export_count;
 	spinlock_t		delayed_cmd_lock;
-	spinlock_t		execute_task_lock;
 	spinlock_t		dev_reservation_lock;
 	unsigned int		dev_reservation_flags;
 #define DRF_SPC2_RESERVATIONS			0x00000001
@@ -811,7 +818,6 @@ struct se_device {
 	struct list_head	dev_tmr_list;
 	struct work_struct	qf_work_queue;
 	struct list_head	delayed_cmd_list;
-	struct list_head	state_list;
 	struct list_head	qf_cmd_list;
 	/* Pointer to associated SE HBA */
 	struct se_hba		*se_hba;
@@ -838,6 +844,8 @@ struct se_device {
 	/* For se_lun->lun_se_dev RCU read-side critical access */
 	u32			hba_index;
 	struct rcu_head		rcu_head;
+	int			queue_cnt;
+	struct se_device_queue	*queues;
 };
 
 struct se_hba {
-- 
1.8.3.1

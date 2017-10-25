From: Mike Christie <mchristi@redhat.com>
Date: Wed, 25 Oct 2017 16:47:24 +0000
Subject: [PATCH 14/20] tcmu: don't block submitting context for block waits
Message-Id: <1508950050-10120-15-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

You can commonly have multiple tcmu devices exported as
multiple luns through the same transport connection or
we can have multiple connections with multiple luns.
We do not want to block the fabric module's submitting
context when waiting for blocks because this can
lead to transport tests like iscsi nops/pings timing
out, and it can lead to issues where one device slows
down and causes other devices and other transports
to block when we are only waiting on the per dev
block limit and not the global one.

This patch has tcmu queue the cmd internally while it tries
to unmap pages from other tcmu devices.

Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 304 ++++++++++++++++++++++++++------------
 1 file changed, 212 insertions(+), 92 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 9dad078..45cf37f 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -131,8 +131,8 @@ struct tcmu_dev {
 	size_t data_off;
 	size_t data_size;
 
-	wait_queue_head_t wait_cmdr;
 	struct mutex cmdr_lock;
+	struct list_head cmdr_queue;
 
 	uint32_t waiting_blocks;
 	uint32_t dbi_max;
@@ -163,6 +163,7 @@ struct tcmu_dev {
 struct tcmu_cmd {
 	struct se_cmd *se_cmd;
 	struct tcmu_dev *tcmu_dev;
+	struct list_head cmdr_queue_entry;
 
 	uint16_t cmd_id;
 
@@ -453,6 +454,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	if (!tcmu_cmd)
 		return NULL;
 
+	INIT_LIST_HEAD(&tcmu_cmd->cmdr_queue_entry);
 	tcmu_cmd->se_cmd = se_cmd;
 	tcmu_cmd->tcmu_dev = udev;
 
@@ -773,6 +775,10 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	unsigned long tmo = udev->cmd_time_out;
 	int cmd_id;
 
+	/*
+	 * If it was on the cmdr queue waiting we do not reset the timer
+	 * for requeues and when it is finally sent to userspace.
+	 */
 	if (tcmu_cmd->cmd_id)
 		return 0;
 
@@ -784,15 +790,54 @@ static int tcmu_setup_cmd_timer(struct tcmu_cmd *tcmu_cmd)
 	tcmu_cmd->cmd_id = cmd_id;
 
 	if (!tmo)
-		return 0;
+		tmo = TCMU_TIME_OUT;
+
+	pr_debug("allocated cmd %u for dev %s tmo %lu\n", tcmu_cmd->cmd_id,
+		 udev->name, tmo / MSEC_PER_SEC);
 
 	tcmu_cmd->deadline = round_jiffies_up(jiffies + msecs_to_jiffies(tmo));
 	mod_timer(&udev->timeout, tcmu_cmd->deadline);
 	return 0;
 }
 
-static sense_reason_t
-tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
+static int add_to_cmdr_queue(struct tcmu_cmd *tcmu_cmd)
+{
+	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
+	int ret;
+
+	ret = tcmu_setup_cmd_timer(tcmu_cmd);
+	if (ret)
+		return ret;
+
+	list_add_tail(&tcmu_cmd->cmdr_queue_entry, &udev->cmdr_queue);
+	pr_debug("adding cmd %u on dev %s to ring space wait queue\n",
+		 tcmu_cmd->cmd_id, udev->name);
+
+	if (!udev->waiting_blocks)
+		return 0;
+
+	spin_lock(&root_udev_waiter_lock);
+	if (list_empty(&udev->waiter)) {
+		pr_debug("adding %s to block waiter list\n", udev->name);
+
+		list_add_tail(&udev->waiter, &root_udev_waiter);
+		wake_up(&unmap_wait);
+	}
+	spin_unlock(&root_udev_waiter_lock);
+	return 0;
+}
+
+/**
+ * queue_cmd_ring - queue cmd to ring or internally
+ * @tcmu_cmd: cmd to queue
+ * @scsi_err: TCM error code if failure (-1) returned.
+ *
+ * Returns:
+ * -1 we cannot queue internally or to the ring.
+ *  0 success
+ *  1 internally queued to wait for ring memory to free.
+ */
+static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
 {
 	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
 	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;
@@ -806,8 +851,12 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	bool copy_to_data_area;
 	size_t data_length = tcmu_cmd_get_data_length(tcmu_cmd);
 
-	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags))
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+	*scsi_err = TCM_NO_SENSE;
+
+	if (test_bit(TCMU_DEV_BIT_BROKEN, &udev->flags)) {
+		*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		return -1;
+	}
 
 	/*
 	 * Must be a certain minimum size for response sense info, but
@@ -824,7 +873,8 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	base_command_size = tcmu_cmd_get_base_cmd_size(tcmu_cmd->dbi_cnt);
 	command_size = tcmu_cmd_get_cmd_size(tcmu_cmd, base_command_size);
 
-	mutex_lock(&udev->cmdr_lock);
+	if (!list_empty(&udev->cmdr_queue))
+		goto queue;
 
 	mb = udev->mb_addr;
 	cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
@@ -833,53 +883,18 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 		pr_warn("TCMU: Request of size %zu/%zu is too big for %u/%zu "
 			"cmd ring/data area\n", command_size, data_length,
 			udev->cmdr_size, udev->data_size);
-		mutex_unlock(&udev->cmdr_lock);
-		return TCM_INVALID_CDB_FIELD;
+		*scsi_err = TCM_INVALID_CDB_FIELD;
+		return -1;
 	}
 
-	while (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
-		int ret;
-		DEFINE_WAIT(__wait);
-
+	if (!is_ring_space_avail(udev, tcmu_cmd, command_size, data_length)) {
 		/*
 		 * Don't leave commands partially setup because the unmap
 		 * thread might need the blocks to make forward progress.
 		 */
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cur);
 		tcmu_cmd_reset_dbi_cur(tcmu_cmd);
-
-		prepare_to_wait(&udev->wait_cmdr, &__wait, TASK_INTERRUPTIBLE);
-
-		pr_debug("sleeping for ring space\n");
-		/*
-		 * Try to insert the current udev to waiter list and
-		 * then wake up the unmap thread
-		 */
-		if (udev->waiting_blocks) {
-			spin_lock(&root_udev_waiter_lock);
-			if (list_empty(&udev->waiter))
-				list_add_tail(&udev->waiter, &root_udev_waiter);
-			spin_unlock(&root_udev_waiter_lock);
-
-			wake_up(&unmap_wait);
-		}
-		mutex_unlock(&udev->cmdr_lock);
-
-		if (udev->cmd_time_out)
-			ret = schedule_timeout(
-					msecs_to_jiffies(udev->cmd_time_out));
-		else
-			ret = schedule_timeout(msecs_to_jiffies(TCMU_TIME_OUT));
-		finish_wait(&udev->wait_cmdr, &__wait);
-		if (!ret) {
-			pr_warn("tcmu: command timed out\n");
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
-		}
-
-		mutex_lock(&udev->cmdr_lock);
-
-		/* We dropped cmdr_lock, cmd_head is stale */
-		cmd_head = mb->cmd_head % udev->cmdr_size; /* UAM */
+		goto queue;
 	}
 
 	/* Insert a PAD if end-of-ring space is too small */
@@ -916,10 +931,10 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 				copy_to_data_area);
 	if (ret) {
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-		mutex_unlock(&udev->cmdr_lock);
 
 		pr_err("tcmu: alloc and scatter data failed\n");
-		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+		return -1;
 	}
 	entry->req.iov_cnt = iov_cnt;
 
@@ -933,10 +948,10 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 					&iov, &iov_cnt, false);
 		if (ret) {
 			tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-			mutex_unlock(&udev->cmdr_lock);
 
 			pr_err("tcmu: alloc and scatter bidi data failed\n");
-			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			*scsi_err = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
+			return -1;
 		}
 	}
 	entry->req.iov_bidi_cnt = iov_cnt;
@@ -944,7 +959,8 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 	ret = tcmu_setup_cmd_timer(tcmu_cmd);
 	if (ret) {
 		tcmu_cmd_free_data(tcmu_cmd, tcmu_cmd->dbi_cnt);
-		return TCM_OUT_OF_RESOURCES;
+		*scsi_err = TCM_OUT_OF_RESOURCES;
+		return -1;
 	}
 	entry->hdr.cmd_id = tcmu_cmd->cmd_id;
 
@@ -966,36 +982,40 @@ tcmu_queue_cmd_ring(struct tcmu_cmd *tcmu_cmd)
 
 	UPDATE_HEAD(mb->cmd_head, command_size, udev->cmdr_size);
 	tcmu_flush_dcache_range(mb, sizeof(*mb));
-	mutex_unlock(&udev->cmdr_lock);
 
 	/* TODO: only if FLUSH and FUA? */
 	uio_event_notify(&udev->uio_info);
 
-	if (udev->cmd_time_out)
-		mod_timer(&udev->timeout, round_jiffies_up(jiffies +
-			  msecs_to_jiffies(udev->cmd_time_out)));
+	return 0;
+
+queue:
+	if (add_to_cmdr_queue(tcmu_cmd)) {
+		*scsi_err = TCM_OUT_OF_RESOURCES;
+		return -1;
+	}
 
-	return TCM_NO_SENSE;
+	return 1;
 }
 
 static sense_reason_t
 tcmu_queue_cmd(struct se_cmd *se_cmd)
 {
+	struct se_device *se_dev = se_cmd->se_dev;
+	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 	struct tcmu_cmd *tcmu_cmd;
-	sense_reason_t ret;
+	sense_reason_t scsi_ret;
+	int ret;
 
 	tcmu_cmd = tcmu_alloc_cmd(se_cmd);
 	if (!tcmu_cmd)
 		return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 
-	ret = tcmu_queue_cmd_ring(tcmu_cmd);
-	if (ret != TCM_NO_SENSE) {
-		pr_err("TCMU: Could not queue command\n");
-
+	mutex_lock(&udev->cmdr_lock);
+	ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
+	mutex_unlock(&udev->cmdr_lock);
+	if (ret < 0)
 		tcmu_free_cmd(tcmu_cmd);
-	}
-
-	return ret;
+	return scsi_ret;
 }
 
 static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *entry)
@@ -1082,8 +1102,8 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 		handled++;
 	}
 
-	if (mb->cmd_tail = mb->cmd_head)
-		del_timer(&udev->timeout); /* no more pending cmds */
+	if (mb->cmd_tail = mb->cmd_head && list_empty(&udev->cmdr_queue))
+		del_timer(&udev->timeout); /* no more pending or waiting cmds */
 
 	return handled;
 }
@@ -1091,6 +1111,10 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
 static int tcmu_check_expired_cmd(int id, void *p, void *data)
 {
 	struct tcmu_cmd *cmd = p;
+	struct tcmu_dev *udev = cmd->tcmu_dev;
+	u8 scsi_status;
+	struct se_cmd *se_cmd;
+	bool is_running;
 
 	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
 		return 0;
@@ -1098,10 +1122,34 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
 	if (!time_after(jiffies, cmd->deadline))
 		return 0;
 
-	set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
-	target_complete_cmd(cmd->se_cmd, SAM_STAT_CHECK_CONDITION);
+	is_running = list_empty(&cmd->cmdr_queue_entry);
+	pr_debug("Timing out cmd %u on dev %s that is %s.\n",
+		 id, udev->name, is_running ? "inflight" : "queued");
+
+	se_cmd = cmd->se_cmd;
 	cmd->se_cmd = NULL;
 
+	if (is_running) {
+		set_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags);
+		/*
+		 * target_complete_cmd will translate this to LUN COMM FAILURE
+		 */
+		scsi_status = SAM_STAT_CHECK_CONDITION;
+	} else {
+		list_del_init(&cmd->cmdr_queue_entry);
+
+		if (list_empty(&udev->cmdr_queue)) {
+			spin_lock(&root_udev_waiter_lock);
+			if (!list_empty(&udev->waiter))
+				list_del_init(&udev->waiter);
+			spin_unlock(&root_udev_waiter_lock);
+		}
+
+		idr_remove(&udev->commands, id);
+		tcmu_free_cmd(cmd);
+		scsi_status = SAM_STAT_TASK_SET_FULL;
+	}
+	target_complete_cmd(se_cmd, scsi_status);
 	return 0;
 }
 
@@ -1157,10 +1205,10 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	udev->hba = hba;
 	udev->cmd_time_out = TCMU_TIME_OUT;
 
-	init_waitqueue_head(&udev->wait_cmdr);
 	mutex_init(&udev->cmdr_lock);
 
 	INIT_LIST_HEAD(&udev->timedout_entry);
+	INIT_LIST_HEAD(&udev->cmdr_queue);
 	INIT_LIST_HEAD(&udev->waiter);
 	idr_init(&udev->commands);
 
@@ -1175,6 +1223,55 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
 	return &udev->se_dev;
 }
 
+static bool run_cmdr_queue(struct tcmu_dev *udev)
+{
+	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
+	LIST_HEAD(cmds);
+	bool drained = true;
+	sense_reason_t scsi_ret;
+	int ret;
+
+	if (list_empty(&udev->cmdr_queue))
+		return true;
+
+	pr_debug("running %s's cmdr queue\n", udev->name);
+
+	list_splice_init(&udev->cmdr_queue, &cmds);
+
+	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, &cmds, cmdr_queue_entry) {
+		list_del_init(&tcmu_cmd->cmdr_queue_entry);
+
+	        pr_debug("removing cmd %u on dev %s from queue\n",
+		         tcmu_cmd->cmd_id, udev->name);
+
+		ret = queue_cmd_ring(tcmu_cmd, &scsi_ret);
+		if (ret < 0) {
+		        pr_debug("cmd %u on dev %s failed with %u\n",
+			         tcmu_cmd->cmd_id, udev->name, scsi_ret);
+
+			idr_remove(&udev->commands, tcmu_cmd->cmd_id);
+			/*
+			 * Ignore scsi_ret for now. target_complete_cmd
+			 * drops it.
+			 */
+			target_complete_cmd(tcmu_cmd->se_cmd,
+					    SAM_STAT_CHECK_CONDITION);
+			tcmu_free_cmd(tcmu_cmd);
+		} else if (ret > 0) {
+			pr_debug("ran out of space during cmdr queue run\n");
+			/*
+			 * cmd was requeued, so just put all cmds back in
+			 * the queue
+			 */
+			list_splice_tail(&cmds, &udev->cmdr_queue);
+			drained = false;
+			goto done;
+		}
+	}
+done:
+	return drained;
+}
+
 static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 {
 	struct tcmu_dev *tcmu_dev = container_of(info, struct tcmu_dev, uio_info);
@@ -1185,11 +1282,11 @@ static int tcmu_irqcontrol(struct uio_info *info, s32 irq_on)
 	 * make sure that the other waiters in list be fed ahead
 	 * of it.
 	 */
-	if (tcmu_dev->waiting_blocks) {
+	if (!list_empty(&tcmu_dev->waiter)) {
 		wake_up(&unmap_wait);
 	} else {
 		tcmu_handle_completions(tcmu_dev);
-		wake_up(&tcmu_dev->wait_cmdr);
+		run_cmdr_queue(tcmu_dev);
 	}
 	mutex_unlock(&tcmu_dev->cmdr_lock);
 
@@ -2044,6 +2141,13 @@ static uint32_t find_free_blocks(void)
 	loff_t off;
 	uint32_t start, end, block, free_blocks = 0;
 
+	spin_lock(&root_udev_waiter_lock);
+	if (list_empty(&root_udev_waiter)) {
+		spin_unlock(&root_udev_waiter_lock);
+		return 0;
+	}
+	spin_unlock(&root_udev_waiter_lock);
+
 	mutex_lock(&root_udev_mutex);
 retry:
 	list_for_each_entry(udev, &root_udev, node) {
@@ -2083,7 +2187,8 @@ static uint32_t find_free_blocks(void)
 		/* Release the block pages */
 		tcmu_blocks_release(&udev->data_blocks, start, end);
 
-		if (list_empty(&udev->waiter)) {
+		if (list_empty(&udev->waiter) &&
+		    !list_empty(&udev->cmdr_queue)) {
 			/*
 			 * if we had to take pages from a dev that hit its
 			 * DATA_BLOCK_BITS limit put it on the waiter
@@ -2115,45 +2220,58 @@ static uint32_t find_free_blocks(void)
 	return free_blocks;
 }
 
-static void run_cmdr_queues(uint32_t *free_blocks)
+static bool run_cmdr_queues(void)
 {
 	struct tcmu_dev *udev, *tmp_udev;
 	LIST_HEAD(devs);
+	unsigned free_blocks;
 
-	/*
-	 * Try to wake up the udevs who are waiting
-	 * for the global data pool blocks.
-	 */
 	spin_lock(&root_udev_waiter_lock);
 	list_splice_init(&root_udev_waiter, &devs);
 
 	list_for_each_entry_safe(udev, tmp_udev, &devs, waiter) {
 		list_del_init(&udev->waiter);
+
+		free_blocks = TCMU_GLOBAL_MAX_BLOCKS -
+						atomic_read(&global_db_count);
+		pr_debug("checking cmdr queue for %s: blocks waiting %u free db count %u\n",
+			 udev->name, udev->waiting_blocks, free_blocks);
+
 		spin_unlock(&root_udev_waiter_lock);
 
 		mutex_lock(&udev->cmdr_lock);
-		if (udev->waiting_blocks < *free_blocks) {
+		if (udev->waiting_blocks > free_blocks) {
 			spin_lock(&root_udev_waiter_lock);
 			if (list_empty(&udev->waiter))
-				list_add_tail(&udev->waiter, &root_udev_waiter);
+				list_add(&udev->waiter, &root_udev_waiter);
 			spin_unlock(&root_udev_waiter_lock);
 
 			mutex_unlock(&udev->cmdr_lock);
-			goto resplice;
+			goto unsplice;
 		}
-
-		*free_blocks -= udev->waiting_blocks;
+		/*
+		 * Reset waiting_blocks and let queue_cmd_ring recalc,
+		 * if needed.
+		 */
 		udev->waiting_blocks = 0;
+
+		if (!run_cmdr_queue(udev) && udev->waiting_blocks) {
+			/* failed because we hit the global block limit */
+			mutex_unlock(&udev->cmdr_lock);
+			goto unsplice;
+		}
 		mutex_unlock(&udev->cmdr_lock);
 
-		wake_up(&udev->wait_cmdr);
+		spin_lock(&root_udev_waiter_lock);
 	}
 	spin_unlock(&root_udev_waiter_lock);
+	return true;
 
-resplice:
+unsplice:
 	spin_lock(&root_udev_waiter_lock);
 	list_splice(&devs, &root_udev_waiter);
 	spin_unlock(&root_udev_waiter_lock);
+	return false;
 }
 
 static void check_timedout_devices(void)
@@ -2179,7 +2297,7 @@ static void check_timedout_devices(void)
 
 static int unmap_thread_fn(void *data)
 {
-	uint32_t free_blocks = 0;
+	bool drained = true;
 	bool has_block_waiters;
 	bool has_timed_out_devs;
 
@@ -2187,7 +2305,6 @@ static int unmap_thread_fn(void *data)
 		DEFINE_WAIT(__wait);
 
 		prepare_to_wait(&unmap_wait, &__wait, TASK_INTERRUPTIBLE);
-
 		/*
 		 * If we had space left, check if devs were added/readded
 		 * while the lock was dropped.
@@ -2204,18 +2321,21 @@ static int unmap_thread_fn(void *data)
 			has_timed_out_devs = false;
 		spin_unlock_bh(&timed_out_udevs_lock);
 
-		if ((!free_blocks || !has_block_waiters) && !has_timed_out_devs)
+		/*
+		 * Handle race where new waiters were added and we still
+		 * had space (were at least able to drain the queue on
+		 * the previous run).
+		 */
+		if ((!drained || !has_block_waiters) && !has_timed_out_devs)
 			schedule();
 
 		finish_wait(&unmap_wait, &__wait);
 
-		if (kthread_should_stop())
-			break;
-
 		check_timedout_devices();
 
-		free_blocks += find_free_blocks();
-		run_cmdr_queues(&free_blocks);
+		find_free_blocks();
+
+		drained = run_cmdr_queues();
 	}
 
 	return 0;
-- 
2.7.2


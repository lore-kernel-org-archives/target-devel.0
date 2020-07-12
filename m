From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 12 Jul 2020 01:15:32 +0000
Subject: Re: [PATCH 7/8] scsi: target: tcmu: Implement tmr_notify callback
Message-Id: <24d9afb0-3ea9-e83b-acf0-b44f04583a6e@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-8-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200710104817.19462-8-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/10/20 5:48 AM, Bodo Stroesser wrote:
> This patch implements the tmr_notify callback for tcmu.
> When the callback is called, tcmu checks the list of aborted
> commands it received as parameter:
>   - aborted commands in the qfull_queue are removed from
>     the queue and target_complete_command is called
>   - from the cmd_ids of aborted commands currently uncompleted
>     in cmd ring it creates a list of aborted cmd_ids.
> Finally a TMR notification is written to cmd ring containing
> TMR type and cmd_id list. If there is no space in ring, the
> TMR notification is queued on a TMR specific queue.
> 
> The TMR specific queue 'tmr_queue' can be seen as a extension
> of the cmd ring. At the end of each iexecution of
> tcmu_complete_commands() we check, whether tmr_queue contains
> TMRs and try to move them onto the ring. If tmr_queue is not
> empty after that, we don't call run_qfull_queue() because
> commands must not overtake TMRs.
> 
> Operating that way we guarantee that cmd_ids in TMR notification
> received by userspace either match an active, not yet completed
> command or are no longer valid due to userspace having complete
> some cmd_ids meanwhile.
> 
> New commands that were assigned to an aborted cmd_id will always
> appear on the cmd ring _after_ the TMR.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>   drivers/target/target_core_user.c     | 226 ++++++++++++++++++++++++++++++++--
>   include/uapi/linux/target_core_user.h |  25 ++++
>   2 files changed, 242 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 6adf4e7cc00b..e864706de977 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -137,6 +137,7 @@ struct tcmu_dev {
>   
>   	struct mutex cmdr_lock;
>   	struct list_head qfull_queue;
> +	struct list_head tmr_queue;
>   
>   	uint32_t dbi_max;
>   	uint32_t dbi_thresh;
> @@ -183,6 +184,15 @@ struct tcmu_cmd {
>   #define TCMU_CMD_BIT_EXPIRED 0
>   	unsigned long flags;
>   };
> +
> +struct tcmu_tmr {
> +	struct list_head queue_entry;
> +
> +	uint8_t tmr_type;
> +	uint32_t tmr_cmd_cnt;
> +	int16_t tmr_cmd_ids[0];
> +};
> +
>   /*
>    * To avoid dead lock the mutex lock order should always be:
>    *
> @@ -844,6 +854,9 @@ static bool is_ring_space_avail(struct tcmu_dev *udev, struct tcmu_cmd *cmd,
>   		return false;
>   	}
>   
> +	if (!data_needed)
> +		return true;
> +
>   	/* try to check and get the data blocks as needed */
>   	space = spc_bitmap_free(udev->data_bitmap, udev->dbi_thresh);
>   	if ((space * DATA_BLOCK_SIZE) < data_needed) {
> @@ -1106,6 +1119,61 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>   	return 1;
>   }
>   
> +/*

We do 2 stars for this type of comment:

/**

> + * queue_tmr_ring - queue tmr info to ring or internally
> + *

No extra newline.

> + * @dev: related tcmu_dev
> + * @tmr: tcmu_tmr containing tmr info to queue
> + *
> + * Returns:
> + *  0 success
> + *  1 internally queued to wait for ring memory to free.
> + */
> +static int
> +queue_tmr_ring(struct tcmu_dev *dev, struct tcmu_tmr *tmr)
> +{
> +	struct tcmu_tmr_entry *entry;
> +	int cmd_size;
> +	int id_list_sz;
> +	struct tcmu_mailbox *mb = dev->mb_addr;
> +	uint32_t cmd_head;
> +
> +	if (test_bit(TCMU_DEV_BIT_BROKEN, &dev->flags))
> +		goto out_free;
> +
> +	id_list_sz = sizeof(tmr->tmr_cmd_ids[0]) * tmr->tmr_cmd_cnt;
> +	cmd_size = round_up(sizeof(*entry) + id_list_sz, TCMU_OP_ALIGN_SIZE);
> +
> +	if (!list_empty(&dev->tmr_queue) ||
> +	    !is_ring_space_avail(dev, NULL, cmd_size, 0)) {
> +		list_add_tail(&tmr->queue_entry, &dev->tmr_queue);
> +		pr_debug("adding tmr %p on dev %s to TMR ring space wait queue\n",
> +			 tmr, dev->name);
> +		return 1;
> +	}
> +
> +	cmd_head = ring_insert_padding(dev, cmd_size);
> +
> +	entry = (void *)mb + CMDR_OFF + cmd_head;
> +	memset(entry, 0, cmd_size);
> +	tcmu_hdr_set_op(&entry->hdr.len_op, TCMU_OP_TMR);
> +	tcmu_hdr_set_len(&entry->hdr.len_op, cmd_size);
> +	entry->tmr_type = tmr->tmr_type;
> +	entry->cmd_cnt = tmr->tmr_cmd_cnt;
> +	memcpy(&entry->cmd_ids[0], &tmr->tmr_cmd_ids[0], id_list_sz);
> +	tcmu_flush_dcache_range(entry, cmd_size);
> +
> +	UPDATE_HEAD(mb->cmd_head, cmd_size, dev->cmdr_size);
> +	tcmu_flush_dcache_range(mb, sizeof(*mb));
> +
> +	uio_event_notify(&dev->uio_info);
> +
> +out_free:
> +	kfree(tmr);
> +
> +	return 0;
> +}
> +
>   static sense_reason_t
>   tcmu_queue_cmd(struct se_cmd *se_cmd)
>   {
> @@ -1141,6 +1209,85 @@ static void tcmu_set_next_deadline(struct list_head *queue,
>   		del_timer(timer);
>   }
>   
> +static int
> +tcmu_tmr_type(enum tcm_tmreq_table tmf)
> +{
> +	switch (tmf) {
> +	case TMR_ABORT_TASK:		return TCMU_TMR_ABORT_TASK;
> +	case TMR_ABORT_TASK_SET:	return TCMU_TMR_ABORT_TASK_SET;
> +	case TMR_CLEAR_ACA:		return TCMU_TMR_CLEAR_ACA;
> +	case TMR_CLEAR_TASK_SET:	return TCMU_TMR_CLEAR_TASK_SET;
> +	case TMR_LUN_RESET:		return TCMU_TMR_LUN_RESET;
> +	case TMR_TARGET_WARM_RESET:	return TCMU_TMR_TARGET_WARM_RESET;
> +	case TMR_TARGET_COLD_RESET:	return TCMU_TMR_TARGET_COLD_RESET;
> +	case TMR_LUN_RESET_PRO:		return TCMU_TMR_LUN_RESET_PRO;
> +	default:			return TCMU_TMR_UNKNOWN;
> +	}
> +}
> +
> +static void
> +tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
> +		struct list_head *cmd_list)
> +{
> +	int i = 0, cmd_cnt = 0;
> +	bool unqueued = false;
> +	uint16_t *cmd_ids = NULL;
> +	struct tcmu_cmd *cmd;
> +	struct se_cmd *se_cmd;
> +	struct tcmu_tmr *tmr;
> +	struct tcmu_dev *dev = TCMU_DEV(se_dev);
> +
> +	mutex_lock(&dev->cmdr_lock);
> +
> +	// First we check for aborted commands in qfull_queue

I know the coding style doc does not say to never use // anymore, but 
just use the same style we have already in the rest of the code for 
single line comments:

/* comment */


>   
> +struct tcmu_tmr_entry {
> +	struct tcmu_cmd_entry_hdr hdr;
> +
> +#define TCMU_TMR_UNKNOWN		0
> +#define TCMU_TMR_ABORT_TASK		1
> +#define TCMU_TMR_ABORT_TASK_SET		2
> +#define TCMU_TMR_CLEAR_ACA		3
> +#define TCMU_TMR_CLEAR_TASK_SET		4
> +#define TCMU_TMR_LUN_RESET		5
> +#define TCMU_TMR_TARGET_WARM_RESET	6
> +#define TCMU_TMR_TARGET_COLD_RESET	7
> +/* Pseudo reset due to received PR OUT */
> +#define TCMU_TMR_LUN_RESET_PRO		128
> +	__u8 tmr_type;
> +
> +	__u8 __pad1;
> +	__u16 __pad2;
> +	__u32 cmd_cnt;
> +	__u64 __pad3;
> +	__u64 __pad4;
> +	__u16 cmd_ids[0];
> +} __packed;
> +

Is this new request and the tmr_notify callback just supposed to clean 
up the requested commands or is it supposed to perform the actions of 
the task management function defined in the specs?

The callback name makes it feel like it's just a notification, but the 
names above make it seem like we are supposed to execute the TMF in 
userspace. But if the latter, then how do we notify the kernel if the 
TMF was successful or failed?

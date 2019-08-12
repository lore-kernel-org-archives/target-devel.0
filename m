From: Damien Le Moal <Damien.LeMoal@wdc.com>
Date: Mon, 12 Aug 2019 18:00:22 +0000
Subject: Re: [PATCH v2] tcmu: avoid use-after-free after command timeout
Message-Id: <BYAPR04MB5816B8BFAE68F477F5A0C8D3E7D30@BYAPR04MB5816.namprd04.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190811182510.1706-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <Dmitry.Fomichev@wdc.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, Mike Christie <mchristi@redhat.com>, Bart Van Assche <bvanassche@acm.org>

On 2019/08/11 11:25, Dmitry Fomichev wrote:
> In tcmu_handle_completion() function, the variable called read_len is
> always initialized with a value taken from se_cmd structure. If this
> function is called to complete an expired (timed out) out command, the
> session command pointed by se_cmd is likely to be already deallocated by
> the target core at that moment. As the result, this access triggers a
> use-after-free warning from KASAN.
> 
> This patch fixes the code not to touch se_cmd when completing timed out
> TCMU commands. It also resets the pointer to se_cmd at the time when the
> TCMU_CMD_BIT_EXPIRED flag is set because it is going to become invalid
> after calling target_complete_cmd() later in the same function,
> tcmu_check_expired_cmd().
> 
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  drivers/target/target_core_user.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 04eda111920e..661bb9358364 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1132,14 +1132,16 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
>  	struct se_cmd *se_cmd = cmd->se_cmd;
>  	struct tcmu_dev *udev = cmd->tcmu_dev;
>  	bool read_len_valid = false;
> -	uint32_t read_len = se_cmd->data_length;
> +	uint32_t read_len;
>  
>  	/*
>  	 * cmd has been completed already from timeout, just reclaim
>  	 * data area space and free cmd
>  	 */
> -	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
> +	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
> +		WARN_ON_ONCE(se_cmd);
>  		goto out;
> +	}
>  
>  	list_del_init(&cmd->queue_entry);
>  
> @@ -1152,6 +1154,7 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
>  		goto done;
>  	}
>  
> +	read_len = se_cmd->data_length;
>  	if (se_cmd->data_direction == DMA_FROM_DEVICE &&
>  	    (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) && entry->rsp.read_len) {
>  		read_len_valid = true;
> @@ -1307,6 +1310,7 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
>  		 */
>  		scsi_status = SAM_STAT_CHECK_CONDITION;
>  		list_del_init(&cmd->queue_entry);
> +		cmd->se_cmd = NULL;
>  	} else {
>  		list_del_init(&cmd->queue_entry);
>  		idr_remove(&udev->commands, id);
> @@ -2022,6 +2026,7 @@ static void tcmu_reset_ring(struct tcmu_dev *udev, u8 err_level)
>  
>  		idr_remove(&udev->commands, i);
>  		if (!test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
> +			WARN_ON(!cmd->se_cmd);

May be WARN_ON_ONCE() similarly to the previous one ? No strong opinion about it
though.

>  			list_del_init(&cmd->queue_entry);
>  			if (err_level == 1) {
>  				/*
> 

Apart from the optional nit above:

Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research

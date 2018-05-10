From: Mike Christie <mchristi@redhat.com>
Date: Thu, 10 May 2018 18:51:59 +0000
Subject: Re: [PATCH v2] target: transport should allow st ILI reads
Message-Id: <5AF494CF.6020005@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180509205921.12348-1-lduncan@suse.com>
In-Reply-To: <20180509205921.12348-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/09/2018 03:59 PM, Lee Duncan wrote:
> When a tape drive is exported via LIO using the
> pscsi module, a read that requests more bytes per block
> than the tape can supply returns an empty buffer. This
> is because the pscsi pass-through target module sees
> the "ILI" illegal length bit set and thinks there
> is no reason to return the data.
> 
> This is a long-standing transport issue, since it
> assume that no data need be returned under a check
> condition, which isn't always the case for tape.
> 
> Add in a check for tape reads with the the ILI, EOM,
> or FM bits set, with a sense code of NO_SENSE,
> treating such cases as if there is no sense data
> and the read succeeded. The layered tape driver then
> "does the right thing" when it gets such a response.
> 
> Changes from RFC:
>  - Moved ugly code from transport to pscsi module
>  - Added checking EOM and FM bits, as well as ILI
>  - fixed malformed patch
>  - Clarified description a bit
> 
> Signed-off-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/target/target_core_pscsi.c     | 22 +++++++++++++++++++++-
>  drivers/target/target_core_transport.c |  6 ++++++
>  include/target/target_core_base.h      |  1 +
>  3 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 0d99b242e82e..b237104af81c 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -689,8 +689,28 @@ static void pscsi_complete_cmd(struct se_cmd *cmd, u8 scsi_status,
>  	}
>  after_mode_select:
>  
> -	if (scsi_status = SAM_STAT_CHECK_CONDITION)
> +	if (scsi_status = SAM_STAT_CHECK_CONDITION) {
>  		transport_copy_sense_to_cmd(cmd, req_sense);
> +
> +		/*
> +		 * hack to check for TAPE device reads with
> +		 * FM/EOM/ILI set, so that we can get data
> +		 * back despite framework assumption that a
> +		 * check condition means there is no data
> +		 */
> +		if ((sd->type = TYPE_TAPE) &&
> +		    (cmd->data_direction = DMA_FROM_DEVICE)) {
> +			/*
> +			 * is sense data valid, fixed format,
> +			 * and have FM, EOM, or ILI set?
> +			 */
> +			if ((req_sense[0] = 0xf0) &&	/* valid, fixed format */
> +			    (req_sense[2] & 0xe0) &&	/* FM, EOM, or ILI */
> +			    ((req_sense[2] & 0xf) = 0)) { /* key=NO_SENSE */
> +				cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;
> +			}
> +		}
> +	}
>  }
>  
>  enum {
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 74b646f165d4..56661a824266 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2192,6 +2192,11 @@ static void target_complete_ok_work(struct work_struct *work)
>  	if (atomic_read(&cmd->se_dev->dev_qf_count) != 0)
>  		schedule_work(&cmd->se_dev->qf_work_queue);
>  
> +	if (cmd->se_cmd_flags & SCF_TREAT_READ_AS_NORMAL) {
> +		pr_debug("Tape FM/EOM/ILI status detected. Treating as OK\n");
> +		goto treat_as_normal_read;
> +	}
> +
>  	/*
>  	 * Check if we need to send a sense buffer from
>  	 * the struct se_cmd in question.
> @@ -2241,6 +2246,7 @@ static void target_complete_ok_work(struct work_struct *work)
>  		if (cmd->scsi_status)
>  			goto queue_status;
>  
> +treat_as_normal_read:
>  		atomic_long_add(cmd->data_length,
>  				&cmd->se_lun->lun_stats.tx_data_octets);


Do you want to return both the data and sense or just one or the other?
Both right? In this code path we would return both the data and sense
for drivers like iscsi.

If the queue_data_in call a little below this line returns
-ENOMEM/-EAGAIN then I think the queue full handling is going to end up
only returning the sense like in your original bug. You would need a
similar change to transport_complete_qf so it returns the data.

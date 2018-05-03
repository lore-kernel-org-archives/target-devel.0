From: "Bryant G. Ly" <bryantly@linux.ibm.com>
Date: Thu, 03 May 2018 23:40:28 +0000
Subject: Re: [PATCH RFC] target transport: allow st INI reads
Message-Id: <e655bf3a-347b-919a-9fc5-980114259617@linux.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180503175340.3863-1-lduncan@suse.com>
In-Reply-To: <20180503175340.3863-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


On 5/3/18 12:53 PM, Lee Duncan wrote:

> When a tape drive is exported via LIO using the
> pscsi module, a read that requests more bytes per block
> than the tape can supply returns an empty buffer. This
> is because the pscsi pass-through target module sees
> the "ILI" illegal length bit set and thinks there
> is no reason to return the data.
>
> Add in a hack to check for tape reads with the INI
> bit set, treating such cases as if there is no
> sense data. The tape driver then "does the right
> thing" when it gets the INI bit and that date.
>
> NOTE: I'm not sure if this is the right place to effect
> this change, nor if it's the right approach, so comments/
> suggestions are welcomed!
> ---
>   drivers/target/target_core_transport.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 836d552b0385..aafd64b514fe 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2187,7 +2187,25 @@ static void target_complete_ok_work(struct work_struct *work)
>   	 * the struct se_cmd in question.
>   	 */
>   	if (cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) {
> +		struct se_device *dev = cmd->se_dev;
> +		unsigned char *sense = cmd->sense_buffer;
> +
>   		WARN_ON(!cmd->scsi_status);
> +
> +		/*
> +		 * hack: check for tape reads with the ILI (illegal
> +		 * length indicator) set, and just pass those through
> +		 */
> +		if ((dev->transport->get_device_type(dev) = TYPE_TAPE) &&
> +		    (cmd->scsi_status = SAM_STAT_CHECK_CONDITION) &&
> +		    (cmd->data_direction = DMA_FROM_DEVICE)) {
> +			if ((sense[0] = 0xf0) &&	/* 'valid' and 'fixed format' */
> +			    (sense[2] & 0x20)) {	/* 'ILI' */
> +				pr_debug("Tape ILI Bit detected. Treating as OK\n");
> +				goto treat_as_normal_read;
>
Is this an incomplete patch? I don't see this function
having the goto treat_as_normal_read?

But I'd prob just move this code into target_core_pscsi then
just set a flag so that this function can just look for that flag.
That way it looks less like of a hack.

if (cmd->se_cmd_flags & NEWFLAG) goto treat_as_normal_read;

-Bryant


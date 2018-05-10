From: Christoph Hellwig <hch@infradead.org>
Date: Thu, 10 May 2018 08:17:03 +0000
Subject: Re: [PATCH v2] target: transport should allow st ILI reads
Message-Id: <20180510081703.GA10560@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180509205921.12348-1-lduncan@suse.com>
In-Reply-To: <20180509205921.12348-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, May 09, 2018 at 01:59:21PM -0700, Lee Duncan wrote:
> When a tape drive is exported via LIO using the
> pscsi module, a read that requests more bytes per block
> than the tape can supply returns an empty buffer. This
> is because the pscsi pass-through target module sees
> the "ILI" illegal length bit set and thinks there
> is no reason to return the data.

Please use the full line length available for commit messages..

> and the read succeeded. The layered tape driver then
> "does the right thing" when it gets such a response.
>  - Moved ugly code from transport to pscsi module

probably wants and uptdate of the subject line as well.

> +		 * hack to check for TAPE device reads with
> +		 * FM/EOM/ILI set, so that we can get data
> +		 * back despite framework assumption that a
> +		 * check condition means there is no data
> +		 */
> +		if ((sd->type = TYPE_TAPE) &&
> +		    (cmd->data_direction = DMA_FROM_DEVICE)) {

No need for the inner braces.

> +			if ((req_sense[0] = 0xf0) &&	/* valid, fixed format */
> +			    (req_sense[2] & 0xe0) &&	/* FM, EOM, or ILI */
> +			    ((req_sense[2] & 0xf) = 0)) { /* key=NO_SENSE */
> +				cmd->se_cmd_flags |= SCF_TREAT_READ_AS_NORMAL;

Same here.

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
>  		/*

The goto looks at least a little odd as it skips many things that
don't look realted.  As far as I can tell what you want to skip is
mostly the SCF_TRANSPORT_TASK_SENSE check, which can be done with
an additional conditional.  Do we also need to skip the scsi_status
check above?  If yes it needs another conditional, and a good comment.

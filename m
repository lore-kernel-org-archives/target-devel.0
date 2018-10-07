From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Sun, 07 Oct 2018 01:31:20 +0000
Subject: Re: [PATCH 08/17] target/core: Make compare_and_write_callback() accept NULL as third argument
Message-Id: <1538875880.5272.19.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-9-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-9-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-09-17 at 14:35 -0700, Bart Van Assche wrote:
> This patch does not change any functionality. A later patch in this series,
> namely "Make ABORT and LUN RESET handling synchronous", depends on this
> patch.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_sbc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
> index 689ba6da9a0f..4719e6a98430 100644
> --- a/drivers/target/target_core_sbc.c
> +++ b/drivers/target/target_core_sbc.c
> @@ -482,7 +482,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
>  	if (cmd->scsi_status) {
>  		pr_debug("compare_and_write_callback: non zero scsi_status:"
>  			" 0x%02x\n", cmd->scsi_status);
> -		*post_ret = 1;
> +		if (post_ret)
> +			*post_ret = 1;
>  		if (cmd->scsi_status = SAM_STAT_CHECK_CONDITION)
>  			ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
>  		goto out;

Looks fine, but should be folded into patch #9 since it's the one who is
first passing a NULL in *post_ret transport_generic_request_failure().

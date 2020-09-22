From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 22 Sep 2020 17:28:14 +0000
Subject: Re: [PATCH] scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case.
Message-Id: <f850f290-c2f9-6ed9-1d84-980e1ba26c99@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1600300471-26135-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, martin.petersen@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: ssudhakarp@gmail.com

On 9/16/20 6:54 PM, Sudhakar Panneerselvam wrote:
> transport_lookup_tmr_lun() uses "orig_fe_lun" member of struct se_cmd
> for the lookup. Hence, update this field directly for the
> TARGET_SCF_LOOKUP_LUN_FROM_TAG case.
> 
> Fixes: a36840d80027 ("target: Initialize LUN in transport_init_se_cmd()")
> Reported-by: Martin Wilck <mwilck@suse.com>
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  drivers/target/target_core_transport.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 9fb0be0aa620..8dd289214dd8 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1840,7 +1840,8 @@ int target_submit_tmr(struct se_cmd *se_cmd, struct se_session *se_sess,
>  	 * out unpacked_lun for the original se_cmd.
>  	 */
>  	if (tm_type = TMR_ABORT_TASK && (flags & TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
> -		if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
> +		if (!target_lookup_lun_from_tag(se_sess, tag,
> +						&se_cmd->orig_fe_lun))
>  			goto failure;
>  	}
>  
> 

Reviewed-by: Mike Christie <michael.christie@oracle.com>

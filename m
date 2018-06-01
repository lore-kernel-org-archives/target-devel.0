From: Mike Christie <mchristi@redhat.com>
Date: Fri, 01 Jun 2018 19:27:23 +0000
Subject: Re: [PATCH] target: fix truncated PR-in ReadKeys response
Message-Id: <5B119E1B.6040202@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180531222054.32655-1-ddiss@suse.de>
In-Reply-To: <20180531222054.32655-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/31/2018 05:20 PM, David Disseldorp wrote:
> SPC5r17 states that the contents of the ADDITIONAL LENGTH field are not
> altered based on the allocation length, so always calculate and pack the
> full key list length even if the list itself is truncated.
> 
> This behaviour can be tested using the libiscsi PrinReadKeys.Truncate
> test.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_pr.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 01ac306131c1..2e865fdaa362 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -3727,11 +3727,16 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
>  		 * Check for overflow of 8byte PRI READ_KEYS payload and
>  		 * next reservation key list descriptor.
>  		 */
> -		if ((add_len + 8) > (cmd->data_length - 8))
> -			break;
> -
> -		put_unaligned_be64(pr_reg->pr_res_key, &buf[off]);
> -		off += 8;
> +		if ((off + 8) <= cmd->data_length) {
> +			put_unaligned_be64(pr_reg->pr_res_key, &buf[off]);
> +			off += 8;
> +		}
> +		/*
> +		 * SPC5r17: 6.16.2 READ KEYS service action
> +		 * The ADDITIONAL LENGTH field indicates the number of bytes in
> +		 * the Reservation key list. The contents of the ADDITIONAL
> +		 * LENGTH field are not altered based on the allocation length
> +		 */
>  		add_len += 8;
>  	}
>  	spin_unlock(&dev->t10_pr.registration_lock);
> 

Looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>

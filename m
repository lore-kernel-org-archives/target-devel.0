From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 01 Sep 2020 17:55:23 +0000
Subject: Re: [PATCH] scsi: target: iscsi: Fix data digest calculation
Message-Id: <56a124d4-d503-d8b2-332b-99f1c2288463@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1598358910-3052-1-git-send-email-varun@chelsio.com>
In-Reply-To: <1598358910-3052-1-git-send-email-varun@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Varun Prakash <varun@chelsio.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org, nab@linux-iscsi.org, stable@vger.kernel.org

On 8/25/20 7:35 AM, Varun Prakash wrote:
> Current code does not consider 'page_off' in data digest
> calculation, to fix this add a local variable 'first_sg' and
> set first_sg.offset to sg->offset + page_off.
> 
> Fixes: e48354ce078c ("iscsi-target: Add iSCSI fabric support for target v4.1")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Varun Prakash <varun@chelsio.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index c968961..2ec778e 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1389,14 +1389,27 @@ static u32 iscsit_do_crypto_hash_sg(
>  	sg = cmd->first_data_sg;
>  	page_off = cmd->first_data_sg_off;
>  
> +	if (data_length && page_off) {
> +		struct scatterlist first_sg;
> +		u32 len = min_t(u32, data_length, sg->length - page_off);
> +
> +		sg_init_table(&first_sg, 1);
> +		sg_set_page(&first_sg, sg_page(sg), len, sg->offset + page_off);
> +
> +		ahash_request_set_crypt(hash, &first_sg, NULL, len);
> +		crypto_ahash_update(hash);
> +
> +		data_length -= len;
> +		sg = sg_next(sg);
> +	}
> +
>  	while (data_length) {
> -		u32 cur_len = min_t(u32, data_length, (sg->length - page_off));
> +		u32 cur_len = min_t(u32, data_length, sg->length);
>  
>  		ahash_request_set_crypt(hash, sg, NULL, cur_len);
>  		crypto_ahash_update(hash);
>  
>  		data_length -= cur_len;
> -		page_off = 0;
>  		/* iscsit_map_iovec has already checked for invalid sg pointers */
>  		sg = sg_next(sg);
>  	}
> 

Looks ok to me.

Reviewed-by: Mike Christie <michael.christie@oralce.com>

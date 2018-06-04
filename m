From: "Maged Mokhtar" <mmokhtar@petasan.org>
Date: Mon, 04 Jun 2018 11:16:45 +0000
Subject: Re: [PATCH] target: fix truncated PR-in ReadKeys response
Message-Id: <8E1956E152D945F9B3BC20D277595DB0@SANAtechPC>
List-Id: <target-devel.vger.kernel.org>
References: <20180531222054.32655-1-ddiss@suse.de>
In-Reply-To: <20180531222054.32655-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



--------------------------------------------------
From: "David Disseldorp" <ddiss@suse.de>
Sent: Friday, June 01, 2018 1:20 AM
To: <target-devel@vger.kernel.org>
Cc: "ronnie sahlberg" <ronniesahlberg@gmail.com>; "David Disseldorp" 
<ddiss@suse.de>
Subject: [PATCH] target: fix truncated PR-in ReadKeys response

> SPC5r17 states that the contents of the ADDITIONAL LENGTH field are not
> altered based on the allocation length, so always calculate and pack the
> full key list length even if the list itself is truncated.
>
> This behaviour can be tested using the libiscsi PrinReadKeys.Truncate
> test.
>
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
> drivers/target/target_core_pr.c | 15 ++++++++++-----
> 1 file changed, 10 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/target/target_core_pr.c 
> b/drivers/target/target_core_pr.c
> index 01ac306131c1..2e865fdaa362 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -3727,11 +3727,16 @@ core_scsi3_pri_read_keys(struct se_cmd *cmd)
>  * Check for overflow of 8byte PRI READ_KEYS payload and
>  * next reservation key list descriptor.
>  */
> - if ((add_len + 8) > (cmd->data_length - 8))
> - break;
> -
> - put_unaligned_be64(pr_reg->pr_res_key, &buf[off]);
> - off += 8;
> + if ((off + 8) <= cmd->data_length) {
> + put_unaligned_be64(pr_reg->pr_res_key, &buf[off]);
> + off += 8;
> + }
> + /*
> + * SPC5r17: 6.16.2 READ KEYS service action
> + * The ADDITIONAL LENGTH field indicates the number of bytes in
> + * the Reservation key list. The contents of the ADDITIONAL
> + * LENGTH field are not altered based on the allocation length
> + */
>  add_len += 8;
>  }
>  spin_unlock(&dev->t10_pr.registration_lock);
> -- 
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



This also fixes an issue in Windows server 2016 failover cluster with
many client connections, the initial allocation length sent in cdb is
72 bytes which  limits it to 8 keys, with additional length not affected
by truncation, it will retry with correct size.
Interesting I was looking at the same issue in target_core_rbd. 


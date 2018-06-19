From: David Disseldorp <ddiss@suse.de>
Date: Tue, 19 Jun 2018 12:02:16 +0000
Subject: Re: [PATCH v2] target: fix truncated PR-in ReadKeys response
Message-Id: <20180619140216.23077c60@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180605100025.12112-1-ddiss@suse.de>
In-Reply-To: <20180605100025.12112-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

cc'ing the SCSI list, as it doesn't look like anything is making it
through target-devel nowadays...
https://patchwork.kernel.org/patch/10448059/

Cheers, David

On Tue,  5 Jun 2018 12:00:25 +0200, David Disseldorp wrote:

> SPC5r17 states that the contents of the ADDITIONAL LENGTH field are not
> altered based on the allocation length, so always calculate and pack the
> full key list length even if the list itself is truncated.
> 
> According to Maged:
>   Yes it fixes the "Storage Spaces Persistent Reservation" test in the
>   Windows 2016 Server Failover Cluster validation suites when having
>   many connections that result in more than 8 registrations. I tested
>   your patch on 4.17 with iblock.
> 
> This behaviour can be tested using the libiscsi PrinReadKeys.Truncate
> test.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> Reviewed-by: Mike Christie <mchristi@redhat.com>
> Tested-by: Maged Mokhtar <mmokhtar@petasan.org>
> ---
>  drivers/target/target_core_pr.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)
> 
> Changes since v1:
> * CC stable
> * mention Maged's Windows PR test fix comment in commit message
> * add Reviewed-by and Tested-by tags
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


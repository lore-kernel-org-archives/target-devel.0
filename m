From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 19 Nov 2019 05:32:57 +0000
Subject: Re: [PATCH] target: Fix a pr_debug() argument
Message-Id: <yq1blt8ig6u.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191107215525.64415-1-bvanassche@acm.org>
In-Reply-To: <20191107215525.64415-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Hi Bart!

> Print the string for which conversion failed instead of printing the
> function name twice.

What do you mean wrt. printing the function name twice?

> Cc: Christoph Hellwig <hch@lst.de>
> Fixes: 2650d71e244f ("target: move transport ID handling to the core")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/target/target_core_fabric_lib.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
> index 3c79411c4cd0..6b4b354c88aa 100644
> --- a/drivers/target/target_core_fabric_lib.c
> +++ b/drivers/target/target_core_fabric_lib.c
> @@ -118,7 +118,7 @@ static int srp_get_pr_transport_id(
>  	memset(buf + 8, 0, leading_zero_bytes);
>  	rc = hex2bin(buf + 8 + leading_zero_bytes, p, count);
>  	if (rc < 0) {
> -		pr_debug("hex2bin failed for %s: %d\n", __func__, rc);
> +		pr_debug("hex2bin failed for %s: %d\n", p, rc);
>  		return rc;
>  	}

-- 
Martin K. Petersen	Oracle Linux Engineering

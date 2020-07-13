From: Himanshu Madhani <himanshu.madhani@oracle.com>
Date: Mon, 13 Jul 2020 17:05:58 +0000
Subject: Re: [PATCH -next] scsi: target: Remove unused variable 'tpg'
Message-Id: <1fdb8a6d-e820-257c-3c94-b0a470beeb71@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200709114636.69256-1-weiyongjun1@huawei.com>
In-Reply-To: <20200709114636.69256-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yongjun <weiyongjun1@huawei.com>, Hulk Robot <hulkci@huawei.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



On 7/9/20 6:46 AM, Wei Yongjun wrote:
> Gcc report warning as follows:
> 
> drivers/target/target_core_pr.c:1162:26: warning:
>   variable 'tpg' set but not used [-Wunused-but-set-variable]
>   1162 |  struct se_portal_group *tpg;
>        |                          ^~~
> 
> After commit 63c9ffe473d3 ("scsi: target: Check enforce_pr_isids
> during registration"), 'tpg' is never used, so removing it to
> avoid build warning.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>   drivers/target/target_core_pr.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 300b03b1b696..8fc88654bff6 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -1159,7 +1159,6 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
>   {
>   	struct t10_reservation *pr_tmpl = &dev->t10_pr;
>   	struct t10_pr_registration *pr_reg, *pr_reg_tmp;
> -	struct se_portal_group *tpg;
>   
>   	spin_lock(&pr_tmpl->registration_lock);
>   	list_for_each_entry_safe(pr_reg, pr_reg_tmp,
> @@ -1170,7 +1169,6 @@ static struct t10_pr_registration *__core_scsi3_locate_pr_reg(
>   		if (pr_reg->pr_reg_nacl != nacl)
>   			continue;
>   
> -		tpg = pr_reg->pr_reg_nacl->se_tpg;
>   		/*
>   		 * If this registration does NOT contain a fabric provided
>   		 * ISID, then we have found a match.
> 
Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                     Oracle Linux Engineering

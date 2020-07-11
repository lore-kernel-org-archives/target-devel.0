From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Date: Sat, 11 Jul 2020 18:28:35 +0000
Subject: Re: [PATCH -next] scsi: target: Remove unused variable 'tpg'
Message-Id: <BYAPR04MB496584475C53DE2B9B9ABA8786620@BYAPR04MB4965.namprd04.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200709114636.69256-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yongjun <weiyongjun1@huawei.com>, Hulk Robot <hulkci@huawei.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

On 7/9/20 04:36, Wei Yongjun wrote:
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
> Reported-by: Hulk Robot<hulkci@huawei.com>
> Signed-off-by: Wei Yongjun<weiyongjun1@huawei.com>

Looks good to me.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

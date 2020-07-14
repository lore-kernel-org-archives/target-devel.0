From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 14 Jul 2020 04:58:46 +0000
Subject: Re: [PATCH -next] scsi: target: Remove unused variable 'tpg'
Message-Id: <159470266467.11195.6170018447771951517.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200709114636.69256-1-weiyongjun1@huawei.com>
In-Reply-To: <20200709114636.69256-1-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yongjun <weiyongjun1@huawei.com>, Hulk Robot <hulkci@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Thu, 9 Jul 2020 19:46:36 +0800, Wei Yongjun wrote:

> Gcc report warning as follows:
> 
> drivers/target/target_core_pr.c:1162:26: warning:
>  variable 'tpg' set but not used [-Wunused-but-set-variable]
>  1162 |  struct se_portal_group *tpg;
>       |                          ^~~
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: target: Remove unused variable 'tpg'
      https://git.kernel.org/mkp/scsi/c/dd06a40201fe

-- 
Martin K. Petersen	Oracle Linux Engineering

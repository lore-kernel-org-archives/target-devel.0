From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 25 May 2020 09:11:38 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
Message-Id: <68d6b1e9-65fa-e91c-e55e-f520839b5efe@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200523101129.GB98132@mwanda>
In-Reply-To: <20200523101129.GB98132@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On 05/23/20 12:11, Dan Carpenter wrote:
> The pr_debug() dereferences "cmd" after we already freed it by calling
> tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.
> 
> Fixes: 61fb24822166 ("scsi: target: tcmu: Userspace must not complete queued commands")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> ---
>   drivers/target/target_core_user.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)
> 

Thank you.

I'm very sorry for this stupid bug.

BR, Bodo

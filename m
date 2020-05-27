From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 27 May 2020 02:12:55 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
Message-Id: <159054550934.12032.1754394879666854643.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200523101129.GB98132@mwanda>
In-Reply-To: <20200523101129.GB98132@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter@oracle.com>, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, kernel-janitors@vger.kernel.org

On Sat, 23 May 2020 13:11:29 +0300, Dan Carpenter wrote:

> The pr_debug() dereferences "cmd" after we already freed it by calling
> tcmu_free_cmd(cmd).  The debug printk needs to be done earlier.

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Fix a use after free in tcmu_check_expired_queue_cmd()
      https://git.kernel.org/mkp/scsi/c/9d7464b18892

-- 
Martin K. Petersen	Oracle Linux Engineering

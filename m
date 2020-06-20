From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Sat, 20 Jun 2020 03:26:35 +0000
Subject: Re: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM
Message-Id: <159262354735.7800.15424809109743064228.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>

On Thu, 18 Jun 2020 15:16:30 +0200, Bodo Stroesser wrote:

> This small series of patches consists of:
>    [PATCH 1/2 v2] scsi: target: tcmu: Optimize use of flush_dcache_page
>    [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
> 
> Together with commit
>    8c4e0f212398 scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
> these patches fix crashes in tcmu on ARM.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/2] scsi: target: tcmu: Optimize use of flush_dcache_page
      https://git.kernel.org/mkp/scsi/c/3c58f737231e
[2/2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM
      https://git.kernel.org/mkp/scsi/c/3145550a7f8b

-- 
Martin K. Petersen	Oracle Linux Engineering

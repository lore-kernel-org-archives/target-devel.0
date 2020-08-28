From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Fri, 28 Aug 2020 08:43:35 +0000
Subject: Re: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM
Message-Id: <ec08c542-5903-4ebd-d18e-9c9b2f067eb6@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200618131632.32748-1-bstroesser@ts.fujitsu.com>
 <159262354735.7800.15424809109743064228.b4-ty@oracle.com>
In-Reply-To: <159262354735.7800.15424809109743064228.b4-ty@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, stable@vger.kernel.org
Cc: JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>

Hi,

I'm adding stable@vger.kernel.org

On 2020-06-20 05:26, Martin K. Petersen wrote:
> On Thu, 18 Jun 2020 15:16:30 +0200, Bodo Stroesser wrote:
> 
>> This small series of patches consists of:
>>     [PATCH 1/2 v2] scsi: target: tcmu: Optimize use of flush_dcache_page
>>     [PATCH 2/2 v2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
>>
>> Together with commit
>>     8c4e0f212398 scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
>> these patches fix crashes in tcmu on ARM.
>>
>> [...]
> 
> Applied to 5.9/scsi-queue, thanks!
> 
> [1/2] scsi: target: tcmu: Optimize use of flush_dcache_page
>        https://git.kernel.org/mkp/scsi/c/3c58f737231e
> [2/2] scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range on ARM
>        https://git.kernel.org/mkp/scsi/c/3145550a7f8b
> 

Patch 2/2 of this series already made it into 5.8, (5.7,) 5.4 and 4.19,
but patch 1/2 was not added yet. The crash will be fixed with with both
patches only. So please consider adding patch 1/2 also. The full commit
is 3c58f737231e2c8cbf543a09d84d8c8e80e05e43

Thank you
Bodo

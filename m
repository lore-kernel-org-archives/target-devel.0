From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 30 Jun 2020 03:23:03 +0000
Subject: Re: [PATCH v2] scsi: target: tcmu: Fix crash on ARM during cmd completion
Message-Id: <159348736490.22355.1210827363211730704.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200629093756.8947-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200629093756.8947-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, JiangYu <lnsyyj@hotmail.com>, Henry Willard <henry.willard@oracle.com>, Daniel Meyerholt <dxm523@gmail.com>

On Mon, 29 Jun 2020 11:37:56 +0200, Bodo Stroesser wrote:

> If tcmu_handle_completions() has to process a padding shorter
> than sizeof(struct tcmu_cmd_entry), the current call to
> tcmu_flush_dcache_range() with sizeof(struct tcmu_cmd_entry) as
> length param is wrong and causes crashes on e.g. ARM, because
> tcmu_flush_dcache_range() in this case calls
> 	flush_dcache_page(vmalloc_to_page(start));
> with start being an invalid address above the end of the
> vmalloc'ed area.
> 
> [...]

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Fix crash on ARM during cmd completion
      https://git.kernel.org/mkp/scsi/c/5a0c256d96f0

-- 
Martin K. Petersen	Oracle Linux Engineering

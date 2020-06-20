From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Sat, 20 Jun 2020 03:26:34 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Remove unnecessary bit TCMU_CMD_BIT_INFLIGHT
Message-Id: <159262354734.7800.12324526277284503765.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200619173806.5016-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200619173806.5016-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Mike Christie <michael.christie@oracle.com>, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>

On Fri, 19 Jun 2020 19:38:06 +0200, Bodo Stroesser wrote:

> Since
> commit 61fb24822166 ("scsi: target: tcmu: Userspace must not complete
>  queued commands")
> tcmu_cmd bit TCMU_CMD_BIT_INFLIGHT is set but never checked.
> So we can remove it safely.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Remove unnecessary bit TCMU_CMD_BIT_INFLIGHT
      https://git.kernel.org/mkp/scsi/c/da3f28da1c27

-- 
Martin K. Petersen	Oracle Linux Engineering

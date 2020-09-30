From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 30 Sep 2020 03:34:46 +0000
Subject: Re: [PATCH 0/3] target: scsi: tcmu: code rework and speed up of read data handling
Message-Id: <160143685412.27701.100112187449074876.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, Bodo Stroesser <bstroesser@ts.fujitsu.com>, Mike Christie <michael.christie@oracle.com>, target-devel@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>

On Thu, 10 Sep 2020 17:50:38 +0200, Bodo Stroesser wrote:

> This small series is made on top of Martin's 5.10/scsi-queue branch.
> 
> The patches simplify some code, splits off new helper functions
> or implement a cleaner code sequence to prevent double work.
> The 3rd patch speeds up buffer preparation for SCSI commands with
> long read data.
> The series is also base for cleaned up version v3 of my patch
>   scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel
> 
> [...]

Applied to 5.10/scsi-queue, thanks!

[1/3] scsi: target: tcmu: Join tcmu_cmd_get_data_length() and tcmu_cmd_get_block_cnt()
      https://git.kernel.org/mkp/scsi/c/52ef2743f16c
[2/3] scsi: target: tcmu: Optimize queue_cmd_ring()
      https://git.kernel.org/mkp/scsi/c/7e98905e9d0d
[3/3] scsi: target: tcmu: Optimize scatter_data_area()
      https://git.kernel.org/mkp/scsi/c/3c9a7c58ea3d

-- 
Martin K. Petersen	Oracle Linux Engineering

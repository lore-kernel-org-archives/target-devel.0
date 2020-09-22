From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 22 Sep 2020 16:20:48 +0000
Subject: Re: [PATCH 0/3] target: scsi: tcmu: code rework and speed up of read data handling
Message-Id: <2ba4d645-02b2-acd4-f009-ad1aade5f048@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 9/10/20 10:50 AM, Bodo Stroesser wrote:
> This small series is made on top of Martin's 5.10/scsi-queue branch.
> 
> The patches simplify some code, splits off new helper functions
> or implement a cleaner code sequence to prevent double work.
> The 3rd patch speeds up buffer preparation for SCSI commands with
> long read data.
> The series is also base for cleaned up version v3 of my patch
>   scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel
> 
> Bodo Stroesser (3):
>   scsi: target: tcmu: join tcmu_cmd_get_data_length and tcmu_cmd_get_block_cnt
>   scsi: target: tcmu: optimize queue_cmd_ring
>   scsi: target: tcmu: optimize scatter_data_area
> 
>  drivers/target/target_core_user.c | 340 +++++++++++++++++++-------------------
>  1 file changed, 170 insertions(+), 170 deletions(-)
> 

Acked-by: Mike Christie <michael.christie@oracle.com>

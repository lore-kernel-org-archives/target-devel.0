From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 11 Nov 2020 02:58:23 +0000
Subject: Re: [PATCH 1/8] target: fix lun ref count handling
Message-Id: <160506295513.14063.6141786437368137956.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604257174-4524-1-git-send-email-michael.christie@oracle.com> <1604257174-4524-2-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604257174-4524-2-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, njavali@marvell.com, james.bottomley@hansenpartnership.com, himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>

On Sun, 1 Nov 2020 12:59:27 -0600, Mike Christie wrote:

> This fixes 2 bugs in the lun refcounting.
> 
> 1. For the TCM_WRITE_PROTECTED case we were returning an error after
> taking a ref to the lun, but never dropping it (caller just send
> status and drops cmd ref).
> 
> 2. We still need to do a percpu_ref_tryget_live for the virt lun0 like
> we do for other luns, because the tpg code does the refcount/wait
> process like it does with other luns.

Applied to 5.11/scsi-queue, thanks!

[1/8] scsi: target: Fix LUN ref count handling
      https://git.kernel.org/mkp/scsi/c/a2b5d6f975a4
[2/8] scsi: target: Fix cmd_count ref leak
      https://git.kernel.org/mkp/scsi/c/02dd4914b0bc
[3/8] scsi: qla2xxx: Drop TARGET_SCF_LOOKUP_LUN_FROM_TAG
      https://git.kernel.org/mkp/scsi/c/8f394da36a36
[4/8] scsi: target: Remove TARGET_SCF_LOOKUP_LUN_FROM_TAG
      https://git.kernel.org/mkp/scsi/c/27b0efd15d52
[5/8] scsi: qla2xxx: Move sess cmd list/lock to driver
      https://git.kernel.org/mkp/scsi/c/605e74025f95
[6/8] scsi: target: Drop sess_cmd_lock from I/O path
      https://git.kernel.org/mkp/scsi/c/6f55b06f9b07
[7/8] scsi: target: Make state_list per CPU
      https://git.kernel.org/mkp/scsi/c/1526d9f10c61
[8/8] scsi: tcm_loop: Allow queues, can_queue and cmd_per_lun to be settable
      https://git.kernel.org/mkp/scsi/c/94a0dfcf7d33

-- 
Martin K. Petersen	Oracle Linux Engineering

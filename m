From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Fri, 15 May 2020 01:10:25 +0000
Subject: Re: [PATCH v2] scsi: target: put lun_ref at end of tmr processing
Message-Id: <158950481363.8120.6288768454257707610.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200513153443.3554-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200513153443.3554-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bly@catalogicsoftware.com, Bodo Stroesser <bstroesser@ts.fujitsu.com>, bvanassche@acm.org
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, stable@vger.kernel.org

On Wed, 13 May 2020 17:34:43 +0200, Bodo Stroesser wrote:

> Testing with Loopback I found, that after a Loopback LUN
> has executed a TMR, I can no longer unlink the LUN.
> The rm command hangs in transport_clear_lun_ref() at
> wait_for_completion(&lun->lun_shutdown_comp)
> The reason is, that transport_lun_remove_cmd() is not
> called at the end of target_tmr_work().
> 
> [...]

Applied to 5.7/scsi-fixes, thanks!

[1/1] scsi: target: Put lun_ref at end of tmr processing
      https://git.kernel.org/mkp/scsi/c/f2e6b75f6ee8

-- 
Martin K. Petersen	Oracle Linux Engineering

From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 May 2020 23:05:40 +0000
Subject: Re: [PATCH] scsi: target: put lun_ref at end of tmr processing
Message-Id: <b5da2b56-2924-abec-2a8c-94d53741560d@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200512161753.10625-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200512161753.10625-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, martin.petersen@oracle.com, mchristi@readhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bly@catalogicsoftware.com

On 2020-05-12 09:17, Bodo Stroesser wrote:
> Testing with Loopback I found, that after a Loopback LUN
> has executed a TMR, I can no longer unlink the LUN.
> The rm command hangs in transport_clear_lun_ref() at
> wait_for_completion(&lun->lun_shutdown_comp)
> The reason is, that transport_lun_remove_cmd() is not
> called at the end of target_tmr_work().
> 
> It seems, that in other fabrics this call happens implicitly
> when the fabric drivers call transport_generic_free_cmd()
> during their ->queue_tm_rsp().
> 
> Unfortunately Loopback seems to not comply to the common way
> of calling transport_generic_free_cmd() from ->queue_*().
> Instead it calls transport_generic_free_cmd() from its
>   ->check_stop_free() only.
> 
> But the ->check_stop_free() is called by
> transport_cmd_check_stop_to_fabric() after it has reset the
> se_cmd->se_lun pointer.
> Therefore the following transport_generic_free_cmd() skips the
> transport_lun_remove_cmd().
> 
> So this patch re-adds the transport_lun_remove_cmd() at the end
> of target_tmr_work(), which was removed during commit
> 2c9fa49e100f962af988f1c0529231bf14905cda
> "scsi: target/core: Make ABORT and LUN RESET handling synchronous"
> 
> For fabrics using transport_generic_free_cmd() in the usual way
> the double call to transport_lun_remove_cmd() doesn't harm, as
> transport_lun_remove_cmd() checks for this situation and does
> not release lun_ref twice.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Tested-by: Bryant G. Ly <bryangly@gmail.com>

Please add Fixes: ... and Cc: stable tags. Anyway:

Reviewed-by: Bart van Assche <bvanassche@acm.org>

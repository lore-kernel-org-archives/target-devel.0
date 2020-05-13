From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Wed, 13 May 2020 15:34:43 +0000
Subject: [PATCH v2] scsi: target: put lun_ref at end of tmr processing
Message-Id: <20200513153443.3554-1-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, bvanassche@acm.org, mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bly@catalogicsoftware.com
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>, stable@vger.kernel.org

Testing with Loopback I found, that after a Loopback LUN
has executed a TMR, I can no longer unlink the LUN.
The rm command hangs in transport_clear_lun_ref() at
wait_for_completion(&lun->lun_shutdown_comp)
The reason is, that transport_lun_remove_cmd() is not
called at the end of target_tmr_work().

It seems, that in other fabrics this call happens implicitly
when the fabric drivers call transport_generic_free_cmd()
during their ->queue_tm_rsp().

Unfortunately Loopback seems to not comply to the common way
of calling transport_generic_free_cmd() from ->queue_*().
Instead it calls transport_generic_free_cmd() from its
  ->check_stop_free() only.

But the ->check_stop_free() is called by
transport_cmd_check_stop_to_fabric() after it has reset the
se_cmd->se_lun pointer.
Therefore the following transport_generic_free_cmd() skips the
transport_lun_remove_cmd().

So this patch re-adds the transport_lun_remove_cmd() at the end
of target_tmr_work(), which was removed during commit
2c9fa49e100f962af988f1c0529231bf14905cda
"scsi: target/core: Make ABORT and LUN RESET handling synchronous"

For fabrics using transport_generic_free_cmd() in the usual way
the double call to transport_lun_remove_cmd() doesn't harm, as
transport_lun_remove_cmd() checks for this situation and does
not release lun_ref twice.

Fixes: 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET handling synchronous")
Cc: stable@vger.kernel.org
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Tested-by: Bryant G. Ly <bryangly@gmail.com>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
---

v2:
 - Resend of the same patch with added tags "Fixes:",
   "Cc: stable@.." and "Reviewed-by:"

 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 594b724bbf79..264a822c0bfa 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3350,6 +3350,7 @@ static void target_tmr_work(struct work_struct *work)
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
-- 
2.12.3

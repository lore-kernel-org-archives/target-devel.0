From: Sasha Levin <sashal@kernel.org>
Date: Mon, 08 Jun 2020 23:04:33 +0000
Subject: [PATCH AUTOSEL 5.6 148/606] scsi: target: Put lun_ref at end of tmr processing
Message-Id: <20200608231211.3363633-148-sashal@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Bryant G . Ly" <bryangly@gmail.com>, Bart van Assche <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>

commit f2e6b75f6ee82308ef7b00f29e71e5f1c6b3d52a upstream.

Testing with Loopback I found that, after a Loopback LUN has executed a
TMR, I can no longer unlink the LUN.  The rm command hangs in
transport_clear_lun_ref() at wait_for_completion(&lun->lun_shutdown_comp)
The reason is, that transport_lun_remove_cmd() is not called at the end of
target_tmr_work().

It seems, that in other fabrics this call happens implicitly when the
fabric drivers call transport_generic_free_cmd() during their
->queue_tm_rsp().

Unfortunately Loopback seems to not comply to the common way
of calling transport_generic_free_cmd() from ->queue_*().
Instead it calls transport_generic_free_cmd() from its
  ->check_stop_free() only.

But the ->check_stop_free() is called by
transport_cmd_check_stop_to_fabric() after it has reset the se_cmd->se_lun
pointer.  Therefore the following transport_generic_free_cmd() skips the
transport_lun_remove_cmd().

So this patch re-adds the transport_lun_remove_cmd() at the end of
target_tmr_work(), which was removed during commit 2c9fa49e100f ("scsi:
target/core: Make ABORT and LUN RESET handling synchronous").

For fabrics using transport_generic_free_cmd() in the usual way the double
call to transport_lun_remove_cmd() doesn't harm, as
transport_lun_remove_cmd() checks for this situation and does not release
lun_ref twice.

Link: https://lore.kernel.org/r/20200513153443.3554-1-bstroesser@ts.fujitsu.com
Fixes: 2c9fa49e100f ("scsi: target/core: Make ABORT and LUN RESET handling synchronous")
Cc: stable@vger.kernel.org
Tested-by: Bryant G. Ly <bryangly@gmail.com>
Reviewed-by: Bart van Assche <bvanassche@acm.org>
Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/target/target_core_transport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 0ae9e60fc4d5..61486e5abee4 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3349,6 +3349,7 @@ static void target_tmr_work(struct work_struct *work)
 
 	cmd->se_tfo->queue_tm_rsp(cmd);
 
+	transport_lun_remove_cmd(cmd);
 	transport_cmd_check_stop_to_fabric(cmd);
 	return;
 
-- 
2.25.1

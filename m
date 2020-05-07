From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Thu, 07 May 2020 15:33:20 +0000
Subject: Lun unlink from configFS for Loopback after TMR execution hangs forever
Message-Id: <ffee233a-fe6d-e1c9-7071-9fb463453b0c@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, Mike Christie <mchristi@redhat.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>

Hi,

I am testing with Loopback and found, that after a
Loopback LUN has executed a TMR, I can no longer unlink
the LUN.

The rm command hangs in transport_clear_lun_ref() at
wait_for_completion(&lun->lun_shutdown_comp)

The reason is, that transport_lun_remove_cmd() is not
called at the end of target_tmr_work().

It seems, that in other fabrics this call happens implicitly
when the fabric driver calls transport_generic_free_cmd()
during its ->queue_tm_rsp().

Unfortunately the Loopback seems to not comply to the common
way of calling transport_generic_free_cmd() from ->queue_*(),
but calls it from its ->check_stop_free() only.

But the ->check_stop_free() is called by
transport_cmd_check_stop_to_fabric() after it has reset the
se_cmd->se_lun pointer.
Therefore the following transport_generic_free_cmd() skips the
transport_lun_remove_cmd().

So it seems, that Loopback driver is doing wrong.

OTOH, target_tmr_work() seems to be the only place, where
transport_cmd_check_stop_to_fabric() is called without
calling transport_lun_remove_cmd() before.

Now I'm wondering, how to fix the problem:
1) Just (re-)add a call to transport_lun_remove_cmd() before
    calling transport_cmd_check_stop_to_fabric() in
    target_tmr_work()
2) Change Loopback driver to comply with the usual way
    of using transport_generic_free_cmd()

I think I'd prefer 1 and already tested it, works fine for
Loopback. Currently I'm not able to test other fabrics, but
AFAICS the change should not harm other fabric drivers,
because transport_lun_remove_cmd() uses a bit to make safe,
that lun_ref is dropped only once.
Additionally, before commit 2c9fa49e100f "scsi: target/core:
  Make ABORT and LUN RESET handling synchronous" the code
contained the transport_lun_remove_cmd() call.

Regards,
Bodo

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 30 Jun 2020 10:47:01 +0000
Subject: [RFC PATCH 0/8] scsi: target: tcmu: Add TMR notification for tcmu
Message-Id: <20200630104709.23066-1-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

TCM/LIO core handles TMRs without involving backends.
But TMR completion message is sent to initiator only after
commands aborted by the TMR are completed by the backend.
Especially in case of tcmu backend, if userspace executes long
running commands and therefore initiator sends ABORT_TASK on
timeout, the ABORT itself can time out if core still waits for
userspace/tcmu to complete the command.

It would be very helpful for userspace to get a notification
about received TMR and which commands were aborted by that TMR.
Then userspace can decide whether to cancel command processing,
 and it can send command completion earlier than it would
without TMR notification.
It is also helpful for userspace traces and device emulation to
get notification about TMR events.

So this patch series in the first two patches implements in
core the usage of a new optional backend callback for TMR
notifications. The core calls it before core waits for
completion of aborted commands (params: se_dev, TMR type,
and list of se_cmds aborted by this TMR).
Of course other backends than tcmu can use this part of the
series also to implement their own TMR notification if
necessary.

The further six patches implement the TMR notify callback for
tcmu. The new configFS attribute tmr_notification allows to
switch on TMR messages on the cmd ring. The default of the
attribute is the old behavior without TMR info on the ring, but
with following changes:
 - if tcmu receives an already aborted command, it immediately
   rejects it. So it will never appear in userspace.
 - if tcmu finds, that according to TMR notification a cmd on
   the qfull_queue was aborted, tcmu removes it from qfull_queue
   and completes it immediately. So userspace will not 'see'
   those commands.

When attribute tmr_notification is set to 1, tcmu additionally
prepares a list of cmd_ids from those commands, that are aborted
by the TMR and are active in cmd ring (not timed out).
This list together with the TMR type is either immediately
written to cmd ring (new TMR entry type) or queued in a separate
tmr queue if ring space is too small.
TMRs in the tmr queue do not time out. If ring space becomes
available, tcmu moves TMRs from tmr queue to ring with higher
priority than cmds from qfull queue.

This mechanism makes sure that userspace receives TMR
notifications as early as possible. Userspace can use the
list of cmd_ids attached to the TMR notification to identify
aborted commands from its list of received and not yet completed
commands. In case userspace has meanwhile completed some of the
cmd_ids on the list, it can just ignore these cmd_ids.
A possible new command having the cmd_id as one of the aborted
commands will always appear on the ring after the TMR
notification.

Bodo Stroesser (8):
  scsi: target: Modify core_tmr_abort_task()
  scsi: target: Add tmr_notify backend function
  scsi: target: tcmu: Use priv pointer in se_cmd
  scsi: target: tcmu: Do not queue aborted commands
  scsi: target: tcmu: Factor out new helper ring_insert_padding
  scsi: target: tcmu: Fix and simplify timeout handling
  scsi: target: tcmu: Implement tmr_notify callback
  scsi: target: tcmu: Make TMR notification optional

 drivers/target/target_core_tmr.c       |  36 +++-
 drivers/target/target_core_transport.c |   1 +
 drivers/target/target_core_user.c      | 377 +++++++++++++++++++++++++++------
 include/target/target_core_backend.h   |   2 +
 include/target/target_core_base.h      |   1 +
 include/uapi/linux/target_core_user.h  |  25 +++
 6 files changed, 369 insertions(+), 73 deletions(-)

-- 
2.12.3

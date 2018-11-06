From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 06 Nov 2018 17:17:08 +0000
Subject: [PATCH 00/10] Make ABORT and LUN RESET handling synchronous
Message-Id: <20181106171718.89594-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Martin,

This is a respin of the patch series that makes ABORT and LUN RESET handling
synchronous. Compared to last time when this patch series was posted, the
actual patch that makes task management function handling synchronous has
been split into three patches. That makes the changes easier to follow.
Please consider this patch series for kernel v4.21.

Thanks,

Bart.

Bart Van Assche (10):
  target/tcmu: Fix queue_cmd_ring() declaration
  target/core: Use kvcalloc() instead of open-coding it
  target/core: Simplify transport_clear_lun_ref()
  target/core: Make sure that target_wait_for_sess_cmds() waits long
    enough
  target/core: Use system workqueues for TMF
  target/core: Make it possible to wait from more than one context for
    command completion
  target/core: Simplify the code for aborting SCSI commands
  target/core: Fix TAS handling for aborted commands
  target/core: Make ABORT and LUN RESET handling synchronous
  target/core: Reduce the amount of code executed with a spinlock held

 drivers/target/iscsi/iscsi_target.c          |  11 +-
 drivers/target/iscsi/iscsi_target_configfs.c |   2 +
 drivers/target/iscsi/iscsi_target_erl1.c     |  28 +-
 drivers/target/target_core_device.c          |  17 -
 drivers/target/target_core_internal.h        |   2 -
 drivers/target/target_core_tmr.c             |  52 ++-
 drivers/target/target_core_tpg.c             |   1 -
 drivers/target/target_core_transport.c       | 405 ++++++++-----------
 drivers/target/target_core_user.c            |   2 +-
 drivers/target/target_core_xcopy.c           |   6 +-
 include/target/target_core_base.h            |   7 +-
 include/target/target_core_fabric.h          |  11 +-
 12 files changed, 221 insertions(+), 323 deletions(-)

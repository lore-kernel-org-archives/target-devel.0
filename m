From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:37 +0000
Subject: [PATCH 00/17] Make ABORT and LUN RESET handling synchronous
Message-Id: <20180917213554.987-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Martin,

As you maybe know the LIO task management handling code is complicated
because it is asynchronous compared to the command execution flow. This
patch series makes task management function handling synchronous and
thereby significantly simplifies the LIO code. Please consider these
patches for kernel v4.20.

Thanks,

Bart.

Bart Van Assche (17):
  target/core: Fix spelling in two source code comments
  target/core: Use the SECTOR_SHIFT constant
  target/core: Remove an unused data member from struct xcopy_pt_cmd
  target/core: Change the return type of transport_init_session from
    void to int
  target/core: Make sure that target_wait_for_sess_cmds() waits long
    enough
  target/core: Use sg_alloc_table() instead of open-coding it
  target/core: Use system workqueues for TMF
  target/core: Make compare_and_write_callback() accept NULL as third
    argument
  target/core: Always call transport_complete_callback() upon failure
  target/core: Make it possible to wait from more than one context for
    command completion
  target/core: Make ABORT and LUN RESET handling synchronous
  target/core: Reduce the amount of code executed with a spinlock held
  target/core: Avoid that LUN reset sporadically triggers data
    corruption
  target/qla2xxx: Simplify the code for handling aborted commands
  target/core: Remove the write_pending_status() callback function
  target/core: Remove several state tests from the TMF code
  target/core: Simplify the LUN RESET implementation

 Documentation/target/tcm_mod_builder.py      |   8 -
 drivers/infiniband/ulp/srpt/ib_srpt.c        |   9 -
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |   6 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  31 --
 drivers/target/iscsi/iscsi_target_configfs.c |  13 -
 drivers/target/loopback/tcm_loop.c           |   6 -
 drivers/target/sbp/sbp_target.c              |   6 -
 drivers/target/target_core_configfs.c        |   4 -
 drivers/target/target_core_device.c          |  16 -
 drivers/target/target_core_iblock.c          |   4 +-
 drivers/target/target_core_iblock.h          |   1 -
 drivers/target/target_core_internal.h        |   2 -
 drivers/target/target_core_sbc.c             |  20 +-
 drivers/target/target_core_tmr.c             |  97 ++---
 drivers/target/target_core_transport.c       | 430 +++++++++----------
 drivers/target/target_core_xcopy.c           |  15 +-
 drivers/target/tcm_fc/tcm_fc.h               |   1 -
 drivers/target/tcm_fc/tfc_cmd.c              |   7 -
 drivers/target/tcm_fc/tfc_conf.c             |   1 -
 drivers/usb/gadget/function/f_tcm.c          |   9 -
 drivers/vhost/scsi.c                         |   6 -
 drivers/xen/xen-scsiback.c                   |   6 -
 include/target/target_core_base.h            |   6 +-
 include/target/target_core_fabric.h          |   4 +-
 24 files changed, 272 insertions(+), 436 deletions(-)

-- 
2.18.0

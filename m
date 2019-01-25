From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 25 Jan 2019 18:34:42 +0000
Subject: [PATCH 00/16] SCSI target patches for kernel v5.1
Message-Id: <20190125183458.220477-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Martin,

This series includes the following patches:
- Simplify the SCSI core now that TMF processing is synchronous.
- Cleanup and bug fixes for the SRP and iSCSI target drivers.

Please consider these patches for kernel v5.1.

Thanks,

Bart.

Bart Van Assche (16):
  target/core: Remove the write_pending_status() callback function
  target/core: Remove several state tests from the TMF code
  target/core: Simplify the LUN RESET implementation
  target/core: Inline transport_lun_remove_cmd()
  target/core: Add target_send_busy()
  RDMA/srpt: Fix handling of command / TMF submission failure
  RDMA/srpt: Fix handling of TMF submission failure
  RDMA/srpt: Rework I/O context allocation
  RDMA/srpt: Fix a credit leak for aborted commands
  target/iscsi: Remove an incorrect comment
  target/iscsi: Convert comments about locking into runtime checks
  target/iscsi: Fix spelling of "unsolicited"
  target/iscsi: Rename a function and a function pointer
  target/iscsi: Avoid that iscsit_release_commands_from_conn() triggers
    a deadlock
  target/iscsi: Simplify iscsit_dump_data_payload()
  target/iscsi: Simplify iscsit_handle_text_cmd()

 Documentation/target/tcm_mod_builder.py      |  8 --
 drivers/infiniband/ulp/isert/ib_isert.c      |  2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c        | 80 +++++++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.h        |  4 -
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  6 --
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 31 --------
 drivers/target/iscsi/cxgbit/cxgbit.h         |  2 +-
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c     |  2 +-
 drivers/target/iscsi/cxgbit/cxgbit_main.c    |  2 +-
 drivers/target/iscsi/cxgbit/cxgbit_target.c  |  2 +-
 drivers/target/iscsi/iscsi_target.c          | 47 +++++-------
 drivers/target/iscsi/iscsi_target.h          |  2 +-
 drivers/target/iscsi/iscsi_target_configfs.c | 13 ----
 drivers/target/iscsi/iscsi_target_erl0.c     |  5 +-
 drivers/target/iscsi/iscsi_target_erl1.c     | 59 +++++----------
 drivers/target/iscsi/iscsi_target_util.c     | 23 +++---
 drivers/target/loopback/tcm_loop.c           |  6 --
 drivers/target/sbp/sbp_target.c              |  6 --
 drivers/target/target_core_alua.c            |  5 +-
 drivers/target/target_core_configfs.c        |  4 -
 drivers/target/target_core_device.c          |  6 +-
 drivers/target/target_core_pr.c              | 15 ++--
 drivers/target/target_core_tmr.c             | 39 +---------
 drivers/target/target_core_transport.c       | 49 +++++-------
 drivers/target/target_core_xcopy.c           |  6 --
 drivers/target/tcm_fc/tcm_fc.h               |  1 -
 drivers/target/tcm_fc/tfc_cmd.c              |  7 --
 drivers/target/tcm_fc/tfc_conf.c             |  1 -
 drivers/usb/gadget/function/f_tcm.c          |  9 ---
 drivers/vhost/scsi.c                         |  6 --
 drivers/xen/xen-scsiback.c                   |  6 --
 include/target/iscsi/iscsi_transport.h       |  4 +-
 include/target/target_core_base.h            |  1 -
 include/target/target_core_fabric.h          |  2 +-
 34 files changed, 125 insertions(+), 336 deletions(-)

-- 
2.20.1.495.gaa96b0ce6b-goog

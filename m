From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Thu, 01 Mar 2018 22:26:18 +0000
Subject: [PATCH 00/14] SCSI target patches for kernel v4.17
Message-Id: <20180301222632.31507-1-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hello Nic,

This patch series simplifies task management function handling in the SCSI
target core considerably. The following tests have been run against this patch
series for both the iSCSI and SRPT target drivers:
- Run the libiscsi conformance tests.
- Run fio ${dev} in one shell and while sg_reset -d ${dev}; do :; done from
  another shell. This is a good way to stress test TMF handling.
- For the SRP target driver: run the srp-test software.

Please consider this patch series for kernel v4.17.

Thanks,

Bart.

Bart Van Assche (14):
  target: Fix an argument name in a function documentation header
  target: Use config_item_name() instead of open-coding it
  target: Avoid that EXTENDED COPY commands trigger lock inversion
  target: Make the session shutdown code also wait for commands that are
    being aborted
  target: Document when CMD_T_STOP and CMD_T_COMPLETE are set
  target: Simplify core_tmr_handle_tas_abort()
  target: Fold core_tmr_handle_tas_abort() into
    transport_cmd_finish_abort()
  target: Simplify transport_generic_free_cmd() (1/2)
  target: Simplify transport_generic_free_cmd() (2/2)
  target: Simplify the code for waiting for command completion
  target/iscsi: Reduce number of __iscsit_free_cmd() callers
  target: Remove second argument from fabric_make_tpg()
  target/tcm_loop: Avoid that static checkers warn about dead code
  target: Fix handling of removed LUNs

 drivers/infiniband/ulp/srpt/ib_srpt.c        |   2 -
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |   1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  12 +-
 drivers/target/iscsi/iscsi_target.c          |   2 -
 drivers/target/iscsi/iscsi_target_configfs.c |   7 +-
 drivers/target/iscsi/iscsi_target_util.c     |   4 +-
 drivers/target/loopback/tcm_loop.c           |  11 +-
 drivers/target/sbp/sbp_target.c              |   6 +-
 drivers/target/target_core_configfs.c        |   4 +-
 drivers/target/target_core_device.c          |  31 +++--
 drivers/target/target_core_fabric_configfs.c |   2 +-
 drivers/target/target_core_internal.h        |   2 +-
 drivers/target/target_core_sbc.c             |   7 +-
 drivers/target/target_core_tmr.c             |  30 +----
 drivers/target/target_core_transport.c       | 166 ++++++++++++---------------
 drivers/target/target_core_ua.c              |  10 +-
 drivers/target/tcm_fc/tfc_conf.c             |   5 +-
 drivers/usb/gadget/function/f_tcm.c          |   8 +-
 drivers/vhost/scsi.c                         |   4 +-
 drivers/xen/xen-scsiback.c                   |   4 +-
 include/target/target_core_base.h            |   5 +-
 include/target/target_core_fabric.h          |   2 +-
 22 files changed, 136 insertions(+), 189 deletions(-)

-- 
2.16.2


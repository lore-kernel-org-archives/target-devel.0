From: David Disseldorp <ddiss@suse.de>
Date: Fri, 23 Nov 2018 17:36:10 +0000
Subject: [PATCH 0/3] target: drop unneeded pi_prot_format and get_fabric_name()
Message-Id: <20181123173613.4547-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patchset removes unneeded se_dev_attrib.pi_prot_format and
fabric_ops.get_fabric_name() struct members. Removal of the latter
allowed for further cleanup due to the fact that all fabric modules
except iscsi_target_mod provide matching strings for fabric_ops.name
and fabric_ops.get_fabric_name() - use a new fabric_ops.fabric_alias
member to handle the iscsi_target_mod special case.

Cheers, David

David Disseldorp (3):
      target: drop unused pi_prot_format attribute storage
      target: drop unnecessary get_fabric_name() accessor from fabric_ops
      target: replace fabric_ops.name with fabric_alias

 drivers/infiniband/ulp/srpt/ib_srpt.c        |  8 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  8 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 16 +---
 drivers/target/iscsi/iscsi_target_configfs.c |  9 +-
 drivers/target/loopback/tcm_loop.c           |  8 +-
 drivers/target/sbp/sbp_target.c              |  8 +-
 drivers/target/target_core_alua.c            |  6 +-
 drivers/target/target_core_configfs.c        | 47 ++++++-----
 drivers/target/target_core_device.c          | 26 +++---
 drivers/target/target_core_fabric_configfs.c |  2 +-
 drivers/target/target_core_pr.c              | 88 ++++++++++----------
 drivers/target/target_core_stat.c            |  4 +-
 drivers/target/target_core_tmr.c             |  4 +-
 drivers/target/target_core_tpg.c             | 22 ++---
 drivers/target/target_core_transport.c       | 10 +--
 drivers/target/target_core_ua.c              |  4 +-
 drivers/target/target_core_xcopy.c           |  7 +-
 drivers/target/tcm_fc/tfc_conf.c             |  8 +-
 drivers/usb/gadget/function/f_tcm.c          |  8 +-
 drivers/vhost/scsi.c                         |  8 +-
 drivers/xen/xen-scsiback.c                   |  8 +-
 include/target/target_core_base.h            |  1 -
 include/target/target_core_fabric.h          | 14 +++-
 23 files changed, 134 insertions(+), 190 deletions(-)

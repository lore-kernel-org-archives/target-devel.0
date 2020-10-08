From: Joe Perches <joe@perches.com>
Date: Thu, 08 Oct 2020 02:36:23 +0000
Subject: [PATCH-next 0/4] RDMA: sprintf to sysfs_emit conversions
Message-Id: <cover.1602122879.git.joe@perches.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

A recent commit added a sysfs_emit and sysfs_emit_at to allow various
sysfs show functions to ensure that the PAGE_SIZE buffer argument is
never overrun and always NUL terminated.

Convert the RDMA/InfiniBand subsystem to use these new functions.

The first 2 patches exclusively used coccinelle to convert uses.
The third and fourth patches were done manually.

Compiled allyesconfig and defconfig with all infiniband options selected
no warnings, but untested, no hardward

Overall object size is reduced

total size: allyesconfig x86-64
new: 8364003	1680968	 131520	10176491 9b47eb	(TOTALS)
old: 8365883	1681032	 131520	10178435 9b4f83	(TOTALS)

total size: defconfig x86-64 with all infiniband selected
new; 1359153	 131228	   1910  1492291 16c543	(TOTALS)
old: 1359422	 131228	   1910  1492560 16c650	(TOTALS)

Joe Perches (4):
  RDMA: Convert sysfs device * show functions to use sysfs_emit()
  RDMA: Convert sysfs kobject * show functions to use sysfs_emit()
  RDMA: manual changes for sysfs_emit and neatening
  RDMA: Convert various random sprintf sysfs _show uses to sysfs_emit

 drivers/infiniband/core/cm.c                  |   4 +-
 drivers/infiniband/core/cma_configfs.c        |   4 +-
 drivers/infiniband/core/sysfs.c               | 155 ++++++++++--------
 drivers/infiniband/core/ucma.c                |   2 +-
 drivers/infiniband/core/user_mad.c            |   6 +-
 drivers/infiniband/core/uverbs_main.c         |   4 +-
 drivers/infiniband/hw/bnxt_re/main.c          |   4 +-
 drivers/infiniband/hw/cxgb4/provider.c        |  13 +-
 drivers/infiniband/hw/hfi1/sysfs.c            |  62 ++++---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c     |   6 +-
 drivers/infiniband/hw/mlx4/main.c             |   9 +-
 drivers/infiniband/hw/mlx4/mcg.c              |  82 +++++----
 drivers/infiniband/hw/mlx4/sysfs.c            |  70 ++++----
 drivers/infiniband/hw/mlx5/main.c             |  13 +-
 drivers/infiniband/hw/mthca/mthca_provider.c  |  33 ++--
 drivers/infiniband/hw/ocrdma/ocrdma_main.c    |   4 +-
 drivers/infiniband/hw/qedr/main.c             |  10 +-
 drivers/infiniband/hw/qib/qib_sysfs.c         |  91 +++++-----
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c  | 104 +++++-------
 .../infiniband/hw/vmw_pvrdma/pvrdma_main.c    |   6 +-
 drivers/infiniband/sw/rxe/rxe_verbs.c         |   2 +-
 drivers/infiniband/ulp/ipoib/ipoib_cm.c       |   4 +-
 drivers/infiniband/ulp/ipoib/ipoib_main.c     |   7 +-
 drivers/infiniband/ulp/ipoib/ipoib_vlan.c     |   2 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt-sysfs.c  |  60 +++----
 drivers/infiniband/ulp/rtrs/rtrs-srv-sysfs.c  |  20 +--
 drivers/infiniband/ulp/srp/ib_srp.c           |  49 +++---
 drivers/infiniband/ulp/srpt/ib_srpt.c         |  14 +-
 28 files changed, 423 insertions(+), 417 deletions(-)

-- 
2.26.0

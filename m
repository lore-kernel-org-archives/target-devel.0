From: Julia Lawall <Julia.Lawall@inria.fr>
Date: Sun, 20 Sep 2020 11:26:12 +0000
Subject: [PATCH 00/14] drop double zeroing
Message-Id: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-spi@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, rds-devel@oss.oracle.com, linux-rdma@vger.kernel.org, Yossi Leybovich <sleybo@amazon.com>, netdev@vger.kernel.org, linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, dmaengine@vger.kernel.org, linux-block@vger.kernel.org, linux-nfs@vger.kernel.org, linux-wireless@vger.kernel.org, linux-media@vger.kernel.org, linux-pci@vger.kernel.org

sg_init_table zeroes its first argument, so the allocation of that argument
doesn't have to.

---

 block/bsg-lib.c                                  |    2 +-
 drivers/dma/sh/rcar-dmac.c                       |    2 +-
 drivers/dma/sh/shdma-base.c                      |    2 +-
 drivers/infiniband/hw/efa/efa_verbs.c            |    2 +-
 drivers/media/common/saa7146/saa7146_core.c      |    2 +-
 drivers/misc/mic/scif/scif_nodeqp.c              |    2 +-
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.c |    2 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c      |    2 +-
 drivers/pci/p2pdma.c                             |    2 +-
 drivers/spi/spi-topcliff-pch.c                   |    4 ++--
 drivers/target/target_core_rd.c                  |    2 +-
 drivers/tty/serial/pch_uart.c                    |    2 +-
 net/rds/rdma.c                                   |    2 +-
 net/sunrpc/xprtrdma/frwr_ops.c                   |    2 +-
 14 files changed, 15 insertions(+), 15 deletions(-)

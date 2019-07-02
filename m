From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Jul 2019 15:30:29 +0000
Subject: [PATCH 0/2] Use REQ_OP_WRITE_SAME to implement WRITE SAME
Message-Id: <20190702153031.3832-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Martin,

The SCSI target iblock backend uses regular writes to implement the SCSI WRITE
SAME command. That is suboptimal for at least SCSI and NVMe SSDs. This patch
series makes the iblock backend use REQ_OP_WRITE_SAME instead. Please consider
these patches for inclusion in the upstream kernel.

Thanks,

Bart.

Bart Van Assche (2):
  block: Add blkdev_submit_write_same()
  target/core: Use REQ_OP_WRITE_SAME to implement WRITE SAME

 block/blk-lib.c                     | 37 ++++++++++++++++++++++++++++-
 drivers/target/target_core_iblock.c | 17 +++++++++++++
 include/linux/blkdev.h              |  3 +++
 3 files changed, 56 insertions(+), 1 deletion(-)

-- 
2.22.0.410.gd8fdbe21b5-goog

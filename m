From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 15 Oct 2018 15:51:33 +0000
Subject: [PATCH 0/6] SCSI target patches for kernel v4.20
Message-Id: <20181015155139.143446-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Martin,

Please consider this series of six patches for kernel v4.20. Except for
one new patch this patch series is a subset of the patch series I posted
earlier. I have selected those patches from that series of which I think
there is agreement about these patches. This patch series should not
conflict with the two other pending patch series (from Nicholas Bellinger
and from David Disseldorp).

Thanks,

Bart.

Bart Van Assche (6):
  target/core: Fix spelling in two source code comments
  target/core: Remove an unused data member from struct xcopy_pt_cmd
  target/core: Remove the SCF_COMPARE_AND_WRITE_POST flag
  target/core: Use the SECTOR_SHIFT constant
  target/core: Use sg_alloc_table() instead of open-coding it
  target/core: Always call transport_complete_callback() upon failure

 drivers/target/target_core_iblock.c    |  4 ++--
 drivers/target/target_core_iblock.h    |  1 -
 drivers/target/target_core_sbc.c       | 23 ++++++++++-------------
 drivers/target/target_core_transport.c | 15 +++++----------
 drivers/target/target_core_xcopy.c     |  3 ---
 include/target/target_core_base.h      |  1 -
 6 files changed, 17 insertions(+), 30 deletions(-)

-- 
2.19.0.605.g01d371f741-goog

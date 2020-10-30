From: David Disseldorp <ddiss@suse.de>
Date: Fri, 30 Oct 2020 21:39:27 +0000
Subject: [PATCH v2 0/4] scsi: target: COMPARE AND WRITE miscompare sense
Message-Id: <20201030213931.10720-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

This patchset adds missing functionality to return the offset of
non-matching read/compare data in the sense INFORMATION field on
COMPARE AND WRITE miscompare.

The functionality can be tested using the libiscsi
CompareAndWrite.MiscompareSense test proposed via:
  https://github.com/sahlberg/libiscsi/pull/344

Changes since v2:
- perform bad_sector->sense_info rename in overlooked ib_isert
- drop scatterlist change queued via Jens' tree
- add Mike's reviewed-by tag
- rebase against Martin's 5.11/scsi-queue branch

Changes since v1:
- drop unnecessary WARN_ON()
- fix two checkpatch warnings
- drop single-use nlbas variable
- avoid compare_len recalculation

Cheers, David

 drivers/infiniband/ulp/isert/ib_isert.c |   4 +-
 drivers/target/target_core_sbc.c        | 137 ++++++++++++++----------
 drivers/target/target_core_transport.c  |  33 +++---
 include/target/target_core_base.h       |   2 +-
 4 files changed, 103 insertions(+), 73 deletions(-)

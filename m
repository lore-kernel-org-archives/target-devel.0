From: David Disseldorp <ddiss@suse.de>
Date: Thu, 26 Mar 2020 22:15:00 +0000
Subject: [PATCH v2 0/5] scsi: target:
Message-Id: <20200326221505.5303-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org

These changes remove unnecessary heap allocations in the XCOPY
READ/WRITE dispatch loop.

Synthetic benchmarks on my laptop using the libiscsi iscsi-dd utility
(--xcopy --max 1 --blocks 65535 src=dst) against a target backed by an
8G zram (DEBUG_KMEMLEAK=y) iblock backstore (avg across four runs) show:
before: 5.30845G/s
after:  5.99056G/s (approx. +12.8%)

Changes since v1:
- drop RFC
- rework 3/5 and 5/5 following Christoph's feedback

Feedback appreciated.

Cheers, David

----------------------------------------------------------------
David Disseldorp (5):
      scsi: target: use #def for xcopy descriptor len
      scsi: target: drop xcopy DISK BLOCK LENGTH debug
      scsi: target: avoid per-loop XCOPY buffer allocations
      scsi: target: increase XCOPY I/O size
      scsi: target: use the stack for XCOPY passthrough cmds

 drivers/target/target_core_xcopy.c | 160 ++++++++++-------------------
 drivers/target/target_core_xcopy.h |   9 +-
 2 files changed, 55 insertions(+), 114 deletions(-)

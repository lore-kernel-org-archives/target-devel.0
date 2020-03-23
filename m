From: David Disseldorp <ddiss@suse.de>
Date: Mon, 23 Mar 2020 16:54:05 +0000
Subject: [RFC PATCH 0/5] scsi: target: XCOPY performance
Message-Id: <20200323165410.24423-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org

These changes remove unnecessary heap allocations in the XCOPY
READ/WRITE dispatch loop.

Synthetic benchmarks on my laptop using the libiscsi iscsi-dd utility
(--xcopy --max 1 --blocks 65535 src=dst) against a target backed by an 8G
zram (DEBUG_KMEMLEAK=y) iblock backstore (avg across four runs) show:
before: 5.35776G/s
after:  6.12636G/s (approx. +14%)

Feedback appreciated.

Cheers, David

----------------------------------------------------------------
David Disseldorp (5):
      scsi: target: use #def for xcopy descriptor len
      scsi: target: drop xcopy DISK BLOCK LENGTH debug
      scsi: target: avoid per-loop XCOPY buffer allocations
      scsi: target: increase XCOPY I/O size
      scsi: target: avoid XCOPY per-loop read/write cmd allocations

 drivers/target/target_core_xcopy.c | 135 ++++++++++-------------------
 drivers/target/target_core_xcopy.h |  14 +--
 2 files changed, 57 insertions(+), 92 deletions(-)

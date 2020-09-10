From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Thu, 10 Sep 2020 15:50:38 +0000
Subject: [PATCH 0/3] target: scsi: tcmu: code rework and speed up of read data handling
Message-Id: <20200910155041.17654-1-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Bodo Stroesser <bstroesser@ts.fujitsu.com>

This small series is made on top of Martin's 5.10/scsi-queue branch.

The patches simplify some code, splits off new helper functions
or implement a cleaner code sequence to prevent double work.
The 3rd patch speeds up buffer preparation for SCSI commands with
long read data.
The series is also base for cleaned up version v3 of my patch
  scsi: target: tcmu: add compat mode for 32bit userspace on 64bit kernel

Bodo Stroesser (3):
  scsi: target: tcmu: join tcmu_cmd_get_data_length and tcmu_cmd_get_block_cnt
  scsi: target: tcmu: optimize queue_cmd_ring
  scsi: target: tcmu: optimize scatter_data_area

 drivers/target/target_core_user.c | 340 +++++++++++++++++++-------------------
 1 file changed, 170 insertions(+), 170 deletions(-)

-- 
2.12.3

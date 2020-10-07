From: Maurizio Lombardi <mlombard@redhat.com>
Date: Wed, 07 Oct 2020 14:53:24 +0000
Subject: [PATCH 0/2] fix race conditions with task aborts
Message-Id: <20201007145326.56850-1-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, bvanassche@acm.org, michael.christie@oracle.com

This patchset fixes some possible race conditions when
2 threads call iscsit_free_cmd()/__iscsit_free_cmd() at
the same time.

Maurizio Lombardi (2):
  target: iscsi: prevent a race condition in iscsit_unmap_cmd()
  target: iscsi: fix a race condition when aborting a task

 drivers/target/iscsi/iscsi_target_login.c | 1 +
 drivers/target/iscsi/iscsi_target_util.c  | 7 ++++---
 include/target/iscsi/iscsi_target_core.h  | 1 +
 3 files changed, 6 insertions(+), 3 deletions(-)

-- 
2.26.2

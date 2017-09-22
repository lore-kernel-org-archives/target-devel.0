From: Allen Pais <allen.lkml@gmail.com>
Date: Fri, 22 Sep 2017 10:20:49 +0000
Subject: [PATCH 0/5] use setup_timer() helper function.
Message-Id: <1506074934-15062-1-git-send-email-allen.lkml@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, target-devel@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>

This series uses setup_timer() helper function. The series
addresses the files under drivers/target/iscsi/*.

Allen Pais (5):
  iscsi-target: use setup_timer() helper.
  iscsi-target: use setup_timer() helper.
  iscsi-target: use setup_timer() helper.
  iscsi-target: use setup_timer() helper.
  iscsi-target: use setup_timer() helper.

 drivers/target/iscsi/iscsi_target_erl0.c  | 5 ++---
 drivers/target/iscsi/iscsi_target_erl1.c  | 5 ++---
 drivers/target/iscsi/iscsi_target_login.c | 5 ++---
 drivers/target/iscsi/iscsi_target_nego.c  | 5 ++---
 drivers/target/iscsi/iscsi_target_util.c  | 5 ++---
 5 files changed, 10 insertions(+), 15 deletions(-)

-- 
2.7.4


From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date: Thu, 21 May 2020 17:41:48 +0000
Subject: [PATCH 0/3] target: fix NULL pointer dereference
Message-Id: <1590082908-884-1-git-send-email-sudhakar.panneerselvam@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: shirley.ma@oracle.com, ssudhakarp@gmail.com

The following set of commits address a NULL pointer dereference and some
refactoring around this issue.

Sudhakar Panneerselvam (3):
  target: factor out a new helper, target_init_cmd_from_cdb()
  target: fix NULL pointer dereference
  target: rename target_setup_cmd_from_cdb() to target_parse_cdb()

 drivers/target/iscsi/iscsi_target.c    | 21 +++++++++++++--------
 drivers/target/target_core_transport.c | 27 +++++++++++++++++++++------
 drivers/target/target_core_xcopy.c     |  5 ++++-
 include/target/target_core_fabric.h    |  3 ++-
 4 files changed, 40 insertions(+), 16 deletions(-)

-- 
1.8.3.1

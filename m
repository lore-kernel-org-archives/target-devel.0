From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date: Tue, 02 Jun 2020 18:33:42 +0000
Subject: [PATCH v3 0/3] target: fix NULL pointer dereference
Message-Id: <1591122825-2652-1-git-send-email-sudhakar.panneerselvam@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, michael.christie@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: shirley.ma@oracle.com

The following set of commits address a NULL pointer dereference and some
refactoring around this issue.

v3:
 - fix NULL pointer dereference when cdb initialization fails

v2:
 - new helper is named as target_cmd_init_cdb()
 - existing function, target_setup_cmd_from_cdb is renamed as
   target_cmd_parse_cdb()

Sudhakar Panneerselvam (3):
  target: factor out a new helper, target_cmd_init_cdb()
  target: fix NULL pointer dereference
  target: rename target_setup_cmd_from_cdb() to target_cmd_parse_cdb()

 drivers/target/iscsi/iscsi_target.c    | 21 +++++++++++-------
 drivers/target/target_core_transport.c | 40 +++++++++++++++++++++++++++-------
 drivers/target/target_core_xcopy.c     |  5 ++++-
 include/target/target_core_fabric.h    |  3 ++-
 4 files changed, 51 insertions(+), 18 deletions(-)

-- 
1.8.3.1

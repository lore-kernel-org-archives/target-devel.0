From: Hou Pu <houpu@bytedance.com>
Date: Fri, 24 Apr 2020 03:58:41 +0000
Subject: [PATCH v2 0/2] iscsi-target: fix login error when receiving is too fast
Message-Id: <20200424035843.5914-1-houpu@bytedance.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, mchristi@redhat.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Hou Pu <houpu@bytedance.com>

Hi,
We encountered "iSCSI Login negotiation failed" several times.
After enable debug log in iscsi_target_nego.c of iSCSI target.
Error shows:
  "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"

Patch 1 is trying to fix this problem. Please see comment in patch 1
for details.

Changes from v2:
* Improve comments in patch #1.
* Change bit possition of login_flags in patch #1.

Hou Pu (2):
  iscsi-target: fix login error when receiving is too fast
  iscsi-target: Fix inconsistent debug message in
    __iscsi_target_sk_check_close

 drivers/target/iscsi/iscsi_target_nego.c | 31 ++++++++++++++++++++++++++-----
 include/target/iscsi/iscsi_target_core.h |  9 +++++----
 2 files changed, 31 insertions(+), 9 deletions(-)

-- 
2.11.0

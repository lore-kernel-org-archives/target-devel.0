From: Pu Hou <houpu@bytedance.com>
Date: Wed, 15 Apr 2020 08:08:17 +0000
Subject: [PATCH 0/2] iscsi-target: fix login error when receiving is too fast
Message-Id: <20200415080819.27327-1-houpu@bytedance.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, Pu Hou <houpu@bytedance.com>

Hi,
We encountered "iSCSI Login negotiation failed" several times.
After enable debug log in iscsi_target_nego.c of iSCSI target.
Error shows:
  "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"

Patch 1 is trying to fix this problem. Please see comment in patch 1
for details.

Pu Hou (2):
  iscsi-target: fix login error when receiving is too fast
  iscsi-target: Fix inconsistent debug message in
    __iscsi_target_sk_check_close

 drivers/target/iscsi/iscsi_target_nego.c | 31 ++++++++++++++++++++++++++-----
 include/target/iscsi/iscsi_target_core.h |  1 +
 2 files changed, 27 insertions(+), 5 deletions(-)

-- 
2.11.0

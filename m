From: Hou Pu <houpu@bytedance.com>
Date: Thu, 16 Jul 2020 10:02:10 +0000
Subject: [PATCH v4 0/2] iscsi-target: fix login error when receiving is too fast
Message-Id: <20200716100212.4237-1-houpu@bytedance.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, Hou Pu <houpu@bytedance.com>

Hi,
We encountered "iSCSI Login negotiation failed" several times.
After enable debug log in iscsi_target_nego.c of iSCSI target.
Error shows:
  "Got LOGIN_FLAGS_READ_ACTIVE=1, conn: xxxxxxxxxx >>>>"

Patch 1 is trying to fix this problem. Please see comment in patch 1
for details.

Sorry for delay of v4. Version 3 of this patchset could be found here[1].

Changes from v4:
* In iscsi_target_do_login_rx(), call cancel_delayed_work() if it is final
  login pdu. Also call cancel_delayed_work() if current negotiation is failed.
  This is advised by Mike Christie. See below[1] for more details.

Changes from v3:
* Fix style problem found by checkpatch.pl.

Changes from v2:
* Improve comments in patch #1.
* Change bit possition of login_flags in patch #1.


[1]:
https://www.spinics.net/lists/target-devel/msg18281.html

Hou Pu (2):
  iscsi-target: fix login error when receiving is too fast
  iscsi-target: Fix inconsistent debug message in
    __iscsi_target_sk_check_close

 drivers/target/iscsi/iscsi_target_nego.c | 36 +++++++++++++++++++++++++++-----
 include/target/iscsi/iscsi_target_core.h |  9 ++++----
 2 files changed, 36 insertions(+), 9 deletions(-)

-- 
2.11.0

From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 06:17:38 +0000
Subject: [PATCH-3.18.y 0/2] target: stable backports
Message-Id: <1510813060-15334-1-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Here are two target patches for v3.18.y stable, the first of which
did not originally include a stable CC, and the latter did not apply
due to a minor context change.

The series has been cut against v3.18.81.  Please apply at your earliest
convenience.

Thank you,

--nab

Bart Van Assche (1):
  target/iscsi: Fix iSCSI task reassignment handling

Nicholas Bellinger (1):
  iscsi-target: Fix iscsi_np reset hung task during parallel delete

 drivers/target/iscsi/iscsi_target.c       | 20 ++++++++------------
 drivers/target/iscsi/iscsi_target_core.h  |  1 +
 drivers/target/iscsi/iscsi_target_login.c |  7 +++++--
 include/target/iscsi/iscsi_target_core.h  |  1 +
 include/target/target_core_base.h         |  1 +
 5 files changed, 16 insertions(+), 14 deletions(-)

-- 
1.8.5.3


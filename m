From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 06:29:48 +0000
Subject: [PATCH-3.10.y 0/3] target: stable backports
Message-Id: <1510813791-16082-1-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Greg-KH,

Here are three target patches for v3.10.y stable, the first of which
did not originally include a stable CC, and the latter two did not
apply due to a minor context change.

The series has been cut against v3.10.108.  Please apply at your earliest
convenience.

Thank you,

--nab

Bart Van Assche (1):
  target/iscsi: Fix iSCSI task reassignment handling

Mikulas Patocka (1):
  iscsi-target: fix iscsit_del_np deadlock on unload

Nicholas Bellinger (1):
  iscsi-target: Fix iscsi_np reset hung task during parallel delete

 drivers/target/iscsi/iscsi_target.c       | 20 ++++++++------------
 drivers/target/iscsi/iscsi_target_core.h  |  1 +
 drivers/target/iscsi/iscsi_target_login.c | 25 ++++++++++++-------------
 include/target/target_core_base.h         |  1 +
 4 files changed, 22 insertions(+), 25 deletions(-)

-- 
1.8.5.3


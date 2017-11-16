From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 05:54:33 +0000
Subject: [PATCH-4.9.y 0/2] target: stable backports
Message-Id: <1510812307-14530-1-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Greg-KH,

Here are two target patches for v4.9.y stable, the first of which
did not originally include a stable CC, and the latter did not apply
due to a minor context change.

The series has been cut against v4.9.62.  Please apply at your earliest
convenience.

Thank you,

--nab

Bart Van Assche (1):
  target/iscsi: Fix iSCSI task reassignment handling

Nicholas Bellinger (1):
  qla2xxx: Fix incorrect tcm_qla2xxx_free_cmd use during TMR ABORT (v2)

 drivers/scsi/qla2xxx/tcm_qla2xxx.c  | 33 ---------------------------------
 drivers/target/iscsi/iscsi_target.c | 19 +++++++------------
 include/target/target_core_base.h   |  1 +
 3 files changed, 8 insertions(+), 45 deletions(-)

-- 
1.8.5.3


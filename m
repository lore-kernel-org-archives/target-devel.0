From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 05:57:19 +0000
Subject: [PATCH-4.4.y 0/2] target: stable backports
Message-Id: <1510812472-14734-1-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Greg-KH,

Here are two target patches for v4.4.y stable, the first of which
did not originally include a stable CC, and the latter did not apply
due to a minor context change.

The series has been cut against v4.4.98.  Please apply at your earliest
convenience.

Thank you,

--nab

Bart Van Assche (1):
  target/iscsi: Fix iSCSI task reassignment handling

Nicholas Bellinger (1):
  target: Fix node_acl demo-mode + uncached dynamic shutdown regression

 drivers/target/iscsi/iscsi_target.c    | 19 +++++++------------
 drivers/target/target_core_tpg.c       |  4 ++--
 drivers/target/target_core_transport.c |  4 ++--
 include/target/target_core_base.h      |  1 +
 4 files changed, 12 insertions(+), 16 deletions(-)

-- 
1.8.5.3


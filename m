From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Fri, 12 Jan 2018 23:56:34 +0000
Subject: [PATCH-4.1.y 0/2] target: stable backports
Message-Id: <1515801396-31747-1-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Sasha,

Here are two target patches for v4.1.y stable, which did not apply
due to minor context changes.

The series has been cut against v4.1.48.  Please apply at your earliest
convenience.

Thank you,

--nab

Nicholas Bellinger (2):
  iscsi-target: Make TASK_REASSIGN use proper se_cmd->cmd_kref
  target: Avoid early CMD_T_PRE_EXECUTE failures during ABORT_TASK

 drivers/target/iscsi/iscsi_target.c    | 20 +++++++-------------
 drivers/target/target_core_tmr.c       |  9 +++++++++
 drivers/target/target_core_transport.c |  2 ++
 include/target/target_core_base.h      |  1 +
 4 files changed, 19 insertions(+), 13 deletions(-)

-- 
1.8.5.3


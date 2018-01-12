From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Fri, 12 Jan 2018 23:49:56 +0000
Subject: [PATCH-3.18.y 0/2] target: stable backports
Message-Id: <1515801798-32155-1-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
References: <1510813060-15334-1-git-send-email-nab@linux-iscsi.org>
In-Reply-To: <1510813060-15334-1-git-send-email-nab@linux-iscsi.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Greg-KH,

Here are two target patches for v3.18.y stable, which did not apply
due to minor context changes.

The series has been cut against v3.18.91.  Please apply at your earliest
convenience.

Thank you,

--nab

Nicholas Bellinger (2):
  iscsi-target: Make TASK_REASSIGN use proper se_cmd->cmd_kref
  target: Avoid early CMD_T_PRE_EXECUTE failures during ABORT_TASK

 drivers/target/iscsi/iscsi_target.c    | 21 +++++++--------------
 drivers/target/target_core_tmr.c       |  9 +++++++++
 drivers/target/target_core_transport.c |  2 ++
 include/target/target_core_base.h      |  1 +
 4 files changed, 19 insertions(+), 14 deletions(-)

-- 
1.8.5.3


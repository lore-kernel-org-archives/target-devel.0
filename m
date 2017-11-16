From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Thu, 16 Nov 2017 06:14:12 +0000
Subject: [PATCH-4.1.y 0/7] target: stable backports
Message-Id: <1510812859-15101-1-git-send-email-nab@linux-iscsi.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel <target-devel@vger.kernel.org>
Cc: stable <stable@vger.kernel.org>, Sasha Levin <alexander.levin@verizon.com>, Greg-KH <gregkh@linuxfoundation.org>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Sasha,

Here are a target patches outstanding for v4.1.y stable.  Note that
some of these had not been merged from the last v4.1.y series posted
here:

http://www.spinics.net/lists/target-devel/msg15916.html

Please ensure these get picked up for the next v4.1.y release.

The series has been cut against v4.1.45.  Please apply at your earliest
convenience.

Thank you,

--nab

Bart Van Assche (1):
  target/iscsi: Fix iSCSI task reassignment handling

Jiang Yi (1):
  iscsi-target: Always wait for kthread_should_stop() before kthread
    exit

Nicholas Bellinger (5):
  target: Obtain se_node_acl->acl_kref during get_initiator_node_acl
  target: Fix multi-session dynamic se_node_acl double free OOPs
  target: Avoid mappedlun symlink creation during lun shutdown
  Revert "target: Fix VERIFY and WRITE VERIFY command parsing"
  target: Fix node_acl demo-mode + uncached dynamic shutdown regression

 drivers/target/iscsi/iscsi_target.c          | 49 ++++++++++------
 drivers/target/iscsi/iscsi_target_erl0.c     |  6 +-
 drivers/target/iscsi/iscsi_target_erl0.h     |  2 +-
 drivers/target/iscsi/iscsi_target_login.c    |  4 ++
 drivers/target/target_core_fabric_configfs.c |  5 ++
 drivers/target/target_core_sbc.c             | 71 +++-------------------
 drivers/target/target_core_tpg.c             | 51 ++++++++++++++--
 drivers/target/target_core_transport.c       | 88 ++++++++++++++++++----------
 include/target/target_core_base.h            |  3 +
 include/target/target_core_fabric.h          |  2 +
 10 files changed, 163 insertions(+), 118 deletions(-)

-- 
1.8.5.3


From: xiubli@redhat.com
Date: Thu, 19 Apr 2018 07:46:01 +0000
Subject: [PATCHv4 0/3] tcmu: allow userspace to reset netlink
Message-Id: <1524123964-21347-1-git-send-email-xiubli@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

Changes since v1(suggested by Mike Christie):
v2: - Makes the reset per device.
v3: - Remove nl_cmd->complete, use status instead
    - Fix lock issue
    - Check if a nl command is even waiting before trying to wake up
v4: - Add module wide action support and make the reset netlink for the
      module wide

Xiubo Li (3):
  target/configfs: add module wide action support
  target: adjust and export target_for_each_device visible to modules
  tcmu: add module wide action/reset_netlink support

 drivers/target/target_core_configfs.c | 46 +++++++++++++++++++++
 drivers/target/target_core_device.c   | 10 +----
 drivers/target/target_core_hba.c      | 11 +++++
 drivers/target/target_core_internal.h |  7 +++-
 drivers/target/target_core_user.c     | 77 +++++++++++++++++++++++++++++++----
 drivers/target/target_core_xcopy.c    |  3 ++
 include/target/target_core_backend.h  |  4 ++
 7 files changed, 138 insertions(+), 20 deletions(-)

-- 
1.8.3.1


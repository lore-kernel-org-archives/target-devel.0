From: Maurizio Lombardi <mlombard@redhat.com>
Date: Fri, 13 Mar 2020 16:12:50 +0000
Subject: [PATCH 0/3] Fix a race condition in the target driver
Message-Id: <20200313161253.5507-1-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Multiple threads may try to destroy the same iscsi session
structure by calling iscsit_close_session() and then end
up hanging.

This patchset modifies the driver so the session
structure is destroyed by iscsit_close_connection() when
the last connection gets closed, thus preventing
the race condition.

Maurizio Lombardi (3):
  target: remove boilerplate code
  target: fix target hang when multiple threads try to destroy the same
    iscsi session.
  iscsi target: calling iscsit_stop_session() inside
    iscsit_close_session() has no effect

 drivers/target/iscsi/iscsi_target.c          | 82 ++++++--------------
 drivers/target/iscsi/iscsi_target.h          |  1 -
 drivers/target/iscsi/iscsi_target_configfs.c |  5 +-
 drivers/target/iscsi/iscsi_target_login.c    |  5 +-
 include/target/iscsi/iscsi_target_core.h     |  2 +-
 5 files changed, 32 insertions(+), 63 deletions(-)

-- 
2.21.0

From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 13 Nov 2019 22:05:06 +0000
Subject: [PATCH v4 0/2] Two SCSI target reliability improvement patches
Message-Id: <20191113220508.198257-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Martin,

The two patches in this series fix complaints that are reported when
running the libiscsi test tool against the SCSI target code. I'm not sure why
I hadn't noticed these issues before - maybe new tests have been added to the
test tool. Please consider these patches for Linux kernel version v5.5.

Thanks,

Bart.

Changes compared to v3:
- Left out the target_tmr_work() patch.

Changes compared to v2:
- Changed target_{,un}depend_item() calls into configfs_{get,put}_item() calls.
- Changed ISCSI_REASON_BOOKMARK_NO_RESOURCES into
  ISCSI_REASON_WAITING_FOR_LOGOUT.

Changes compared to v1:
- The patch that declares target_release_reservation() static has been left
  out because a patch in this series introduces a call to that function
  outside the file in which that function has been defined.
- The patch for releasing SPC-2 reservations has been reworked as requested by
  Roman.
- Two new patches have been added.

Bart Van Assche (2):
  target/core: Release SPC-2 reservations when closing a session
  target/iscsi: Wait for all commands to finish before freeing a session

 drivers/target/iscsi/iscsi_target.c    | 10 ++++++++--
 drivers/target/target_core_transport.c | 15 +++++++++++++++
 include/scsi/iscsi_proto.h             |  1 +
 3 files changed, 24 insertions(+), 2 deletions(-)

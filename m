From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 13 Nov 2019 17:52:36 +0000
Subject: [PATCH v3 0/3] Three SCSI target reliability improvements
Message-Id: <20191113175239.147389-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Martin,

The three patches in this series fix complaints that were reported while
running the libiscsi test tool against the SCSI target code. I'm not sure why
I hadn't noticed these issues before - maybe new tests have been added to the
test tool. Please consider these patches for Linux kernel version v5.5.

Thanks,

Bart.

Changes compared to v2:
- Changed target_{,un}depend_item() calls into configfs_{get,put}_item() calls.
- Changed ISCSI_REASON_BOOKMARK_NO_RESOURCES into
  ISCSI_REASON_WAITING_FOR_LOGOUT.

Changes compared to v1:
- The patch that declares target_release_reservation() static has been left out because a patch in this series introduces a call to that function outside the file in which that function has been defined.
- The patch for releasing SPC-2 reservations has been reworked as requested by Roman.
- Two new patches have been added.

Bart Van Assche (3):
  target/core: Release SPC-2 reservations when closing a session
  target/core: Fix a use-after-free in the TMF handling code
  target/iscsi: Wait for all commands to finish before freeing a session

 drivers/target/iscsi/iscsi_target.c    | 10 ++++++++--
 drivers/target/target_core_transport.c | 21 +++++++++++++++++++++
 include/scsi/iscsi_proto.h             |  1 +
 3 files changed, 30 insertions(+), 2 deletions(-)

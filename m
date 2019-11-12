From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 12 Nov 2019 03:57:49 +0000
Subject: [PATCH 0/3] Three reliability improvements
Message-Id: <20191112035752.8338-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Martin,

The three patches in this series fix the complaints that were reported while
running the libiscsi test tool against the SCSI target code. I'm not sure why
I hadn't noticed these issues before - maybe new tests have been added to the
test tool. Please consider these patches for Linux kernel version v5.5.

Thanks,

Bart.

Bart Van Assche (3):
  target/core: Release SPC-2 reservations when closing a session
  target/core: Fix a use-after-free in the TMF handling code
  target/iscsi: Wait for all commands to finish before freeing a session

 drivers/target/iscsi/iscsi_target.c    | 10 ++++++++--
 drivers/target/target_core_transport.c | 21 +++++++++++++++++++++
 2 files changed, 29 insertions(+), 2 deletions(-)

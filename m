From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 11 Nov 2019 18:29:42 +0000
Subject: [PATCH 0/2] Improve SPC-2 reservation support
Message-Id: <20191111182944.191123-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Martin,

This patch series improves support for SPC-2 reservations in the SCSI target
code. Please consider these patches for inclusion in the v5.5 kernel.

Thanks,

Bart.

Bart Van Assche (2):
  target/core: Declare target_release_reservation() 'static'
  target/iscsi: Fix a use-after-free while closing a session

 drivers/target/target_core_pr.c        |  2 +-
 drivers/target/target_core_pr.h        |  1 -
 drivers/target/target_core_transport.c | 11 +++++++++++
 3 files changed, 12 insertions(+), 2 deletions(-)

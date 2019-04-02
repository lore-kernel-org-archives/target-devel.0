From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 02 Apr 2019 19:58:04 +0000
Subject: [PATCH 00/11] SCSI target patches for kernel v5.2
Message-Id: <20190402195815.254796-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20171031180319.19258-1-bart.vanassche@wdc.com>
In-Reply-To: <20171031180319.19258-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Martin,

This patch series fixes a few bugs and also simplifies the SCSI target code.
Please consider these patches for kernel v5.2.

Thanks,

Bart.

Bart Van Assche (11):
  target/core: Fix a race condition in the LUN lookup code
  target/core: Rework the SPC-2 reservation handling code
  target/core: Release SPC-2 reservation upon initiator logout
  target/core: Remove a set-but-not-used member variable from the XCOPY
    implementation
  target/core: Simplify LUN initialization in XCOPY implementation
  target/core: Make the XCOPY setup code easier to read by inlining two
    functions
  target/iscsi: Detect conn_cmd_list corruption early
  target/iscsi: Only send R2T if needed
  target/iscsi: Handle too large immediate data buffers correctly
  target/iscsi: Make iscsit_map_iovec() more robust
  target/iscsi: Make sure PDU processing continues if parsing a command
    fails

 drivers/target/iscsi/iscsi_target.c      | 118 ++++++++++++++++-------
 drivers/target/iscsi/iscsi_target_util.c |   5 +
 drivers/target/target_core_configfs.c    |   5 +-
 drivers/target/target_core_device.c      |   4 +-
 drivers/target/target_core_pr.c          |  33 ++++---
 drivers/target/target_core_pr.h          |   1 +
 drivers/target/target_core_tmr.c         |   2 +-
 drivers/target/target_core_transport.c   |  10 ++
 drivers/target/target_core_xcopy.c       |  92 +++++-------------
 include/target/iscsi/iscsi_target_core.h |   1 +
 include/target/target_core_base.h        |   4 +-
 include/target/target_core_fabric.h      |   1 +
 12 files changed, 150 insertions(+), 126 deletions(-)

-- 
2.21.0.196.g041f5ea1cf98

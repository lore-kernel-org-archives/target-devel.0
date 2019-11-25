From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 25 Nov 2019 16:56:49 +0000
Subject: [PATCH v3 00/13] scsi: qla2xxx: Bug fixes
Message-Id: <20191125165702.1013-1-r.bolshakov@yadro.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>

Hi Martin,

The patch series contains fixes for qla2xxx and solves two visible
issues:
  - Target port in N2N topology doesn't perform login if it has higher
    WWPN than initiator
  - ABORT TASK TMF leads to crash if it's received shortly after ACL of
    an initiator is deleted and there's active I/O from the initiator

It also contains reliability improvements and cleanups.

Changes since v2 (https://patchwork.kernel.org/cover/11254937/):
- Target is allowed to perform PLOGI only if it detects N2N mode;
- Dropped patches to improve ABTS handling for ports that are not
  currently logged in. They will go into a separate patch series.
Changes since v1 (https://patchwork.kernel.org/cover/11141979/):
- Fixes target port in N2N mode were added (patches 5-11);
- Target port makes explicit LOGO on session teardown in the patch made
  by Quinn. Together with patch 1, it helps to immediately turn
  fc_remote_port to the Blocked stated on client side and avoids visibly
  stuck session;
- The last three patches address violation of FCP specification with
  regards to handling of ABTS-LS from ports that are not currently
  logged in.

Thank you,
Roman

Quinn Tran (1):
  scsi: qla2xxx: Use explicit LOGO in target mode

Roman Bolshakov (12):
  scsi: qla2xxx: Ignore NULL pointer in tcm_qla2xxx_free_mcmd
  scsi: qla2xxx: Initialize free_work before flushing it
  scsi: qla2xxx: Drop superfluous INIT_WORK of del_work
  scsi: qla2xxx: Change discovery state before PLOGI
  scsi: qla2xxx: Allow PLOGI in target mode
  scsi: qla2xxx: Don't call qlt_async_event twice
  scsi: qla2xxx: Fix PLOGI payload and ELS IOCB dump length
  scsi: qla2xxx: Configure local loop for N2N target
  scsi: qla2xxx: Send Notify ACK after N2N PLOGI
  scsi: qla2xxx: Don't defer relogin unconditonally
  scsi: qla2xxx: Ignore PORT UPDATE after N2N PLOGI
  scsi: qla2xxx: Add debug dump of LOGO payload and ELS IOCB

 drivers/scsi/qla2xxx/qla_def.h     |  1 +
 drivers/scsi/qla2xxx/qla_init.c    | 21 ++++++++++----------
 drivers/scsi/qla2xxx/qla_iocb.c    | 31 ++++++++++++++++++++++++------
 drivers/scsi/qla2xxx/qla_isr.c     |  4 ----
 drivers/scsi/qla2xxx/qla_mbx.c     |  3 ++-
 drivers/scsi/qla2xxx/qla_target.c  |  4 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  3 +++
 7 files changed, 43 insertions(+), 24 deletions(-)

-- 
2.24.0

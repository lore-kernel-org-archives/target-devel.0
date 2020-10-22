From: Anastasia Kovaleva <a.kovaleva@yadro.com>
Date: Thu, 22 Oct 2020 17:20:08 +0000
Subject: [PATCH 0/3] scsi: target: Set correct residual data
Message-Id: <20201022172011.42367-1-a.kovaleva@yadro.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, linux@yadro.com, Anastasia Kovaleva <a.kovaleva@yadro.com>

Hi Martin,
Please apply the changes to 5.10/scsi-queue at your earliest
convenience.

Tne series changes the behavior of the target in regard to processing
commands with overflow/underflow in accordance with the standarts.

The target driver used to process the DMA_TO_DEVICE commands with
residuals (in particular, WRITE command) incorrectly. The target
response contained neither a residual count, nor an OVERFLOW/UNDERFLOW
bit. Such behavior did not comply with the RFC 7143. Also the
returned ASC and ASCQ were incorrect according to FCP-4,
and residuals were not set for the 4Kn devices.

This patches fix the major inconsistances in processing these kind of
commands.

This patch series has been tested with a modified libiscsi testing
library.
The link to the pull request:
https://github.com/sahlberg/libiscsi/pull/345

Write10Residuals, Write12Residuals, Write16Residuals tests have passed.

Thanks,
Anastasia

Anastasia Kovaleva (2):
  scsi: target: core: Signal WRITE residuals
  scsi: target: core: Change ASCQ for residual write

Roman Bolshakov (1):
  scsi: target: core: Set residuals for 4Kn devices

 drivers/target/target_core_transport.c | 53 +++++++++++++-------------
 include/target/target_core_base.h      |  1 +
 2 files changed, 28 insertions(+), 26 deletions(-)

-- 
2.24.3 (Apple Git-128)

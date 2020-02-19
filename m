From: David Disseldorp <ddiss@suse.de>
Date: Wed, 19 Feb 2020 13:01:34 +0000
Subject: [PATCH v2 0/2] scsi: target: modify boolean configfs attributes
Message-Id: <20200219130136.18946-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This series includes a fix for a regression in the configfs interface
and has a subsequent type cleanup to avoid similar mistakes in future.

Changes since v1:
- change unmap_zeroes_data type from int to bool and do the same for
  other attributes in a follow-up commit

David Disseldorp (2):
      scsi: target: fix unmap_zeroes_data boolean initialisation
      scsi: target: convert boolean se_dev_attrib types to bool

 drivers/target/target_core_device.c |  2 +-
 drivers/target/target_core_tmr.c    |  6 ++---
 include/target/target_core_base.h   | 34 ++++++++++++++---------------
 3 files changed, 21 insertions(+), 21 deletions(-)

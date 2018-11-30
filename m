From: David Disseldorp <ddiss@suse.de>
Date: Fri, 30 Nov 2018 23:34:18 +0000
Subject: [PATCH v5 0/5] target: user configurable T10 Vendor ID
Message-Id: <20181130233423.26556-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch-set allows for the modification of the T10 Vendor
Identification string returned in the SCSI INQUIRY response, via the
target/core/$backstore/$name/wwn/vendor_id ConfigFS path.

Changes since v4:
- merge null-termination changes into a single patch
- add patch to initialise t10_wwn ID defaults earlier
- use strlcpy() instead of strncpy() in some places

Changes since v3:
- perform explicit null termination of t10_wwn vendor, model and
  revision fields.
- replace field dump for-loops

Changes since v2:
- https://www.spinics.net/lists/target-devel/msg10720.html
- Support eight byte vendor ID strings
- Split out consistent INQUIRY data padding as a separate patch
- Drop t10_wwn.model buffer print fix, already upstream

Changes since v1:
- https://www.spinics.net/lists/target-devel/msg10545.html
- Rebase against nab's for-next branch, which includes Christoph's
  configfs API changes.

David Disseldorp (5):
      target: use consistent left-aligned ASCII INQUIRY data
      target: consistently null-terminate t10_wwn strings
      target: add device vendor_id configfs attribute
      target: remove hardcoded T10 Vendor ID in INQUIRY response
      target: perform t10_wwn ID initialisation in target_alloc_device()

 drivers/target/target_core_configfs.c | 62 +++++++++++++++++++++++--
 drivers/target/target_core_device.c   | 65 +++++++++++----------------
 drivers/target/target_core_pscsi.c    | 18 +++++---
 drivers/target/target_core_spc.c      | 20 ++++++---
 drivers/target/target_core_stat.c     | 32 +++----------
 include/target/target_core_base.h     | 14 ++++--
 6 files changed, 128 insertions(+), 83 deletions(-)

From: David Disseldorp <ddiss@suse.de>
Date: Thu, 29 Nov 2018 01:01:50 +0000
Subject: [PATCH v4 0/7] target: user configurable T10 Vendor ID
Message-Id: <20181129010157.12687-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patchset allows for the modification of the T10 Vendor
Identification string returned in the SCSI INQUIRY response, via the
target/core/$backstore/$name/wwn/vendor_id ConfigFS path.

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

Bart Van Assche (1):
      target: use printf width specifier for t10_wwn field dumps

David Disseldorp (6):
      target: use consistent left-aligned ASCII INQUIRY data
      target: consistently null-terminate t10_wwn.vendor
      target: consistently null-terminate t10_wwn.model
      target: consistently null-terminate t10_wwn.revision
      target: add device vendor_id configfs attribute
      target: remove hardcoded T10 Vendor ID in INQUIRY response

 drivers/target/target_core_configfs.c | 56 +++++++++++++++++++++++++--
 drivers/target/target_core_device.c   | 47 ++++++++--------------
 drivers/target/target_core_pscsi.c    | 16 +++++---
 drivers/target/target_core_spc.c      | 20 +++++++---
 drivers/target/target_core_stat.c     | 32 ++++-----------
 include/target/target_core_base.h     | 14 +++++--
 6 files changed, 114 insertions(+), 71 deletions(-)

From: David Disseldorp <ddiss@suse.de>
Date: Mon, 19 Nov 2018 21:06:32 +0000
Subject: [PATCH v3 0/4] target: user configurable T10 Vendor ID
Message-Id: <20181119210636.22979-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patchset allows for the modification of the T10 Vendor
Identification string returned in the SCSI INQUIRY response, via the
target/core/$backstore/$name/wwn/vendor_id ConfigFS path.

Changes since v2:
- https://www.spinics.net/lists/target-devel/msg10720.html
- Support eight byte vendor ID strings
- Split out consistent INQUIRY data padding as a separate patch
- Drop t10_wwn.model buffer print fix, already upstream

Changes since v1:
- https://www.spinics.net/lists/target-devel/msg10545.html
- Rebase against nab's for-next branch, which includes Christoph's
  configfs API changes.

David Disseldorp (4):
      target: use consistent left-aligned ASCII INQUIRY data
      target: don't assume t10_wwn.vendor is null terminated
      target: add device vendor_id configfs attribute
      target: remove hardcoded T10 Vendor ID in INQUIRY response

 drivers/target/target_core_configfs.c | 55 +++++++++++++++++++++++++++
 drivers/target/target_core_spc.c      | 19 ++++++---
 drivers/target/target_core_stat.c     | 11 +++++-
 include/target/target_core_base.h     |  3 +-
 4 files changed, 80 insertions(+), 8 deletions(-)

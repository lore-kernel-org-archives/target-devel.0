From: David Disseldorp <ddiss@suse.de>
Date: Wed, 05 Dec 2018 12:18:33 +0000
Subject: [PATCH v7 0/5] target: user configurable T10 Vendor ID
Message-Id: <20181205121838.23982-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch-set allows for the modification of the T10 Vendor
Identification string returned in the SCSI INQUIRY response, via the
target/core/$backstore/$name/wwn/vendor_id ConfigFS path.

Changes since v6:
- PATCH 2/5
  + fill pscsi inquiry data using proper sd->inquiry pointer names
  + dump pscsi sd->inquiry data using sprintf
  + tweak emulate_model_alias truncation warning
  + drop a few duplicate BUILD_BUG_ON()s
  + drop Hannes' sign-off
- PATCH 3/5
  + check user vendor string for non-ascii-printable chars
  + strip newline before INQUIRY_VENDOR_LEN length check
  + drop sign-offs from Bryant, Lee and Hannes

Changes since v5:
- remove unnecessary TRANSPORT_FLAG_PASSTHROUGH conditional from t10_wwn
  ID defaults initialisation.

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

 drivers/target/target_core_configfs.c | 86 +++++++++++++++++++++++++--
 drivers/target/target_core_device.c   | 55 +++++------------
 drivers/target/target_core_pscsi.c    | 50 +++++-----------
 drivers/target/target_core_spc.c      | 20 +++++--
 drivers/target/target_core_stat.c     | 32 +++-------
 include/target/target_core_base.h     | 14 ++++-
 6 files changed, 145 insertions(+), 112 deletions(-)

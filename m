From: David Disseldorp <ddiss@suse.de>
Date: Tue, 04 Dec 2018 10:12:33 +0000
Subject: [PATCH v6 0/5] target: user configurable T10 Vendor ID
Message-Id: <20181204101238.20587-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch-set allows for the modification of the T10 Vendor
Identification string returned in the SCSI INQUIRY response, via the
target/core/$backstore/$name/wwn/vendor_id ConfigFS path.

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

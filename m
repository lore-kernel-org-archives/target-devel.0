From: David Disseldorp <ddiss@suse.de>
Date: Mon, 23 Mar 2020 16:54:09 +0000
Subject: [RFC PATCH 4/5] scsi: target: increase XCOPY I/O size
Message-Id: <20200323165410.24423-5-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200323165410.24423-1-ddiss@suse.de>
In-Reply-To: <20200323165410.24423-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org, David Disseldorp <ddiss@suse.de>

The I/O size is already bound by dev_attrib.hw_max_sectors, so increase
the hardcoded XCOPY_MAX_SECTORS maximum to improve performance against
backstores with high-latency.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_xcopy.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index 9558974185ea..f1aaf7140798 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -5,7 +5,7 @@
 #define XCOPY_TARGET_DESC_LEN		32
 #define XCOPY_SEGMENT_DESC_LEN		28
 #define XCOPY_NAA_IEEE_REGEX_LEN	16
-#define XCOPY_MAX_SECTORS		1024
+#define XCOPY_MAX_SECTORS		4096
 
 /*
  * SPC4r37 6.4.6.1
-- 
2.16.4

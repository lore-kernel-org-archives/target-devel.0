From: David Disseldorp <ddiss@suse.de>
Date: Mon, 23 Mar 2020 16:54:07 +0000
Subject: [RFC PATCH 2/5] scsi: target: drop xcopy DISK BLOCK LENGTH debug
Message-Id: <20200323165410.24423-3-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200323165410.24423-1-ddiss@suse.de>
In-Reply-To: <20200323165410.24423-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org, David Disseldorp <ddiss@suse.de>

The DISK BLOCK LENGTH field is carried with XCOPY target descriptors on
the wire, but is currently unmarshalled during 0x02 segment descriptor
passing. The unmarshalled value is currently unused, so drop it.

Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_xcopy.c | 5 -----
 drivers/target/target_core_xcopy.h | 1 -
 2 files changed, 6 deletions(-)

diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
index 7e5b13da0c20..66b68295c50f 100644
--- a/drivers/target/target_core_xcopy.c
+++ b/drivers/target/target_core_xcopy.c
@@ -315,11 +315,6 @@ static int target_xcopy_parse_segdesc_02(struct se_cmd *se_cmd, struct xcopy_op
 		xop->nolb, (unsigned long long)xop->src_lba,
 		(unsigned long long)xop->dst_lba);
 
-	if (dc != 0) {
-		xop->dbl = get_unaligned_be24(&desc[29]);
-
-		pr_debug("XCOPY seg desc 0x02: DC=1 w/ dbl: %u\n", xop->dbl);
-	}
 	return 0;
 }
 
diff --git a/drivers/target/target_core_xcopy.h b/drivers/target/target_core_xcopy.h
index 26ba4c3c9cff..0840b03e8faa 100644
--- a/drivers/target/target_core_xcopy.h
+++ b/drivers/target/target_core_xcopy.h
@@ -35,7 +35,6 @@ struct xcopy_op {
 	unsigned short stdi;
 	unsigned short dtdi;
 	unsigned short nolb;
-	unsigned int dbl;
 
 	struct xcopy_pt_cmd *src_pt_cmd;
 	struct xcopy_pt_cmd *dst_pt_cmd;
-- 
2.16.4

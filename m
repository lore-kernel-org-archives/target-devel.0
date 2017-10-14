From: David Disseldorp <ddiss@suse.de>
Date: Sat, 14 Oct 2017 21:03:51 +0000
Subject: [PATCH 1/2] target: fix PR state file path truncation detection
Message-Id: <20171014210352.8713-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If an LIO backstore is configured with a sufficiently long Unit Serial
string, alongside a similarly long dbroot path, then a truncated
Persistent Reservation APTPL state file path will be used. This
truncation can unintentionally lead to two LUs with differing serial
numbers sharing PR state file.

Fixes: fdddf932269a ("target: use new "dbroot" target attribute")
Signed-off-by: David Disseldorp <ddiss@suse.de>
---
 drivers/target/target_core_pr.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index dd2cd8048582..61e6eed9cb86 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1976,15 +1976,16 @@ static int __core_scsi3_write_aptpl_to_file(
 	int ret;
 	loff_t pos = 0;
 
-	memset(path, 0, 512);
+	memset(path, 0, sizeof(path));
 
-	if (strlen(&wwn->unit_serial[0]) >= 512) {
+	ret = snprintf(path, sizeof(path), "%s/pr/aptpl_%s",
+			db_root, &wwn->unit_serial[0]);
+	if (ret >= sizeof(path)) {
 		pr_err("WWN value for struct se_device does not fit"
 			" into path buffer\n");
 		return -EMSGSIZE;
 	}
 
-	snprintf(path, 512, "%s/pr/aptpl_%s", db_root, &wwn->unit_serial[0]);
 	file = filp_open(path, flags, 0600);
 	if (IS_ERR(file)) {
 		pr_err("filp_open(%s) for APTPL metadata"
-- 
2.13.6


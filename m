From: David Disseldorp <ddiss@suse.de>
Date: Wed, 18 Oct 2017 23:39:19 +0000
Subject: [PATCH v3 1/2] target: fix PR state file path truncation
Message-Id: <20171018233920.20750-1-ddiss@suse.de>
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
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/target_core_pr.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
index dd2cd8048582..e3c6053cf23e 100644
--- a/drivers/target/target_core_pr.c
+++ b/drivers/target/target_core_pr.c
@@ -1971,24 +1971,21 @@ static int __core_scsi3_write_aptpl_to_file(
 	struct t10_wwn *wwn = &dev->t10_wwn;
 	struct file *file;
 	int flags = O_RDWR | O_CREAT | O_TRUNC;
-	char path[512];
+	char *path;
 	u32 pr_aptpl_buf_len;
 	int ret;
 	loff_t pos = 0;
 
-	memset(path, 0, 512);
-
-	if (strlen(&wwn->unit_serial[0]) >= 512) {
-		pr_err("WWN value for struct se_device does not fit"
-			" into path buffer\n");
-		return -EMSGSIZE;
-	}
+	path = kasprintf(GFP_KERNEL, "%s/pr/aptpl_%s", db_root,
+			&wwn->unit_serial[0]);
+	if (!path)
+		return -ENOMEM;
 
-	snprintf(path, 512, "%s/pr/aptpl_%s", db_root, &wwn->unit_serial[0]);
 	file = filp_open(path, flags, 0600);
 	if (IS_ERR(file)) {
 		pr_err("filp_open(%s) for APTPL metadata"
 			" failed\n", path);
+		kfree(path);
 		return PTR_ERR(file);
 	}
 
@@ -1999,6 +1996,7 @@ static int __core_scsi3_write_aptpl_to_file(
 	if (ret < 0)
 		pr_debug("Error writing APTPL metadata file: %s\n", path);
 	fput(file);
+	kfree(path);
 
 	return (ret < 0) ? -EIO : 0;
 }
-- 
2.13.6


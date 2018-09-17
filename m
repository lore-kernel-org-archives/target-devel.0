From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 17 Sep 2018 21:35:43 +0000
Subject: [PATCH 06/17] target/core: Use sg_alloc_table() instead of open-coding it
Message-Id: <20180917213554.987-7-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The purpose of sg_alloc_table() is to allocate and initialize an
sg-list. Use that function instead of open-coding it.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
---
 drivers/target/target_core_sbc.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_sbc.c b/drivers/target/target_core_sbc.c
index ebac2b49b9c6..689ba6da9a0f 100644
--- a/drivers/target/target_core_sbc.c
+++ b/drivers/target/target_core_sbc.c
@@ -453,7 +453,8 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 						 int *post_ret)
 {
 	struct se_device *dev = cmd->se_dev;
-	struct scatterlist *write_sg = NULL, *sg;
+	struct sg_table write_tbl = { };
+	struct scatterlist *write_sg, *sg;
 	unsigned char *buf = NULL, *addr;
 	struct sg_mapping_iter m;
 	unsigned int offset = 0, len;
@@ -494,14 +495,12 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 		goto out;
 	}
 
-	write_sg = kmalloc_array(cmd->t_data_nents, sizeof(*write_sg),
-				 GFP_KERNEL);
-	if (!write_sg) {
+	if (sg_alloc_table(&write_tbl, cmd->t_data_nents, GFP_KERNEL) < 0) {
 		pr_err("Unable to allocate compare_and_write sg\n");
 		ret = TCM_OUT_OF_RESOURCES;
 		goto out;
 	}
-	sg_init_table(write_sg, cmd->t_data_nents);
+	write_sg = write_tbl.sgl;
 	/*
 	 * Setup verify and write data payloads from total NumberLBAs.
 	 */
@@ -597,7 +596,7 @@ static sense_reason_t compare_and_write_callback(struct se_cmd *cmd, bool succes
 	 * sbc_compare_and_write() before the original READ I/O submission.
 	 */
 	up(&dev->caw_sem);
-	kfree(write_sg);
+	sg_free_table(&write_tbl);
 	kfree(buf);
 	return ret;
 }
-- 
2.18.0

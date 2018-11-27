From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 27 Nov 2018 23:51:56 +0000
Subject: [PATCH v2 02/10] target/core: Use kvcalloc() instead of open-coding it
Message-Id: <20181127235204.186731-3-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patch does not change any functionality. Note: the code that frees
sess_cmd_map already uses kvfree() so that code does not need to be
modified.

Reviewed-by: David Disseldorp <ddiss@suse.de>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: Mike Christie <mchristi@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Hannes Reinecke <hare@suse.de>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_transport.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 2cfd61d62e97..d9e4b736312e 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -273,14 +273,11 @@ int transport_alloc_session_tags(struct se_session *se_sess,
 {
 	int rc;
 
-	se_sess->sess_cmd_map = kcalloc(tag_size, tag_num,
-					GFP_KERNEL | __GFP_NOWARN | __GFP_RETRY_MAYFAIL);
+	se_sess->sess_cmd_map = kvcalloc(tag_size, tag_num,
+					 GFP_KERNEL | __GFP_RETRY_MAYFAIL);
 	if (!se_sess->sess_cmd_map) {
-		se_sess->sess_cmd_map = vzalloc(array_size(tag_size, tag_num));
-		if (!se_sess->sess_cmd_map) {
-			pr_err("Unable to allocate se_sess->sess_cmd_map\n");
-			return -ENOMEM;
-		}
+		pr_err("Unable to allocate se_sess->sess_cmd_map\n");
+		return -ENOMEM;
 	}
 
 	rc = sbitmap_queue_init_node(&se_sess->sess_tag_pool, tag_num, -1,
-- 
2.20.0.rc0.387.gc7a69e6b6c-goog

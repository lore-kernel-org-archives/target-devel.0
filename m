From: Maurizio Lombardi <mlombard@redhat.com>
Date: Fri, 09 Nov 2018 10:13:36 +0000
Subject: [PATCH] target: fix a memory leak in pscsi_map_sg()
Message-Id: <1541758416-30607-1-git-send-email-mlombard@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

If blk_rq_append_bio() fails, the bio should be released before returning.
This patch also removes a "bio = NULL" assignment which is not
needed because the bio pointer will be immediatly reassigned after the jump.

Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
---
 drivers/target/target_core_pscsi.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 47d76c8..432361e 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -948,11 +948,6 @@ static inline struct bio *pscsi_get_bio(int nr_vecs)
 					goto fail;
 				}
 
-				/*
-				 * Clear the pointer so that another bio will
-				 * be allocated with pscsi_get_bio() above.
-				 */
-				bio = NULL;
 				goto new_bio;
 			}
 
@@ -970,6 +965,8 @@ static inline struct bio *pscsi_get_bio(int nr_vecs)
 
 	return 0;
 fail:
+	if (bio)
+		bio_put(bio);
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
 
-- 
Maurizio Lombardi

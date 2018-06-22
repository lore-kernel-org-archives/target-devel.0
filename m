From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Fri, 22 Jun 2018 21:53:03 +0000
Subject: [PATCH 16/20] target/tcm_loop: Avoid that static checkers warn about dead code
Message-Id: <20180622215307.8758-17-bart.vanassche@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The code under the "release:" label can only be reached after se_cmd
has been set to a non-NULL value. Hence remove the if (se_cmd) test.
Keep the else-part since calling transport_generic_free_cmd() is not
necessary for a command that has not been submitted to the core.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 4d3895d5ea43 ("target/tcm_loop: Merge struct tcm_loop_cmd and struct tcm_loop_tmr")
Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
Reviewed-by: Mike Christie <mchristi@redhat.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/target/loopback/tcm_loop.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4c8a97711291..b2e7ff50ff61 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -239,10 +239,7 @@ static int tcm_loop_issue_tmr(struct tcm_loop_tpg *tl_tpg,
 	return ret;
 
 release:
-	if (se_cmd)
-		transport_generic_free_cmd(se_cmd, 0);
-	else
-		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
 	goto out;
 }
 
-- 
2.17.1


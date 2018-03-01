From: Bart Van Assche <bart.vanassche@wdc.com>
Date: Thu, 01 Mar 2018 22:26:31 +0000
Subject: [PATCH 13/14] target/tcm_loop: Avoid that static checkers warn about dead code
Message-Id: <20180301222632.31507-14-bart.vanassche@wdc.com>
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
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Christie <mchristi@redhat.com>
---
 drivers/target/loopback/tcm_loop.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 6106c5f4cc41..cb22d1ead93d 100644
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
2.16.2


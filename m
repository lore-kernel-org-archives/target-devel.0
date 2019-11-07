From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 07 Nov 2019 21:55:25 +0000
Subject: [PATCH] target: Fix a pr_debug() argument
Message-Id: <20191107215525.64415-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Print the string for which conversion failed instead of printing the
function name twice.

Cc: Christoph Hellwig <hch@lst.de>
Fixes: 2650d71e244f ("target: move transport ID handling to the core")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/target_core_fabric_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
index 3c79411c4cd0..6b4b354c88aa 100644
--- a/drivers/target/target_core_fabric_lib.c
+++ b/drivers/target/target_core_fabric_lib.c
@@ -118,7 +118,7 @@ static int srp_get_pr_transport_id(
 	memset(buf + 8, 0, leading_zero_bytes);
 	rc = hex2bin(buf + 8 + leading_zero_bytes, p, count);
 	if (rc < 0) {
-		pr_debug("hex2bin failed for %s: %d\n", __func__, rc);
+		pr_debug("hex2bin failed for %s: %d\n", p, rc);
 		return rc;
 	}
 
-- 
2.24.0.rc1.363.gb1bccd3e3d-goog

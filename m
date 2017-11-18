From: tang.wenji@zte.com.cn
Date: Sat, 18 Nov 2017 09:14:23 +0000
Subject: [PATCH] fix page addr in tcmu_flush_dcache_range
Message-Id: <1510996463-26020-1-git-send-email-tang.wenji@zte.com.cn>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

The page addr should be update.

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
---
 drivers/target/target_core_user.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 942d0942..82dc246 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -470,12 +470,13 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 static inline void tcmu_flush_dcache_range(void *vaddr, size_t size)
 {
 	unsigned long offset = offset_in_page(vaddr);
+	void *start = vaddr - offset;
 
 	size = round_up(size+offset, PAGE_SIZE);
-	vaddr -= offset;
 
 	while (size) {
-		flush_dcache_page(virt_to_page(vaddr));
+		flush_dcache_page(virt_to_page(start));
+		start += PAGE_SIZE;
 		size -= PAGE_SIZE;
 	}
 }
-- 
2.8.1.windows.1


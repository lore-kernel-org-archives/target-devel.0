From: Mike Christie <mchristi@redhat.com>
Date: Tue, 28 Nov 2017 18:40:27 +0000
Subject: [PATCH 01/15] tcmu: fix page addr in tcmu_flush_dcache_range
Message-Id: <1511894441-8626-2-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

From: tangwenji <tang.wenji@zte.com.cn>

The page addr should be update.

Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
Signed-off-by: Mike Christie <mchristi@redhat.com>
---
 drivers/target/target_core_user.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index a415d87..6bcaa8b 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -455,12 +455,13 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
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
1.8.3.1


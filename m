From: Damien Le Moal <damien.lemoal@wdc.com>
Date: Fri, 08 Nov 2019 08:27:35 +0000
Subject: [PATCH] target: core: Prevent memory reclaim recursion
Message-Id: <20191108082735.417876-1-damien.lemoal@wdc.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

Prevent recursion into the IO path under low memory conditions by using
GFP_NOIO in place of GFP_KERNEL when allocating a new command with
tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/target/target_core_user.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 35be1be87d2a..0b9dfa6b17bc 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -499,7 +499,7 @@ static inline bool tcmu_get_empty_block(struct tcmu_dev *udev,
 			schedule_delayed_work(&tcmu_unmap_work, 0);
 
 		/* try to get new page from the mm */
-		page = alloc_page(GFP_KERNEL);
+		page = alloc_page(GFP_NOIO);
 		if (!page)
 			goto err_alloc;
 
@@ -573,7 +573,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	struct tcmu_dev *udev = TCMU_DEV(se_dev);
 	struct tcmu_cmd *tcmu_cmd;
 
-	tcmu_cmd = kmem_cache_zalloc(tcmu_cmd_cache, GFP_KERNEL);
+	tcmu_cmd = kmem_cache_zalloc(tcmu_cmd_cache, GFP_NOIO);
 	if (!tcmu_cmd)
 		return NULL;
 
@@ -584,7 +584,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
 	tcmu_cmd_reset_dbi_cur(tcmu_cmd);
 	tcmu_cmd->dbi_cnt = tcmu_cmd_get_block_cnt(tcmu_cmd);
 	tcmu_cmd->dbi = kcalloc(tcmu_cmd->dbi_cnt, sizeof(uint32_t),
-				GFP_KERNEL);
+				GFP_NOIO);
 	if (!tcmu_cmd->dbi) {
 		kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
 		return NULL;
-- 
2.23.0

From: Souptick Joarder <jrdr.linux@gmail.com>
Date: Sat, 14 Apr 2018 18:54:10 +0000
Subject: [PATCH] target: Change return type to vm_fault_t
Message-Id: <20180414185557.GA19545@jordon-HP-15-Notebook-PC>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Use new return type vm_fault_t for fault handler
in struct vm_operations_struct.

Signed-off-by: Souptick Joarder <jrdr.linux@gmail.com>
Reviewed-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/target/target_core_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
index 4ad89ea..d6af292 100644
--- a/drivers/target/target_core_user.c
+++ b/drivers/target/target_core_user.c
@@ -1382,7 +1382,7 @@ static struct page *tcmu_try_get_block_page(struct tcmu_dev *udev, uint32_t dbi)
 	return page;
 }

-static int tcmu_vma_fault(struct vm_fault *vmf)
+static vm_fault_t tcmu_vma_fault(struct vm_fault *vmf)
 {
 	struct tcmu_dev *udev = vmf->vma->vm_private_data;
 	struct uio_info *info = &udev->uio_info;
--
1.9.1


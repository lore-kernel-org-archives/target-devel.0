From: Allen Pais <allen.lkml@gmail.com>
Date: Wed, 13 Sep 2017 07:44:10 +0000
Subject: [PATCH 01/10] arch:powerpc: return -ENOMEM on failed allocation
Message-Id: <1505287939-14106-1-git-send-email-allen.lkml@gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: nouveau@lists.freedesktop.org, linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, megaraidlinux.pdl@broadcom.com, target-devel@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-btrfs@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 arch/powerpc/platforms/cell/spider-pci.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/cell/spider-pci.c b/arch/powerpc/platforms/cell/spider-pci.c
index d1e61e2..82aa3f7 100644
--- a/arch/powerpc/platforms/cell/spider-pci.c
+++ b/arch/powerpc/platforms/cell/spider-pci.c
@@ -106,7 +106,7 @@ static int __init spiderpci_pci_setup_chip(struct pci_controller *phb,
 	dummy_page_va = kmalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!dummy_page_va) {
 		pr_err("SPIDERPCI-IOWA:Alloc dummy_page_va failed.\n");
-		return -1;
+		return -ENOMEM;
 	}
 
 	dummy_page_da = dma_map_single(phb->parent, dummy_page_va,
@@ -137,7 +137,7 @@ int __init spiderpci_iowa_init(struct iowa_bus *bus, void *data)
 	if (!priv) {
 		pr_err("SPIDERPCI-IOWA:"
 		       "Can't allocate struct spiderpci_iowa_private");
-		return -1;
+		return -ENOMEM;
 	}
 
 	if (of_address_to_resource(np, 0, &r)) {
-- 
2.7.4


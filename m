From: Allen Pais <allen.lkml@gmail.com>
Date: Wed, 13 Sep 2017 07:44:14 +0000
Subject: [PATCH 05/10] drivers:net: return -ENOMEM on allocation failure.
Message-Id: <1505287939-14106-5-git-send-email-allen.lkml@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <1505287939-14106-1-git-send-email-allen.lkml@gmail.com>
In-Reply-To: <1505287939-14106-1-git-send-email-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: nouveau@lists.freedesktop.org, linux-crypto@vger.kernel.org, dri-devel@lists.freedesktop.org, MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, netdev@vger.kernel.org, megaraidlinux.pdl@broadcom.com, target-devel@vger.kernel.org, linux-fbdev@vger.kernel.org, linux-btrfs@vger.kernel.org, Allen Pais <allen.lkml@gmail.com>

Signed-off-by: Allen Pais <allen.lkml@gmail.com>
---
 drivers/net/bonding/bond_alb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index c02cc81..89df377 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -864,7 +864,7 @@ static int rlb_initialize(struct bonding *bond)
 
 	new_hashtbl = kmalloc(size, GFP_KERNEL);
 	if (!new_hashtbl)
-		return -1;
+		return -ENOMEM;
 
 	spin_lock_bh(&bond->mode_lock);
 
-- 
2.7.4


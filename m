From: Allen Pais <allen.lkml@gmail.com>
Date: Wed, 13 Sep 2017 07:44:17 +0000
Subject: [PATCH 08/10] driver:cxgbit: return -NOMEM on allocation failure.
Message-Id: <1505287939-14106-8-git-send-email-allen.lkml@gmail.com>
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
 drivers/target/iscsi/cxgbit/cxgbit_target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_target.c b/drivers/target/iscsi/cxgbit/cxgbit_target.c
index 514986b..47127d6 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_target.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_target.c
@@ -399,7 +399,7 @@ cxgbit_map_skb(struct iscsi_cmd *cmd, struct sk_buff *skb, u32 data_offset,
 	if (padding) {
 		page = alloc_page(GFP_KERNEL | __GFP_ZERO);
 		if (!page)
-			return -1;
+			return -ENOMEM;
 		skb_fill_page_desc(skb, i, page, 0, padding);
 		skb->data_len += padding;
 		skb->len += padding;
-- 
2.7.4


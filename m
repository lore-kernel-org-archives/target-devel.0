From: Julia Lawall <Julia.Lawall@inria.fr>
Date: Sun, 20 Sep 2020 11:26:14 +0000
Subject: [PATCH 02/14] target/rd: drop double zeroing
Message-Id: <1600601186-7420-3-git-send-email-Julia.Lawall@inria.fr>
List-Id: <target-devel.vger.kernel.org>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
In-Reply-To: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

sg_init_table zeroes its first argument, so the allocation of that argument
doesn't have to.

the semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,n,flags;
@@

x = 
- kcalloc
+ kmalloc_array
  (n,sizeof(*x),flags)
...
sg_init_table(x,n)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/target/target_core_rd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -131,7 +131,7 @@ static int rd_allocate_sgl_table(struct
 		if (sg_per_table < total_sg_needed)
 			chain_entry = 1;
 
-		sg = kcalloc(sg_per_table + chain_entry, sizeof(*sg),
+		sg = kmalloc_array(sg_per_table + chain_entry, sizeof(*sg),
 				GFP_KERNEL);
 		if (!sg)
 			return -ENOMEM;

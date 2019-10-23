From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 23 Oct 2019 20:21:50 +0000
Subject: [PATCH] target/cxgbit: Fix cxgbit_fw4_ack()
Message-Id: <20191023202150.22173-1-bvanassche@acm.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Mike Christie <mchristi@redhat.com>, Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Dan Carpenter <dan.carpenter@oracle.com>, Varun Prakash <varun@chelsio.com>, Nicholas Bellinger <nab@linux-iscsi.org>, stable@vger.kernel.org

Use the pointer 'p' after having tested that pointer instead of before.

Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Varun Prakash <varun@chelsio.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Cc: <stable@vger.kernel.org>
Fixes: 5cadafb236df ("target/cxgbit: Fix endianness annotations")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/target/iscsi/cxgbit/cxgbit_cm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/cxgbit/cxgbit_cm.c b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
index c70caf4ea490..a2b5c796bbc4 100644
--- a/drivers/target/iscsi/cxgbit/cxgbit_cm.c
+++ b/drivers/target/iscsi/cxgbit/cxgbit_cm.c
@@ -1831,7 +1831,7 @@ static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
 
 	while (credits) {
 		struct sk_buff *p = cxgbit_sock_peek_wr(csk);
-		const u32 csum = (__force u32)p->csum;
+		u32 csum;
 
 		if (unlikely(!p)) {
 			pr_err("csk 0x%p,%u, cr %u,%u+%u, empty.\n",
@@ -1840,6 +1840,7 @@ static void cxgbit_fw4_ack(struct cxgbit_sock *csk, struct sk_buff *skb)
 			break;
 		}
 
+		csum = (__force u32)p->csum;
 		if (unlikely(credits < csum)) {
 			pr_warn("csk 0x%p,%u, cr %u,%u+%u, < %u.\n",
 				csk,  csk->tid,
-- 
2.23.0

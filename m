From: YueHaibing <yuehaibing@huawei.com>
Date: Thu, 12 Nov 2020 14:54:43 +0000
Subject: [PATCH] IB/srpt: Fix passing zero to 'PTR_ERR'
Message-Id: <20201112145443.17832-1-yuehaibing@huawei.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>

Fix smatch warning:

drivers/infiniband/ulp/srpt/ib_srpt.c:2341 srpt_cm_req_recv() warn: passing zero to 'PTR_ERR'

Use PTR_ERR_OR_ZERO instead of PTR_ERR

Fixes: 847462de3a0a ("IB/srpt: Fix srpt_cm_req_recv() error path (1/2)")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6be60aa5ffe2..3ff24b5048ac 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2338,7 +2338,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 
 	if (IS_ERR_OR_NULL(ch->sess)) {
 		WARN_ON_ONCE(ch->sess = NULL);
-		ret = PTR_ERR(ch->sess);
+		ret = PTR_ERR_OR_ZERO(ch->sess);
 		ch->sess = NULL;
 		pr_info("Rejected login for initiator %s: ret = %d.\n",
 			ch->sess_name, ret);
-- 
2.17.1

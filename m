From: Jing Xiangfeng <jingxiangfeng@huawei.com>
Date: Wed, 17 Jun 2020 14:08:03 +0000
Subject: [PATCH v3] IB/srpt: Remove WARN_ON from srpt_cm_req_recv
Message-Id: <20200617140803.181333-1-jingxiangfeng@huawei.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jingxiangfeng@huawei.com

The callers pass the pointer '&req' or 'private_data' to
srpt_cm_req_recv(), and 'private_data' is initialized in srp_send_req().
'sdev' is allocated and stored in srpt_add_one(). It's easy to show that
sdev and req are always valid. So we remove unnecessary WARN_ON.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index ef7fcd3..0fa65c6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2156,9 +2156,6 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 
 	WARN_ON_ONCE(irqs_disabled());
 
-	if (WARN_ON(!sdev || !req))
-		return -EINVAL;
-
 	it_iu_len = be32_to_cpu(req->req_it_iu_len);
 
 	pr_info("Received SRP_LOGIN_REQ with i_port_id %pI6, t_port_id %pI6 and it_iu_len %d on port %d (guid=%pI6); pkey %#04x\n",
-- 
1.8.3.1

From: Jing Xiangfeng <jingxiangfeng@huawei.com>
Date: Mon, 15 Jun 2020 09:12:20 +0000
Subject: [PATCH] IB/srpt: Fix a potential null pointer dereference
Message-Id: <20200615091220.6439-1-jingxiangfeng@huawei.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jingxiangfeng@huawei.com

In srpt_cm_req_recv(), it is possible that sdev is NULL,
so we should test sdev before using it.

Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 98552749d71c..72053254bf84 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2143,7 +2143,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 			    const struct srp_login_req *req,
 			    const char *src_addr)
 {
-	struct srpt_port *sport = &sdev->port[port_num - 1];
+	struct srpt_port *sport;
 	struct srpt_nexus *nexus;
 	struct srp_login_rsp *rsp = NULL;
 	struct srp_login_rej *rej = NULL;
@@ -2162,6 +2162,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 	if (WARN_ON(!sdev || !req))
 		return -EINVAL;
 
+	sport = &sdev->port[port_num - 1];
 	it_iu_len = be32_to_cpu(req->req_it_iu_len);
 
 	pr_info("Received SRP_LOGIN_REQ with i_port_id %pI6, t_port_id %pI6 and it_iu_len %d on port %d (guid=%pI6); pkey %#04x\n",
-- 
2.17.1

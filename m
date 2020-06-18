From: Sasha Levin <sashal@kernel.org>
Date: Thu, 18 Jun 2020 01:02:29 +0000
Subject: [PATCH AUTOSEL 5.7 052/388] RDMA/srpt: Fix disabling device management
Message-Id: <20200618010805.600873-52-sashal@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200618010805.600873-1-sashal@kernel.org>
In-Reply-To: <20200618010805.600873-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kamal Heib <kamalheib1@gmail.com>, Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@mellanox.com>, Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 23bbd5818e2b0d265aa1835e66f5055f63a8fa4c ]

Avoid disabling device management for devices that don't support
Management datagrams (MADs) by checking if the "mad_agent" pointer is
initialized before calling ib_modify_port, also fix the error flow in
srpt_refresh_port() to disable device management if
ib_register_mad_agent() fail.

Fixes: 09f8a1486dca ("RDMA/srpt: Fix handling of SR-IOV and iWARP ports")
Link: https://lore.kernel.org/r/20200514114720.141139-1-kamalheib1@gmail.com
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 98552749d71c..fcf982c60db6 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -610,6 +610,11 @@ static int srpt_refresh_port(struct srpt_port *sport)
 			       dev_name(&sport->sdev->device->dev), sport->port,
 			       PTR_ERR(sport->mad_agent));
 			sport->mad_agent = NULL;
+			memset(&port_modify, 0, sizeof(port_modify));
+			port_modify.clr_port_cap_mask = IB_PORT_DEVICE_MGMT_SUP;
+			ib_modify_port(sport->sdev->device, sport->port, 0,
+				       &port_modify);
+
 		}
 	}
 
@@ -633,9 +638,8 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
 		sport = &sdev->port[i - 1];
 		WARN_ON(sport->port != i);
-		if (ib_modify_port(sdev->device, i, 0, &port_modify) < 0)
-			pr_err("disabling MAD processing failed.\n");
 		if (sport->mad_agent) {
+			ib_modify_port(sdev->device, i, 0, &port_modify);
 			ib_unregister_mad_agent(sport->mad_agent);
 			sport->mad_agent = NULL;
 		}
-- 
2.25.1

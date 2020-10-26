From: Leon Romanovsky <leon@kernel.org>
Date: Mon, 26 Oct 2020 13:27:37 +0000
Subject: [PATCH rdma-next] IB/srpt: Fix memory leak in srpt_add_one
Message-Id: <20201026132737.1338171-1-leon@kernel.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Maor Gottlieb <maorg@nvidia.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, "Nicholas A. Bellinger" <nab@risingtidesystems.com>, target-devel@vger.kernel.org

From: Maor Gottlieb <maorg@nvidia.com>

In case srpt_refresh_port failed for the second port, then
we don't unregister the MAD agnet.

Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 30 ++++++++++++++++++---------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 0065eb17ae36..cfe38996ea91 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -619,13 +619,7 @@ static int srpt_refresh_port(struct srpt_port *sport)
 	return 0;
 }
 
-/**
- * srpt_unregister_mad_agent - unregister MAD callback functions
- * @sdev: SRPT HCA pointer.
- *
- * Note: It is safe to call this function more than once for the same device.
- */
-static void srpt_unregister_mad_agent(struct srpt_device *sdev)
+static void __srpt_unregister_mad_agent(struct srpt_device *sdev, int port_cnt)
 {
 	struct ib_port_modify port_modify = {
 		.clr_port_cap_mask = IB_PORT_DEVICE_MGMT_SUP,
@@ -633,7 +627,10 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 	struct srpt_port *sport;
 	int i;
 
-	for (i = 1; i <= sdev->device->phys_port_cnt; i++) {
+	if (!port_cnt)
+		return;
+
+	for (i = 1; i <= port_cnt; i++) {
 		sport = &sdev->port[i - 1];
 		WARN_ON(sport->port != i);
 		if (sport->mad_agent) {
@@ -644,6 +641,17 @@ static void srpt_unregister_mad_agent(struct srpt_device *sdev)
 	}
 }
 
+/**
+ * srpt_unregister_mad_agent - unregister MAD callback functions
+ * @sdev: SRPT HCA pointer.
+ *
+ * Note: It is safe to call this function more than once for the same device.
+ */
+static void srpt_unregister_mad_agent(struct srpt_device *sdev)
+{
+	__srpt_unregister_mad_agent(sdev, sdev->device->phys_port_cnt);
+}
+
 /**
  * srpt_alloc_ioctx - allocate a SRPT I/O context structure
  * @sdev: SRPT HCA pointer.
@@ -3185,7 +3193,8 @@ static int srpt_add_one(struct ib_device *device)
 		if (ret) {
 			pr_err("MAD registration failed for %s-%d.\n",
 			       dev_name(&sdev->device->dev), i);
-			goto err_event;
+			i--;
+			goto err_port;
 		}
 	}
 
@@ -3197,7 +3206,8 @@ static int srpt_add_one(struct ib_device *device)
 	pr_debug("added %s.\n", dev_name(&device->dev));
 	return 0;
 
-err_event:
+err_port:
+	__srpt_unregister_mad_agent(sdev, i);
 	ib_unregister_event_handler(&sdev->event_handler);
 err_cm:
 	if (sdev->cm_id)
-- 
2.26.2

From: Roman Pen <roman.penyaev@profitbricks.com>
Date: Mon, 04 Jun 2018 12:30:01 +0000
Subject: [PATCH v2 6/8] IB/isert: embed mutex inside isert_device structure
Message-Id: <20180604123003.24748-7-roman.penyaev@profitbricks.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

do not abuse device_list_mutex.  In the next patch device_list_mutex
will be removed.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Cc: Doug Ledford <dledford@redhat.com>
Cc: target-devel@vger.kernel.org
---
 drivers/infiniband/ulp/isert/ib_isert.c | 11 +++++++----
 drivers/infiniband/ulp/isert/ib_isert.h |  1 +
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index fff40b097947..b7da1a6ea32c 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -96,14 +96,14 @@ isert_comp_get(struct isert_conn *isert_conn)
 	struct isert_comp *comp;
 	int i, min = 0;
 
-	mutex_lock(&device_list_mutex);
+	mutex_lock(&device->comp_mutex);
 	for (i = 0; i < device->comps_used; i++)
 		if (device->comps[i].active_qps <
 		    device->comps[min].active_qps)
 			min = i;
 	comp = &device->comps[min];
 	comp->active_qps++;
-	mutex_unlock(&device_list_mutex);
+	mutex_unlock(&device->comp_mutex);
 
 	isert_info("conn %p, using comp %p min_index: %d\n",
 		   isert_conn, comp, min);
@@ -114,9 +114,11 @@ isert_comp_get(struct isert_conn *isert_conn)
 static void
 isert_comp_put(struct isert_comp *comp)
 {
-	mutex_lock(&device_list_mutex);
+	struct isert_device *device = comp->device;
+
+	mutex_lock(&device->comp_mutex);
 	comp->active_qps--;
-	mutex_unlock(&device_list_mutex);
+	mutex_unlock(&device->comp_mutex);
 }
 
 static struct ib_qp *
@@ -374,6 +376,7 @@ isert_device_get(struct rdma_cm_id *cma_id)
 	}
 
 	INIT_LIST_HEAD(&device->dev_node);
+	mutex_init(&device->comp_mutex);
 
 	device->ib_device = cma_id->device;
 	ret = isert_create_device_ib_res(device);
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 3b296bac4f60..9f0b0a6d87cf 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -184,6 +184,7 @@ struct isert_comp {
 struct isert_device {
 	bool			pi_capable;
 	int			refcount;
+	struct mutex		comp_mutex;
 	struct ib_device	*ib_device;
 	struct ib_pd		*pd;
 	struct isert_comp	*comps;
-- 
2.13.1


From: Roman Pen <roman.penyaev@profitbricks.com>
Date: Mon, 04 Jun 2018 12:30:02 +0000
Subject: [PATCH v2 7/8] IB/isert: use refcount_t instead of just a raw integer
Message-Id: <20180604123003.24748-8-roman.penyaev@profitbricks.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

refcount_t has a nice overflow runtime protection on x86 and clear API,
so prefer it instead of a raw integer.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Doug Ledford <dledford@redhat.com>
Cc: target-devel@vger.kernel.org
---
 drivers/infiniband/ulp/isert/ib_isert.c | 14 +++++++-------
 drivers/infiniband/ulp/isert/ib_isert.h |  3 ++-
 2 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index b7da1a6ea32c..08dc9d27e5b1 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -342,9 +342,9 @@ static void
 isert_device_put(struct isert_device *device)
 {
 	mutex_lock(&device_list_mutex);
-	device->refcount--;
-	isert_info("device %p refcount %d\n", device, device->refcount);
-	if (!device->refcount) {
+	isert_info("device %p refcount %d\n", device,
+		   refcount_read(&device->refcount));
+	if (refcount_dec_and_test(&device->refcount)) {
 		isert_free_device_ib_res(device);
 		list_del(&device->dev_node);
 		kfree(device);
@@ -361,9 +361,9 @@ isert_device_get(struct rdma_cm_id *cma_id)
 	mutex_lock(&device_list_mutex);
 	list_for_each_entry(device, &device_list, dev_node) {
 		if (device->ib_device->node_guid = cma_id->device->node_guid) {
-			device->refcount++;
+			refcount_inc(&device->refcount);
 			isert_info("Found iser device %p refcount %d\n",
-				   device, device->refcount);
+				   device, refcount_read(&device->refcount));
 			mutex_unlock(&device_list_mutex);
 			return device;
 		}
@@ -386,10 +386,10 @@ isert_device_get(struct rdma_cm_id *cma_id)
 		return ERR_PTR(ret);
 	}
 
-	device->refcount++;
+	refcount_inc(&device->refcount);
 	list_add_tail(&device->dev_node, &device_list);
 	isert_info("Created a new iser device %p refcount %d\n",
-		   device, device->refcount);
+		   device, refcount_read(&device->refcount));
 	mutex_unlock(&device_list_mutex);
 
 	return device;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.h b/drivers/infiniband/ulp/isert/ib_isert.h
index 9f0b0a6d87cf..ff08bf29dce4 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.h
+++ b/drivers/infiniband/ulp/isert/ib_isert.h
@@ -2,6 +2,7 @@
 #include <linux/socket.h>
 #include <linux/in.h>
 #include <linux/in6.h>
+#include <linux/refcount.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/rdma_cm.h>
 #include <rdma/rw.h>
@@ -183,7 +184,7 @@ struct isert_comp {
 
 struct isert_device {
 	bool			pi_capable;
-	int			refcount;
+	refcount_t		refcount;
 	struct mutex		comp_mutex;
 	struct ib_device	*ib_device;
 	struct ib_pd		*pd;
-- 
2.13.1


From: Roman Pen <roman.penyaev@profitbricks.com>
Date: Mon, 04 Jun 2018 12:30:03 +0000
Subject: [PATCH v2 8/8] IB/isert: use ib_client API to wrap ib_device
Message-Id: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

ib_client API provides a way to wrap an ib_device with a specific ULP
structure.  Using that API local lists and mutexes can be completely
avoided and allocation/removal paths become a bit cleaner.

Signed-off-by: Roman Pen <roman.penyaev@profitbricks.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Steve Wise <swise@opengridcomputing.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Doug Ledford <dledford@redhat.com>
Cc: target-devel@vger.kernel.org
---
 drivers/infiniband/ulp/isert/ib_isert.c | 96 ++++++++++++++++++++++-----------
 1 file changed, 65 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 08dc9d27e5b1..c80f31573919 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -42,8 +42,7 @@ static int isert_debug_level;
 module_param_named(debug_level, isert_debug_level, int, 0644);
 MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default:0)");
 
-static DEFINE_MUTEX(device_list_mutex);
-static LIST_HEAD(device_list);
+static struct ib_client isert_rdma_ib_client;
 static struct workqueue_struct *isert_comp_wq;
 static struct workqueue_struct *isert_release_wq;
 
@@ -341,7 +340,6 @@ isert_free_device_ib_res(struct isert_device *device)
 static void
 isert_device_put(struct isert_device *device)
 {
-	mutex_lock(&device_list_mutex);
 	isert_info("device %p refcount %d\n", device,
 		   refcount_read(&device->refcount));
 	if (refcount_dec_and_test(&device->refcount)) {
@@ -349,48 +347,44 @@ isert_device_put(struct isert_device *device)
 		list_del(&device->dev_node);
 		kfree(device);
 	}
-	mutex_unlock(&device_list_mutex);
 }
 
 static struct isert_device *
 isert_device_get(struct rdma_cm_id *cma_id)
 {
 	struct isert_device *device;
-	int ret;
 
-	mutex_lock(&device_list_mutex);
-	list_for_each_entry(device, &device_list, dev_node) {
-		if (device->ib_device->node_guid = cma_id->device->node_guid) {
-			refcount_inc(&device->refcount);
-			isert_info("Found iser device %p refcount %d\n",
-				   device, refcount_read(&device->refcount));
-			mutex_unlock(&device_list_mutex);
-			return device;
-		}
-	}
+	/* Paired with isert_ib_client_remove_one() */
+	rcu_read_lock();
+	device = ib_get_client_data(cma_id->device, &isert_rdma_ib_client);
+	if (device && WARN_ON(!refcount_inc_not_zero(&device->refcount)))
+		device = NULL;
+	rcu_read_unlock();
 
-	device = kzalloc(sizeof(struct isert_device), GFP_KERNEL);
-	if (!device) {
-		mutex_unlock(&device_list_mutex);
-		return ERR_PTR(-ENOMEM);
-	}
+	return device;
+}
+
+static struct isert_device *
+isert_device_alloc(struct ib_device *ib_device)
+{
+	struct isert_device *device;
+	int ret;
+
+	device = kzalloc(sizeof(*device), GFP_KERNEL);
+	if (unlikely(!device))
+		return NULL;
 
 	INIT_LIST_HEAD(&device->dev_node);
 	mutex_init(&device->comp_mutex);
-
-	device->ib_device = cma_id->device;
+	refcount_set(&device->refcount, 1);
+	device->ib_device = ib_device;
 	ret = isert_create_device_ib_res(device);
 	if (ret) {
 		kfree(device);
-		mutex_unlock(&device_list_mutex);
-		return ERR_PTR(ret);
+		return NULL;
 	}
-
-	refcount_inc(&device->refcount);
-	list_add_tail(&device->dev_node, &device_list);
 	isert_info("Created a new iser device %p refcount %d\n",
 		   device, refcount_read(&device->refcount));
-	mutex_unlock(&device_list_mutex);
 
 	return device;
 }
@@ -530,8 +524,8 @@ isert_connect_request(struct rdma_cm_id *cma_id, struct rdma_cm_event *event)
 		goto out;
 
 	device = isert_device_get(cma_id);
-	if (IS_ERR(device)) {
-		ret = PTR_ERR(device);
+	if (unlikely(!device)) {
+		ret = -ENODEV;
 		goto out_rsp_dma_map;
 	}
 	isert_conn->device = device;
@@ -2681,15 +2675,52 @@ static struct iscsit_transport iser_target_transport = {
 	.iscsit_get_sup_prot_ops = isert_get_sup_prot_ops,
 };
 
+static void isert_ib_client_add_one(struct ib_device *ib_device)
+{
+	struct isert_device *device;
+
+	device = isert_device_alloc(ib_device);
+	if (likely(device))
+		ib_set_client_data(ib_device, &isert_rdma_ib_client, device);
+	else
+		pr_err("Allocattion of a device failed.\n");
+}
+
+static void isert_ib_client_remove_one(struct ib_device *ib_device,
+				       void *client_data)
+{
+	struct isert_device *device = client_data;
+
+	if (unlikely(!device))
+		return;
+
+	ib_set_client_data(ib_device, &isert_rdma_ib_client, NULL);
+	/* Paired with isert_device_get() */
+	synchronize_rcu();
+	isert_device_put(device);
+}
+
+static struct ib_client isert_rdma_ib_client = {
+	.name   = "isert_client_ib",
+	.add    = isert_ib_client_add_one,
+	.remove = isert_ib_client_remove_one
+};
+
 static int __init isert_init(void)
 {
 	int ret;
 
+	ret = ib_register_client(&isert_rdma_ib_client);
+	if (unlikely(ret)) {
+		isert_err("ib_register_client(): %d\n", ret);
+		return ret;
+	}
 	isert_comp_wq = alloc_workqueue("isert_comp_wq",
 					WQ_UNBOUND | WQ_HIGHPRI, 0);
 	if (!isert_comp_wq) {
 		isert_err("Unable to allocate isert_comp_wq\n");
-		return -ENOMEM;
+		ret = -ENOMEM;
+		goto unregister_client;
 	}
 
 	isert_release_wq = alloc_workqueue("isert_release_wq", WQ_UNBOUND,
@@ -2707,6 +2738,8 @@ static int __init isert_init(void)
 
 destroy_comp_wq:
 	destroy_workqueue(isert_comp_wq);
+unregister_client:
+	ib_unregister_client(&isert_rdma_ib_client);
 
 	return ret;
 }
@@ -2717,6 +2750,7 @@ static void __exit isert_exit(void)
 	destroy_workqueue(isert_release_wq);
 	destroy_workqueue(isert_comp_wq);
 	iscsit_unregister_transport(&iser_target_transport);
+	ib_unregister_client(&isert_rdma_ib_client);
 	isert_info("iSER_TARGET[0] - Released iser_target_transport\n");
 }
 
-- 
2.13.1


From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Mon, 04 Jun 2018 21:58:39 +0000
Subject: Re: [PATCH v2 8/8] IB/isert: use ib_client API to wrap ib_device
Message-Id: <20180604215839.GD24926@ziepe.ca>
List-Id: <target-devel.vger.kernel.org>
References: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
In-Reply-To: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Jun 04, 2018 at 02:30:03PM +0200, Roman Pen wrote:
> ib_client API provides a way to wrap an ib_device with a specific ULP
> structure.  Using that API local lists and mutexes can be completely
> avoided and allocation/removal paths become a bit cleaner.
> 
> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.de>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Steve Wise <swise@opengridcomputing.com>
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: target-devel@vger.kernel.org
>  drivers/infiniband/ulp/isert/ib_isert.c | 96 ++++++++++++++++++++++-----------
>  1 file changed, 65 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index 08dc9d27e5b1..c80f31573919 100644
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -42,8 +42,7 @@ static int isert_debug_level;
>  module_param_named(debug_level, isert_debug_level, int, 0644);
>  MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default:0)");
>  
> -static DEFINE_MUTEX(device_list_mutex);
> -static LIST_HEAD(device_list);
> +static struct ib_client isert_rdma_ib_client;
>  static struct workqueue_struct *isert_comp_wq;
>  static struct workqueue_struct *isert_release_wq;
>  
> @@ -341,7 +340,6 @@ isert_free_device_ib_res(struct isert_device *device)
>  static void
>  isert_device_put(struct isert_device *device)
>  {
> -	mutex_lock(&device_list_mutex);
>  	isert_info("device %p refcount %d\n", device,
>  		   refcount_read(&device->refcount));
>  	if (refcount_dec_and_test(&device->refcount)) {
> @@ -349,48 +347,44 @@ isert_device_put(struct isert_device *device)
>  		list_del(&device->dev_node);
>  		kfree(device);
>  	}
> -	mutex_unlock(&device_list_mutex);
>  }
>  
>  static struct isert_device *
>  isert_device_get(struct rdma_cm_id *cma_id)
>  {
>  	struct isert_device *device;
> -	int ret;
>  
> -	mutex_lock(&device_list_mutex);
> -	list_for_each_entry(device, &device_list, dev_node) {
> -		if (device->ib_device->node_guid = cma_id->device->node_guid) {
> -			refcount_inc(&device->refcount);
> -			isert_info("Found iser device %p refcount %d\n",
> -				   device, refcount_read(&device->refcount));
> -			mutex_unlock(&device_list_mutex);
> -			return device;
> -		}
> -	}
> +	/* Paired with isert_ib_client_remove_one() */
> +	rcu_read_lock();
> +	device = ib_get_client_data(cma_id->device, &isert_rdma_ib_client);
> +	if (device && WARN_ON(!refcount_inc_not_zero(&device->refcount)))
> +		device = NULL;
> +	rcu_read_unlock();

I think I'd prefer a managed kref API instead of tricky
RCU..

ib_get_client_data doesn't use rcu_derference, so this isn't
*technically* right

Something like:

 /* Returns NULL or a valid pointer holding a kref. The kref must be
    freed by the caller */
 struct kref_t *ib_get_client_kref(...);

 /* Atomically releases any kref already held and sets to a new
    value. If non-null a kref is obtained. */
 void ib_set_client_kref(struct kref_t *);

And a client_kref_put function pointer to struct ib_client to point to
the putter function.

The core code can safely manage all the required locking to guarentee
it returns a valid kref'd pointer, without needing to expose RCU.

Looks like many clients fit into this model already, so may as well
help them out.

Jason

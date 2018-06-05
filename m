From: Roman Penyaev <roman.penyaev@profitbricks.com>
Date: Tue, 05 Jun 2018 10:20:49 +0000
Subject: Re: [PATCH v2 8/8] IB/isert: use ib_client API to wrap ib_device
Message-Id: <CAJrWOzD7uxt4DAtUa=8eSPe-6qqcPx1YRatQ18M4uPj3R7B_RQ@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
In-Reply-To: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Jun 4, 2018 at 11:58 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Mon, Jun 04, 2018 at 02:30:03PM +0200, Roman Pen wrote:
>> ib_client API provides a way to wrap an ib_device with a specific ULP
>> structure.  Using that API local lists and mutexes can be completely
>> avoided and allocation/removal paths become a bit cleaner.
>>
>> Signed-off-by: Roman Pen <roman.penyaev@profitbricks.de>
>> Cc: Christoph Hellwig <hch@lst.de>
>> Cc: Steve Wise <swise@opengridcomputing.com>
>> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
>> Cc: Sagi Grimberg <sagi@grimberg.me>
>> Cc: Doug Ledford <dledford@redhat.com>
>> Cc: target-devel@vger.kernel.org
>>  drivers/infiniband/ulp/isert/ib_isert.c | 96 ++++++++++++++++++++++-----------
>>  1 file changed, 65 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
>> index 08dc9d27e5b1..c80f31573919 100644
>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>> @@ -42,8 +42,7 @@ static int isert_debug_level;
>>  module_param_named(debug_level, isert_debug_level, int, 0644);
>>  MODULE_PARM_DESC(debug_level, "Enable debug tracing if > 0 (default:0)");
>>
>> -static DEFINE_MUTEX(device_list_mutex);
>> -static LIST_HEAD(device_list);
>> +static struct ib_client isert_rdma_ib_client;
>>  static struct workqueue_struct *isert_comp_wq;
>>  static struct workqueue_struct *isert_release_wq;
>>
>> @@ -341,7 +340,6 @@ isert_free_device_ib_res(struct isert_device *device)
>>  static void
>>  isert_device_put(struct isert_device *device)
>>  {
>> -     mutex_lock(&device_list_mutex);
>>       isert_info("device %p refcount %d\n", device,
>>                  refcount_read(&device->refcount));
>>       if (refcount_dec_and_test(&device->refcount)) {
>> @@ -349,48 +347,44 @@ isert_device_put(struct isert_device *device)
>>               list_del(&device->dev_node);
>>               kfree(device);
>>       }
>> -     mutex_unlock(&device_list_mutex);
>>  }
>>
>>  static struct isert_device *
>>  isert_device_get(struct rdma_cm_id *cma_id)
>>  {
>>       struct isert_device *device;
>> -     int ret;
>>
>> -     mutex_lock(&device_list_mutex);
>> -     list_for_each_entry(device, &device_list, dev_node) {
>> -             if (device->ib_device->node_guid = cma_id->device->node_guid) {
>> -                     refcount_inc(&device->refcount);
>> -                     isert_info("Found iser device %p refcount %d\n",
>> -                                device, refcount_read(&device->refcount));
>> -                     mutex_unlock(&device_list_mutex);
>> -                     return device;
>> -             }
>> -     }
>> +     /* Paired with isert_ib_client_remove_one() */
>> +     rcu_read_lock();
>> +     device = ib_get_client_data(cma_id->device, &isert_rdma_ib_client);
>> +     if (device && WARN_ON(!refcount_inc_not_zero(&device->refcount)))
>> +             device = NULL;
>> +     rcu_read_unlock();
>
> I think I'd prefer a managed kref API instead of tricky
> RCU..
>
> ib_get_client_data doesn't use rcu_derference, so this isn't
> *technically* right

Why? ib_(get|set)_client_data() takes spin_lock, which guarantees
pointer will be observed correctly and nothing will be reordered.
rcu_dereference() does READ_ONCE(), which in its turn expands to
volatile cast, which prevents compiler from optimization.
Of course spin lock in ib_*_client_data() has stronger guarantees.

Here I used RCU only in order not to introduce another lock.
I need a grace period to be sure everybody observes pointer
as NULL *or* the reference is safely increased.

So these two variants are similar:

RCU

        /* READ PATH */

        rcu_read_lock();
        device = ib_get_client_data(cma_id->device, &isert_rdma_ib_client);
        if (device && WARN_ON(!refcount_inc_not_zero(&device->refcount)))
                device = NULL;
        rcu_read_unlock();


        /* FREE PATH */

        ib_set_client_data(ib_device, &isert_rdma_ib_client, NULL);
        synchronize_rcu();
        isert_device_put(device);


LOCK

        /* READ PATH */

        spin_lock(&lock);
        device = ib_get_client_data(cma_id->device, &isert_rdma_ib_client);
        if (device && WARN_ON(!refcount_inc_not_zero(&device->refcount)))
                device = NULL;
        spin_unlock(&lock);


        /* FREE PATH */

        ib_set_client_data(ib_device, &isert_rdma_ib_client, NULL);
        /* Blink with the lock to be sure everybody has left critical section */
        spin_lock(&lock);
        spin_unlock(&lock);
        isert_device_put(device);

        /* or even another FREE PATH, wrap ib_set_client_data() with
lock/unlock */

        spin_lock(&lock);
        ib_set_client_data(ib_device, &isert_rdma_ib_client, NULL);
        spin_unlock(&lock);
        isert_device_put(device);

>
> Something like:
>
>  /* Returns NULL or a valid pointer holding a kref. The kref must be
>     freed by the caller */
>  struct kref_t *ib_get_client_kref(...);
>
>  /* Atomically releases any kref already held and sets to a new
>     value. If non-null a kref is obtained. */
>  void ib_set_client_kref(struct kref_t *);
>
> And a client_kref_put function pointer to struct ib_client to point to
> the putter function.
>
> The core code can safely manage all the required locking to guarentee
> it returns a valid kref'd pointer, without needing to expose RCU.

I understand your idea.  If refcount_inc_not_zero() can be invoked
directly from ib_get_client_data() under spin lock, that will of
course eliminate the need to do any locks outside the device.c.

But seems this is not enough.  Proposed kref protects read path,
when ulp device is already set, but if not?  I.e. there should
be some help from core API to create ulp device and set it,
if client_data has not been set yet, i.e. something the following
should be done under the lock inside device.c:

        mutex_lock(&nvme_devices_mutex);
        ndev = ib_get_client_data(cm_id->device, &nvme_rdma_ib_client);
        if (ndev && WARN_ON(!nvme_rdma_dev_get(ndev)))
                ndev = NULL;
        else if (!ndev) {
               ndev = nvme_rdma_alloc_device(cmd_id->device);
               if (likely(ndev))
                   ib_set_client_data(cm_id->device, &nvmet_rdma_ib_client,
                                      ndev);
        }
        mutex_unlock(&nvme_devices_mutex);

* code hunk is stolen from previous email, where we discuss that
* ulp device can be created on demand.

And it seems that such approach will require some new ib_client
callbacks to create and free ulp device, which I personally do
not like.

Can we follow instead the way with cmpxchg semantics:

        static struct nvme_rdma_device *
        nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
        {
                struct nvme_rdma_device *ndev;
                struct kref *kref;

                kref = ib_get_client_kref(cm_id->device,
                                          &nvme_rdma_ib_client);
                if (!kref) {
                        ndev = nvme_rdma_alloc_device(cm_id->device);
                        WARN_ON(!ndev); /* ignore error path for now */

                        kref = ib_cmpxchg_client_kref(cm_id->device,
&nvme_rdma_ib_client,
                                                      NULL, &ndev->kref);
                        if (kref) {
                                /* We raced with someone and lost, free ndev */
                                nvme_rdma_dev_put(ndev);
                        } else
                                /* We won! */
                                kref = &ndev->kref;
                }

                return container_of(kref, typeof(*ndev), kref);
        }


The major difference is that the pointer will be updated IFF it
was NULL.

IMO that can worth to do because no extra callbacks and locks are
required and ULP device has full control.

What do you think?

--
Roman

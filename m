From: Roman Penyaev <roman.penyaev@profitbricks.com>
Date: Mon, 11 Jun 2018 08:55:39 +0000
Subject: Re: [PATCH v2 8/8] IB/isert: use ib_client API to wrap ib_device
Message-Id: <CAJrWOzB5iaheBRKMLRZK9AAL98YhNG1sy0qtkgZq=E73JK3LEg@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
In-Reply-To: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Jun 5, 2018 at 4:22 PM, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> On Tue, Jun 05, 2018 at 12:20:49PM +0200, Roman Penyaev wrote:
>
>> > I think I'd prefer a managed kref API instead of tricky
>> > RCU..
>> >
>> > ib_get_client_data doesn't use rcu_derference, so this isn't
>> > *technically* right
>>
>> Why? ib_(get|set)_client_data() takes spin_lock, which guarantees
>> pointer will be observed correctly and nothing will be reordered.
>> rcu_dereference() does READ_ONCE(), which in its turn expands to
>> volatile cast, which prevents compiler from optimization.
>> Of course spin lock in ib_*_client_data() has stronger guarantees.
>
> Maybe, or maybe Alpha does something insane. Who knows with RCU..

The thing is that in this case it does not matter what memory model
has your architecture, we are trying to avoid compiler optimization,
i.e. the following case:

   rcu_read_lock();
   if (*ptr)
       do_something();
   rcu_read_unlock();

can be optimized by the *compiler* (again, only compiler optimization
matters):

   tmp = *ptr;         <<< NOT NICE
   rcu_read_lock();
   if (tmp)
       do_something();
   rcu_read_unlock();

To guarantee that load from @ptr happens after rcu_read_lock(),
@ptr should be volatile (that what exactly rcu_dereference() does),
i.e. that tells compiler explicitly: keep the exact order of these
two lines.

To avoid confusion with all this RCU macros the chunk below can be
expanded and rewritten as following:

    preempt_count_inc();      <<< just increase percpu variable
    barrier();                <<< compiler barrier, which prevents
                                  other volatile accesses leak up
    if (*(volatile int *)ptr) <<< explicit volatile access
        do_something();

barrier();                <<< compiler barrier, prevents from
                             leaking down
preempt_count_dec();

Returning to my case:

    rcu_read_lock();
device = ib_get_client_data(...);
...
rcu_read_unlock();

Previously I mentioned that ib_get_client_data() function has a
spin lock, but this actually also does not matter, what matters
is that this is a real function *call*.  Compiler in this case
is not able to predict what will happen in this function, thus
keeps the same order.  (C standard explicitly defines function
call as a sequence point (C99 Annex C), i.e. between sequence
points, where volatile access is also a sequence point, compiler
can't change the order of the execution).

Of course I do not consider here that ib_get_client_data() can
become a macro in the future. In that case spin lock inside
starts playing the main role.

> But, generally, using RCU and locks together like this is sort of a
> non-sense thing to do, the point of RCU is to avoid locks, so if you
> have locks, then use them locks properly and forget about the RCU.

I agree, looks like a mess, but without support from core API that
is impossible to do without additional protections: locks, RCU or
whatever you like.

>> > Something like:
>> >
>> >  /* Returns NULL or a valid pointer holding a kref. The kref must be
>> >     freed by the caller */
>> >  struct kref_t *ib_get_client_kref(...);
>> >
>> >  /* Atomically releases any kref already held and sets to a new
>> >     value. If non-null a kref is obtained. */
>> >  void ib_set_client_kref(struct kref_t *);
>> >
>> > And a client_kref_put function pointer to struct ib_client to point to
>> > the putter function.
>> >
>> > The core code can safely manage all the required locking to guarentee
>> > it returns a valid kref'd pointer, without needing to expose RCU.
>>
>> I understand your idea.  If refcount_inc_not_zero() can be invoked
>> directly from ib_get_client_data() under spin lock, that will of
>> course eliminate the need to do any locks outside the device.c.
>
> Well, this wouldn't need refcount_inc_not_zero() anymore, as the kref
> is now guarenteed to be positive when in the core's storage list.
>
>> But seems this is not enough.  Proposed kref protects read path,
>> when ulp device is already set, but if not?  I.e. there should
>> be some help from core API to create ulp device and set it,
>> if client_data has not been set yet, i.e. something the following
>> should be done under the lock inside device.c:
>
> Yes, it would be nice for the core code to handle this atomically for
> the ULP.
>
>>         mutex_lock(&nvme_devices_mutex);
>>         ndev = ib_get_client_data(cm_id->device, &nvme_rdma_ib_client);
>>         if (ndev && WARN_ON(!nvme_rdma_dev_get(ndev)))
>>                 ndev = NULL;
>>         else if (!ndev) {
>>                ndev = nvme_rdma_alloc_device(cmd_id->device);
>>                if (likely(ndev))
>>                    ib_set_client_data(cm_id->device, &nvmet_rdma_ib_client,
>>                                       ndev);
>>         }
>>         mutex_unlock(&nvme_devices_mutex);
>
> And this is too much complexity for ULPs.

Indeed, but it is explicit.  And please keep in mind I considered here
only one NVMe case.

>> And it seems that such approach will require some new ib_client
>> callbacks to create and free ulp device, which I personally do
>> not like.
>
> Why? Seems like a fine idea to me, and simplifies all the ULPs
>
> Add two new call backs:
>  create_kref
>  relase_kref
>
> And the core code will call create the very first time the kref data
> is accessed, and do so safely under some kind of locking.

The thing is that inside ib_(get|set)_client_data() spin lock is used,
because those two can be called from any context, thus ib_client.alloc()
callback can't be called under spin lock, because alloc() can sleep.

If we assume that each ULP knows that for the first time
ib_alloc_or_get_client_data() (or any analogue) is called on the path,
where sleep is allowed - then yes, that should work out.  But seems
that should be covered by fat comment.

But what if to go even further and make "struct ib_client_data" public
with kref inside?  That will require changes for ib_client API,  please
take a look:

--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h

@@

+struct ib_client_data;
+
 struct ib_client {
        char  *name;
        void (*add)   (struct ib_device *);
        void (*remove)(struct ib_device *, void *client_data);

+       struct ib_client_data *(*alloc_client_data)(struct ib_device *);
+       void (*free_client_data)(struct ib_client_data *);
+

@@

+struct ib_client_data {
+       struct kref kref;
+       struct ib_device *device;
+       struct ib_client *client;
+       struct list_head device_entry;
+       struct list_head client_entry;
+ };
+

- void *ib_get_client_data(struct ib_device *device, struct ib_client *client);
- void  ib_set_client_data(struct ib_device *device, struct ib_client *client,
-                          void *data);

+ struct ib_client_data *
+ ib_alloc_or_get_client_data(struct ib_device *device,
+                             struct ib_client *client);
+ struct ib_client_data *
+ ib_get_client_data(struct ib_device *device,
+                    struct ib_client *client);
+ bool ib_put_client_data(struct ib_client_data *data);


Then each existent ULP should be changed accordingly, e.g.:

static void ulp_add_one(struct ib_device *device)
{
       struct ib_client_data *data;

       /*
        * Called here for the first time, i.e. ib_client.alloc_client_data()
        * would be invoked.  We do not put the reference and keep ULP dev
        * structure in core lists.
        */
       (void)ib_alloc_or_get_client_data(device, &ib_client);
}

static void ulp_remove_one(struct ib_device *device, void *client_data)
{
       ...
       /* Should be last reference put */
       WARN_ON(!ib_put_client_data(&sdev->ib_data));
}

static void ulp_event_handler(struct ib_event_handler *handler,
                              struct ib_event *event)
{
       struct ib_client_data *data;
       struct ulp_device *ulp_dev;

       data = ib_get_client_data(event->device, &srpt_client);
       if (unlikely(!data))
                return;

       ulp_dev = container_of(data, typeof(*ulp_dev), ib_data);

       /*  ...
          Use ulp_dev
          ...
        */

       /* One reference is still alive */
       WARN_ON(ib_put_client_data(&sdev->ib_data));
}

And NVMe and ISER case would become indeed much simpler:
ib_alloc_or_get_client_data() can be called just from the cm_handler(),
where sleep is allowed.


> The core code will call release_kref when the ib_device is removed.
>
>> Can we follow instead the way with cmpxchg semantics:
>>
>>         static struct nvme_rdma_device *
>>         nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
>>         {
>>                 struct nvme_rdma_device *ndev;
>>                 struct kref *kref;
>>
>>                 kref = ib_get_client_kref(cm_id->device,
>>                                           &nvme_rdma_ib_client);
>>                 if (!kref) {
>>                         ndev = nvme_rdma_alloc_device(cm_id->device);
>>                         WARN_ON(!ndev); /* ignore error path for now */
>>
>>                         kref = ib_cmpxchg_client_kref(cm_id->device,
>> &nvme_rdma_ib_client,
>>                                                       NULL, &ndev->kref);
>>                         if (kref) {
>>                                 /* We raced with someone and lost, free ndev */
>>                                 nvme_rdma_dev_put(ndev);
>>                         } else
>>                                 /* We won! */
>>                                 kref = &ndev->kref;
>>                 }
>>
>>                 return container_of(kref, typeof(*ndev), kref);
>>         }
>
> Bleck, even more complexity.
>
> Why? That is too much code duplication in every ULP for what?

Well, I considered only NVMe case, I did not plan to touch others.

> Why such a mess to avoid a simple and well defined callback?

Indeed we can, if change API and refactor internals of device.c a bit.
I can send an RFC in couple of days with making ib_client_data public
and the stuff which I described above.  What do you think?

--
Roman

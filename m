From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Tue, 05 Jun 2018 14:22:02 +0000
Subject: Re: [PATCH v2 8/8] IB/isert: use ib_client API to wrap ib_device
Message-Id: <20180605142202.GB8651@ziepe.ca>
List-Id: <target-devel.vger.kernel.org>
References: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
In-Reply-To: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, Jun 05, 2018 at 12:20:49PM +0200, Roman Penyaev wrote:

> > I think I'd prefer a managed kref API instead of tricky
> > RCU..
> >
> > ib_get_client_data doesn't use rcu_derference, so this isn't
> > *technically* right
> 
> Why? ib_(get|set)_client_data() takes spin_lock, which guarantees
> pointer will be observed correctly and nothing will be reordered.
> rcu_dereference() does READ_ONCE(), which in its turn expands to
> volatile cast, which prevents compiler from optimization.
> Of course spin lock in ib_*_client_data() has stronger guarantees.

Maybe, or maybe Alpha does something insane. Who knows with RCU..

But, generally, using RCU and locks together like this is sort of a
non-sense thing to do, the point of RCU is to avoid locks, so if you
have locks, then use them locks properly and forget about the RCU.

> > Something like:
> >
> >  /* Returns NULL or a valid pointer holding a kref. The kref must be
> >     freed by the caller */
> >  struct kref_t *ib_get_client_kref(...);
> >
> >  /* Atomically releases any kref already held and sets to a new
> >     value. If non-null a kref is obtained. */
> >  void ib_set_client_kref(struct kref_t *);
> >
> > And a client_kref_put function pointer to struct ib_client to point to
> > the putter function.
> >
> > The core code can safely manage all the required locking to guarentee
> > it returns a valid kref'd pointer, without needing to expose RCU.
> 
> I understand your idea.  If refcount_inc_not_zero() can be invoked
> directly from ib_get_client_data() under spin lock, that will of
> course eliminate the need to do any locks outside the device.c.

Well, this wouldn't need refcount_inc_not_zero() anymore, as the kref
is now guarenteed to be positive when in the core's storage list.

> But seems this is not enough.  Proposed kref protects read path,
> when ulp device is already set, but if not?  I.e. there should
> be some help from core API to create ulp device and set it,
> if client_data has not been set yet, i.e. something the following
> should be done under the lock inside device.c:

Yes, it would be nice for the core code to handle this atomically for
the ULP.

>         mutex_lock(&nvme_devices_mutex);
>         ndev = ib_get_client_data(cm_id->device, &nvme_rdma_ib_client);
>         if (ndev && WARN_ON(!nvme_rdma_dev_get(ndev)))
>                 ndev = NULL;
>         else if (!ndev) {
>                ndev = nvme_rdma_alloc_device(cmd_id->device);
>                if (likely(ndev))
>                    ib_set_client_data(cm_id->device, &nvmet_rdma_ib_client,
>                                       ndev);
>         }
>         mutex_unlock(&nvme_devices_mutex);

And this is too much complexity for ULPs.

> And it seems that such approach will require some new ib_client
> callbacks to create and free ulp device, which I personally do
> not like.

Why? Seems like a fine idea to me, and simplifies all the ULPs

Add two new call backs:
 create_kref
 relase_kref

And the core code will call create the very first time the kref data
is accessed, and do so safely under some kind of locking.

The core code will call release_kref when the ib_device is removed.

> Can we follow instead the way with cmpxchg semantics:
> 
>         static struct nvme_rdma_device *
>         nvme_rdma_find_get_device(struct rdma_cm_id *cm_id)
>         {
>                 struct nvme_rdma_device *ndev;
>                 struct kref *kref;
> 
>                 kref = ib_get_client_kref(cm_id->device,
>                                           &nvme_rdma_ib_client);
>                 if (!kref) {
>                         ndev = nvme_rdma_alloc_device(cm_id->device);
>                         WARN_ON(!ndev); /* ignore error path for now */
> 
>                         kref = ib_cmpxchg_client_kref(cm_id->device,
> &nvme_rdma_ib_client,
>                                                       NULL, &ndev->kref);
>                         if (kref) {
>                                 /* We raced with someone and lost, free ndev */
>                                 nvme_rdma_dev_put(ndev);
>                         } else
>                                 /* We won! */
>                                 kref = &ndev->kref;
>                 }
> 
>                 return container_of(kref, typeof(*ndev), kref);
>         }

Bleck, even more complexity.

Why? That is too much code duplication in every ULP for what?

Why such a mess to avoid a simple and well defined callback?

Jason

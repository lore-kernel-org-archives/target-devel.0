From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Mon, 11 Jun 2018 16:51:56 +0000
Subject: Re: [PATCH v2 8/8] IB/isert: use ib_client API to wrap ib_device
Message-Id: <20180611165156.GC5799@ziepe.ca>
List-Id: <target-devel.vger.kernel.org>
References: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
In-Reply-To: <20180604123003.24748-9-roman.penyaev@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Jun 11, 2018 at 10:55:39AM +0200, Roman Penyaev wrote:

> can be optimized by the *compiler* (again, only compiler optimization
> matters):
> 
>    tmp = *ptr;         <<< NOT NICE
>    rcu_read_lock();
>    if (tmp)
>        do_something();
>    rcu_read_unlock();

No, this already isn't possible.

>     preempt_count_inc();      <<< just increase percpu variable
>     barrier();                <<< compiler barrier, which prevents
>                                   other volatile accesses leak up

barrier() prevents everything from moving out.

>     if (*(volatile int *)ptr) <<< explicit volatile access
>         do_something();

Alpha inserts a special CPU barrier in here.

> barrier();                <<< compiler barrier, prevents from
>                              leaking down
> preempt_count_dec();

The point of rcu_dereference is to pair with rcu_assign_pointer so the
code can make a control flow decision without re-ordering, eg:

 if (rcu_dereference(ptr) != 0)
     assert(*something != NULL);

Guarentees that if the store side does

 rcu_assign_pointer(ptr, 0);
 *something = NULL;

Then the assert cannot fire.

It has nothing to do with accesses leaking outside the rcu critical,
section.

> Returning to my case:
> 
>     rcu_read_lock();
> device = ib_get_client_data(...);
> ...
> rcu_read_unlock();
> 
> Previously I mentioned that ib_get_client_data() function has a
> spin lock, but this actually also does not matter, what matters
> is that this is a real function *call*.

No, it does matter. Code should never rely on a function call to
create an implicit compiler barrier. eg We have LTO now which washes
that side-effect away.

The spinlock was the right answer, because there is no RCU protected
data here, and none of the special properties of RCU are required.

> >> And it seems that such approach will require some new ib_client
> >> callbacks to create and free ulp device, which I personally do
> >> not like.
> >
> > Why? Seems like a fine idea to me, and simplifies all the ULPs
> >
> > Add two new call backs:
> >  create_kref
> >  relase_kref
> >
> > And the core code will call create the very first time the kref data
> > is accessed, and do so safely under some kind of locking.
> 
> The thing is that inside ib_(get|set)_client_data() spin lock is used,
> because those two can be called from any context, thus ib_client.alloc()
> callback can't be called under spin lock, because alloc() can sleep.

> If we assume that each ULP knows that for the first time
> ib_alloc_or_get_client_data() (or any analogue) is called on the path,
> where sleep is allowed - then yes, that should work out.  But seems
> that should be covered by fat comment.

Seems reasonable..

> +struct ib_client_data;
> +
>  struct ib_client {
>         char  *name;
>         void (*add)   (struct ib_device *);
>         void (*remove)(struct ib_device *, void *client_data);
> 
> +       struct ib_client_data *(*alloc_client_data)(struct ib_device *);
> +       void (*free_client_data)(struct ib_client_data *);
> +

> +struct ib_client_data {
> +       struct kref kref;
> +       struct ib_device *device;
> +       struct ib_client *client;
> +       struct list_head device_entry;
> +       struct list_head client_entry;
> + };

Well, the point of the alloc callback was to not alloc data until the
client became activated, exposing this struct doesn't really seem to
help that since you'd still need a void * in here with the data pointer.

> > Why such a mess to avoid a simple and well defined callback?
> 
> Indeed we can, if change API and refactor internals of device.c a bit.
> I can send an RFC in couple of days with making ib_client_data public
> and the stuff which I described above.  What do you think?

Sure, you can mess around with the core code to make a nicer cleanup.

Jason

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 01 Sep 2019 17:38:50 +0000
Subject: Re: Bug report: KFIFO kfifo_init() may introduce buffer overflow
Message-Id: <CAHk-=wjqSDYowpYexqmryVc0ibX3tORb5H4G+ryW--g4vGENXg@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190722114700.GE3089@kadam>
In-Reply-To: <20190722114700.GE3089@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sun, Sep 1, 2019 at 10:11 AM laokz <laokz@foxmail.com> wrote:
>
> At first glance, I thought this issue was serious, based on user space
> experience. Later I realized it may be trivial in kernel space, for kmalloc
> also using roundup_power_of_2 algorithm through SLAB/SLUB.

No, there are definitely slab sizes that aren't always powers of two.

It may be that almost by mistake, the particular one problem you point
out (ibmvscsi_tgt) ends up having its allocation grown to a power of
two, so it's not a problem in practice, but you definitely found a
bug.

I ended up doing a minimal half-revert in commit ab9bb6318b09
("Partially revert "kfifo: fix kfifo_alloc() and kfifo_init()"") which
fixes the basic problem.

> > Also, INIT_KFIFO() and DECLARE_KFIFO() should probably have a
> >
> >      BUILD_BUG_ON(!__is_kfifo_ptr && !is_power_of_2(ARRAY_SIZE(__tmp-
> > >buf)));
> >
> > or something. Probably worth indirection through a helper macro to set
> > the ".mask" field.
>
> Now, I learned that actual scenario may be more complex and uncontrollable
> in some degree, supposing this issue had a statically allocated buffer. So,
> it's worth to use least cost to keep kernel from potential damage.

It turns out that DECLARE_KFIFO ends up protecting against bad kfifo
sizes, because __STRUCT_KFIFO() does this:

        type            buf[((size < 2) || (size & (size - 1))) ? -1 : size]; \

which is making sure that size is at least 2 and a power-of-two. If it
isn't, the compiler will error out due to a negative array size thanks
to that check.

So it's _probably_ the case that the only actual problem was
kfifo_init() itself. And yes, it's quite possible that the only user
that didn't use a power of two ended up having SLAB round that
allocation up for the size it *did* use.

But your bug report was valid, and I'd love you to double-check all
this. Code that just happens to work by mistake is still a serious bug
waiting to happen.

Thanks,

             Linus

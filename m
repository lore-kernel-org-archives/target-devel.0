From: Eric Biggers <ebiggers@kernel.org>
Date: Sat, 10 Oct 2020 01:30:36 +0000
Subject: Re: [PATCH RFC PKS/PMEM 22/58] fs/f2fs: Utilize new kmap_thread()
Message-Id: <20201010013036.GD1122@sol.localdomain>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-23-ira.weiny@intel.com>
 <20201009213434.GA839@sol.localdomain>
 <20201010003954.GW20115@casper.infradead.org>
In-Reply-To: <20201010003954.GW20115@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, ira.weiny@intel.com, Thomas Gleixner <tglx@linutronix.de>, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, intel-wired-lan@lists.osuosl.org, kexec@lists.infradead.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, bpf@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-um@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, ceph-devel@vger.kernel.org, io-uring@vger.kernel.org, linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On Sat, Oct 10, 2020 at 01:39:54AM +0100, Matthew Wilcox wrote:
> On Fri, Oct 09, 2020 at 02:34:34PM -0700, Eric Biggers wrote:
> > On Fri, Oct 09, 2020 at 12:49:57PM -0700, ira.weiny@intel.com wrote:
> > > The kmap() calls in this FS are localized to a single thread.  To avoid
> > > the over head of global PKRS updates use the new kmap_thread() call.
> > >
> > > @@ -2410,12 +2410,12 @@ static inline struct page *f2fs_pagecache_get_page(
> > >  
> > >  static inline void f2fs_copy_page(struct page *src, struct page *dst)
> > >  {
> > > -	char *src_kaddr = kmap(src);
> > > -	char *dst_kaddr = kmap(dst);
> > > +	char *src_kaddr = kmap_thread(src);
> > > +	char *dst_kaddr = kmap_thread(dst);
> > >  
> > >  	memcpy(dst_kaddr, src_kaddr, PAGE_SIZE);
> > > -	kunmap(dst);
> > > -	kunmap(src);
> > > +	kunmap_thread(dst);
> > > +	kunmap_thread(src);
> > >  }
> > 
> > Wouldn't it make more sense to switch cases like this to kmap_atomic()?
> > The pages are only mapped to do a memcpy(), then they're immediately unmapped.
> 
> Maybe you missed the earlier thread from Thomas trying to do something
> similar for rather different reasons ...
> 
> https://lore.kernel.org/lkml/20200919091751.011116649@linutronix.de/

I did miss it.  I'm not subscribed to any of the mailing lists it was sent to.

Anyway, it shouldn't matter.  Patchsets should be standalone, and not require
reading random prior threads on linux-kernel to understand.

And I still don't really understand.  After this patchset, there is still code
nearly identical to the above (doing a temporary mapping just for a memcpy) that
would still be using kmap_atomic().  Is the idea that later, such code will be
converted to use kmap_thread() instead?  If not, why use one over the other?

- Eric

From: James Bottomley <James.Bottomley@HansenPartnership.com>
Date: Sat, 10 Oct 2020 02:43:13 +0000
Subject: Re: [PATCH RFC PKS/PMEM 22/58] fs/f2fs: Utilize new kmap_thread()
Message-Id: <95d137992900152a0453f7ba37771cb9025121fa.camel@HansenPartnership.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-23-ira.weiny@intel.com>
 <20201009213434.GA839@sol.localdomain>
In-Reply-To: <20201009213434.GA839@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>, ira.weiny@intel.com
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, intel-wired-lan@lists.osuosl.org, kexec@lists.infradead.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, bpf@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-um@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, ceph-devel@vger.kernel.org, io-uring@vger.kernel.org, linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On Fri, 2020-10-09 at 14:34 -0700, Eric Biggers wrote:
> On Fri, Oct 09, 2020 at 12:49:57PM -0700, ira.weiny@intel.com wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > The kmap() calls in this FS are localized to a single thread.  To
> > avoid the over head of global PKRS updates use the new
> > kmap_thread() call.
> > 
> > Cc: Jaegeuk Kim <jaegeuk@kernel.org>
> > Cc: Chao Yu <chao@kernel.org>
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > ---
> >  fs/f2fs/f2fs.h | 8 ++++----
> >  1 file changed, 4 insertions(+), 4 deletions(-)
> > 
> > diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> > index d9e52a7f3702..ff72a45a577e 100644
> > --- a/fs/f2fs/f2fs.h
> > +++ b/fs/f2fs/f2fs.h
> > @@ -2410,12 +2410,12 @@ static inline struct page
> > *f2fs_pagecache_get_page(
> >  
> >  static inline void f2fs_copy_page(struct page *src, struct page
> > *dst)
> >  {
> > -	char *src_kaddr = kmap(src);
> > -	char *dst_kaddr = kmap(dst);
> > +	char *src_kaddr = kmap_thread(src);
> > +	char *dst_kaddr = kmap_thread(dst);
> >  
> >  	memcpy(dst_kaddr, src_kaddr, PAGE_SIZE);
> > -	kunmap(dst);
> > -	kunmap(src);
> > +	kunmap_thread(dst);
> > +	kunmap_thread(src);
> >  }
> 
> Wouldn't it make more sense to switch cases like this to
> kmap_atomic()?
> The pages are only mapped to do a memcpy(), then they're immediately
> unmapped.

On a VIPT/VIVT architecture, this is horrendously wasteful.  You're
taking something that was mapped at colour c_src mapping it to a new
address src_kaddr, which is likely a different colour and necessitates
flushing the original c_src, then you copy it to dst_kaddr, which is
also likely a different colour from c_dst, so dst_kaddr has to be
flushed on kunmap and c_dst has to be invalidated on kmap.  What we
should have is an architectural primitive for doing this, something
like kmemcopy_arch(dst, src).  PIPT architectures can implement it as
the above (possibly losing kmap if they don't need it) but VIPT/VIVT
architectures can set up a correctly coloured mapping so they can
simply copy from c_src to c_dst without any need to flush and the data
arrives cache hot at c_dst.

James

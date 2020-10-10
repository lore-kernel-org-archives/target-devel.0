From: Coly Li <colyli@suse.de>
Date: Sat, 10 Oct 2020 02:20:34 +0000
Subject: Re: [PATCH RFC PKS/PMEM 48/58] drivers/md: Utilize new kmap_thread()
Message-Id: <c802fbf4-f67a-b205-536d-9c71b440f9c8@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-49-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-49-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ira.weiny@intel.com
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Thomas Gleixner <tglx@linutronix.de>, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, ceph-devel@vger.kernel.org, amd-gfx@lists.freedesktop.org, io-uring@vger.kernel.org, cluster-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>, linux-afs@lists.infradead.org, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On 2020/10/10 03:50, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> These kmap() calls are localized to a single thread.  To avoid the over
> head of global PKRS updates use the new kmap_thread() call.
> 

Hi Ira,

There were a number of options considered.

1) Attempt to change all the thread local kmap() calls to kmap_atomic()
2) Introduce a flags parameter to kmap() to indicate if the mapping
should be global or not
3) Change ~20-30 call sites to 'kmap_global()' to indicate that they
require a global mapping of the pages
4) Change ~209 call sites to 'kmap_thread()' to indicate that the
mapping is to be used within that thread of execution only


I copied the above information from patch 00/58 to this message. The
idea behind kmap_thread() is fine to me, but as you said the new api is
very easy to be missed in new code (even for me). I would like to be
supportive to option 2) introduce a flag to kmap(), then we won't forget
the new thread-localized kmap method, and people won't ask why a
_thread() function is called but no kthread created.

Thanks.


Coly Li



> Cc: Coly Li <colyli@suse.de> (maintainer:BCACHE (BLOCK LAYER CACHE))
> Cc: Kent Overstreet <kent.overstreet@gmail.com> (maintainer:BCACHE (BLOCK LAYER CACHE))
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  drivers/md/bcache/request.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
> index c7cadaafa947..a4571f6d09dd 100644
> --- a/drivers/md/bcache/request.c
> +++ b/drivers/md/bcache/request.c
> @@ -44,10 +44,10 @@ static void bio_csum(struct bio *bio, struct bkey *k)
>  	uint64_t csum = 0;
>  
>  	bio_for_each_segment(bv, bio, iter) {
> -		void *d = kmap(bv.bv_page) + bv.bv_offset;
> +		void *d = kmap_thread(bv.bv_page) + bv.bv_offset;
>  
>  		csum = bch_crc64_update(csum, d, bv.bv_len);
> -		kunmap(bv.bv_page);
> +		kunmap_thread(bv.bv_page);
>  	}
>  
>  	k->ptr[KEY_PTRS(k)] = csum & (~0ULL >> 1);
> 

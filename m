From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 10 Oct 2020 03:43:15 +0000
Subject: Re: [PATCH RFC PKS/PMEM 51/58] kernel: Utilize new kmap_thread()
Message-Id: <87k0vysq3w.fsf@x220.int.ebiederm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-52-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-52-ira.weiny@intel.com> (ira weiny's
 message of "Fri, 9 Oct 2020 12:50:26 -0700")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ira.weiny@intel.com
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Thomas Gleixner <tglx@linutronix.de>, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, ceph-devel@vger.kernel.org, amd-gfx@lists.freedesktop.org, io-uring@vger.kernel.org, cluster-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>, linux-afs@lists.infradead.org, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

ira.weiny@intel.com writes:

> From: Ira Weiny <ira.weiny@intel.com>
>
> This kmap() call is localized to a single thread.  To avoid the over
> head of global PKRS updates use the new kmap_thread() call.

Acked-by: "Eric W. Biederman" <ebiederm@xmission.com>

>
> Cc: Eric Biederman <ebiederm@xmission.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  kernel/kexec_core.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index c19c0dad1ebe..272a9920c0d6 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -815,7 +815,7 @@ static int kimage_load_normal_segment(struct kimage *image,
>  		if (result < 0)
>  			goto out;
>  
> -		ptr = kmap(page);
> +		ptr = kmap_thread(page);
>  		/* Start with a clear page */
>  		clear_page(ptr);
>  		ptr += maddr & ~PAGE_MASK;
> @@ -828,7 +828,7 @@ static int kimage_load_normal_segment(struct kimage *image,
>  			memcpy(ptr, kbuf, uchunk);
>  		else
>  			result = copy_from_user(ptr, buf, uchunk);
> -		kunmap(page);
> +		kunmap_thread(page);
>  		if (result) {
>  			result = -EFAULT;
>  			goto out;
> @@ -879,7 +879,7 @@ static int kimage_load_crash_segment(struct kimage *image,
>  			goto out;
>  		}
>  		arch_kexec_post_alloc_pages(page_address(page), 1, 0);
> -		ptr = kmap(page);
> +		ptr = kmap_thread(page);
>  		ptr += maddr & ~PAGE_MASK;
>  		mchunk = min_t(size_t, mbytes,
>  				PAGE_SIZE - (maddr & ~PAGE_MASK));
> @@ -895,7 +895,7 @@ static int kimage_load_crash_segment(struct kimage *image,
>  		else
>  			result = copy_from_user(ptr, buf, uchunk);
>  		kexec_flush_icache_page(page);
> -		kunmap(page);
> +		kunmap_thread(page);
>  		arch_kexec_pre_free_pages(page_address(page), 1);
>  		if (result) {
>  			result = -EFAULT;

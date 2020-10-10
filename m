From: John Hubbard <jhubbard@nvidia.com>
Date: Sat, 10 Oct 2020 02:53:07 +0000
Subject: Re: [PATCH RFC PKS/PMEM 57/58] nvdimm/pmem: Stray access protection for pmem->virt_addr
Message-Id: <bd3f5ece-0e7b-4c15-abbc-1b3b943334dc@nvidia.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-58-ira.weiny@intel.com>
In-Reply-To: <20201009195033.3208459-58-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: ira.weiny@intel.com, Andrew Morton <akpm@linux-foundation.org>, Thomas
 Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav
 Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, ceph-devel@vger.kernel.org, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, cluster-devel@redhat.com, linux-cachefs@redhat.com, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Fenghua Yu <fenghua.yu@intel.com>, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, io-uring@vger.kernel.org, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On 10/9/20 12:50 PM, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> The pmem driver uses a cached virtual address to access its memory
> directly.  Because the nvdimm driver is well aware of the special
> protections it has mapped memory with, we call dev_access_[en|dis]able()
> around the direct pmem->virt_addr (pmem_addr) usage instead of the
> unnecessary overhead of trying to get a page to kmap.
> 
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>   drivers/nvdimm/pmem.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
> index fab29b514372..e4dc1ae990fc 100644
> --- a/drivers/nvdimm/pmem.c
> +++ b/drivers/nvdimm/pmem.c
> @@ -148,7 +148,9 @@ static blk_status_t pmem_do_read(struct pmem_device *pmem,
>   	if (unlikely(is_bad_pmem(&pmem->bb, sector, len)))
>   		return BLK_STS_IOERR;
>   
> +	dev_access_enable(false);
>   	rc = read_pmem(page, page_off, pmem_addr, len);
> +	dev_access_disable(false);

Hi Ira!

The APIs should be tweaked to use a symbol (GLOBAL, PER_THREAD), instead of
true/false. Try reading the above and you'll see that it sounds like it's
doing the opposite of what it is ("enable_this(false)" sounds like a clumsy
API design to *disable*, right?). And there is no hint about the scope.

And it *could* be so much more readable like this:

     dev_access_enable(DEV_ACCESS_THIS_THREAD);



thanks,
-- 
John Hubbard
NVIDIA

From: Damien Le Moal <Damien.LeMoal@wdc.com>
Date: Mon, 12 Oct 2020 02:30:18 +0000
Subject: Re: [PATCH RFC PKS/PMEM 26/58] fs/zonefs: Utilize new kmap_thread()
Message-Id: <BL0PR04MB65146627753E6A8125C30044E7070@BL0PR04MB6514.namprd04.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-27-ira.weiny@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "ira.weiny@intel.com" <ira.weiny@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Cc: "linux-aio@kvack.org" <linux-aio@kvack.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>, "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>, "ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, "drbd-dev@lists.linbit.com" <drbd-dev@lists.linbit.com>, Naohiro Aota <Naohiro.Aota@wdc.com>, "linux-cifs@vger.kernel.org" <linux-cifs@vger.kernel.org>, "linux-nilfs@vger.kernel.org" <linux-nilfs@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "amd-gfx@lists.freedesktop.org" <amd-gfx@lists.freedesktop.org>, "linux-afs@lists.infradead.org" <linux-afs@lists.infradead.org>, "cluster-devel@redhat.com" <cluster-devel@redhat.com>, "linux-cachefs@redhat.com" <linux-cachefs@redhat.com>, "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-um@lists.infradead.org" <linux-um@lists.infradead.org>, "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>, "ecryptfs@vger.kernel.org" <ecryptfs@vger.kernel.org>, "linux-erofs@lists.ozlabs.org" <linux-erofs@lists.ozlabs.org>, "reiserfs-devel@vger.kernel.org" <reiserfs-devel@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "linux-bcache@vger.kernel.org" <linux-bcache@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "linux-ntfs-dev@lists.sourceforge.net" <linux-ntfs-dev@lists.sourceforge.net>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-f2fs-devel@lists.sourceforge.net" <linux-f2fs-devel@lists.sourceforge.net>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>

On 2020/10/10 4:52, ira.weiny@intel.com wrote:
> From: Ira Weiny <ira.weiny@intel.com>
> 
> The kmap() calls in this FS are localized to a single thread.  To avoid
> the over head of global PKRS updates use the new kmap_thread() call.
> 
> Cc: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: Naohiro Aota <naohiro.aota@wdc.com>
> Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> ---
>  fs/zonefs/super.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/zonefs/super.c b/fs/zonefs/super.c
> index 8ec7c8f109d7..2fd6c86beee1 100644
> --- a/fs/zonefs/super.c
> +++ b/fs/zonefs/super.c
> @@ -1297,7 +1297,7 @@ static int zonefs_read_super(struct super_block *sb)
>  	if (ret)
>  		goto free_page;
>  
> -	super = kmap(page);
> +	super = kmap_thread(page);
>  
>  	ret = -EINVAL;
>  	if (le32_to_cpu(super->s_magic) != ZONEFS_MAGIC)
> @@ -1349,7 +1349,7 @@ static int zonefs_read_super(struct super_block *sb)
>  	ret = 0;
>  
>  unmap:
> -	kunmap(page);
> +	kunmap_thread(page);
>  free_page:
>  	__free_page(page);
>  
> 

acked-by: Damien Le Moal <damien.lemoal@wdc.com>

-- 
Damien Le Moal
Western Digital Research

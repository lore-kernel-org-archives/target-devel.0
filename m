From: Dave Hansen <dave.hansen@intel.com>
Date: Mon, 12 Oct 2020 16:28:29 +0000
Subject: Re: [PATCH RFC PKS/PMEM 22/58] fs/f2fs: Utilize new kmap_thread()
Message-Id: <5d621db9-23d4-e140-45eb-d7fca2093d2b@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-23-ira.weiny@intel.com>
 <20201009213434.GA839@sol.localdomain>
 <20201010003954.GW20115@casper.infradead.org>
 <20201010013036.GD1122@sol.localdomain>
 <20201012065635.GB2046448@iweiny-DESK2.sc.intel.com>
 <20201012161946.GA858@sol.localdomain>
In-Reply-To: <20201012161946.GA858@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Eric Biggers <ebiggers@kernel.org>, Ira Weiny <ira.weiny@intel.com>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, amd-gfx@lists.freedesktop.org, linux-kselftest@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, Matthew Wilcox <willy@infradead.org>, linux-afs@lists.infradead.org, cluster-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, intel-wired-lan@lists.osuosl.org, kexec@lists.infradead.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, bpf@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-um@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, ceph-devel@vger.kernel.org, io-uring@vger.kernel.org, linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On 10/12/20 9:19 AM, Eric Biggers wrote:
> On Sun, Oct 11, 2020 at 11:56:35PM -0700, Ira Weiny wrote:
>>> And I still don't really understand.  After this patchset, there is still code
>>> nearly identical to the above (doing a temporary mapping just for a memcpy) that
>>> would still be using kmap_atomic().
>> I don't understand.  You mean there would be other call sites calling:
>>
>> kmap_atomic()
>> memcpy()
>> kunmap_atomic()
> Yes, there are tons of places that do this.  Try 'git grep -A6 kmap_atomic'
> and look for memcpy().
> 
> Hence why I'm asking what will be the "recommended" way to do this...
> kunmap_thread() or kmap_atomic()?

kmap_atomic() is always preferred over kmap()/kmap_thread().
kmap_atomic() is _much_ more lightweight since its TLB invalidation is
always CPU-local and never broadcast.

So, basically, unless you *must* sleep while the mapping is in place,
kmap_atomic() is preferred.

From: Matthew Wilcox <willy@infradead.org>
Date: Mon, 12 Oct 2020 20:02:54 +0000
Subject: Re: [PATCH RFC PKS/PMEM 22/58] fs/f2fs: Utilize new kmap_thread()
Message-Id: <20201012200254.GB20115@casper.infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-23-ira.weiny@intel.com>
 <20201009213434.GA839@sol.localdomain>
 <20201010003954.GW20115@casper.infradead.org>
 <20201010013036.GD1122@sol.localdomain>
 <20201012065635.GB2046448@iweiny-DESK2.sc.intel.com>
 <20201012161946.GA858@sol.localdomain>
 <5d621db9-23d4-e140-45eb-d7fca2093d2b@intel.com>
 <20201012164438.GA20115@casper.infradead.org>
 <20201012195354.GC2046448@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20201012195354.GC2046448@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, Dave Hansen <dave.hansen@intel.com>, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, Thomas Gleixner <tglx@linutronix.de>, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, amd-gfx@lists.freedesktop.org, linux-afs@lists.infradead.org, Eric Biggers <ebiggers@kernel.org>, Ingo Molnar <mingo@redhat.com>, intel-wired-lan@lists.osuosl.org, kexec@lists.infradead.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, bpf@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-um@lists.infradead.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Jaegeuk Kim <jaegeuk@kernel.org>, ceph-devel@vger.kernel.org, io-uring@vger.kernel.org, linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-mm@kvack.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, cluster-devel@redhat.com, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-erofs@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On Mon, Oct 12, 2020 at 12:53:54PM -0700, Ira Weiny wrote:
> On Mon, Oct 12, 2020 at 05:44:38PM +0100, Matthew Wilcox wrote:
> > On Mon, Oct 12, 2020 at 09:28:29AM -0700, Dave Hansen wrote:
> > > kmap_atomic() is always preferred over kmap()/kmap_thread().
> > > kmap_atomic() is _much_ more lightweight since its TLB invalidation is
> > > always CPU-local and never broadcast.
> > > 
> > > So, basically, unless you *must* sleep while the mapping is in place,
> > > kmap_atomic() is preferred.
> > 
> > But kmap_atomic() disables preemption, so the _ideal_ interface would map
> > it only locally, then on preemption make it global.  I don't even know
> > if that _can_ be done.  But this email makes it seem like kmap_atomic()
> > has no downsides.
> 
> And that is IIUC what Thomas was trying to solve.
> 
> Also, Linus brought up that kmap_atomic() has quirks in nesting.[1]
> 
> >From what I can see all of these discussions support the need to have something
> between kmap() and kmap_atomic().
> 
> However, the reason behind converting call sites to kmap_thread() are different
> between Thomas' patch set and mine.  Both require more kmap granularity.
> However, they do so with different reasons and underlying implementations but
> with the _same_ resulting semantics; a thread local mapping which is
> preemptable.[2]  Therefore they each focus on changing different call sites.
> 
> While this patch set is huge I think it serves a valuable purpose to identify a
> large number of call sites which are candidates for this new semantic.

Yes, I agree.  My problem with this patch-set is that it ties it to
some Intel feature that almost nobody cares about.  Maybe we should
care about it, but you didn't try very hard to make anyone care about
it in the cover letter.

For a future patch-set, I'd like to see you just introduce the new
API.  Then you can optimise the Intel implementation of it afterwards.
Those patch-sets have entirely different reviewers.

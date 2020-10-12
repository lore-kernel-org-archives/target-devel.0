From: Coly Li <colyli@suse.de>
Date: Mon, 12 Oct 2020 07:40:27 +0000
Subject: Re: [PATCH RFC PKS/PMEM 48/58] drivers/md: Utilize new kmap_thread()
Message-Id: <026a7658-6c43-6510-a8b5-32f29de7b281@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20201009195033.3208459-1-ira.weiny@intel.com>
 <20201009195033.3208459-49-ira.weiny@intel.com>
 <c802fbf4-f67a-b205-536d-9c71b440f9c8@suse.de>
 <20201012052817.GZ2046448@iweiny-DESK2.sc.intel.com>
In-Reply-To: <20201012052817.GZ2046448@iweiny-DESK2.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ira Weiny <ira.weiny@intel.com>
Cc: linux-aio@kvack.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>, linux-mmc@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>, dri-devel@lists.freedesktop.org, linux-mm@kvack.org, target-devel@vger.kernel.org, linux-mtd@lists.infradead.org, linux-kselftest@vger.kernel.org, samba-technical@lists.samba.org, Thomas Gleixner <tglx@linutronix.de>, drbd-dev@lists.linbit.com, devel@driverdev.osuosl.org, linux-cifs@vger.kernel.org, linux-nilfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, x86@kernel.org, ceph-devel@vger.kernel.org, amd-gfx@lists.freedesktop.org, io-uring@vger.kernel.org, cluster-devel@redhat.com, Ingo Molnar <mingo@redhat.com>, intel-wired-lan@lists.osuosl.org, xen-devel@lists.xenproject.org, linux-ext4@vger.kernel.org, Kent Overstreet <kent.overstreet@gmail.com>, Fenghua Yu <fenghua.yu@intel.com>, linux-afs@lists.infradead.org, linux-um@lists.infradead.org, intel-gfx@lists.freedesktop.org, ecryptfs@vger.kernel.org, linux-erofs@lists.ozlabs.org, reiserfs-devel@vger.kernel.org, linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-cachefs@redhat.com, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, netdev@vger.kernel.org, kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-fsdevel@vger.kernel.org, bpf@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-btrfs@vger.kernel.org

On 2020/10/12 13:28, Ira Weiny wrote:
> On Sat, Oct 10, 2020 at 10:20:34AM +0800, Coly Li wrote:
>> On 2020/10/10 03:50, ira.weiny@intel.com wrote:
>>> From: Ira Weiny <ira.weiny@intel.com>
>>>
>>> These kmap() calls are localized to a single thread.  To avoid the over
>>> head of global PKRS updates use the new kmap_thread() call.
>>>
>>
>> Hi Ira,
>>
>> There were a number of options considered.
>>
>> 1) Attempt to change all the thread local kmap() calls to kmap_atomic()
>> 2) Introduce a flags parameter to kmap() to indicate if the mapping
>> should be global or not
>> 3) Change ~20-30 call sites to 'kmap_global()' to indicate that they
>> require a global mapping of the pages
>> 4) Change ~209 call sites to 'kmap_thread()' to indicate that the
>> mapping is to be used within that thread of execution only
>>
>>
>> I copied the above information from patch 00/58 to this message. The
>> idea behind kmap_thread() is fine to me, but as you said the new api is
>> very easy to be missed in new code (even for me). I would like to be
>> supportive to option 2) introduce a flag to kmap(), then we won't forget
>> the new thread-localized kmap method, and people won't ask why a
>> _thread() function is called but no kthread created.
> 
> Thanks for the feedback.
> 
> I'm going to hold off making any changes until others weigh in.  FWIW, I kind
> of like option 2 as well.  But there is already kmap_atomic() so it seemed like
> kmap_XXXX() was more in line with the current API.

I understand it now, the idea is fine to me.

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

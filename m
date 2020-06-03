From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 03 Jun 2020 02:31:33 +0000
Subject: Re: [PATCH] scsi: target: tcmu: fix size in calls to tcmu_flush_dcache_range
Message-Id: <159114947916.26776.943125808891892721.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, mchristi@redhat.com, Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>

On Thu, 28 May 2020 21:31:08 +0200, Bodo Stroesser wrote:

> 1) If remaining ring space before the end of the ring is
>    smaller then the next cmd to write, tcmu writes a padding
>    entry which fills the remaining space at the end of the
>    ring.
>    Then tcmu calls tcmu_flush_dcache_range() with the size
>    of struct tcmu_cmd_entry as data length to flush.
>    If the space filled by the padding was smaller then
>    tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
>    an address range reaching behind the end of the vmalloc'ed
>    ring.
>    tcmu_flush_dcache_range() in a loop calls
>       flush_dcache_page(virt_to_page(start));
>    for every page being part of the range. On x86 the line is
>    optimized out by the compiler, as flush_dcache_page() is
>    empty on x86.
>    But I assume the above can cause trouble on other
>    architectures that really have a flush_dcache_page().
>    For paddings only the header part of an entry is relevant
>    Due to alignment rules the header always fits in the
>    remaining space, if padding is needed.
>    So tcmu_flush_dcache_range() can safely be called with
>    sizeof(entry->hdr) as the length here.
> 
> [...]

Applied to 5.8/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
      https://git.kernel.org/mkp/scsi/c/8c4e0f212398

-- 
Martin K. Petersen	Oracle Linux Engineering

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 01 Sep 2020 15:58:29 +0000
Subject: Re: [PATCH] scsi: target: tcmu: fix size in calls to tcmu_flush_dcache_range
Message-Id: <8ced4335-dcae-96c8-7c14-3eeb5c97324b@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200528193108.9085-1-bstroesser@ts.fujitsu.com>
 <159114947916.26776.943125808891892721.b4-ty@oracle.com>
 <79f7119f-fda7-64cc-b617-d49a23f2e628@ts.fujitsu.com>
 <28862cd1-e7f2-d161-1bab-4d2ff73cf6a1@ts.fujitsu.com>
 <20200901140212.GE397411@kroah.com>
In-Reply-To: <20200901140212.GE397411@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>, stable@vger.kernel.org

On 2020-09-01 16:02, Greg KH wrote:
> On Fri, Aug 28, 2020 at 12:03:38PM +0200, Bodo Stroesser wrote:
>> Hi,
>> I'm adding stable@vger.kernel.org
>>
>> Once again, this time really adding stable.
>>
>> On 2020-06-03 04:31, Martin K. Petersen wrote:
>>> On Thu, 28 May 2020 21:31:08 +0200, Bodo Stroesser wrote:
>>>
>>>> 1) If remaining ring space before the end of the ring is
>>>>       smaller then the next cmd to write, tcmu writes a padding
>>>>       entry which fills the remaining space at the end of the
>>>>       ring.
>>>>       Then tcmu calls tcmu_flush_dcache_range() with the size
>>>>       of struct tcmu_cmd_entry as data length to flush.
>>>>       If the space filled by the padding was smaller then
>>>>       tcmu_cmd_entry, tcmu_flush_dcache_range() is called for
>>>>       an address range reaching behind the end of the vmalloc'ed
>>>>       ring.
>>>>       tcmu_flush_dcache_range() in a loop calls
>>>>          flush_dcache_page(virt_to_page(start));
>>>>       for every page being part of the range. On x86 the line is
>>>>       optimized out by the compiler, as flush_dcache_page() is
>>>>       empty on x86.
>>>>       But I assume the above can cause trouble on other
>>>>       architectures that really have a flush_dcache_page().
>>>>       For paddings only the header part of an entry is relevant
>>>>       Due to alignment rules the header always fits in the
>>>>       remaining space, if padding is needed.
>>>>       So tcmu_flush_dcache_range() can safely be called with
>>>>       sizeof(entry->hdr) as the length here.
>>>>
>>>> [...]
>>>
>>> Applied to 5.8/scsi-queue, thanks!
>>>
>>> [1/1] scsi: target: tcmu: Fix size in calls to tcmu_flush_dcache_range
>>>          https://git.kernel.org/mkp/scsi/c/8c4e0f212398
>>>
>>
>> The full commit of this patch is:
>>       8c4e0f212398cdd1eb4310a5981d06a723cdd24f
>>
>> This patch is the first of four patches that are necessary to run tcmu
>> on ARM without crash. For details please see
>>       https://bugzilla.kernel.org/show_bug.cgi?id 8045
>> Upsteam commits of patches 2,3, and 4 are:
>>     2: 3c58f737231e "scsi: target: tcmu: Optimize use of flush_dcache_page"
>>     3: 3145550a7f8b "scsi: target: tcmu: Fix crash in tcmu_flush_dcache_range
>> on ARM"
>>     4: 5a0c256d96f0 "scsi: target: tcmu: Fix crash on ARM during cmd
>> completion"
>>
>> Since patches 3 and 4 already were accepted for 5.8, 5.4, and 4.19, and
>> I sent a request to add patch 2 about 1 hour ago, please consider adding
>> this patch to 5.4 and 4.19, because without it tcmu on ARM will still
>> crash.
> 
> I don't see such a request, and am confused now.
> 
> What exact commits do you want backported, and to what trees?
> 
> thanks,
> 
> greg k-h
> 

Sorry for the confusion.

The subject of the request I mentioned is
    "Re: [PATCH v2 0/2] scsi: target: tcmu: fix crashes on ARM"
because it is for the first patch of a small series of two.

Please backport to kernels 4.19 and 5.4 (it is part of 5.8 from beginning):
  8c4e0f212398 "scsi: target: tcmu: fix size in calls to tcmu_flush_dcache_range"

Please backport to kernels 4.19, 5.4 and 5.8:
  3c58f737231e "scsi: target: tcmu: Optimize use of flush_dcache_page"

Backporting to 4.14 or earlier AFAICS would need more work, especially testing.
I don't think that its worth it.

Thank you,
Bodo

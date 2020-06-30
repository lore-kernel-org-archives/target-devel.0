From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 30 Jun 2020 18:00:57 +0000
Subject: Re: [RFC] scsi: target: tcmu: running 32bit userspace on 64bit kernel
Message-Id: <b1452aaf-d5f2-3342-a723-b2cc788ed4b0@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <364c13da-6d4f-c28b-36b3-082db8c3de58@ts.fujitsu.com>
 <1593535964.4124.2.camel@HansenPartnership.com>
 <2cc4fd9e-e96d-725b-c047-4bd26af604a6@ts.fujitsu.com>
 <1593538071.4124.7.camel@HansenPartnership.com>
In-Reply-To: <1593538071.4124.7.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



On 2020-06-30 19:27, James Bottomley wrote:
> On Tue, 2020-06-30 at 19:17 +0200, Bodo Stroesser wrote:
>> On 2020-06-30 18:52, James Bottomley wrote:
>>> On Tue, 2020-06-30 at 18:49 +0200, Bodo Stroesser wrote:
> [...]
>>>> So we can compile a 32-bit application that works on 64-bit
>>>> kernel without need to manipulate the include file prepared by
>>>> the kernel.
>>>>
>>>> What do you think? Do you know a better solution?
>>>
>>> Can you not use something similar to the compat_ioctl
>>> mechanism?  the job of the compat layer is to re-layout the input
>>> and output structures to impedance match between 32 and 64 bit.
>>>
>>> James
>>>
>>
>> struct tcmu_cmd_entry is prepared by kernel and exposed to userspace
>> via an mmap()ed uio device. From tcmu module point of view it is
>> vmalloc area.
>>
>> So there is no 'glue' code that could do conversion.
> 
> OK, so can't you do it like a vdso then?  For them we detect on mmap
> what the architectural model is and map different areas depending on
> that, so effectively you have a 64 and a 32 bit layout area and which
> one you map depends on the architecture type you see coming into the
> setup call.  You expect only one to be mapped and you only do extra
> conversions on the impedance mismatch case.

I think, vdso and tcmu's uio mmaps are different in vdso AFAIK being
constant code while the uio mmap contains data (e.g. tcmu_cmd_entries) 
that is written and read by tcmu module and userspace. So kernel needs 
to know what format of entries userspace expects.
Additionally, the data is preserved over close and re-open of the uio
device and mapping. So it would be necessary to re-format data existing
in a ring buffer according to the appl arch. I don't like this idea.
But alternatively on architecture change we could flush the ring buffer.

Hmm. tcmu is called during mmap() for the uio-device. If we can
determine the appl arch at that time, it would work. Let me check.

Bodo

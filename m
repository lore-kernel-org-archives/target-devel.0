From: James Smart <jsmart2021@gmail.com>
Date: Thu, 20 Dec 2018 22:25:51 +0000
Subject: Re: Aw: [ANNOUNCE v2]: Broadcom (Emulex) FC Target driver - efct
Message-Id: <7e98a7ce-2a7d-6d51-60ab-b8057392f0fe@gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <9b8c7647-f9ab-9147-1378-b047929d5e11@broadcom.com>
In-Reply-To: <9b8c7647-f9ab-9147-1378-b047929d5e11@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 12/19/2018 10:04 AM, Sebastian Herbszt wrote:
> Hello James,
> 
>> I'd like to announce the availability of the Broadcom (Emulex) FC target
>> driver - efct.
>>
>> This is the 2nd round of announcement.   In the first round, after
>> discussion with community members, it was decided that the driver would
>> consist of the following:
>>    - A SLI4-library that can be used by both an initiator driver and a
>> target driver
>>    - A FC Discovery library that could be used by both an initiator
>> driver and a target driver.
>>    - A SLI3-library that would be used by an initiator driver only
>>    - Delivery of a target driver that would support SCSI and NVME
>>    - Delivery of an initiator driver that would support SCSI and NVME
>> (NVME on SLI-4 only).
>>
>> As of this announcement the repository on gitlab
>> (git@gitlab.com:jsmart/efct-Emulex_FC_Target.git)
>> contains:
>>   - the SLI-4 library
>>   - the FC Discovery library
>>   - the efct target driver that supports SCSI (lio)
> 
> a lot has changed since v1:
> 
> 71 files changed, 39869 insertions(+), 25695 deletions(-)
> 
> Can you maybe provide the full git history which should have tracked all
> the file renaming?

unfortunately, no. It was done using internal tools which are not git 
based. All further development will be on the gitlab git tree.

We're putting together a change log from v1 to v2 that should help in 
the things you're asking.


> Beside the split it seems there are other changes. More leftovers of the
> FCoE support are gone, ddump support is no longer present and the initiator
> support is not settable. Any further changes I missed?

Yes - it's concentrating on FC support.
ddump - it was temporary removed due to some app interfaces. I believe 
it will be added back.
Yes - initiator support was removed as there will be a separate 
initiator driver.

> 
> I noticed this version does only build here on kernel 4.18. I pushed the
> required changes for kernel 4.19 to my repository [1].

Thanks, I've asked to have our guys pull them in from your repository.

> 
>> Effort is underway on adding nvme target support to the efct driver, and
>> after that, the initiator driver will be refactored.  The intent will be
>> to move all elements into the upstream tree although it is expected the
>> libraries and target components will be merged in a stage separate from
>> the initiator components.
> 
> What are the plans for the "lpfc" driver? Will it use "libefc" and "libefc_sli"
> or will a new (SLI4+) driver ("efci" ?) emerge?

We want to finish the nvme support in efct first.  the initiator driver 
will be a large amount of work. I may start some of the initiator bring 
up in parallel, but regardless, the initiator will be a longer task.

We can choose whether to leave it the same name or give it a new one. I 
expect we'll lean to keeping the same name.

It will use the libefc_sli library for the adapter interfaces and will 
also use libefc for the discovery items. However, the behaviors between 
initiator vs target are significantly different so I don't expect libefc 
to work well in the beginning, but we'll get it to a working state as we 
go through the integration.


> 
>> While those efforts are underway, we would like receive review comments
>> on the code that is present. Comments can be sent to:
>> ecd-efct.pdl@broadcom.com or myself
>>
>> -- james
> 
> [1] https://repo.or.cz/efct-Emulex_FC_Target/sherbszt.git/shortlog/refs/heads/v2-update
> 
> Sebastian
> 

thanks Sebastian

-- james


PS: Here's a quick change list

1) Driver split,
    efct --> LIO target driver.
    libefc --> Emulex FC discovery Library.
    libfc_sli --> Emulex FC SLI Library.

2) Support for  4.18 kernel

3) Removed Wrapper functions efct_thread, efct_sem, efct_timer,
efct_malloc .. etc..

4) G7/Prism adapter support.

5) Removed FCoE support, as we support only FC.

6) Removed dma pool allocations, used dma coherent to alloc dma buffers.

7) Removed SLI queue lock wrappers, register read and wrappers..etc..

8) Fixed styling issues as per linux kernel coding style.

9) Removed ddump files. Will add the new dump functionality as a
feature in the next release.

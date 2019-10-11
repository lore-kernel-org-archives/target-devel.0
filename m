From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Fri, 11 Oct 2019 10:12:22 +0000
Subject: Re: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <38ec5155-9dd1-480a-a542-141f652bc2eb@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
In-Reply-To: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org



On 10/11/19 08:09, Hannes Reinecke wrote:
> On 10/10/19 11:18 PM, Mike Christie wrote:
>> On 10/10/2019 03:14 PM, Bart Van Assche wrote:
>>> On 10/10/19 11:57 AM, Bodo Stroesser wrote:
>>>> Hmm. You are right. Ideally only SCSI-2 compliant initiators should
>>>> use the LUN field and they should run parallel SCSI only.
>>>>
>>>> OTOH, like Mike already said, we can't know whether there is any SW, FW,
>>>> BIOS, ... out there, that still sends such old style CDBs.
>>>>
>>>> For example: probably SW could send such CDBs by simply using SCSI
>>>> generic device on top of a modern initiator. (I hope that's true, I
>>>> didn't test ...)
>>>> That means, old code can produce old SCSI CDBs even when running
>>>> on top of modern HW.
>>>>
>>>> Do we want to take the risk of breaking such "old stuff"?
>>>
>>> Is blindly filtering out the LUN number correct? All initiator code that
>>
>> I have no idea about other details other than the code comments. I think
>> in general that code is wrong:
>>
>> 1. The original comment mentions iscsi and SAM2 but I think the SBC,
>> SPC, etc versions iscsi supported no longer supported commands that had
>> the LUN in those bits.
>>
>> 2. If we got one of these old commands and we clear the LUN, then we
>> have LUN=0 in that field, but the physical (not the lio level hba struct
>> but the drivers/scsi one) HBA/driver for the physical device might have
>> the physical device at LUN != 0, so I would think firmware might have
>> had issues with that.
>>
>> 3. It does not make sense to me why that list is so incomplete. I do not
>> understand why only those commands are in that list and not others.
>>
>>
> The iSCSI rfc is dated from 2004, whereas SPC-2 is dated 2001.
> And SPC-2 makes no reference to the embedded LUN.
> So one can safely assume there won't be any iSCSI devices embedding LUN
> numbers in CDBs.
> So by all intents and purposes we will only face this issue if we were
> using pscsi to talk to old SCSI-2 devices.
> 
> I'd say strip it in the general case, and delegate it to pscsi if there
> is a need.

If I understood correctly, we all would prefer to make TCMU completely
transparent regarding the CDB.

For pscsi I think we all agree, that the code is wrong or incomplete.
But for pscsi up to now no one complained. So I'm wondering whether we
should spend much effort for pscsi to discuss / find out the right
solution? Especially as the original comment in the code, as posted by
Mike, as well as the current comment are not very clear. Thus 'fixing'
pscsi would mean to change or remove something we don't understand
completely.

So I agree to Hannes: we should simply move that code from
passthrough_parse_cdb() to pscsi_parse_cdb(), at least as a first step.

Regards,
Bodo

> 
> Cheers,
> 
> Hannes
> 

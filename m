From: Mike Christie <mchristi@redhat.com>
Date: Thu, 10 Oct 2019 21:18:38 +0000
Subject: Re: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <5D9FA02E.3050909@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
In-Reply-To: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/10/2019 03:14 PM, Bart Van Assche wrote:
> On 10/10/19 11:57 AM, Bodo Stroesser wrote:
>> Hmm. You are right. Ideally only SCSI-2 compliant initiators should
>> use the LUN field and they should run parallel SCSI only.
>>
>> OTOH, like Mike already said, we can't know whether there is any SW, FW,
>> BIOS, ... out there, that still sends such old style CDBs.
>>
>> For example: probably SW could send such CDBs by simply using SCSI
>> generic device on top of a modern initiator. (I hope that's true, I
>> didn't test ...)
>> That means, old code can produce old SCSI CDBs even when running
>> on top of modern HW.
>>
>> Do we want to take the risk of breaking such "old stuff"?
> 
> Is blindly filtering out the LUN number correct? All initiator code that

I have no idea about other details other than the code comments. I think
in general that code is wrong:

1. The original comment mentions iscsi and SAM2 but I think the SBC,
SPC, etc versions iscsi supported no longer supported commands that had
the LUN in those bits.

2. If we got one of these old commands and we clear the LUN, then we
have LUN=0 in that field, but the physical (not the lio level hba struct
but the drivers/scsi one) HBA/driver for the physical device might have
the physical device at LUN != 0, so I would think firmware might have
had issues with that.

3. It does not make sense to me why that list is so incomplete. I do not
understand why only those commands are in that list and not others.


> I found and that touches the highest three bits of that byte sets the
> LUN number in that byte. From the SCSI error handler:
> 
> if (sdev->scsi_level <= SCSI_2 && sdev->scsi_level != SCSI_UNKNOWN)
>     scmd->cmnd[1] = (scmd->cmnd[1] & 0x1f)|(sdev->lun << 5 & 0xe0);
> 
> Bart.

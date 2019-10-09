From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Wed, 09 Oct 2019 12:06:13 +0000
Subject: Re: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <edf61b13-06e0-85ac-3d79-bb91e10cef96@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
In-Reply-To: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/09/19 09:00, Christoph Hellwig wrote:
> On Tue, Oct 08, 2019 at 08:20:12PM +0000, bodo.stroesser@ts.fujitsu.com wrote:
>> 1) Scan the SCSI specs and add all other missing command codes to the list of
>>     Codes to skip
>>
>> 2) Create a list of commands that definitely have the LUN field in byte 1 and
>>     reset the bits only in those. (Might be better than 1), because I expect new
>>     commands to not have the LUN field.)
>>
>> 3) Remove the code entirely, because it is no longer needed / useful (?)
>>
>> For 1) and 2) an additionally question is, based on what SCSI version the lists would
>> have to be created?
> 
> (4) limit the clearing of the LUN field to devices that claim
> a compliance to SCSI-2 or earlier, as those use the LUN field.
> 
I'm not sure that (4) would work.
The comment in the code says:

   /*
    * Clear a lun set in the cdb if the initiator talking to use spoke
    * and old standards version, as we can't assume the underlying device
    * won't choke up on it.
    */

If I understand correctly, the purpose of the code is just the opposite 
from what you suggest, as it should reset useless LUN bits coming from
old (SCSI-2) initiators, that otherwise could confuse SCSI-3 or higher 
targets.
SCSI-2 compliant targets should not run into trouble due to LUN bits 
being set, I think.

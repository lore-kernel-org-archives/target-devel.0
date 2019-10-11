From: Hannes Reinecke <hare@suse.de>
Date: Fri, 11 Oct 2019 06:09:37 +0000
Subject: Re: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <b5c4de4c-b93d-8579-e427-79cb565e3d08@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
In-Reply-To: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-3"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On 10/10/19 11:18 PM, Mike Christie wrote:
> On 10/10/2019 03:14 PM, Bart Van Assche wrote:
>> On 10/10/19 11:57 AM, Bodo Stroesser wrote:
>>> Hmm. You are right. Ideally only SCSI-2 compliant initiators should
>>> use the LUN field and they should run parallel SCSI only.
>>>
>>> OTOH, like Mike already said, we can't know whether there is any SW, FW,
>>> BIOS, ... out there, that still sends such old style CDBs.
>>>
>>> For example: probably SW could send such CDBs by simply using SCSI
>>> generic device on top of a modern initiator. (I hope that's true, I
>>> didn't test ...)
>>> That means, old code can produce old SCSI CDBs even when running
>>> on top of modern HW.
>>>
>>> Do we want to take the risk of breaking such "old stuff"?
>>
>> Is blindly filtering out the LUN number correct? All initiator code that
>=20
> I have no idea about other details other than the code comments. I think
> in general that code is wrong:
>=20
> 1. The original comment mentions iscsi and SAM2 but I think the SBC,
> SPC, etc versions iscsi supported no longer supported commands that had
> the LUN in those bits.
>=20
> 2. If we got one of these old commands and we clear the LUN, then we
> have LUN=3D0 in that field, but the physical (not the lio level hba struct
> but the drivers/scsi one) HBA/driver for the physical device might have
> the physical device at LUN !=3D 0, so I would think firmware might have
> had issues with that.
>=20
> 3. It does not make sense to me why that list is so incomplete. I do not
> understand why only those commands are in that list and not others.
>=20
>=20
The iSCSI rfc is dated from 2004, whereas SPC-2 is dated 2001.
And SPC-2 makes no reference to the embedded LUN.
So one can safely assume there won't be any iSCSI devices embedding LUN
numbers in CDBs.
So by all intents and purposes we will only face this issue if we were
using pscsi to talk to old SCSI-2 devices.

I'd say strip it in the general case, and delegate it to pscsi if there
is a need.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
HRB 247165 (AG M=FCnchen), GF: Felix Imend=F6rffer

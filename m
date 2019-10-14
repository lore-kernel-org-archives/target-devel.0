From: Hannes Reinecke <hare@suse.de>
Date: Mon, 14 Oct 2019 06:41:10 +0000
Subject: Re: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <52e9fbb8-0fd9-cb2c-08ad-e3419da60ac8@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
In-Reply-To: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-3"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On 10/11/19 7:13 PM, Bart Van Assche wrote:
> On 10/11/19 3:12 AM, Bodo Stroesser wrote:
>> If I understood correctly, we all would prefer to make TCMU completely
>> transparent regarding the CDB.
>>
>> For pscsi I think we all agree, that the code is wrong or incomplete.
>> But for pscsi up to now no one complained. So I'm wondering whether we
>> should spend much effort for pscsi to discuss / find out the right
>> solution? Especially as the original comment in the code, as posted by
>> Mike, as well as the current comment are not very clear. Thus 'fixing'
>> pscsi would mean to change or remove something we don't understand
>> completely.
>>
>> So I agree to Hannes: we should simply move that code from
>> passthrough_parse_cdb() to pscsi_parse_cdb(), at least as a first step.
>=20
> Hannes wrote "[ ... ] delegate it to pscsi if there is a need." Is there
> really a need for such code in the SCSI passthrough driver? The upstream
> SCSI target code is one of the four Linux SCSI target stacks that I know
> of. I haven't found any SCSI-2 LUN number filtering code in the tgt
> project (http://stgt.sourceforge.net/). I'm not sure about IET. SCST is
> around since 2006 and has SCSI-2 LUN number filtering code in its CDROM
> and MODISK passthrough drivers. That LUN number filtering code is there
> since the initial commit so it is not the result of a recent request of
> a user. SCST does not have LUN filtering code in its disk passthrough
> driver nor in its tape passthrough driver. In other words, I do not
> expect that anyone's setup will be broken by removing
> passthrough_parse_cdb() entirely.
>=20
I guess Bart is right.
We should just drop it and see if someone's complaining.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
HRB 247165 (AG M=FCnchen), GF: Felix Imend=F6rffer

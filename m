From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 10 Oct 2019 15:41:09 +0000
Subject: Re: Wrong resetting of Logical Unit Number field in CDB
Message-Id: <d286de86-beb8-e564-6308-9822c88337a0@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
In-Reply-To: <ac680e032540400a8cd7b1bf03361df3@R01UKEXCASM125.r01.fujitsu.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On 10/10/19 5:07 AM, Bodo Stroesser wrote:
> On 10/10/19 05:38, Mike Christie wrote:
>> On 10/08/2019 03:20 PM, bodo.stroesser@ts.fujitsu.com wrote:
>>> Hi,
>>>
>>> We use TCMUser to run userspace tape and changer emulations.
>>>
>>> Current tests with a new version of backup SW failed, due to that=20
>>> application
>>> using SECURITY PROTOCOL IN / OUT=A0 SCSI commands.
>>> The CDBs of these commands in byte 1 contain relevant information that
>>> is overwritten in passthrough_parse_cdb() / target_core_device.c
>>>
>>> This is the related part of the code:
>>>
>>> =A0=A0=A0=A0=A0=A0=A0=A0 /*
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 * Clear a lun set in the cdb if the initiat=
or talking to=20
>>> use spoke
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 * and old standards version, as we can't as=
sume the=20
>>> underlying device
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 * won't choke up on it.
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 */
>>> =A0=A0=A0=A0=A0=A0=A0=A0 switch (cdb[0]) {
>>> =A0=A0=A0=A0=A0=A0=A0=A0 case READ_10: /* SBC - RDProtect */
>>> =A0=A0=A0=A0=A0=A0=A0=A0 case READ_12: /* SBC - RDProtect */
>>> =A0=A0=A0=A0=A0=A0=A0=A0 case READ_16: /* SBC - RDProtect */
>>> =A0=A0=A0=A0=A0=A0=A0=A0 case SEND_DIAGNOSTIC: /* SPC - SELF-TEST Code =
*/
>>> =A0=A0=A0=A0=A0=A0=A0=A0 case VERIFY: /* SBC - VRProtect */
>>> =A0=A0=A0=A0=A0=A0=A0=A0 case VERIFY_16: /* SBC - VRProtect */
>>> =A0=A0=A0=A0=A0=A0=A0=A0 case WRITE_VERIFY: /* SBC - VRProtect */
>>> =A0=A0=A0=A0=A0=A0=A0=A0 case WRITE_VERIFY_12: /* SBC - VRProtect */
>>> =A0=A0=A0=A0=A0=A0=A0=A0 case MAINTENANCE_IN: /* SPC - Parameter Data F=
ormat for SA=20
>>> RTPG */
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
>>> =A0=A0=A0=A0=A0=A0=A0=A0 default:
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 cdb[1] &=3D 0x1f; /* c=
lear logical unit number */
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
>>> =A0=A0=A0=A0=A0=A0=A0=A0 }
>>>
>>> Obviously the list of command codes for which bits 5,6,7 of byte 1=20
>>> are _not_ reset
>>> is not complete. Now I'm wondering what would be the right fix:
>>>
>>> 1) Scan the SCSI specs and add all other missing command codes to the=20
>>> list of
>>> =A0=A0=A0 Codes to skip
>>>
>>> 2) Create a list of commands that definitely have the LUN field in=20
>>> byte 1 and
>>> =A0=A0=A0 reset the bits only in those. (Might be better than 1), becau=
se I=20
>>> expect new
>>> =A0=A0=A0 commands to not have the LUN field.)
>>>
>>> 3) Remove the code entirely, because it is no longer needed / useful (?)
>>>
>>
>> My preference would be to remove it like Bart suggested. Maybe we should
>> make it configurable via a device attribute or backend module flag.
>>
>> For the 2 users:
>>
>> pscsi - It seems this code was there from the beginning via
>> transport_generic_prepare_cdb in the original commit. Nick must have
>> found some initiator where the workaround was needed and I am not sure
>> if we would break them or not now. Based on the original code's comment
>> about iscsi my guess is there was some misc iscsi initiator probably in
>> a boot firmware or some offload card that supported old commands.
>>
>> tcmu - We want the raw cdb. I think masking out the above bits was an
>> accident. It looks like when Andy converted tcmu to use common code the
>> behavior got brought in for tcmu.
>>
> I think, regarding TCMU you both are right, we should skip the code.
> To avoid the need for an attribute, I'd prefer a new flag in the backend
> ops. So pscsi can stay unchanged for the moment.
>=20
> If you agree, I would prepare a patch.

SCSI-2 was introduced in 1994 and SCSI-3 was introduced in 1996=20
according to https://en.wikipedia.org/wiki/Parallel_SCSI. Is embedding=20
the LUN in byte one of the CDB something that is only relevant for=20
SCSI-2 parallel adapters? Since the SCSI target code supports receiving=20
SCSI commands over iSCSI, FC and SRP but not through a parallel port,=20
can the SCSI target code ever receive a CDB with a LUN number in byte=20
one of the CDB?

Thanks,

Bart.

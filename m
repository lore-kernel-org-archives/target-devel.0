From: Mike Christie <mchristi@redhat.com>
Date: Mon, 04 Jun 2018 17:13:22 +0000
Subject: Re: [RFC PATCH] target: add emulate_pr backstore attr to toggle PR support
Message-Id: <5B157332.8010701@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180601000532.11058-1-ddiss@suse.de>
In-Reply-To: <20180601000532.11058-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On 06/03/2018 07:57 AM, David Disseldorp wrote:
> On Fri, 1 Jun 2018 11:22:50 -0500, Mike Christie wrote:
>=20
>> On 05/31/2018 07:05 PM, David Disseldorp wrote:
>>> The new emulate_pr backstore attribute allows for Persistent Reservation
>>> and SCSI2 RESERVE/RELEASE support to be completely disabled. This can be
>>> useful for scenarios such as:
>>> - Enforcing ATS (Compare & Write) usage on recent VMware ESXi initiator=
s =20
>>
>> I was wondering why didn't you want your patch to be able to override
>> the passthrough case like for pscsi when TRANSPORT_FLAG_PASSTHROUGH_PGR
>> is set? It seems like for this ATS case you would want to do that for
>> all backends.
>=20
> Agreed, I'll fix the passthrough case in the next revision.
>=20
>> For the ATS case would you ever need to separate the SCSI 2
>> RESERVE/RELEASE case from the modern PR case (a emulate_scsi2_pr and
>> emulate_pr)? For example would you ever be using a device for ESX, want
>> to do ATS only, but have datastores on the same device that are exported
>> to VMs with apps that are going to use PRs so you would need
>> (emulate_scsi2_pr=FAlse, emulate_pr=3Dtrue)?
>=20
> I considered more granular toggles, but decided against it due to the
> added configuration/implementation complexity. Happy to revisit this if
> others would prefer it though.

I might not understand your original "enforce" part of the patch
description, because it seems like you must do this.

I think ATS only is the default for the newer versions of ESX when the
device reports it supports ATS, and it seems like running windows
clustering in VMs on ESX is common. So, you will have that combo of ATS
only with PRs a lot.

When you wrote "enforce" earlier I thought you meant the patch is
supposed to make sure that ATS only is really on and if ESX messes up
(or maybe the user messed up the settings) and it sends a
RESERVE/RELEASE then it is failed. I do not see how that is possible
with your patch with something like windows clustering VMs.

If the patch was more for protecting against the case where the backend
does not support reservations, and ATS only was used to make sure they
are never used due to that, and we assume backends always implement
older reservations if they implement newer PRs then I think the patch is
fine.

So I do not really care :) I think it depends on what you were trying to
support.


> Perhaps emulate_reservations would make more sense as a single toggle,
> given that RESERVE/RELEASE aren't "persistent", although the existing
> configfs paths seem to use "pr" for both types.
>=20
>>> - Allowing clustered (e.g. tcm-user) backends to block such requests,
>>>   avoiding the multi-node reservation state propagation.
>>>
>>> When explicitly disabled, PR and RESERVE/RELEASE requests receive
>>> Invalid Command Operation Code response sense data.
>>>
>>> Signed-off-by: David Disseldorp <ddiss@suse.de>
>>> ---
>>>  drivers/target/target_core_configfs.c | 21 ++++++++++++++++-----
>>>  drivers/target/target_core_device.c   |  1 +
>>>  drivers/target/target_core_pr.c       | 22 ++++++++++++++++++++++
>>>  include/target/target_core_base.h     |  3 +++
>>>  4 files changed, 42 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/tar=
get_core_configfs.c
>>> index 3f4bf126eed0..17b830e35a08 100644
>>> --- a/drivers/target/target_core_configfs.c
>>> +++ b/drivers/target/target_core_configfs.c
>>> @@ -530,6 +530,7 @@ DEF_CONFIGFS_ATTRIB_SHOW(emulate_tpu);
>>>  DEF_CONFIGFS_ATTRIB_SHOW(emulate_tpws);
>>>  DEF_CONFIGFS_ATTRIB_SHOW(emulate_caw);
>>>  DEF_CONFIGFS_ATTRIB_SHOW(emulate_3pc);
>>> +DEF_CONFIGFS_ATTRIB_SHOW(emulate_pr);
>>>  DEF_CONFIGFS_ATTRIB_SHOW(pi_prot_type);
>>>  DEF_CONFIGFS_ATTRIB_SHOW(hw_pi_prot_type);
>>>  DEF_CONFIGFS_ATTRIB_SHOW(pi_prot_format);
>>> @@ -590,6 +591,7 @@ static ssize_t _name##_store(struct config_item *it=
em, const char *page,	\
>>>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_fua_write);
>>>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_caw);
>>>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_3pc);
>>> +DEF_CONFIGFS_ATTRIB_STORE_BOOL(emulate_pr);
>>>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(enforce_pr_isids);
>>>  DEF_CONFIGFS_ATTRIB_STORE_BOOL(is_nonrot);
>>> =20
>>> @@ -1114,6 +1116,7 @@ CONFIGFS_ATTR(, emulate_tpu);
>>>  CONFIGFS_ATTR(, emulate_tpws);
>>>  CONFIGFS_ATTR(, emulate_caw);
>>>  CONFIGFS_ATTR(, emulate_3pc);
>>> +CONFIGFS_ATTR(, emulate_pr);
>>>  CONFIGFS_ATTR(, pi_prot_type);
>>>  CONFIGFS_ATTR_RO(, hw_pi_prot_type);
>>>  CONFIGFS_ATTR(, pi_prot_format);
>>> @@ -1154,6 +1157,7 @@ struct configfs_attribute *sbc_attrib_attrs[] =3D=
 {
>>>  	&attr_emulate_tpws,
>>>  	&attr_emulate_caw,
>>>  	&attr_emulate_3pc,
>>> +	&attr_emulate_pr,
>>>  	&attr_pi_prot_type,
>>>  	&attr_hw_pi_prot_type,
>>>  	&attr_pi_prot_format,
>>> @@ -1428,6 +1432,9 @@ static ssize_t target_pr_res_holder_show(struct c=
onfig_item *item, char *page)
>>>  	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>>>  		return sprintf(page, "Passthrough\n");
>>> =20
>>> +	if (!dev->dev_attrib.emulate_pr)
>>> +		return sprintf(page, "Reservations Disabled\n");
>>> +
>>>  	spin_lock(&dev->dev_reservation_lock);
>>>  	if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
>>>  		ret =3D target_core_dev_pr_show_spc2_res(dev, page);
>>> @@ -1567,10 +1574,12 @@ static ssize_t target_pr_res_type_show(struct c=
onfig_item *item, char *page)
>>> =20
>>>  	if (dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH_PGR)
>>>  		return sprintf(page, "SPC_PASSTHROUGH\n");
>>> -	else if (dev->dev_reservation_flags & DRF_SPC2_RESERVATIONS)
>>> +	if (!dev->dev_attrib.emulate_pr)
>>> +		return sprintf(page, "Reservations Disabled\n"); =20
>>
>> Do we want this formatted like the other strings here in caps with no
>> spaces between words incase parsers are expecting that format for this f=
ile?
>=20
> AFAICT, targetcli (via rtslib-fb) only makes use of the
> res_aptpl_metadata path. I'm not aware of any other consumers, so happy
> to go with whatever the community preference is here.
>=20

I just seems odd to have a file use 2 different formats for no reason
except there were 2 different people coding it.


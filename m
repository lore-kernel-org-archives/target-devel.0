From: Mike Christie <mchristi@redhat.com>
Date: Thu, 30 Apr 2020 17:29:12 +0000
Subject: Re: [RFC] tcmu: wrong input from userspace can confuse tcmu
Message-Id: <e4b8cc9c-ab81-516f-2c79-f9c7d873e54a@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200430151041.31053-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200430151041.31053-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On 4/30/20 11:40 AM, Bodo Stroesser wrote:
>=20
>=20
> On 04/30/20 17:59, Mike Christie wrote:
>> On 4/30/20 10:10 AM, Bodo Stroesser wrote:
>>> Hi,
>>>
>>> When tcmu queues a new command - no matter whether in command
>>> ring or in qfull_queue - a cmd_id from IDR udev->commands is
>>> assigned to the command.
>>>
>>> If userspaces sends a wrong command completion containing the
>>> cmd_id of a command on the qfull_queue, tcmu_handle_completions()
>>> finds the command in the IDR and calls tcmu_handle_completion()
>>> for it. This might do some nasty things, because commands in
>>> qfull_queue do not have a valid dbi list.
>>>
>>> Of course this is easy to fix. E.g.:
>>>
>>>
>>> --- a/drivers/target/target_core_user.c=A0=A0=A0 2020-04-30
>>> 14:15:36.177184668 +0200
>>> +++ b/drivers/target/target_core_user.c=A0=A0=A0 2020-04-30
>>> 14:29:43.331882066 +0200
>>> @@ -1242,13 +1242,14 @@ static unsigned int tcmu_handle_completi
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 WARN_ON(tcmu_hdr_get_op(entry->hdr.len_op) =
!=3D TCMU_OP_CMD);
>>> =A0 -=A0=A0=A0=A0=A0=A0=A0 cmd =3D idr_remove(&udev->commands, entry->h=
dr.cmd_id);
>>> -=A0=A0=A0=A0=A0=A0=A0 if (!cmd) {
>>> +=A0=A0=A0=A0=A0=A0=A0 cmd =3D idr_find(&udev->commands, entry->hdr.cmd=
_id);
>>> +=A0=A0=A0=A0=A0=A0=A0 if (!cmd || !test_bit(TCMU_CMD_BIT_INFLIGHT, &cm=
d->flags)) {
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 pr_err("cmd_id %u not found, ri=
ng is broken\n",
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 entry->hdr=
.cmd_id);
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 set_bit(TCMU_DEV_BIT_BROKEN, &u=
dev->flags);
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 break;
>>> =A0=A0=A0=A0=A0=A0=A0=A0=A0 }
>>> +=A0=A0=A0=A0=A0=A0=A0 idr_remove(&udev->commands, entry->hdr.cmd_id);
>>> =A0 =A0=A0=A0=A0=A0=A0=A0=A0=A0 tcmu_handle_completion(cmd, entry);
>>> =A0
>>> To avoid the second idr_*() call in main data path, it would also
>>> be possible to not replace the idr_remove() by idr_find(), but
>>> in case cmd was found without TCMU_CMD_BIT_INFLIGHT being set,
>>> during error handling re-add the cmd to the idr with the same id
>>> as before by calling idr_alloc(...,cmd_id, crmdd_id+1, ...).
>>>
>>>
>>> OTOH, I'm wondering whether the better solution would be to
>>> remove idr_alloc() from tcmu_setup_cmd_timer() and add it
>>> to queue_cmd_ring() immediately before or after it calls
>>> tcmu_setup_cmd_timer().
>>> Doing so would mean that commands in qfull_queue no longer have
>>> a cmd_id (which is not necessary AFAICS) and therefore the problem
>>
>> It's done for logging, but its only debug logging so we could just print
>> the pointer value.
>>
>=20
> Yes, and then add the pointer value to the pr_debug that prints the
> assigned cmd_id after idr_alloc()
>=20
>>> cannot happen, because tcmu_handle_completions() cannot find them
>>> in the IDR.
>>>
>>
>> This is probably best if it's not a lot of trouble.
>=20
> I already spent some time to check the necessary changes. I think
> there is no trouble, just some small changes.
> So, yes, the bigger fix is probably better.
>=20
> I'll wait till next week for further comments and then send a patch.
>=20
>>
>> If you go this route then in tcmu_reset_ring I think I made a mistake
>=20
> I'm not sure, but I don't think there is a mistake. If you cleanup
> the ring, you don't need to cancel the commands in qfull_queue.

I was thinking about your userspace restart PGR question in another
mail. Between the time userspace stopped and restarted the session->id
to I_T nexus mapping could have changed, so id now refers to a different
I_T nexus.

Code path wise, it would be easier if we restarted the inflight and
non-inflight commands the same way.


>=20
>> and we just continue the loop if TCMU_CMD_BIT_INFLIGHT is not set. I
>> think we want to do:
>>
>> for cmd in qfull_list
>> =A0=A0=A0=A0 target_complete_cmd()
> So I think, this is not really necessary, but after
> =A0=A0=A0 clear_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
>=20
> we could do
> =A0=A0=A0 run_qfull_queue(udev, false);
>=20
> right?
>=20
>>
>> for cmd in idr
>> =A0=A0=A0=A0=A0 target_complete_cmd()
>>
>=20

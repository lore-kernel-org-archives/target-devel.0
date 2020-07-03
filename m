From: Mike Christie <michael.christie@oracle.com>
Date: Fri, 03 Jul 2020 16:27:50 +0000
Subject: Re: [RFC PATCH 10/10] target: export sessions via configfs
Message-Id: <8e557b7a-aebc-7b3c-d02f-637cff0fd4b9@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
 <1593232509-13720-11-git-send-email-michael.christie@oracle.com>
 <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
In-Reply-To: <24118898-006c-0538-6685-b4902f9eee48@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, hare@suse.de, bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/3/20 7:51 AM, Bodo Stroesser wrote:
> On 2020-06-27 06:35, Mike Christie wrote:
>> This patch exports the LIO sessions via configfs. If userspace makes
>> a "sessions" dir on the ACL or TPG dir to indicate to the kernel it
>> supports the new interface on that TPG, then the kernel will make a
>> dir per session in the tpg/sessions or tpg/acls/alc/sessions dir
> 
> I someone creates a new ACL on a running tpg, can it happen that a
> session already is created before user can create the sessions folder?

Right now yes. In the patch I started to try to support a per tpg mix. If a session exists then you do mkdir sessions, then before you can delete the tpg you have to delete the sessions that were created after the mkdir.

But to handle all the side cases, it becomes a pain, and I don't think anyone will ever use that feature, so I plan to make it either on or off for all sessions on the tpg and no mixing. I think normally we see different tools at the per target or per fabric level, so we should be ok.


> 
>> It works similar to how some targets export their session info today
>> where if it's dynamic session then it goes in the tpg dir and if
>> there is an ACL then it goes in the acl's sessions dir. The name of
>> the dir is "session-$sid".
>>
>> qla2xxx example:
>>
>> For ACL based sessions:
>>
>> ├── 21:00:00:24:ff:46:b8:88
>> │   ├── fabric_statistics
>> │   └── tpgt_1
>> │       ├── acls
>> │       │   └── 21:00:00:24:ff:46:b8:8a
>> │       │       └── sessions
>> │       │           └── session-1
>>
>>
>> or for a dynamic session it would be in the tpg dir
>> .....
>>
>> │       ├── param
>> │       └── sessions
>> │           └── session-1
>>
>>
>>
>> There is currently nothing in the session-$sid dir. To make the RFC
>> easier to read I did not post the transport id patches or the iscsi
>> conversion one, but on the final send I'll include them.
>>
>> Note/Warning:
>>
>> The interface has 2 quirks:
>>
>> 1. It works similar to the loop/vhost/usb/xen nexus file interface
>> where instead of a rmdir to delete the session you write to some special
>> file. For this new interface we have:
>>
>> /fabric/target/tpgt/sessions/remove_session
>>
>> 2. Because the kernel is making the session, there is no mkdir/rmdir
>> support for each session like other objects like LUN, tpg, target, np,
>> etc. But, before we remove the parent tpg, we have to remove the
>> children sessions still. This gives configfs the behavior it expects
>> where parents can't be removed before children and we will not hit
>> issues like we hit before.
> 
> If I got it right, before user can remove a tpg from sysFS, he first
> has to remove all existing sessions by writing the SIDs to the new
> remove_sessions file.

Yes.

> 
> But how do you prevent initiator side from quickly creating a new
> session e.g. in case of FC? Can we end up in a loop of session removal
> and re-creation, especially in case of multiple session an the same tpg?

No. It works the same as today. When you do a tpg removal like when you do

targetlci clearconfig

rtslib disables the tpg which prevents the target from creating new sessions. We then bring down the objects under it like luns, portals, etc. When we get to sessions, if the target has not yet brought them down (some targets do this on tpg disablement and some do not), then with that github patch rtslib will kill them like it does for the other objects.

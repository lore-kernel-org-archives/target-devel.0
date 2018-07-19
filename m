From: Mike Christie <mchristi@redhat.com>
Date: Thu, 19 Jul 2018 03:47:56 +0000
Subject: Re: [PATCH 04/15] target/iscsi: move session_index to common se_session
Message-Id: <5B5009EC.1060008@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1531696591-8558-5-git-send-email-mchristi@redhat.com>
In-Reply-To: <1531696591-8558-5-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/18/2018 07:15 PM, Mike Christie wrote:
> On 07/18/2018 05:19 PM, Bart Van Assche wrote:
>> On Sun, 2018-07-15 at 18:16 -0500, Mike Christie wrote:
>>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>>> index 75ddbbb..97a1ee5 100644
>>> --- a/drivers/target/target_core_transport.c
>>> +++ b/drivers/target/target_core_transport.c
>>> @@ -55,6 +55,8 @@
>>>  
>>>  static struct workqueue_struct *target_completion_wq;
>>>  static struct kmem_cache *se_sess_cache;
>>> +static DEFINE_SPINLOCK(se_sess_idr_lock);
>>> +static DEFINE_IDR(se_sess_idr);
>>
>> Is it necessary that se_sess_idr_lock and se_sess_idr are global? Could these
>> two data structures be members of the data structure associated with
>> /sys/kernel/config/target/iscsi/$port/$tpg (struct se_portal_group?)?
> 
> For tcmu we have a problem where we pass the scsi commands to userspace
> but then we need to know what I_T nexus it was sent through or what
> target port it was received on.
> 
> I thought I could reuse the sid for tcmu commands where I could embed
> the sid in the tcmu_cmd and then userspace can look up the sid and know
> what session the command came in on. If the device is exported through 2
> tpgs then we need the sid target wide in case sessions on different tpgs
> have the same sid. And, then I thought if you exported the device
> through 2 fabrics then I thought you need it set globally.
> 
> I am still working on that part with Bodo, so I can make it per tpg when
> I resend then do another path to change it later.

Hey Bart, I looked into this some more and this value is also being used
as the scsiAttIntrPortIndex. For that use, does it need to be unique
across a target when the target has multiple ports?

So I think it needs to be on the se_wwn right?



From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 15 Jul 2020 18:44:05 +0000
Subject: Re: [PATCH 7/8] scsi: target: tcmu: Implement tmr_notify callback
Message-Id: <2a6a9b1d-e0cf-a68a-f060-53f000356118@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200710104817.19462-1-bstroesser@ts.fujitsu.com>
 <20200710104817.19462-8-bstroesser@ts.fujitsu.com>
 <24d9afb0-3ea9-e83b-acf0-b44f04583a6e@oracle.com>
 <b8bb9898-6ff8-2ffb-47d6-d96534c6d315@ts.fujitsu.com>
 <a32b8b9e-c993-6709-b71e-3fbf80d0bdf3@oracle.com>
 <53776e18-675a-3eea-4be8-703433a247dd@ts.fujitsu.com>
In-Reply-To: <53776e18-675a-3eea-4be8-703433a247dd@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 7/15/20 10:08 AM, Bodo Stroesser wrote:
> On 2020-07-14 20:10, Mike Christie wrote:
>> On 7/13/20 7:03 AM, Bodo Stroesser wrote:
>>> On 2020-07-12 03:15, Mike Christie wrote:
>>>> On 7/10/20 5:48 AM, Bodo Stroesser wrote:
>>>
> 
> ...
> 
>>>>> +struct tcmu_tmr_entry {
>>>>> +    struct tcmu_cmd_entry_hdr hdr;
>>>>> +
>>>>> +#define TCMU_TMR_UNKNOWN        0
>>>>> +#define TCMU_TMR_ABORT_TASK        1
>>>>> +#define TCMU_TMR_ABORT_TASK_SET        2
>>>>> +#define TCMU_TMR_CLEAR_ACA        3
>>>>> +#define TCMU_TMR_CLEAR_TASK_SET        4
>>>>> +#define TCMU_TMR_LUN_RESET        5
>>>>> +#define TCMU_TMR_TARGET_WARM_RESET    6
>>>>> +#define TCMU_TMR_TARGET_COLD_RESET    7
>>>>> +/* Pseudo reset due to received PR OUT */
>>>>> +#define TCMU_TMR_LUN_RESET_PRO        128
>>>>> +    __u8 tmr_type;
>>>>> +
>>>>> +    __u8 __pad1;
>>>>> +    __u16 __pad2;
>>>>> +    __u32 cmd_cnt;
>>>>> +    __u64 __pad3;
>>>>> +    __u64 __pad4;
>>>>> +    __u16 cmd_ids[0];
>>>>> +} __packed;
>>>>> +
>>>>
>>>> Is this new request and the tmr_notify callback just supposed to 
>>>> clean up the requested commands or is it supposed to perform the 
>>>> actions of the task management function defined in the specs?
>>>>
>>>> The callback name makes it feel like it's just a notification, but 
>>>> the names above make it seem like we are supposed to execute the TMF 
>>>> in userspace. But if the latter, then how do we notify the kernel if 
>>>> the TMF was successful or failed?
>>>
>>> My plan is to have a notification only. IMHO userspace (and also tcmu
>>> or another backend) must not interfere with core's TMR handling.
>>> The new callback tmr_notify just allows backend to be helpful during
>>> TMR handling by completing in core aborted, but in backend/userspace
>>> still running commands early.
>>>
>>> Do you refer to the TCMU_TMR_* definitions? I just defined these names
>>> because TMR_* definitions are in target_core_base.h which is not exposed
>>> to userspace programs. Knowing the type of TMR that aborted a command is
>>> useful at least for userspace tracin
>>
>> I see where you are going. Makes sense to me now.
>>
>>>
>>> BTW: I hope there are enough padding fields in the tcmu_tmr_entry to
>>> allow additional session info later?
>>
>> Yes.
>>
>> One question on that. Were you going to use the tcmu_cmd_entry_hdr 
>> flags, or add a flag field to tcmu_tmr_entry?
> 
> The header has a flag field, tcmu_cmd_entry has not. So I didn't
> give tcmu_tmr_entry a flags field.
> We already use the header's uflags for the flag that tells tcmu that
> user defined an explicit length for data transfer to initiator.
> So, if a new flag is necessary I'd prefer to use header's kflags.
> 
>>
>> Or will userspace just know its enabled because we would eventually 
>> add a add/delete session callback to the backend modules. And from the 
>> add callout, we would then notify userspace of the new session and 
>> that other commands like tcmu_tmr_entry have session info in it.
>>
> 
> It is still not completely clear to me how you want to send session info
> to userspace. I assume session id will be written into a renamed padding
> field in cmd and tmr. That would be compatible to old userspace tools.

Yes.

> Since session IDs start at 1, new userspace can easily see that there is
> a valid session ID.
> 
> If userspace finds a session id it not knows yet, it could retrieve
> session info from sysFS or configFS.
> 
> But even then at least if a session is removed I think we will need a
> new tcmu_XXXXX_entry type telling userspace which session ID now is
> invalid.

I was hoping to just add a TCMU_OP for session addition/deletion. For 
the addition case we can check for unknown session ids like you 
mentioned, but just in case someone needed it I thought an addition op 
would be helpful.

> Therefore I assume that a new attribute in configFS is needed to switch
> on the per default deactivated session ID notification. Otherwise
> existing userspace tools might print errors or even exit if they see an
> entry type they don't know.
> If userspace via configFS attribute can switch session info on and off,
> there probably is no need for flags, right?

Yeah.

From: Lee Duncan <lduncan@suse.com>
Date: Fri, 11 May 2018 01:29:11 +0000
Subject: Re: [PATCH v2] target: transport should allow st ILI reads
Message-Id: <e5da46a2-0c98-b386-451d-14d5221c21a4@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180509205921.12348-1-lduncan@suse.com>
In-Reply-To: <20180509205921.12348-1-lduncan@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/10/2018 12:19 PM, Mike Christie wrote:
> On 05/10/2018 01:51 PM, Mike Christie wrote:
>> On 05/09/2018 03:59 PM, Lee Duncan wrote:
>>> When a tape drive is exported via LIO using the
>>> pscsi module, a read that requests more bytes per block
>>> than the tape can supply returns an empty buffer. This
>>> is because the pscsi pass-through target module sees
>>> the "ILI" illegal length bit set and thinks there
>>> is no reason to return the data.
>>>
>>> This is a long-standing transport issue, since it
>>> assume that no data need be returned under a check
>>> condition, which isn't always the case for tape.
>>>
>>> Add in a check for tape reads with the the ILI, EOM,
>>> or FM bits set, with a sense code of NO_SENSE,
>>> treating such cases as if there is no sense data
>>> and the read succeeded. The layered tape driver then
>>> "does the right thing" when it gets such a response.
>>>
>>> Changes from RFC:
>>>  - Moved ugly code from transport to pscsi module
>>>  - Added checking EOM and FM bits, as well as ILI
>>>  - fixed malformed patch
>>>  - Clarified description a bit
>>>
>>> Signed-off-by: Lee Duncan <lduncan@suse.com>
>>> ---
>>>  drivers/target/target_core_pscsi.c     | 22 +++++++++++++++++++++-
>>>  drivers/target/target_core_transport.c |  6 ++++++
>>>  include/target/target_core_base.h      |  1 +
>>>  3 files changed, 28 insertions(+), 1 deletion(-)
>>>
>>> ...
>>
>>
>> Do you want to return both the data and sense or just one or the other?
>> Both right? In this code path we would return both the data and sense
>> for drivers like iscsi.

Yes, both the sense data and the IO data get returned with this patch.

>>
>> If the queue_data_in call a little below this line returns
>> -ENOMEM/-EAGAIN then I think the queue full handling is going to end up
>> only returning the sense like in your original bug. You would need a
>> similar change to transport_complete_qf so it returns the data.

Good point. I will update the patch.

>>
> 
> Oh yeah, one other question/comment. The above code is bypassing the
> normal sense sending code so SCF_SENT_CHECK_CONDITION is not going to be
> set. For iscsi could you end up where 2 paths complete the same command
> because a reassign could race with one of these completions?
> 

Good question.

I believe it will not be an issue. I believe that if the IO completes on
multiple paths it will be treated the same on each path, which means
that the SCF_SENT_CHECK_CONDITION will not be set on either path. Which
is how it is handled now for a normal IO.
-- 
Lee

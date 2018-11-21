From: Mike Christie <mchristi@redhat.com>
Date: Wed, 21 Nov 2018 16:37:35 +0000
Subject: Re: [PATCH v3] scsi: tcmu: avoid cmd/qfull timers updated whenever a new cmd comes
Message-Id: <5BF589CF.9000103@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181017075436.2323-1-xiubli@redhat.com>
In-Reply-To: <20181017075436.2323-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/20/2018 11:37 PM, Xiubo Li wrote:
> [...]
>>> -    is_running = list_empty(&cmd->cmdr_queue_entry);
>>> +    is_running = test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
>>>       se_cmd = cmd->se_cmd;
>>>         if (is_running) {
>>> @@ -1289,7 +1319,6 @@ static int tcmu_check_expired_cmd(int id, void
>>> *p, void *data)
>>>           scsi_status = SAM_STAT_CHECK_CONDITION;
>>>       } else {
>>>           list_del_init(&cmd->cmdr_queue_entry);
>> Move this list_del_init call to outside the if/else.
>>
>> You need do delete it from the cmdr_inflight_queue if that is how it
>> timed out, or if you later call tcmu_get_next_deadline it will still
>> show up and possibly be used to set the next time out which already
>> happened.
> 
> Firstly, this is in the timeout routine, if this cmd was already timed
> out and it must be time_after(jiffies, cmd->deadline), so it won't be
> used again.

It could be stuck a long time. What about jiffies rollover?

From: Xiubo Li <xiubli@redhat.com>
Date: Wed, 21 Nov 2018 05:37:02 +0000
Subject: Re: [PATCH v3] scsi: tcmu: avoid cmd/qfull timers updated whenever a new cmd comes
Message-Id: <997a5bba-e456-c150-02ec-bf816f608899@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181017075436.2323-1-xiubli@redhat.com>
In-Reply-To: <20181017075436.2323-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2018/11/21 11:19, Mike Christie wrote:
> On 10/17/2018 02:54 AM, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>

[...]

>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index 9cd404a..00ed7bb 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -148,7 +148,7 @@ struct tcmu_dev {
>>   	size_t ring_size;
>>   
>>   	struct mutex cmdr_lock;
>> -	struct list_head cmdr_queue;
>> +	struct list_head cmdr_qfull_queue;
> We can just rename to qfull_queue and inflight_queue and then rename the
> function names you modified below.

yeah, will fix it.


>>   
[...]
>>   	
>> +static unsigned long tcmu_get_next_deadline(struct list_head *queue)
>> +{
>> +	struct tcmu_cmd *tcmu_cmd, *tmp_cmd;
>> +
>> +	list_for_each_entry_safe(tcmu_cmd, tmp_cmd, queue, cmdr_queue_entry) {
>> +		if (!time_after(jiffies, tcmu_cmd->deadline))
>> +			return tcmu_cmd->deadline;
>> +	}
>> +
>> +	return 0;
> I think you can just pass the timer to this function, rename it to
> tcmu_set_next_deadline() and move the mod/del_timer calls in here too
> since it is always the same behavior.
Will fix it.
>
[...]
>> @@ -1230,6 +1249,9 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
>>   			break;
>>   		}
>>   
>> +		clear_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
>> +		list_del_init(&cmd->cmdr_queue_entry);
> Move these 2 lines to tcmu_handle_completion.
Will fix it.
[...]
>> -	is_running = list_empty(&cmd->cmdr_queue_entry);
>> +	is_running = test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags);
>>   	se_cmd = cmd->se_cmd;
>>   
>>   	if (is_running) {
>> @@ -1289,7 +1319,6 @@ static int tcmu_check_expired_cmd(int id, void *p, void *data)
>>   		scsi_status = SAM_STAT_CHECK_CONDITION;
>>   	} else {
>>   		list_del_init(&cmd->cmdr_queue_entry);
> Move this list_del_init call to outside the if/else.
>
> You need do delete it from the cmdr_inflight_queue if that is how it
> timed out, or if you later call tcmu_get_next_deadline it will still
> show up and possibly be used to set the next time out which already
> happened.

Firstly, this is in the timeout routine, if this cmd was already timed 
out and it must be time_after(jiffies, cmd->deadline), so it won't be 
used again.

Secondly, For the timed out cmds, it will be deleted in the 
tcmu_handle_completion() later as above mentioned.

And last is that currently maybe only the qfull queue timer is enabled. 
Then there is no need to delete it for the inflight queue.

>> -
>>   		idr_remove(&udev->commands, id);
>>   		tcmu_free_cmd(cmd);
>>   		scsi_status = SAM_STAT_TASK_SET_FULL;
>> @@ -1372,7 +1401,8 @@ static struct se_device *tcmu_alloc_device(struct se_hba *hba, const char *name)
[...]
>> @@ -1437,13 +1468,18 @@ static bool run_cmdr_queue(struct tcmu_dev *udev, bool fail)
>>   			 * cmd was requeued, so just put all cmds back in
>>   			 * the queue
>>   			 */
>> -			list_splice_tail(&cmds, &udev->cmdr_queue);
>> +			list_splice_tail(&cmds, &udev->cmdr_qfull_queue);
>>   			drained = false;
>>   			goto done;
> I think this needs to be a break to fix the bug where we fail to add to
> the ring after the initial command (if we fail on the initial command
> then the qfull timeout should be the same as before). If say the first
> command is put on the ring and we run out of space for the 2nd command
> then the second might have a deadline of 10000 but the first only had a
> deadline of 1.
>
Yeah, that's right, here maybe some cmds from the qfull queue have been 
added to the ring successfully, so we need to update the qfull timer for 
the reset ones.

Will fix it.

Thanks,
BRs
Xiubo

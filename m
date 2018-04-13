From: Xiubo Li <xiubli@redhat.com>
Date: Fri, 13 Apr 2018 03:08:18 +0000
Subject: Re: [PATCHv2] tcmu: allow userspace to reset netlink
Message-Id: <c17299fb-e942-be80-550a-f973df5ec9a3@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1522903193-13947-1-git-send-email-xiubli@redhat.com>
In-Reply-To: <1522903193-13947-1-git-send-email-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


>> +
>> +	if (val != 1) {
>> +		pr_err("Invalid block value %d\n", val);
> I think you wanted
>
> "Invalid reset value %d\n"
Yeah, just copied it from other place.
>
>> +		return -EINVAL;
>> +	}
>> +
>> +	spin_unlock(&udev->nl_cmd_lock);
> Need spin_lock() instead of unlock.
>
>
> I think before calling the code below you need to check if a nl command
> is even waiting. If you just run this with no nl commands waiting then
> next time we send a command nl_cmd->complete will be true and
> tcmu_wait_genl_cmd_reply's wait_event call will return right away.
Will fix this.

>
>> +	nl_cmd->complete = true;
>> +	nl_cmd->status = -EINTR;
>> +	wake_up(&udev->complete_wq);
> Instead of the code above, I think you need to take some of the guts out
> of tcmu_genl_cmd_done to handle removal which is an odd cases due to the
> refcoutning/locking and configfs use.
>
> For non removal commands we need to do a target_undepend_item. For
> remove, we don't want to since we came through configfs and teardown
> already started.
>
> So instead of the above lines take:
>
>          if (nl_cmd->cmd != completed_cmd) {
>                  printk(KERN_ERR "Mismatched commands (Expecting reply
> for %d. Current %d).\n",
>                         completed_cmd, nl_cmd->cmd);
>                  ret = -EINVAL;
>          } else {
>                  nl_cmd->status = rc;
>          }
>
> 	// Note: I changed this from the is_removed
>          if (completed_cmd != TCMU_CMD_REMOVED_DEVICE)
>                   target_undepend_item(&dev->dev_group.cg_item);
>          if (!ret) {
>                  nl_cmd->complete = true;
>                  wake_up(&udev->complete_wq);
>          }
>
Sorry, this part I couldn't totally understand.

Do you mean take the code above you pasted by introducing 
target_undepend_item() for none removal paths just like in 
tcmu_genl_cmd_done() does?
While in tcmu_genl_cmd_done(), the target_depend_item() is called by 
target_find_device() and then it should do target_undepend_item() after 
that, but in
reset_netlink_store(), should it need target_undepend_item() ? If so 
they won't be in pairs.

I think we should only take this part:

         if (nl_cmd->cmd != completed_cmd) {
                 printk(KERN_ERR "Mismatched commands (Expecting reply
for %d. Current %d).\n",
                        completed_cmd, nl_cmd->cmd);
                 ret = -EINVAL;
         } else {
                 nl_cmd->status = rc;
         }

from the tcmu_genl_cmd_done(), right ?

Thanks,
BRs


> from tcmu_genl_cmd_done and make a function that takes the status code
> and completed_cmd. You would just then do
>
> __tcmu_genl_cmd_done(&udev->curr_nl_cmd.cmd, -EINTR);
>
>
>
>
>> +	spin_unlock(&udev->nl_cmd_lock);
>> +
>> +	return count;
>> +}
>> +CONFIGFS_ATTR_WO(tcmu_, reset_netlink);
>> +
>>   static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
>>   				     size_t count)
>>   {
>> @@ -2363,6 +2400,7 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
>>   static struct configfs_attribute *tcmu_action_attrs[] = {
>>   	&tcmu_attr_block_dev,
>>   	&tcmu_attr_reset_ring,
>> +	&tcmu_attr_reset_netlink,
>>   	NULL,
>>   };
>>   
>>


From: Mike Christie <mchristi@redhat.com>
Date: Thu, 05 Apr 2018 03:23:25 +0000
Subject: Re: [PATCH] tcmu: allow userspace to reset netlink
Message-Id: <5AC596AD.8000402@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1522669360-13434-1-git-send-email-xiubli@redhat.com>
In-Reply-To: <1522669360-13434-1-git-send-email-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/04/2018 09:38 PM, Xiubo Li wrote:
> On 2018/4/5 8:47, Mike Christie wrote:
>> On 04/02/2018 06:42 AM, xiubli@redhat.com wrote:
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> This patch adds 1 tcmu attr to reset and complete all the blocked
>>> netlink waiting threads. It's used when the userspace daemon like
>>> tcmu-runner has crashed or forced to shutdown just before the
>>> netlink requests be replied to the kernel, then the netlink requeting
>>> threads will get stuck forever. We must reboot the machine to recover
>>> from it and by this the rebootng is not a must then.
>>>
>>> The netlink reset operation should be done before the userspace daemon
>>> could receive and handle the netlink requests to be safe.
>>>
>>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>>> ---
>>>   drivers/target/target_core_user.c | 99
>>> ++++++++++++++++++++++++++++++++++++---
>>>   1 file changed, 93 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/target/target_core_user.c
>>> b/drivers/target/target_core_user.c
>>> index 4ad89ea..dc8879d 100644
>>> --- a/drivers/target/target_core_user.c
>>> +++ b/drivers/target/target_core_user.c
>>> @@ -103,9 +103,13 @@ struct tcmu_hba {
>>>     #define TCMU_CONFIG_LEN 256
>>>   +static spinlock_t nl_complete_lock;
>>> +static struct idr complete_wait_udevs = IDR_INIT;
>>> +
>>>   struct tcmu_nl_cmd {
>>>       /* wake up thread waiting for reply */
>>> -    struct completion complete;
>>> +    bool complete;
>>> +
>>>       int cmd;
>>>       int status;
>>>   };
>>> @@ -159,12 +163,17 @@ struct tcmu_dev {
>>>         spinlock_t nl_cmd_lock;
>>>       struct tcmu_nl_cmd curr_nl_cmd;
>>> -    /* wake up threads waiting on curr_nl_cmd */
>>> +    /* wake up threads waiting on nl_cmd_wq */
>>>       wait_queue_head_t nl_cmd_wq;
>>>   +    /* complete thread waiting complete_wq */
>>> +    wait_queue_head_t complete_wq;
>>> +
>>>       char dev_config[TCMU_CONFIG_LEN];
>>>         int nl_reply_supported;
>>> +
>>> +    uint32_t dev_id;
>>>   };
>>>     #define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev,
>>> se_dev)
>>> @@ -251,6 +260,56 @@ static int tcmu_get_global_max_data_area(char
>>> *buffer,
>>>            "Max MBs allowed to be allocated to all the tcmu device's "
>>>            "data areas.");
>>>   +static void tcmu_complete_wake_up(struct tcmu_dev *udev)
>>> +{
>>> +    struct tcmu_nl_cmd *nl_cmd = &udev->curr_nl_cmd;
>>> +
>>> +    spin_lock(&nl_complete_lock);
>>> +    nl_cmd->complete = true;
>>> +    wake_up(&udev->complete_wq);
>>> +    spin_unlock(&nl_complete_lock);
>>> +}
>>> +
>>> +static void tcmu_complete_wake_up_all(void)
>>> +{
>>> +    struct tcmu_nl_cmd *nl_cmd;
>>> +    struct tcmu_dev *udev;
>>> +    int i;
>>> +
>>> +    spin_lock(&nl_complete_lock);
>>> +    idr_for_each_entry(&complete_wait_udevs, udev, i) {
>>> +        nl_cmd = &udev->curr_nl_cmd;
>>> +        nl_cmd->complete = true;
>>> +        wake_up(&udev->complete_wq);
>>> +    }
>>> +    spin_unlock(&nl_complete_lock);
>>> +}
>>> +
>>> +static int tcmu_complete_wait(struct tcmu_dev *udev)
>>> +{
>>> +    struct tcmu_nl_cmd *nl_cmd = &udev->curr_nl_cmd;
>>> +    uint32_t dev_id;
>>> +
>>> +    spin_lock(&nl_complete_lock);
>>> +    dev_id = idr_alloc(&complete_wait_udevs, udev, 1, USHRT_MAX,
>>> GFP_NOWAIT);
>>> +    if (dev_id < 0) {
>>> +        pr_err("tcmu: Could not allocate dev id.\n");
>>> +        return dev_id;
>>> +    }
>>> +    udev->dev_id = dev_id;
>> dev_id is never used.
> It will be used when the device is being removed.

Ah yeah, you are right. Bad comment on my part. I was thinking/writing
wrt if we used a list or helper around devices_idr.

> 
>> I think if you just wanted to loop over all the devices you could just
>> use a list.
>>
>> Or,
>>
>> Just add a helper around target_core_device.c:devices_idr that just
>> gives you the tcmu devices.
>>
>>
>>
>>> +    spin_unlock(&nl_complete_lock);
>>> +
>>> +    pr_debug("sleeping for nl reply\n");
>>> +    wait_event(udev->complete_wq, nl_cmd->complete);
>> I don't think you will need the complete field then or this function.
>>
>>
>>> +
>>> +    spin_lock(&nl_complete_lock);
>>> +    nl_cmd->complete = false;
>>> +    idr_remove(&complete_wait_udevs, dev_id);
>>> +    spin_unlock(&nl_complete_lock);
>>> +
>>> +    return 0;
>>> +}
>>> +
>>>   /* multicast group */
>>>   enum tcmu_multicast_groups {
>>>       TCMU_MCGRP_CONFIG,
>>> @@ -311,7 +370,7 @@ static int tcmu_genl_cmd_done(struct genl_info
>>> *info, int completed_cmd)
>>>       if (!is_removed)
>>>            target_undepend_item(&dev->dev_group.cg_item);
>>>       if (!ret)
>>> -        complete(&nl_cmd->complete);
>>> +        tcmu_complete_wake_up(udev);
>>>       return ret;
>>>   }
>>>   @@ -1258,6 +1317,7 @@ static struct se_device
>>> *tcmu_alloc_device(struct se_hba *hba, const char *name)
>>>       timer_setup(&udev->cmd_timer, tcmu_cmd_timedout, 0);
>>>         init_waitqueue_head(&udev->nl_cmd_wq);
>>> +    init_waitqueue_head(&udev->complete_wq);
>>>       spin_lock_init(&udev->nl_cmd_lock);
>>>         INIT_RADIX_TREE(&udev->data_blocks, GFP_KERNEL);
>>> @@ -1462,7 +1522,11 @@ static void tcmu_dev_call_rcu(struct rcu_head *p)
>>>         kfree(udev->uio_info.name);
>>>       kfree(udev->name);
>>> +
>>> +    spin_lock(&nl_complete_lock);
>>> +    idr_remove(&complete_wait_udevs, udev->dev_id);
>>>       kfree(udev);
>>> +    spin_unlock(&nl_complete_lock);
>>>   }
>>>     static int tcmu_check_and_free_pending_cmd(struct tcmu_cmd *cmd)
>>> @@ -1555,7 +1619,6 @@ static void tcmu_init_genl_cmd_reply(struct
>>> tcmu_dev *udev, int cmd)
>>>         memset(nl_cmd, 0, sizeof(*nl_cmd));
>>>       nl_cmd->cmd = cmd;
>>> -    init_completion(&nl_cmd->complete);
>>>         spin_unlock(&udev->nl_cmd_lock);
>>>   }
>>> @@ -1572,8 +1635,9 @@ static int tcmu_wait_genl_cmd_reply(struct
>>> tcmu_dev *udev)
>>>       if (udev->nl_reply_supported <= 0)
>>>           return 0;
>>>   -    pr_debug("sleeping for nl reply\n");
>>> -    wait_for_completion(&nl_cmd->complete);
>>> +    ret = tcmu_complete_wait(udev);
>>> +    if (ret)
>>> +        return ret;
>>>         spin_lock(&udev->nl_cmd_lock);
>>>       nl_cmd->cmd = TCMU_CMD_UNSPEC;
>>> @@ -2323,6 +2387,26 @@ static ssize_t tcmu_block_dev_store(struct
>>> config_item *item, const char *page,
>>>   }
>>>   CONFIGFS_ATTR(tcmu_, block_dev);
>>>   +static ssize_t tcmu_reset_netlink_store(struct config_item *item,
>>> const char *page,
>>> +                    size_t count)
>>> +{
>>> +    u8 val;
>>> +    int ret;
>>> +
>>> +    ret = kstrtou8(page, 0, &val);
>>> +    if (ret < 0)
>>> +        return ret;
>>> +
>>> +    if (val != 1) {
>>> +        pr_err("Invalid block value %d\n", val);
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    tcmu_complete_wake_up_all();
>>> +    return count;
>>> +}
>>> +CONFIGFS_ATTR_WO(tcmu_, reset_netlink);
>>
>> If it's on the device it should only reset the device its on, so if 2
>> daemons/apps are managing different devices it doesn't mess up the other.
>>
>> Or we could just assume that there is only 1 daemon type and just do a
>> global attr at the module level. Probably just the per device is best in
>> case we end up with people running gluster + qemu+tcmu and ceph +
>> tcmu-runner.
>>
>> If you do the per device then you can just take the insides of
>> tcmu_genl_cmd_done and make it into a helper so that you can do the
>> refcount/target_undepend_item properly and it would do the wake up. In
>> the reset configfs function then grab the nl_cmd_lock, and set the
>> curr_nl_cmd status to some or pass it into the helper, and then call
>> your helper which does the common stuff.
> I thought there should only 1 daemon will be exist in user space and at

I think the most common will be the 1 daemon type setup (it would be
rare to run qemu-tcmu and tcmu-runner at the same time) but we could
have multiple daemon instances of the same type due to containers in the
future.

> the same time to simplify it by resetting only one device will also
> reset all the others, or we need to reset all the devices one by one.
> 

I think we want it per device to match the other code like ring reset
and nl reply supported for example. We then get support for everything
very cheaply.


> If so, I will just do the per device resetting, then the patch will be
> very simple.
> 
>>
>>> +
>>>   static ssize_t tcmu_reset_ring_store(struct config_item *item,
>>> const char *page,
>>>                        size_t count)
>>>   {
>>> @@ -2363,6 +2447,7 @@ static ssize_t tcmu_reset_ring_store(struct
>>> config_item *item, const char *page,
>>>   static struct configfs_attribute *tcmu_action_attrs[] = {
>>>       &tcmu_attr_block_dev,
>>>       &tcmu_attr_reset_ring,
>>> +    &tcmu_attr_reset_netlink,
>>>       NULL,
>>>   };
>>>   @@ -2519,6 +2604,8 @@ static int __init tcmu_module_init(void)
>>>       }
>>>       tcmu_ops.tb_dev_attrib_attrs = tcmu_attrs;
>>>   +    spin_lock_init(&nl_complete_lock);
>>> +
>>>       ret = transport_backend_register(&tcmu_ops);
>>>       if (ret)
>>>           goto out_attrs;
>>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe
>> target-devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


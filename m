From: Xiubo Li <lixiubo@cmss.chinamobile.com>
Date: Thu, 14 Sep 2017 00:28:02 +0000
Subject: Re: [PATCHv3] tcmu: fix crash when removing the tcmu device
Message-Id: <1b95fff3-6379-cf0e-cfcd-d85b4201cc39@cmss.chinamobile.com>
List-Id: <target-devel.vger.kernel.org>
References: <59B98D72.8030401@redhat.com>
In-Reply-To: <59B98D72.8030401@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


>>>   static void tcmu_dev_kref_release(struct kref *kref)
>>>   {
>>>   	struct tcmu_dev *udev = container_of(kref, struct tcmu_dev, kref);
>>>   	struct se_device *dev = &udev->se_dev;
>>> +	struct tcmu_cmd *cmd;
>>> +	bool all_expired = true;
>>> +	int i;
>>> +
>>> +	vfree(udev->mb_addr);
Will fix the double free issue and set udev->mb_addr to NULL here.

Thanks,

BRs


>>> +
>>> +	/* Upper layer should drain all requests before calling this */
>>> +	spin_lock_irq(&udev->commands_lock);
>>> +	idr_for_each_entry(&udev->commands, cmd, i) {
>>> +		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
>>> +			all_expired = false;
>>> +	}
>>> +	idr_destroy(&udev->commands);
>>> +	spin_unlock_irq(&udev->commands_lock);
>>> +	WARN_ON(!all_expired);
>>> +
>>> +	tcmu_blocks_release(udev);
>>>   
>>>   	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
>>>   }
>>> @@ -1476,8 +1521,6 @@ -1586,20 +1600,6 @@ static void tcmu_destroy_device(struct se_device *dev)
>>>   	list_del(&udev->node);
>>>   	mutex_unlock(&root_udev_mutex);
>>>   
>>> -	vfree(udev->mb_addr);
>>> -
>>> -	/* Upper layer should drain all requests before calling this */
>>> -	spin_lock_irq(&udev->commands_lock);
>>> -	idr_for_each_entry(&udev->commands, cmd, i) {
>>> -		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
>>> -			all_expired = false;
>>> -	}
>>> -	idr_destroy(&udev->commands);
>>> -	spin_unlock_irq(&udev->commands_lock);
>>> -	WARN_ON(!all_expired);
>>> -
>>> -	tcmu_blocks_release(udev);
>>> -
>>>   	tcmu_netlink_event(udev, TCMU_CMD_REMOVED_DEVICE, 0, NULL);
>>>   
>>>   	uio_unregister_device(&udev->uio_info);
>>>
>>
>> Looks ok to me. Thanks
>>
>> Reviewed-by: Mike Christie <mchristi@redhat.com>
>>
> I take this back.
>
> tcmu_configure_device will do vfree(udev->mb_addr) in its error path so
> you could end up with a double free due to tcmu_dev_kref_release calling
> it again later.




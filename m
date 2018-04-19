From: Zhu Lingshan <lszhu@suse.de>
Date: Thu, 19 Apr 2018 09:47:02 +0000
Subject: Re: [PATCH 5/6] tcmu: refactor nl dev_size attr with new helpers
Message-Id: <c287b437-5da2-755d-7063-6edbf3973c93@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180416110428.5273-5-lszhu@suse.com>
In-Reply-To: <20180416110428.5273-5-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Thanks Mike, V2 is sent out :)


On 2018/4/19 8:15, Mike Christie wrote:
> On 04/16/2018 06:04 AM, Zhu Lingshan wrote:
>> use new netlink events helpers tcmu_netlink_init() and
>> tcmu_netlink_send() to refactor netlink event attribute
>> TCMU_ATTR_DEV_SIZE(belongs to TCMU_CMD_RECONFIG_DEVICE)
>> which is also dev_size in configFS.
>>
>> Signed-off-by: Zhu Lingshan <lszhu@suse.com>
>> ---
>>   drivers/target/target_core_user.c | 24 ++++++++++++++++++++++--
>>   1 file changed, 22 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index f98b986e6d50..d913fb15f1b4 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -2300,6 +2300,27 @@ static ssize_t tcmu_dev_size_show(struct config_item *item, char *page)
>>   	return snprintf(page, PAGE_SIZE, "%zu\n", udev->dev_size);
>>   }
>>   
>> +static int tcmu_send_dev_size_event(struct tcmu_dev *udev, u64 size)
>> +{
>> +	struct sk_buff *skb = NULL;
>> +	void *msg_header = NULL;
>> +	int ret = 0;
>> +
>> +	ret = tcmu_netlink_event_init(udev, TCMU_CMD_RECONFIG_DEVICE,
>> +				      &skb, &msg_header);
>> +	if (ret < 0)
>> +		return ret;
>> +	ret = nla_put_u64_64bit(skb, TCMU_ATTR_DEV_SIZE,
>> +				size, TCMU_ATTR_PAD);
>> +	if (ret < 0) {
>> +		nlmsg_free(skb);
>> +		return ret;
>> +	}
>> +	ret = tcmu_netlink_event_send(udev, TCMU_CMD_RECONFIG_DEVICE,
>> +		&skb, &msg_header);
> You need to tab/space this over to match the other style.
>


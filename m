From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Sun, 26 Jul 2020 11:47:18 +0000
Subject: Re: [PATCH v2 8/8] scsi: target: tcmu: Make TMR notification optional
Message-Id: <386df45e-bc4c-46a8-d671-9e9b24814af9@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200717161212.10731-1-bstroesser@ts.fujitsu.com>
 <20200717161212.10731-9-bstroesser@ts.fujitsu.com>
 <454b34ff-47c6-f54d-7b52-642b08f8cbd1@oracle.com>
In-Reply-To: <454b34ff-47c6-f54d-7b52-642b08f8cbd1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 2020-07-26 02:06, Mike Christie wrote:
> On 7/17/20 11:12 AM, Bodo Stroesser wrote:
>> Add "tmr_notification" configFS attribute to tcmu devices.
>> If default value 0 of the attribute is used, tcmu only
>> removes aborted commands from qfull_queue.
>> If user changes tmr_notification to 1, additionally
>> TMR notifications will be written to the cmd ring.
>>
>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>> ---
>>   drivers/target/target_core_user.c | 39 +++++++++++++++++++++++++++++++++++++++
>>   1 file changed, 39 insertions(+)
>>
>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>> index 92b7a2e84e64..95e66b707373 100644
>> --- a/drivers/target/target_core_user.c
>> +++ b/drivers/target/target_core_user.c
>> @@ -118,6 +118,7 @@ struct tcmu_dev {
>>   #define TCMU_DEV_BIT_OPEN 0
>>   #define TCMU_DEV_BIT_BROKEN 1
>>   #define TCMU_DEV_BIT_BLOCKED 2
>> +#define TCMU_DEV_BIT_TMR_NOTIFY 3
>>   	unsigned long flags;
>>   
>>   	struct uio_info uio_info;
>> @@ -1260,6 +1261,9 @@ tcmu_tmr_notify(struct se_device *se_dev, enum tcm_tmreq_table tmf,
>>   	if (unqueued)
>>   		tcmu_set_next_deadline(&dev->qfull_queue, &dev->qfull_timer);
>>   
>> +	if (!test_bit(TCMU_DEV_BIT_TMR_NOTIFY, &dev->flags))
>> +		goto unlock;
>> +
>>   	pr_debug("TMR event %d on dev %s, aborted cmds %d, afflicted cmd_ids %d\n",
>>   		 tcmu_tmr_type(tmf), dev->name, i, cmd_cnt);
>>   
>> @@ -2706,6 +2710,40 @@ static ssize_t tcmu_emulate_write_cache_store(struct config_item *item,
>>   }
>>   CONFIGFS_ATTR(tcmu_, emulate_write_cache);
>>   
>> +static ssize_t tcmu_tmr_notification_show(struct config_item *item,
>> +					       char *page)
> 
> Sorry about this. Just some nits.
> 
> The spacing above got messed up a little. I think you only need 2 spaces, but it looks like we got some extras.

I'll fix.

> 
> 
>> +{
>> +	struct se_dev_attrib *da = container_of(to_config_group(item),
>> +					struct se_dev_attrib, da_group);
>> +	struct tcmu_dev *dev = TCMU_DEV(da->da_dev);
> 
> 
> Could you use udev or tcmu_dev for the name. Sorry for being a broken record on this one. We use dev or se_dev for the se_device struct already and it throws me off when scanning the code.
> 
> I think patch 5 and 7 need the same fix up.
> 

I think I missunderstood your previous writing. I intentionally used dev and not udev because I thought you wanted it ...

No problem. I'll fix. 

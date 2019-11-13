From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 13 Nov 2019 19:27:31 +0000
Subject: Re: [PATCH v3 2/3] target/core: Fix a use-after-free in the TMF handling code
Message-Id: <45dd927b-9bbd-0358-7ee9-ef3e432f5503@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191113175239.147389-3-bvanassche@acm.org>
In-Reply-To: <20191113175239.147389-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/13/19 10:18 AM, Roman Bolshakov wrote:
> On Wed, Nov 13, 2019 at 09:52:38AM -0800, Bart Van Assche wrote:
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
>> index 09f833c1de8a..944777f4356f 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -3256,6 +3256,8 @@ static void target_tmr_work(struct work_struct *work)
>>   	struct se_tmr_req *tmr = cmd->se_tmr_req;
>>   	int ret;
>>   
>> +	config_item_get(&dev->dev_group.cg_item);
>> +
>>   	if (cmd->transport_state & CMD_T_ABORTED)
>>   		goto aborted;
>>   
>> @@ -3297,10 +3299,14 @@ static void target_tmr_work(struct work_struct *work)
>>   	cmd->se_tfo->queue_tm_rsp(cmd);
>>   
>>   	transport_cmd_check_stop_to_fabric(cmd);
>> +
>> +out:
>> +	config_item_put(&dev->dev_group.cg_item);
>>   	return;
>>   
>>   aborted:
>>   	target_handle_abort(cmd);
>> +	goto out;
>>   }
>>   
>>   int transport_generic_handle_tmr(
> 
> I might be well wrong but could it happen that refcount of se_device
> becomes zero before the work starts? Shouldn't we get the refcount
> increased before the work is scheduled in transport_generic_handle_tmr()?

Hi Roman,

Looking closer into this, I couldn't find an explanation why lun_ref 
does not prevent 'dev' to disappear. In the tests I ran without this 
patch the issue did not reappear. So the call trace mentioned in the 
patch description probably has the same root cause as patch 3/3. I will 
drop this patch.

Bart.

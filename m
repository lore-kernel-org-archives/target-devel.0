From: Lee Duncan <lduncan@suse.com>
Date: Tue, 22 May 2018 13:30:43 +0000
Subject: Re: [PATCH V2] TCMUser: add read length support
Message-Id: <58656e84-f3db-d845-a299-69e993fbd867@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <5afea28f.J3mbAcTR1O71tkwx%bstroesser@ts.fujitsu.com>
In-Reply-To: <5afea28f.J3mbAcTR1O71tkwx%bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/19/2018 03:22 AM, Bodo Stroesser wrote:
> On 05/18/2018 06:27 PM, Lee Duncan wrote:
>>
>> On 05/18/2018 02:53 AM, Bodo Stroesser wrote:
>  
>>> @@ -621,6 +622,7 @@ static void gather_data_area(struct tcmu
>>>  			}
>>>  			copy_bytes = min_t(size_t, sg_remaining,
>>>  					block_remaining);
>>> +			copy_bytes = min_t(size_t, copy_bytes, len_remaining);
>>
>> It may just be me, but I don't like this consecutive use of min_t() to
>> set copy_bytes. I'd prefer adding something like:
>>
>> 	if (len_remaining < copy_bytes)
>> 		copy_bytes = len_remaining;
>>
>> but maybe I'm old-fashioned.
> 
> I trusted in the compiler to remove the useless part of the code ...
> But you are right, I'll change it.
> 
> 
>>> @@ -947,6 +953,8 @@ static void tcmu_handle_completion(struc
>>>  {
>>>  	struct se_cmd *se_cmd = cmd->se_cmd;
>>>  	struct tcmu_dev *udev = cmd->tcmu_dev;
>>> +	bool read_len_valid = false;
>>> +	uint32_t read_len = 0xffffffff;
>>
>> Why do you set read_len? Is it to make the compiler happy? Because it
>> only gets used if read_len_valid is set, in which case it is also set,
>> right?
> 
> I changed gather_data_area() to copy data from uio buffer until either the
> sg list is exhausted or read_len is reached.
> gather_data_area() then writes back to read_len the length of the data that
> really was transferred.
> So, if a userspace program defines a too big read_len, it is truncated to
> what is defined in the sg list.
> Initializing read_len to a very high value avoids truncation in case the user
> did not set an explicit read_len.
> So gather_data_area() can be called with the pointer to read_len regardless
> of read_len_valid being true or false.
> 
> I also thought about initializing read_len to se_cmd->data_length instead of
> 0xffffffff.
> But honestly I wasn't sure whether this would be right in all cases. So I
> stayed with the limitation to the sg list defined length as used by
> gather_data_area().
> 
> If sg_cmd->data_length would be a correct limit for the transfer length also,
> the check for too long read_length could be done in tcmu_handle_completion().
> Then gather_data_area() would no longer need to write back read_len.
> Maybe that would be the clearer code. What do you think?

Yes, that sounds cleaner to me.

> 
>>> +		read_len_valid = (entry->hdr.uflags & TCMU_UFLAG_READ_LEN) &&
>>> +		                 entry->rsp.read_len;
>>> +		if (read_len_valid)
>>> +			read_len = entry->rsp.read_len;
>>
>> Again, perhaps it's just style, but this seems harder to read than:
>>
>> 		if (uflags & READ_LEN && read_len) {
>> 			read_len_valid = true;
>> 			read_len = entry...read_len;
>> 		}
> 
> Yes, your code looks clearer to me also. I'll change it.
> 
> 
>>> +	if (read_len_valid) {
>>> +		pr_debug("read_len = %d\n", read_len);
>>> +		target_complete_cmd_with_length(cmd->se_cmd,
>>> +					entry->rsp.scsi_status, read_len);
>>> +	}
>>> +	else
>>
>> This is just wrong. don't put the else on a separate line please.
> 
> Oh, yes, I'll change it. Maybe this time I was a bit old-fashioned.
> 
> 
> Thank you for the hints and corrections. I'll send an updated patch.
> 
> Bodo
> --


-- 
Lee Duncan
SUSE Labs

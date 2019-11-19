From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 19 Nov 2019 16:30:47 +0000
Subject: Re: [PATCH] target: Fix a pr_debug() argument
Message-Id: <adc67030-d7fd-ba31-3f7a-063650b43f10@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191107215525.64415-1-bvanassche@acm.org>
In-Reply-To: <20191107215525.64415-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/18/19 9:32 PM, Martin K. Petersen wrote:
> 
> Hi Bart!
> 
>> Print the string for which conversion failed instead of printing the
>> function name twice.
> 
> What do you mean wrt. printing the function name twice?
> 
>> Cc: Christoph Hellwig <hch@lst.de>
>> Fixes: 2650d71e244f ("target: move transport ID handling to the core")
>> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
>> ---
>>   drivers/target/target_core_fabric_lib.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
>> index 3c79411c4cd0..6b4b354c88aa 100644
>> --- a/drivers/target/target_core_fabric_lib.c
>> +++ b/drivers/target/target_core_fabric_lib.c
>> @@ -118,7 +118,7 @@ static int srp_get_pr_transport_id(
>>   	memset(buf + 8, 0, leading_zero_bytes);
>>   	rc = hex2bin(buf + 8 + leading_zero_bytes, p, count);
>>   	if (rc < 0) {
>> -		pr_debug("hex2bin failed for %s: %d\n", __func__, rc);
>> +		pr_debug("hex2bin failed for %s: %d\n", p, rc);
>>   		return rc;
>>   	}

Hi Martin,

With CONFIG_DYNAMIC_DEBUG=y, the output of pr_debug() statements is 
controlled by the settings in /sys/kernel/debug/dynamic_debug/control. 
 From Documentation/admin-guide/dynamic-debug-howto.rst:

  p    enables the pr_debug() callsite.
  f    Include the function name in the printed message
  l    Include line number in the printed message
  m    Include module name in the printed message
  t    Include thread ID in messages not generated from interrupt context
  _    No flags are set. (Or'd with others on input)

In other words, the dynamic debug infrastructure already supports 
printing the function name. I use the pmf flags when enabling pr_debug() 
statements. This is why I wrote that explicitly printing the function 
name causes the function name to be printed twice.

Please let me know if you need more information.

Bart.

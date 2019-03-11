From: Mike Christie <mchristi@redhat.com>
Date: Mon, 11 Mar 2019 16:15:53 +0000
Subject: Re: [PATCH] target:tcmu:add '\n' when return user space
Message-Id: <5C8689B9.3070803@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 03/11/2019 11:05 AM, Mike Christie wrote:
> On 03/10/2019 09:41 AM, David Disseldorp wrote:
>> Hi,
>>
>> On Sun, 10 Mar 2019 22:07:53 +0800, tangwenji wrote:
>>
>>> In function tcmu_get_global_max_data_area return string should include '\n'.
>>
>> Why? Please describe the motivation for your changes.
>>
>>> Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
>>> ---
>>>  drivers/target/target_core_user.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
>>> index 5831e0e..50229c1 100644
>>> --- a/drivers/target/target_core_user.c
>>> +++ b/drivers/target/target_core_user.c
>>> @@ -244,7 +244,7 @@ static int tcmu_set_global_max_data_area(const char *str,
>>>  static int tcmu_get_global_max_data_area(char *buffer,
>>>  					 const struct kernel_param *kp)
>>>  {
>>> -	return sprintf(buffer, "%d", TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
>>> +	return sprintf(buffer, "%d\n", TCMU_BLOCKS_TO_MBS(tcmu_global_max_blocks));
>>
>> Although minor, this is still a modification to a released API so
>> probably can't be done without potentially breaking user-space.
>>
> 
> I think the lack of newline is breaking some tools, because they were
> looking for newlines due to the other files having it.
> 

I guess that does not make sense. It will be easier to update userspace
and we would have to carry the userspcae patch for older kernels, so the
patch is not needed.

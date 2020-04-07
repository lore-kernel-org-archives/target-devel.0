From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 07 Apr 2020 14:59:54 +0000
Subject: Re: [PATCH] target: pr: fix PR IN, READ FULL STATUS
Message-Id: <99574976-b040-11a1-c1f1-3a7958adb51a@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200406182951.17446-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200406182951.17446-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi Mike,

On 04/06/20 23:05, Mike Christie wrote:
> On 04/06/2020 01:29 PM, Bodo Stroesser wrote:
>> AFAICS there are some problems in target_core_fabric_lib.c
>> that afflict PERSISTENT RESERVE IN / READ FULL STATUS command.
>>
>> 1) Creation of the response to READ FULL STATUS fails for FC
>>     based reservations. Reason is the too high loop limit (< 24)
>>     in fc_get_pr_transport_id(). The string representation of FC
>>     WWPN is 23 chars long only ("11:22:33:44:55:66:77:88"). So
>>     when i is 23, the loop body is executed a last time for the
>>     ending '\0' of the string and thus hex2bin() reports an error.
>>
>> 2) For iSCSI based reservations that include an ISID, the
>>     reported TRANSPORT ID is wrong. This has two reasons:
>>     a) The code inserts an NULL byte between the ISCSI Name and
>>        the SEPARATOR
>>     b) Only the first 6 chars of the ISID are appended. AFAIK,
>>        binary ISID is 48 bits, so 12 chars might be necessary.
>>
>> The last hunk in this patch fixes a minor flaw that could be
>> triggered by a PR OUT RESERVE on iSCSI, if TRANSPORT IDs with
>> and without ISID are used in the same command. I don't know, if
>> that ever could happen, but with the change the code is cleaner,
>> I think.
>>
>> This patch is based on code review only. It compiles fine, but
>> unfortunately I wasn't able to test.
> 
> Your patch for #2 is still not going to work for iscsi, because there's
> lots of issue in that code. Offlist I sent you my patch for #2 and a
> hand full of other fixes in that code path.

Thank you.

> 
> Let's sync them up, so we can test it all together.

Ok.

> 
> - We should break out the first chunk for your issue #1, and the last
> chunk that sets port_nexus_ptr to NULL into separate patches.

I did, will be sent soon. Meanwhile I was able to test chunk 1, works fine.

> 
> I tested the NULL ptr chunk with my patches and it works fine.

Thank you.

> 
> - If you are ok with my patch for #2, I will post my patch for that and
> the other ones to the list. As you saw I have other fixes in the same
> lines of code and I fixed up the comments, so it would just be easier
> code conflict wise.

One question:
why did you remove writing of the format code in byte 0 of buf?
Isn't that necessary?

Regarding the separator: instead of writing 5 single ASCII bytes as hex
values, wouldn't it be better to do:
	memcpy(&buf[off], ",i,0x", 5);
In the beginning I thought, that using the hex values makes the code
independent from the host code. But there are many other places in the 
code, where silently is assumed, that host code is ASCII.

I'm not sure, whether it is a good idea to assume a fixed size of 12 hex
digits for the ISID string. I know, ISID is 48 bits, but if there are
leading 0s, is there anything in the spec, that disallows to shorten the
string?
Therefore in my patch I used snprintf() to get the right length of the
saved string.

> 
> There is actually another isid fix needed for the core pr code:
> 
> https://patchwork.kernel.org/patch/10525287/
> 
> Handling Bart's review comment for that patch ended up being crazy
> because of other issues in the PR code so I have not completed that fix.

I'm not very familiar with iSCSI, so I don't know where the code should
be, but I think we should not remove the ISID binary value (u64).
In case of shortened ISID strings or in case of lower and upper case a-f
usage, string compare might fail for basically the same ISID values.

Therefore in your patch I don't like the hex2bin usage.
Would it be better to use sscanf() with a check for trailing chars, e.g:
	ret = sscanf(isid, "%llx%c", &pr_reg->pr_reg_bin_isid,
                      &dummychar);
and then check for ret = 1 and
  pr_reg->pr_reg_bin_isid <= 0xffffffffffffllu ?

> 
> 
>>
>> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
>> ---
>>   drivers/target/target_core_fabric_lib.c | 33 ++++++++++++++-------------------
>>   1 file changed, 14 insertions(+), 19 deletions(-)
>>
>> diff --git a/drivers/target/target_core_fabric_lib.c b/drivers/target/target_core_fabric_lib.c
>> index 6b4b354c88aa..8a726076ae56 100644
>> --- a/drivers/target/target_core_fabric_lib.c
>> +++ b/drivers/target/target_core_fabric_lib.c
>> @@ -63,7 +63,7 @@ static int fc_get_pr_transport_id(
>>   	 * encoded TransportID.
>>   	 */
>>   	ptr = &se_nacl->initiatorname[0];
>> -	for (i = 0; i < 24; ) {
>> +	for (i = 0; i < 23; ) {
>>   		if (!strncmp(&ptr[i], ":", 1)) {
>>   			i++;
>>   			continue;
>> @@ -148,10 +148,6 @@ static int iscsi_get_pr_transport_id(
>>   	 */
>>   	len = sprintf(&buf[off], "%s", se_nacl->initiatorname);
>>   	/*
>> -	 * Add Extra byte for NULL terminator
>> -	 */
>> -	len++;
>> -	/*
>>   	 * If there is ISID present with the registration and *format code = 1
>>   	 * 1, use iSCSI Initiator port TransportID format.
>>   	 *
>> @@ -185,17 +181,15 @@ static int iscsi_get_pr_transport_id(
>>   		buf[off+len] = 0x30; off++; /* ASCII Character: "0" */
>>   		buf[off+len] = 0x78; off++; /* ASCII Character: "x" */
>>   		len += 5;
>> -		buf[off+len] = pr_reg->pr_reg_isid[0]; off++;
>> -		buf[off+len] = pr_reg->pr_reg_isid[1]; off++;
>> -		buf[off+len] = pr_reg->pr_reg_isid[2]; off++;
>> -		buf[off+len] = pr_reg->pr_reg_isid[3]; off++;
>> -		buf[off+len] = pr_reg->pr_reg_isid[4]; off++;
>> -		buf[off+len] = pr_reg->pr_reg_isid[5]; off++;
>> -		buf[off+len] = '\0'; off++;
>> -		len += 7;
>> +		len += snprintf(&buf[off+len], PR_REG_ISID_LEN, "%s",
>> +		                pr_reg->pr_reg_isid);
>>   	}
>>   	spin_unlock_irq(&se_nacl->nacl_sess_lock);
>>   	/*
>> +	 * Add Extra byte for NULL terminator
>> +	 */
>> +	len++;
>> +	/*
>>   	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
>>   	 * in the TransportID. The additional length shall be at least 20 and
>>   	 * shall be a multiple of four.
>> @@ -224,10 +218,6 @@ static int iscsi_get_pr_transport_id_len(
>>   	spin_lock_irq(&se_nacl->nacl_sess_lock);
>>   	len = strlen(se_nacl->initiatorname);
>>   	/*
>> -	 * Add extra byte for NULL terminator
>> -	 */
>> -	len++;
>> -	/*
>>   	 * If there is ISID present with the registration, use format code:
>>   	 * 01b: iSCSI Initiator port TransportID format
>>   	 *
>> @@ -236,12 +226,16 @@ static int iscsi_get_pr_transport_id_len(
>>   	 */
>>   	if (pr_reg->isid_present_at_reg) {
>>   		len += 5; /* For ",i,0x" ASCII separator */
>> -		len += 7; /* For iSCSI Initiator Session ID + Null terminator */
>> +		len += strlen(pr_reg->pr_reg_isid); /* Initiator Session ID */
>>   		*format_code = 1;
>>   	} else
>>   		*format_code = 0;
>>   	spin_unlock_irq(&se_nacl->nacl_sess_lock);
>>   	/*
>> +	 * Add extra byte for NULL terminator
>> +	 */
>> +	len++;
>> +	/*
>>   	 * The ADDITIONAL LENGTH field specifies the number of bytes that follow
>>   	 * in the TransportID. The additional length shall be at least 20 and
>>   	 * shall be a multiple of four.
>> @@ -341,7 +335,8 @@ static char *iscsi_parse_pr_out_transport_id(
>>   			*p = tolower(*p);
>>   			p++;
>>   		}
>> -	}
>> +	} else
>> +		*port_nexus_ptr = NULL;
>>   
>>   	return &buf[4];
>>   }
>>
> 

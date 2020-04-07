From: Mike Christie <mchristi@redhat.com>
Date: Tue, 07 Apr 2020 19:21:02 +0000
Subject: Re: [PATCH] target: pr: fix PR IN, READ FULL STATUS
Message-Id: <5E8CD29E.2050907@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200406182951.17446-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200406182951.17446-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/07/2020 12:58 PM, Mike Christie wrote:
> On 04/07/2020 09:59 AM, Bodo Stroesser wrote:
>> Hi Mike,
>>
>> On 04/06/20 23:05, Mike Christie wrote:
>>> On 04/06/2020 01:29 PM, Bodo Stroesser wrote:
>>>> AFAICS there are some problems in target_core_fabric_lib.c
>>>> that afflict PERSISTENT RESERVE IN / READ FULL STATUS command.
>>>>
>>>> 1) Creation of the response to READ FULL STATUS fails for FC
>>>>     based reservations. Reason is the too high loop limit (< 24)
>>>>     in fc_get_pr_transport_id(). The string representation of FC
>>>>     WWPN is 23 chars long only ("11:22:33:44:55:66:77:88"). So
>>>>     when i is 23, the loop body is executed a last time for the
>>>>     ending '\0' of the string and thus hex2bin() reports an error.
>>>>
>>>> 2) For iSCSI based reservations that include an ISID, the
>>>>     reported TRANSPORT ID is wrong. This has two reasons:
>>>>     a) The code inserts an NULL byte between the ISCSI Name and
>>>>        the SEPARATOR
>>>>     b) Only the first 6 chars of the ISID are appended. AFAIK,
>>>>        binary ISID is 48 bits, so 12 chars might be necessary.
>>>>
>>>> The last hunk in this patch fixes a minor flaw that could be
>>>> triggered by a PR OUT RESERVE on iSCSI, if TRANSPORT IDs with
>>>> and without ISID are used in the same command. I don't know, if
>>>> that ever could happen, but with the change the code is cleaner,
>>>> I think.
>>>>
>>>> This patch is based on code review only. It compiles fine, but
>>>> unfortunately I wasn't able to test.
>>>
>>> Your patch for #2 is still not going to work for iscsi, because there's
>>> lots of issue in that code. Offlist I sent you my patch for #2 and a
>>> hand full of other fixes in that code path.
>>
>> Thank you.
>>
>>>
>>> Let's sync them up, so we can test it all together.
>>
>> Ok.
>>
>>>
>>> - We should break out the first chunk for your issue #1, and the last
>>> chunk that sets port_nexus_ptr to NULL into separate patches.
>>
>> I did, will be sent soon. Meanwhile I was able to test chunk 1, works fine.
>>
>>>
>>> I tested the NULL ptr chunk with my patches and it works fine.
>>
>> Thank you.
>>
>>>
>>> - If you are ok with my patch for #2, I will post my patch for that and
>>> the other ones to the list. As you saw I have other fixes in the same
>>> lines of code and I fixed up the comments, so it would just be easier
>>> code conflict wise.
>>
>> One question:
>> why did you remove writing of the format code in byte 0 of buf?
>> Isn't that necessary?
> 
> That is a bug. I forgot to send a patch where it had
> core_scsi3_pri_read_full_status set it with the other common transport
> id value the proto id.
> 
> I will fix it when I send.
> 
> 
>>
>> Regarding the separator: instead of writing 5 single ASCII bytes as hex
>> values, wouldn't it be better to do:
>>     memcpy(&buf[off], ",i,0x", 5);
> 
> I think they just did it the way we have it, because they saw how it was
> worded in SPC and were trying to follow it exactly like how they saw it
> in there.
> 
> I think we can do that cleanup in a separate non-bug patch.
> 
>> In the beginning I thought, that using the hex values makes the code
>> independent from the host code. But there are many other places in the
>> code, where silently is assumed, that host code is ASCII.
>>
>> I'm not sure, whether it is a good idea to assume a fixed size of 12 hex
>> digits for the ISID string. I know, ISID is 48 bits, but if there are
>> leading 0s, is there anything in the spec, that disallows to shorten the
>> string?
> 
> There is nothing about drop leading 0s, but it does say to go by the
> null char and ignore the ADDITIONAL LENGTH field, so I think we could.
> However, I would be worried about initiators actually supporting it
> because it's not explicitly mentioned in the spec and so it seems like
> something we would mess up on the initiator side. On the target side we
> do not even handle when the isid is not 12 bytes (it looks like
> iscsi_parse_pr_out_transport_id is broken).
> 
> I would just do the safest and easiest approach like we have been. Just
> give it the full isid, because initiators have to always handle it. It's
> not like this a fast path, and dropping a couple bytes is going to help
> perf. On the other hand, you risk adding a regression.
> 
> But I think we should fix up the short isid handling on the target side
> in places like iscsi_parse_pr_out_transport_id, so we do not crash or
> read in bogus data.

Hey Bodo,

For this when I fix iscsi_parse_pr_out_transport_id I will make it so we
support whatever the initiator has sent us, so it should handle what you
requested.

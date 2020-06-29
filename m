From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 29 Jun 2020 08:53:10 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Fix crash on ARM during cmd completion
Message-Id: <655e34b7-c6eb-728c-1352-cd87f51d80fb@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
 <93e7f9ef-566e-6949-b2c7-2e822ee49f39@acm.org>
 <15C73AF2-672A-4686-A418-0C41993E8060@oracle.com>
In-Reply-To: <15C73AF2-672A-4686-A418-0C41993E8060@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michael Christie <michael.christie@oracle.com>, Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>, Henry Willard <henry.willard@oracle.com>



On 2020-06-28 21:35, Michael Christie wrote:
> 
> 
>> On Jun 27, 2020, at 9:31 PM, Bart Van Assche <bvanassche@acm.org> wrote:
>>
>> On 2020-06-24 01:53, Bodo Stroesser wrote:
>>> The fix is to use the maximum of remaining ring space and
>>> sizeof(struct tcmu_cmd_entry) as the length param.
>>>
>>
>> [ ... ]
>>
>>> +		/*
>>> +		 * Flush max. up to end of cmd ring, since current entry might
>>> +		 * be a padding that is shorter than sizeof(*entry)
>>> +		 */
>>> +		size_t ring_left = head_to_end(udev->cmdr_last_cleaned,
>>> +					       udev->cmdr_size);
>>> +		tcmu_flush_dcache_range(entry, ring_left < sizeof(*entry) ?
>>> +					ring_left : sizeof(*entry));
>>>
>>> 		if (tcmu_hdr_get_op(entry->hdr.len_op) = TCMU_OP_PAD) {
>>> 			UPDATE_HEAD(udev->cmdr_last_cleaned,
>>
>> The patch description says "maximum" but the above formula calculates the
>> minimum of "ring_left" and sizeof(*entry). Did I perhaps misread this patch?
> 
> Ah yeah, Bodo probably meant to write what they wrote for the comment above about the max up to the end of the ring and not max of space left and entry size.
> 

Thank you, you both are right.

While the code and the comment in the code are fine, patch description
is misleading or even wrong.

So I'm going to re-send the patch with fixed description and Mike's
Acked-by.

BR, Bodo

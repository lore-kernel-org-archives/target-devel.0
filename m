From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 17 Jan 2020 16:35:04 +0000
Subject: Re: Recent trace observed in target code during iSer testing
Message-Id: <a686b847-846e-1495-a7ff-d6184631e296@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <MWHPR1101MB2271A83D246FAE4710E47BB2863C0@MWHPR1101MB2271.namprd11.prod.outlook.com>
 <3b724797-275a-9a14-1503-1778780a5872@acm.org>
 <MWHPR1101MB227100196B12AF2494BB184F863E0@MWHPR1101MB2271.namprd11.prod.outlook.com>
 <MWHPR1101MB227156761E41FA7C47DAE5A486310@MWHPR1101MB2271.namprd11.prod.outlook.com>
In-Reply-To: <MWHPR1101MB227156761E41FA7C47DAE5A486310@MWHPR1101MB2271.namprd11.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "'linux-rdma@vger.kernel.org'" <linux-rdma@vger.kernel.org>

On 1/17/20 7:55 AM, Marciniszyn, Mike wrote:
>> Subject: RE: Recent trace observed in target code during iSer testing
>>
>>>
>>> A candidate fix has been posted but needs review and/or a Tested-by. See
>>> also https://www.spinics.net/lists/target-devel/msg17981.html.
>>>
>>> Thanks,
>>>
>>> Bart.
>>
>> I'm testing this now.
>>
> 
> I have tested this change an it certainly eliminates the percpu message.
> 
> Have you submitted a patch?  I actually extracted the patch from the email thread.
> 
> When you do feel free to add:
> Tested-by: Mike Marciniszyn <mike.marciniszyn@intel.com>

Thanks Mike for having tested this patch. The patch itself has been 
cross-posted to the target-devel and linux-rdma mailing lists. See also 
https://lore.kernel.org/linux-rdma/20200116044737.19507-1-bvanassche@acm.org/

Bart.

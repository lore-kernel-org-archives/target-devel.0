From: Randy Dunlap <rdunlap@infradead.org>
Date: Mon, 06 Aug 2018 23:36:02 +0000
Subject: Re: [PATCH v2] target: fix tcm_loop build errors when SCSI=m
Message-Id: <5780f4ac-4b4e-2851-2c57-fb40b55264c5@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <24dc30ca-b558-fb6c-d478-967dbfa887c4@infradead.org>
In-Reply-To: <24dc30ca-b558-fb6c-d478-967dbfa887c4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/06/2018 04:29 PM, Randy Dunlap wrote:
> On 08/06/2018 04:26 PM, Bart Van Assche wrote:
>> On Mon, 2018-08-06 at 16:20 -0700, Randy Dunlap wrote:
>>> Fixes: 3703b2c5d041 ("[SCSI] tcm_loop: Add multi-fabric Linux/SCSI LLD
>>>        fabric module")
>>
>> From drivers/target/Kconfig on Linus' master branch:
>>
>> menuconfig TARGET_CORE
>> 	tristate "Generic Target Core Mod (TCM) and ConfigFS Infrastructure"
>> 	depends on SCSI && BLOCK
>>
>> if TARGET_CORE
>> [ ... ]
>> source "drivers/target/loopback/Kconfig"
>> endif
>>
>> In other words, the loopback driver already depends on SCSI. So I doubt that
>> this is a longstanding issue. Did you encounter this with Linus' master branch
>> or rather with linux-next?
> 
> Darn.  Thanks for the info.
> 
> I encountered it in linux-next.  I'll dig deeper.

For TARGET_CORE, the depends on SCSI has been removed in linux-next.
That allows the kconfig to go sideways.


-- 
~Randy

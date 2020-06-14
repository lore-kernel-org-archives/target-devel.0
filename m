From: Chris Boot <bootc@boo.tc>
Date: Sun, 14 Jun 2020 10:34:17 +0000
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
Message-Id: <7ad14946-5c25-fc49-1e48-72d37a607832@boo.tc>
List-Id: <target-devel.vger.kernel.org>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
 <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
In-Reply-To: <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Finn Thain <fthain@telegraphics.com.au>, Chris Boot <bootc@bootc.net>
Cc: linuxppc-dev@lists.ozlabs.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 14/06/2020 01:03, Finn Thain wrote:
> On Sat, 13 Jun 2020, Chris Boot wrote:
> 
>> I no longer have the time to maintain this subsystem nor the hardware to
>> test patches with. 
> 
> Then why not patch MAINTAINERS, and orphan it, as per usual practice?
> 
> $ git log --oneline MAINTAINERS | grep -i orphan

My patch to remove it was in response to:

https://lore.kernel.org/lkml/yq1img99d4k.fsf@ca-mkp.ca.oracle.com/

>> It also doesn't appear to have any active users so I doubt anyone will 
>> miss it.
>>
> 
> It's not unusual that any Linux driver written more than 5 years ago 
> "doesn't appear to have any active users".
> 
> If a driver has been orphaned and broken in the past, and no-one stepped 
> up to fix it within a reasonable period, removal would make sense. But 
> that's not the case here.
> 
> I haven't used this driver for a long time, but I still own PowerMacs with 
> firewire, and I know I'm not the only one.

I expect that if someone finds this useful it can stick around (but
that's not my call). I just don't have the time or inclination or
hardware to be able to maintain it anymore, so someone else would have
to pick it up.

Cheers,
Chris

-- 
Chris Boot
bootc@boo.tc

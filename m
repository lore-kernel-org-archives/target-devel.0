From: Chris Boot <bootc@boo.tc>
Date: Mon, 15 Jun 2020 15:00:52 +0000
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
Message-Id: <8da0c285-d707-a3d2-063e-472af5cc560f@boo.tc>
List-Id: <target-devel.vger.kernel.org>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
 <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
 <7ad14946-5c25-fc49-1e48-72d37a607832@boo.tc>
 <alpine.LNX.2.22.394.2006150919110.8@nippy.intranet>
In-Reply-To: <alpine.LNX.2.22.394.2006150919110.8@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Finn Thain <fthain@telegraphics.com.au>
Cc: linuxppc-dev@lists.ozlabs.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 15/06/2020 00:28, Finn Thain wrote:
> On Sun, 14 Jun 2020, Chris Boot wrote:
> 
>> I expect that if someone finds this useful it can stick around (but 
>> that's not my call).
> 
> Who's call is that? If the patch had said "From: Martin K. Petersen" and 
> "This driver is being removed because it has the following defects..." 
> that would be some indication of a good-faith willingness to accept users 
> as developers in the spirit of the GPL, which is what you seem to be 
> alluding to (?).

If you're asking me, I'd say it was martin's call:

> SCSI TARGET SUBSYSTEM                                                          
> M:      "Martin K. Petersen" <martin.petersen@oracle.com>                      
[...]
> F:      drivers/target/                                                        
> F:      include/target/                                                        

>> I just don't have the time or inclination or hardware to be able to 
>> maintain it anymore, so someone else would have to pick it up.
>>
> 
> Which is why most drivers get orphaned, right?

Sure, but that's not what Martin asked me to do, hence this patch.

-- 
Chris Boot
bootc@boo.tc

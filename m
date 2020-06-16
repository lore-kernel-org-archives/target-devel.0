From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 16 Jun 2020 14:08:40 +0000
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
Message-Id: <8cbab988-fba7-8e27-7faf-9f7aa36ca235@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
 <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
 <7ad14946-5c25-fc49-1e48-72d37a607832@boo.tc>
 <alpine.LNX.2.22.394.2006150919110.8@nippy.intranet>
 <8da0c285-d707-a3d2-063e-472af5cc560f@boo.tc>
 <alpine.LNX.2.22.394.2006161929380.8@nippy.intranet>
In-Reply-To: <alpine.LNX.2.22.394.2006161929380.8@nippy.intranet>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Finn Thain <fthain@telegraphics.com.au>, Chris Boot <bootc@boo.tc>
Cc: linuxppc-dev@lists.ozlabs.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 2020-06-16 02:42, Finn Thain wrote:
> Martin said, "I'd appreciate a patch to remove it"
> 
> And Bart said, "do you want to keep this driver in the kernel tree?"
> 
> AFAICT both comments are quite ambiguous. I don't see an actionable 
> request, just an expression of interest from people doing their jobs.
> 
> Note well: there is no pay check associated with having a MAINTAINERS file 
> entry.

Hi Finn,

As far as I know the sbp driver only has had one user ever and that user
is no longer user the sbp driver. So why to keep it in the kernel tree?
Restoring a kernel driver can be easy - the first step is a "git revert".

Thanks,

Bart.

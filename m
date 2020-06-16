From: Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Date: Tue, 16 Jun 2020 14:13:54 +0000
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
Message-Id: <SN4PR0401MB35982D889857E3C03E96E49D9B9D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
 <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
 <7ad14946-5c25-fc49-1e48-72d37a607832@boo.tc>
 <alpine.LNX.2.22.394.2006150919110.8@nippy.intranet>
 <8da0c285-d707-a3d2-063e-472af5cc560f@boo.tc>
 <alpine.LNX.2.22.394.2006161929380.8@nippy.intranet>
 <8cbab988-fba7-8e27-7faf-9f7aa36ca235@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, Finn Thain <fthain@telegraphics.com.au>, Chris Boot <bootc@boo.tc>
Cc: "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On 16/06/2020 16:09, Bart Van Assche wrote:
> On 2020-06-16 02:42, Finn Thain wrote:
>> Martin said, "I'd appreciate a patch to remove it"
>>
>> And Bart said, "do you want to keep this driver in the kernel tree?"
>>
>> AFAICT both comments are quite ambiguous. I don't see an actionable 
>> request, just an expression of interest from people doing their jobs.
>>
>> Note well: there is no pay check associated with having a MAINTAINERS file 
>> entry.
> 
> Hi Finn,
> 
> As far as I know the sbp driver only has had one user ever and that user
> is no longer user the sbp driver. So why to keep it in the kernel tree?
> Restoring a kernel driver can be easy - the first step is a "git revert".

Why not move the driver to drivers/staging for 2 or 3 kernel releases and if
noone steps up, delete it?

Just my 2 Cents,
	Johannes

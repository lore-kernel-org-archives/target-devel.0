From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 17 Jun 2020 03:09:16 +0000
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
Message-Id: <yq1366ul8o4.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
        <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
        <7ad14946-5c25-fc49-1e48-72d37a607832@boo.tc>
        <alpine.LNX.2.22.394.2006150919110.8@nippy.intranet>
        <8da0c285-d707-a3d2-063e-472af5cc560f@boo.tc>
        <alpine.LNX.2.22.394.2006161929380.8@nippy.intranet>
        <8cbab988-fba7-8e27-7faf-9f7aa36ca235@acm.org>
        <SN4PR0401MB35982D889857E3C03E96E49D9B9D0@SN4PR0401MB3598.namprd04.prod.outlook.com>
        <1592321667.4394.5.camel@HansenPartnership.com>
        <5e512185-45d1-61eb-9bec-91e9f9d53ea3@boo.tc>
In-Reply-To: <5e512185-45d1-61eb-9bec-91e9f9d53ea3@boo.tc> (Chris Boot's
        message of "Tue, 16 Jun 2020 18:59:58 +0100")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Boot <bootc@boo.tc>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Johannes Thumshirn <Johannes.Thumshirn@wdc.com>, Bart Van Assche <bvanassche@acm.org>, Finn Thain <fthain@telegraphics.com.au>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux1394-devel@lists.sourceforge.net" <linux1394-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>


Chris,

> I don't especially want it to be gone, nor can I be sure there are no
> users of what is as far as I can tell a working piece of code. I can
> tell you that I never hear about it (other than the odd patch),
> whereas I do get emails out of the blue for some of my other (much
> smaller) stuff which clearly has users. I'd be just as happy for this
> to be orphaned or for nothing to happen to it.
>
> Honestly, I am totally ambivalent as to what happens to this code.
> Martin, however, clearly cares enough to have asked me to supply a
> patch to remove it.

I love it when people take ownership of old drivers. I think it's
wonderful that Finn and others are on the ball when it comes to the 5380
family. I don't care how old things are as long as they are being
actively used.

I am also very happy to keep things in the tree as long as there is a
healthy community around them. However, keeping code around is not
free. Core interfaces change frequently. Nobody enjoys having to tweak
host templates for 50 devices they have never even heard about. Also, we
now live in a reality where there is a constant barrage of build bots
and code analyzers sending mail. So the effective cost of keeping code
around in the tree is going up. I get a substantial amount of code
analysis mail about drivers nobody have touched in a decade or more.

Consequently, I am much more inclined to remove drivers than I have been
in the past. But I am also very happy to bring them back if somebody
uses them or - even better - are willing to step up and maintain them.

I don't particularly like the notion of a driver being orphaned because
all that really means is that the driver transitions from being (at
least partially) somebody else's problem to being mine and mine alone.

-- 
Martin K. Petersen	Oracle Linux Engineering

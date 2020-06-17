From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 17 Jun 2020 02:35:18 +0000
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
Message-Id: <yq18sgml9ds.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
        <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
In-Reply-To: <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet> (Finn
        Thain's message of "Sun, 14 Jun 2020 10:03:31 +1000 (AEST)")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Finn Thain <fthain@telegraphics.com.au>
Cc: Chris Boot <bootc@bootc.net>, linuxppc-dev@lists.ozlabs.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>


Finn,

> I haven't used this driver for a long time, but I still own PowerMacs
> with firewire, and I know I'm not the only one.

I also have old 1394 hardware kicking around in the basement. But having
worked with FireWire shared storage targets in the past, I have zero
desire to ever touch any of that again.

I could understand an objection if we were to entertain removing
sbp2. But really, how many people are setting up FireWire targets?

-- 
Martin K. Petersen	Oracle Linux Engineering

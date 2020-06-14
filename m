From: Finn Thain <fthain@telegraphics.com.au>
Date: Sun, 14 Jun 2020 00:03:31 +0000
Subject: Re: [PATCH] scsi: target/sbp: remove firewire SBP target driver
Message-Id: <alpine.LNX.2.22.394.2006140934520.15@nippy.intranet>
List-Id: <target-devel.vger.kernel.org>
References: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
In-Reply-To: <01020172acd3d10f-3964f076-a820-43fc-9494-3f3946e9b7b5-000000@eu-west-1.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Boot <bootc@bootc.net>
Cc: linuxppc-dev@lists.ozlabs.org, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>, Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>

On Sat, 13 Jun 2020, Chris Boot wrote:

> I no longer have the time to maintain this subsystem nor the hardware to
> test patches with. 

Then why not patch MAINTAINERS, and orphan it, as per usual practice?

$ git log --oneline MAINTAINERS | grep -i orphan

> It also doesn't appear to have any active users so I doubt anyone will 
> miss it.
> 

It's not unusual that any Linux driver written more than 5 years ago 
"doesn't appear to have any active users".

If a driver has been orphaned and broken in the past, and no-one stepped 
up to fix it within a reasonable period, removal would make sense. But 
that's not the case here.

I haven't used this driver for a long time, but I still own PowerMacs with 
firewire, and I know I'm not the only one.

> Signed-off-by: Chris Boot <bootc@bootc.net>
> ---
>  MAINTAINERS                     |    9 -
>  drivers/target/Kconfig          |    1 -
>  drivers/target/Makefile         |    1 -
>  drivers/target/sbp/Kconfig      |   12 -
>  drivers/target/sbp/Makefile     |    2 -
>  drivers/target/sbp/sbp_target.c | 2350 -------------------------------
>  drivers/target/sbp/sbp_target.h |  243 ----
>  7 files changed, 2618 deletions(-)
>  delete mode 100644 drivers/target/sbp/Kconfig
>  delete mode 100644 drivers/target/sbp/Makefile
>  delete mode 100644 drivers/target/sbp/sbp_target.c
>  delete mode 100644 drivers/target/sbp/sbp_target.h
> 

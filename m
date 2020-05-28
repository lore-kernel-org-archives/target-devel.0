From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 28 May 2020 14:53:34 +0000
Subject: Re: [PATCH] sbp-target: add the missed kfree() in an error path
Message-Id: <475e4f50-6d20-d653-8288-0676bc708bcc@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200528102056.911825-1-hslester96@gmail.com>
In-Reply-To: <20200528102056.911825-1-hslester96@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Boot <bootc@bootc.net>
Cc: Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org

On 2020-05-28 03:20, Chuhong Yuan wrote:
> sbp_fetch_command() forgets to call kfree() in an error path.
> Add the missed call to fix it.

Hi Chris,

The changelog of the code under drivers/target/sbp makes we wonder
whether this driver has ever had any other users than its original
author. Do you agree with this? If so, do you want to keep this driver
in the kernel tree?

Thanks,

Bart.

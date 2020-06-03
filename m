From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 03 Jun 2020 01:01:38 +0000
Subject: Re: [PATCH] sbp-target: add the missed kfree() in an error path
Message-Id: <yq1img99d4k.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200528102056.911825-1-hslester96@gmail.com>
        <475e4f50-6d20-d653-8288-0676bc708bcc@acm.org>
        <dcb29beb-0996-a141-89af-ac9c9c5fd5c0@bootc.net>
In-Reply-To: <dcb29beb-0996-a141-89af-ac9c9c5fd5c0@bootc.net> (Chris Boot's
        message of "Thu, 28 May 2020 16:16:51 +0100")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Boot <bootc@bootc.net>
Cc: Bart Van Assche <bvanassche@acm.org>, Chuhong Yuan <hslester96@gmail.com>, "Martin K . Petersen" <martin.petersen@oracle.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org


Chris,

> I think you might be right. I also don't have much time to maintain it
> these days and the hardware I had is long dead.

In that case I'd appreciate a patch to remove it.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 03 Jun 2020 01:42:06 +0000
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
Message-Id: <yq11rmx9b9w.fsf@ca-mkp.ca.oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
In-Reply-To: <20200518183141.66621-1-r.bolshakov@yadro.com> (Roman Bolshakov's
        message of "Mon, 18 May 2020 21:31:42 +0300")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com, target-devel@vger.kernel.org, linux@yadro.com, Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>, Bart Van Assche <bvanassche@acm.org>, Daniel Wagner <dwagner@suse.de>, Himanshu Madhani <himanshu.madhani@oracle.com>, Martin Wilck <mwilck@suse.com>, stable@vger.kernel.org


Roman,

> The driver performs SCR (state change registration) in all modes
> including pure target mode.

What is the current status of this patch? There was a bunch of going
back and forth wrt. whether this was the correct approach.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

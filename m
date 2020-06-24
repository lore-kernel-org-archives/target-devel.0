From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 24 Jun 2020 04:29:41 +0000
Subject: Re: [PATCH v2] scsi: qla2xxx: Keep initiator ports after RSCN
Message-Id: <159297296072.9797.15955182612058210718.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200605144435.27023-1-r.bolshakov@yadro.com>
In-Reply-To: <20200605144435.27023-1-r.bolshakov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, Roman Bolshakov <r.bolshakov@yadro.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, GR-QLogic-Storage-Upstream@marvell.com, target-devel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>, Himanshu Madhani <himanshu.madhani@oracle.com>, Bart Van Assche <bvanassche@acm.org>, Arun Easi <aeasi@marvell.com>, stable@vger.kernel.org, Martin Wilck <mwilck@suse.com>, Quinn Tran <qutran@marvell.com>, linux@yadro.com, Daniel Wagner <dwagner@suse.de>

On Fri, 5 Jun 2020 17:44:37 +0300, Roman Bolshakov wrote:

> The driver performs SCR (state change registration) in all modes
> including pure target mode.
> 
> For each RSCN, scan_needed flag is set in qla2x00_handle_rscn() for the
> port mentioned in the RSCN and fabric rescan is scheduled. During the
> rescan, GNN_FT handler, qla24xx_async_gnnft_done() deletes session of
> the port that caused the RSCN.
> 
> [...]

Applied to 5.8/scsi-fixes, thanks!

[1/1] scsi: qla2xxx: Keep initiator ports after RSCN
      https://git.kernel.org/mkp/scsi/c/632f24f09d5b

-- 
Martin K. Petersen	Oracle Linux Engineering

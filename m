From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Fri, 05 Jun 2020 14:23:11 +0000
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
Message-Id: <20200605142311.GC56901@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
 <yq11rmx9b9w.fsf@ca-mkp.ca.oracle.com>
In-Reply-To: <yq11rmx9b9w.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com, target-devel@vger.kernel.org, linux@yadro.com, Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>, Bart Van Assche <bvanassche@acm.org>, Daniel Wagner <dwagner@suse.de>, Himanshu Madhani <himanshu.madhani@oracle.com>, Martin Wilck <mwilck@suse.com>, stable@vger.kernel.org

On Tue, Jun 02, 2020 at 09:42:06PM -0400, Martin K. Petersen wrote:
> 
> Roman,
> 
> > The driver performs SCR (state change registration) in all modes
> > including pure target mode.
> 
> What is the current status of this patch? There was a bunch of going
> back and forth wrt. whether this was the correct approach.
> 
> Thanks!
> 

Hi Martin,

The patch has a logic error that prevents session deletion if N_Port ID
was changed after fabric rescan and shouldn't be merged IMO. I'll send a
correct v2 shortly.

Thanks,
Roman

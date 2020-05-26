From: Martin Wilck <mwilck@suse.com>
Date: Tue, 26 May 2020 19:21:52 +0000
Subject: Re: [PATCH] scsi: qla2xxx: Keep initiator ports after RSCN
Message-Id: <06a74050412a378acf31f41ce5e39c6c739ee91e.camel@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200518183141.66621-1-r.bolshakov@yadro.com>
         <3ee76f0fc5df716523bfbdd34726b6cccd4971cd.camel@suse.com>
         <20200521151730.GA73599@SPB-NB-133.local>
In-Reply-To: <20200521151730.GA73599@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Bolshakov <r.bolshakov@yadro.com>
Cc: linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com, target-devel@vger.kernel.org, linux@yadro.com, Quinn Tran <qutran@marvell.com>, Arun Easi <aeasi@marvell.com>, Nilesh Javali <njavali@marvell.com>, Bart Van Assche <bvanassche@acm.org>, Daniel Wagner <dwagner@suse.de>, Himanshu Madhani <himanshu.madhani@oracle.com>, stable@vger.kernel.org

Roman,

> [...]
>
> So, as a summary, it seems that the existing code mostly keeps
> sessions
> until:
>  - a conflict of N_Port_ID, N_Port_Name or N_Port handle detected;
>  - the session is in the middle of refresh/rescan and RSCN arrives;
>  - there's an explicit process or port logout from the session, i.e.
>    PRLO, TPRLO, LOGO
>  - there's a new port or process login from the same session, i.e.
>    PLOGI, PRLI;
>  - target is shut down;
>  - target port link is reset;
> 
> And if a session of an initiator is deleted when driver works in
> target
> mode, new session won't be established until a PLOGI and PRLI come
> from
> the initiator.
> 
> The assumption is used qlt_handle_cmd_for_atio() and
> qlt_handle_task_mgmt() to discard commands and TMFs from initiators
> that
> are not logged in.
> 

thank you for this incredibly extensive response. I'll bookmark it,
I guess it can serve as a reference for future qla2xxx work. I hope you
didn't do all this work just for my little question.

Forgive me that I won't immediately try to review this document in
detail. You've studied and understood this driver in much more depth
than I probably ever will.

Thanks again,
Martin



> Thanks,
> Roman

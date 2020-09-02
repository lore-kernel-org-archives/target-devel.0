From: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date: Wed, 02 Sep 2020 15:14:57 +0000
Subject: RE: [PATCH v4 2/4] target: initialize LUN in transport_init_se_cmd().
Message-Id: <dcc05e5d-5b8f-4ae1-991d-b8d454eff3f0@default>
List-Id: <target-devel.vger.kernel.org>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
 <1591559913-8388-3-git-send-email-sudhakar.panneerselvam@oracle.com>
 <cbbd368e6e33af6e22c850192e69b27edd043efd.camel@suse.com>
In-Reply-To: <cbbd368e6e33af6e22c850192e69b27edd043efd.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Martin Wilck <mwilck@suse.com>, Martin Petersen <martin.petersen@oracle.com>, Michael Christie <michael.christie@oracle.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shirley Ma <shirley.ma@oracle.com>, Hannes Reinecke <hare@suse.com>, Daniel Wagner <daniel.wagner@suse.com>, Arun Easi <aeasi@marvell.com>

Hi Martin,

> -----Original Message-----
> From: Martin Wilck [mailto:mwilck@suse.com]
> Sent: Wednesday, September 2, 2020 7:50 AM
> To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>; Martin
> Petersen <martin.petersen@oracle.com>; Michael Christie
> <michael.christie@oracle.com>; target-devel@vger.kernel.org; linux-
> scsi@vger.kernel.org
> Cc: Shirley Ma <shirley.ma@oracle.com>; Hannes Reinecke <hare@suse.com>;
> Daniel Wagner <daniel.wagner@suse.com>; Arun Easi <aeasi@marvell.com>
> Subject: Re: [PATCH v4 2/4] target: initialize LUN in transport_init_se_cmd().
> 
> Hello Sudhakar,
> 
> On Sun, 2020-06-07 at 19:58 +0000, Sudhakar Panneerselvam wrote:
> > Initialization of orig_fe_lun is moved to transport_init_se_cmd()
> > from
> > transport_lookup_cmd_lun(). This helps for the cases where the scsi
> > request
> > fails before the call to transport_lookup_cmd_lun() so that
> > trace_target_cmd_complete() can print the LUN information to the
> > trace
> > buffer. Due to this change, the lun parameter is removed from
> > transport_lookup_cmd_lun() and transport_lookup_tmr_lun().
> >
> > Signed-off-by: Sudhakar Panneerselvam <
> > sudhakar.panneerselvam@oracle.com>
> > ---
> >  drivers/target/iscsi/iscsi_target.c    | 11 +++++------
> >  drivers/target/target_core_device.c    | 19 ++++++++-----------
> >  drivers/target/target_core_tmr.c       |  4 ++--
> >  drivers/target/target_core_transport.c | 12 +++++++-----
> >  drivers/target/target_core_xcopy.c     |  4 ++--
> >  drivers/usb/gadget/function/f_tcm.c    |  6 ++++--
> >  include/target/target_core_fabric.h    |  6 +++---
> >  7 files changed, 31 insertions(+), 31 deletions(-)
> >
> > [...]
> > diff --git a/drivers/target/target_core_transport.c
> > b/drivers/target/target_core_transport.c
> > index f2f7c5b818cc..7ea77933e64d 100644
> > --- a/drivers/target/target_core_transport.c
> > +++ b/drivers/target/target_core_transport.c
> > [...]
> > @@ -1790,7 +1792,7 @@ int target_submit_tmr(struct se_cmd *se_cmd,
> > struct se_session *se_sess,
> >  	BUG_ON(!se_tpg);
> >
> >  	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
> > -			      0, DMA_NONE, TCM_SIMPLE_TAG, sense);
> > +			      0, DMA_NONE, TCM_SIMPLE_TAG, sense,
> > unpacked_lun);
> >  	/*
> >  	 * FIXME: Currently expect caller to handle se_cmd->se_tmr_req
> >  	 * allocation failure.
> 
> Between this hunk and the next one in target_submit_tmr(), there
> is this code:
> 
>         /*
>          * If this is ABORT_TASK with no explicit fabric provided LUN,
>          * go ahead and search active session tags for a match to figure
>          * out unpacked_lun for the original se_cmd.
>          */
>         if (tm_type == TMR_ABORT_TASK && (flags &
> TARGET_SCF_LOOKUP_LUN_FROM_TAG)) {
>                 if (!target_lookup_lun_from_tag(se_sess, tag, &unpacked_lun))
>                         goto failure;
>         }
> 
> > @@ -1818,7 +1820,7 @@ int target_submit_tmr(struct se_cmd *se_cmd,
> > struct se_session *se_sess,
> >  			goto failure;
> >  	}
> >
> > -	ret = transport_lookup_tmr_lun(se_cmd, unpacked_lun);
> > +	ret = transport_lookup_tmr_lun(se_cmd);
> >  	if (ret)
> >  		goto failure;
> >
> 
> AFAICS, your patch breaks the case where the above code is executed to
> derive unpacked_lun from the tag. The updated value of unpacked_lun is
> never used. That would break aborts for the qla2xxx target.
> 
> Am I overlooking something? Can you please explain?
> 

You are right. This change breaks the qlogic abort task code path, since it is the only transport that sets the TARGET_SCF_LOOKUP_LUN_FROM_TAG flag making that condition true. My apologies. I can send out a patch if you have not written one already. Please let me know.

Thanks
Sudhakar

> Regards
> Martin
> 
> 

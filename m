From: Martin Wilck <mwilck@suse.com>
Date: Thu, 03 Sep 2020 13:13:09 +0000
Subject: Re: [PATCH v4 2/4] target: initialize LUN in transport_init_se_cmd().
Message-Id: <4f50cb6d85573779e3c776a26abc4b95c5a5637a.camel@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
         <1591559913-8388-3-git-send-email-sudhakar.panneerselvam@oracle.com>
         <cbbd368e6e33af6e22c850192e69b27edd043efd.camel@suse.com>
         <dcc05e5d-5b8f-4ae1-991d-b8d454eff3f0@default>
         <f1e02a57e5d42c492d89acc2f82809e91e42d2aa.camel@suse.com>
In-Reply-To: <f1e02a57e5d42c492d89acc2f82809e91e42d2aa.camel@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Arun Easi <aeasi@marvell.com>, Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, Martin Petersen <martin.petersen@oracle.com>, Michael Christie <michael.christie@oracle.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shirley Ma <shirley.ma@oracle.com>, Hannes Reinecke <hare@suse.com>, Daniel Wagner <daniel.wagner@suse.com>

On Thu, 2020-09-03 at 15:00 +0200, Martin Wilck wrote:
> On Wed, 2020-09-02 at 08:14 -0700, Sudhakar Panneerselvam wrote:
> > Hi Martin,
> > 
> > > AFAICS, your patch breaks the case where the above code is
> > > executed
> > > to
> > > derive unpacked_lun from the tag. The updated value of
> > > unpacked_lun
> > > is
> > > never used. That would break aborts for the qla2xxx target.
> > > 
> > > Am I overlooking something? Can you please explain?
> > > 
> > 
> > You are right. This change breaks the qlogic abort task code path,
> > since it is the only transport that sets the
> > TARGET_SCF_LOOKUP_LUN_FROM_TAG flag making that condition true. My
> > apologies. I can send out a patch if you have not written one
> > already. Please let me know.
> 
> Please go ahead. I haven't written a patch - I'm not experienced
> enough
> with the target code to quickly grok whether simply moving the
> target_lookup_lun_from_tag() code upward would work, in particular
> wrt
> handling failures and cleaning up.

We may want to discuss whether TARGET_SCF_LOOKUP_LUN_FROM_TAG should be
removed entirely. As you said, qla2xxx is the only user of this
feature. And it actually uses it only in a single code path, 
__qlt_24xx_handle_abts() (everywhere else the LUN is known beforehand,
AFAICT).

If you look at the code of __qlt_24xx_handle_abts(), you can see that
it calls tcm_qla2xxx_find_cmd_by_tag(), which does the same thing
as target_lookup_lun_from_tag(): iterate over se_sess->sess_cmd_list
until a matching tag is found. It would clearly be equivalent, and more
efficient, if qla2xxx set the lun directly rather than relying on
common code iterating through the same list again, later.

Martin

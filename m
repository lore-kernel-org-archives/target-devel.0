From: Martin Wilck <mwilck@suse.com>
Date: Thu, 03 Sep 2020 13:00:58 +0000
Subject: Re: [PATCH v4 2/4] target: initialize LUN in transport_init_se_cmd().
Message-Id: <f1e02a57e5d42c492d89acc2f82809e91e42d2aa.camel@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591559913-8388-1-git-send-email-sudhakar.panneerselvam@oracle.com>
         <1591559913-8388-3-git-send-email-sudhakar.panneerselvam@oracle.com>
         <cbbd368e6e33af6e22c850192e69b27edd043efd.camel@suse.com>
         <dcc05e5d-5b8f-4ae1-991d-b8d454eff3f0@default>
In-Reply-To: <dcc05e5d-5b8f-4ae1-991d-b8d454eff3f0@default>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, Martin Petersen <martin.petersen@oracle.com>, Michael Christie <michael.christie@oracle.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Shirley Ma <shirley.ma@oracle.com>, Hannes Reinecke <hare@suse.com>, Daniel Wagner <daniel.wagner@suse.com>, Arun Easi <aeasi@marvell.com>

On Wed, 2020-09-02 at 08:14 -0700, Sudhakar Panneerselvam wrote:
> Hi Martin,
> 
> > 
> > AFAICS, your patch breaks the case where the above code is executed
> > to
> > derive unpacked_lun from the tag. The updated value of unpacked_lun
> > is
> > never used. That would break aborts for the qla2xxx target.
> > 
> > Am I overlooking something? Can you please explain?
> > 
> 
> You are right. This change breaks the qlogic abort task code path,
> since it is the only transport that sets the
> TARGET_SCF_LOOKUP_LUN_FROM_TAG flag making that condition true. My
> apologies. I can send out a patch if you have not written one
> already. Please let me know.

Please go ahead. I haven't written a patch - I'm not experienced enough
with the target code to quickly grok whether simply moving the
target_lookup_lun_from_tag() code upward would work, in particular wrt
handling failures and cleaning up.

Regards,
Martin

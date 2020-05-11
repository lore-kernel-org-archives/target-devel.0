From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:08:36 +0000
Subject: Re: [PATCH 01/15] target: check enforce_pr_isids during registration
Message-Id: <c9634d6d-36f8-d47a-90b2-6cf91fb4fb22@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-2-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-2-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 5/10/20 11:57 PM, Mike Christie wrote:
> Move the check for enforce_pr_isids to the registration code where we
> can fail at the time an initiator tries to register a path without an
> isid. In its current place in __core_scsi3_locate_pr_reg, it is too
> late because it can be registered and be reported in PR in commands and
> it is stuck in this state because we cannot unregister it.
> 
> Note.
> I am including in this patchset, because the 5th patch is built on top.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/target/target_core_pr.c | 24 +++++++++++++++---------
>   1 file changed, 15 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

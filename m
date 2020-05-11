From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:13:13 +0000
Subject: Re: [PATCH 08/15] target: use tpt_id in target_stat_iport_port_ident_show
Message-Id: <bb56c8de-9bdb-e929-7184-c3858706b978@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-9-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-9-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 5/10/20 11:57 PM, Mike Christie wrote:
> Use the tpt_id session id instead of sess_get_initiator_sid.
> 
> Note that for userspace compat this patch continues the behavior:
> 
> 1. Still add the "+i+" even if there is no session_id.
> 2. Use the acl initiatorname instead of the transportID port/addr/name.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/target/target_core_stat.c | 12 +++---------
>   1 file changed, 3 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

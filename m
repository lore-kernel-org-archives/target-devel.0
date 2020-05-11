From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:13:52 +0000
Subject: Re: [PATCH 09/15] target: drop sess_get_initiator_sid from PR code
Message-Id: <f25ddc37-71dc-0bd7-e33e-e9ca54a1b342@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-10-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-10-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 5/10/20 11:57 PM, Mike Christie wrote:
> Use the transport id session id in the PR related code.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/target/target_core_pr.c        | 23 ++++-------------------
>   drivers/target/target_core_transport.c | 11 ++++-------
>   2 files changed, 8 insertions(+), 26 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:10:10 +0000
Subject: Re: [PATCH 04/15] tcm loop: use target_parse_emulated_name
Message-Id: <ccaceea3-23fa-3fc3-e41b-72032e61c135@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-5-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-5-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 5/10/20 11:57 PM, Mike Christie wrote:
> Use target_parse_emulated_name so the acl and SCSI names are properly
> formatted.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/target/loopback/tcm_loop.c | 65 ++++++--------------------------------
>   1 file changed, 10 insertions(+), 55 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

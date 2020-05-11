From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:11:34 +0000
Subject: Re: [PATCH 06/15] xen scsiback: use target_parse_emulated_name
Message-Id: <e791f498-6239-6bdf-6b27-3dd5b8ba5abe@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-7-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-7-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>

On 5/10/20 11:57 PM, Mike Christie wrote:
> Use target_parse_emulated_name so the acl and SCSI names are
> properly formatted.
> 
> Cc: Juergen Gross <jgross@suse.com>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/xen/xen-scsiback.c | 66 ++++++++--------------------------------------
>   1 file changed, 11 insertions(+), 55 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

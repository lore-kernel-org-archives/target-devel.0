From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:11:05 +0000
Subject: Re: [PATCH 05/15] vhost scsi: use target_parse_emulated_name
Message-Id: <566c4fd4-cd03-1eaa-028b-b634876c3ec1@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-6-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-6-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>

On 5/10/20 11:57 PM, Mike Christie wrote:
> Use target_parse_emulated_name so the acl and SCSI names are
> properly formatted.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/vhost/scsi.c | 69 +++++++++-------------------------------------------
>   1 file changed, 11 insertions(+), 58 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

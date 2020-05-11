From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:09:42 +0000
Subject: Re: [PATCH 03/15] target: add helper to parse acl and transport name
Message-Id: <3f0bf2d4-330a-f2a8-edaf-6f449f549f49@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-4-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-4-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juergen Gross <jgross@suse.com>

On 5/10/20 11:57 PM, Mike Christie wrote:
> The drivers that emulate the initiator port id (loop, scsi vhost, xen scsiback)
> do almost the extact same parsing when making their I_T_nexus. This adds a
> helper that parses out the acl name and port name from the user buffer, so
> these types of drivers drop prefixes like "naa." when they need to for the
> SCSI SPC4 TransportID SAS address, but then keep it for the LIO ACL name.
> 
> The next patches will then convert those drivers.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Juergen Gross <jgross@suse.com>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/target/target_core_fabric_lib.c | 73 +++++++++++++++++++++++++++++++++
>   include/target/target_core_fabric.h     |  2 +
>   2 files changed, 75 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

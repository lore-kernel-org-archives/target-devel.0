From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:09:14 +0000
Subject: Re: [PATCH 02/15] target: separate acl name from port ids
Message-Id: <6eced3be-7934-7492-f413-26f5fcf12f82@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-3-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-3-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: "Michael S . Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, Juergen Gross <jgross@suse.com>

On 5/10/20 11:57 PM, Mike Christie wrote:
> The PGR code assumes the ACL name is going to be based on the SPC4
> transportID type of values. The problem is that for iSCSI we have an extra
> session id as part of the SCSI port id and some fabric modules support or
> would like to support non transportID values for the ACL name. For example,
> iSCSI and SRP would like to use the source address for the ACL name, but
> that is not a valud transportID value that you can get in a PGR request.
> 
> This patch adds a new transport_id struct which maps to the SPC4
> transportID. In the future it will be used for PGR commands instead of the
> ACL name. In this patchset it is used to export the initiator info in the
> session's sysfs dir, so tools can display the info and daemons that execute
> commands like PGRs in userspace can build a session id to I_T nexus mapping.
> 
> In this patch only srp is passing in different values for the transport id
> and acl name. The next patches will convert loop, scsi vhost and xen
> scsiback that are more complex due to their initiator name emulation.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Juergen Gross <jgross@suse.com>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
> 
> V4:
> - Don't drop const char use. We still have target_setup_session allocate
> the transport_id struct, but because every uses format=0 we just need to
> pass in the transport_id's name.
> 
> V3:
> - drop format
> 
>   drivers/infiniband/ulp/srpt/ib_srpt.c    | 10 +++++---
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  4 +--
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c       |  2 +-
>   drivers/target/loopback/tcm_loop.c       |  3 ++-
>   drivers/target/sbp/sbp_target.c          |  2 +-
>   drivers/target/target_core_fabric_lib.c  | 41 +++++++++++++++++++++++++++++++
>   drivers/target/target_core_transport.c   | 42 ++++++++++++++++++++++++--------
>   drivers/target/tcm_fc/tfc_sess.c         |  3 ++-
>   drivers/usb/gadget/function/f_tcm.c      |  3 ++-
>   drivers/vhost/scsi.c                     |  1 +
>   drivers/xen/xen-scsiback.c               |  3 ++-
>   include/target/target_core_base.h        | 12 +++++++++
>   include/target/target_core_fabric.h      |  5 +++-
>   13 files changed, 108 insertions(+), 23 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

From: Hannes Reinecke <hare@suse.de>
Date: Mon, 11 May 2020 06:14:25 +0000
Subject: Re: [PATCH 10/15] target: drop sess_get_initiator_sid
Message-Id: <5dee32d3-7e41-eaab-2544-c73bc9aaf0af@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-11-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-11-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 5/10/20 11:57 PM, Mike Christie wrote:
> sess_get_initiator_sid is no longer used. Drop it.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c        |  1 -
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  2 --
>   drivers/target/iscsi/iscsi_target_configfs.c | 13 -------------
>   drivers/target/tcm_fc/tfc_conf.c             |  1 -
>   drivers/usb/gadget/function/f_tcm.c          |  1 -
>   drivers/vhost/scsi.c                         |  1 -
>   drivers/xen/xen-scsiback.c                   |  1 -
>   include/target/target_core_fabric.h          |  6 ------
>   8 files changed, 26 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

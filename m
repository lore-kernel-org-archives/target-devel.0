From: Hannes Reinecke <hare@suse.de>
Date: Mon, 08 Jun 2020 06:21:46 +0000
Subject: Re: [PATCH 17/17] target: drop sess_get_index
Message-Id: <0f369872-ebd0-9df8-49a5-c7fe15d2a4b4@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-18-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-18-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 6/7/20 10:36 PM, Mike Christie wrote:
> Use the LIO session id for the scsiAttIntrPortIndex. iSCSI was
> already using this value and the other drivers used hard coded
> values of 1 or 0. The SCSI-MIB specs says:
> 
> This object represents an arbitrary integer used to uniquely
> identify a particular attached remote initiator port to a
> particular SCSI target port within a particular SCSI target device
> within a particular SCSI instance.
> 
> So the lio session sid can be used.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c        | 15 ---------------
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     |  6 ------
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  7 -------
>   drivers/target/iscsi/iscsi_target_configfs.c |  6 ------
>   drivers/target/loopback/tcm_loop.c           |  6 ------
>   drivers/target/sbp/sbp_target.c              |  6 ------
>   drivers/target/target_core_configfs.c        |  4 ----
>   drivers/target/target_core_stat.c            |  5 +----
>   drivers/target/tcm_fc/tfc_conf.c             |  1 -
>   drivers/target/tcm_fc/tfc_sess.c             |  7 -------
>   drivers/usb/gadget/function/f_tcm.c          |  6 ------
>   drivers/vhost/scsi.c                         |  6 ------
>   drivers/xen/xen-scsiback.c                   |  6 ------
>   include/target/target_core_fabric.h          |  1 -
>   14 files changed, 1 insertion(+), 81 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

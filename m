From: Hannes Reinecke <hare@suse.de>
Date: Mon, 08 Jun 2020 06:19:48 +0000
Subject: Re: [PATCH 14/17] target: add free_session callout
Message-Id: <61f5abdb-9733-aa7c-b712-bba709745b19@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-15-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-15-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 6/7/20 10:36 PM, Mike Christie wrote:
> The next patches hook the iscsi target into the syfs API and has it
> export some basic info about the session.
> 
> To allow fabric drivers to export info in sysfs, they need to be able
> to free resources when all userspace refs have dropped. This patch
> adds a new session callback free_session which the fabric drivers can
> use to free their internal resources that are accessed via sysfs.
> 
> This also moves the setting of the fabric_sess_ptr to
> transport_alloc_session so drivers like iscsi that use that function
> can know that if that function returns success then they can always
> free the resources pointed at fabric_sess_ptr in the free_session
> callback.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/iscsi/iscsi_target.c          |  7 +----
>   drivers/target/iscsi/iscsi_target_configfs.c |  9 ++++++
>   drivers/target/iscsi/iscsi_target_login.c    |  8 ++---
>   drivers/target/target_core_transport.c       | 47 +++++++++++++++++-----------
>   include/target/target_core_base.h            |  1 +
>   include/target/target_core_fabric.h          | 12 +++++--
>   6 files changed, 51 insertions(+), 33 deletions(-)
> One wonders why this isn't refcounted, but otherwise:

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

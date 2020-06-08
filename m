From: Hannes Reinecke <hare@suse.de>
Date: Mon, 08 Jun 2020 06:15:13 +0000
Subject: Re: [PATCH 12/17] target: hook most target users into sysfs API
Message-Id: <593715ed-874f-79a9-0db9-b4563cf77baf@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-13-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-13-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 6/7/20 10:35 PM, Mike Christie wrote:
> This hooks lio core and all the targets but iscsi into the sysfs API.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/Makefile                |  1 +
>   drivers/target/target_core_configfs.c  |  3 +++
>   drivers/target/target_core_internal.h  |  1 +
>   drivers/target/target_core_transport.c | 38 ++++++++++++++++++++++++++++------
>   4 files changed, 37 insertions(+), 6 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

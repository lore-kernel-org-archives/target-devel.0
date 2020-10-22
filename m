From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Date: Thu, 22 Oct 2020 00:51:25 +0000
Subject: Re: [PATCH 02/17] vhost: remove work arg from vhost_work_flush
Message-Id: <BYAPR04MB496583F88923E12239752032861D0@BYAPR04MB4965.namprd04.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-3-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "stefanha@redhat.com" <stefanha@redhat.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>

On 10/21/20 17:35, Mike Christie wrote:
> vhost_work_flush doesn't do anything with the work arg. This patch drops
> it and then renames vhost_work_flush to vhost_work_dev_flush to reflect
> that the function flushes all the works in the dev and not just a
> specific queue or work item.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Acked-by: Jason Wang <jasowang@redhat.com>

Apparently it used local flush.work, not sure if it supposed to

use work as an argument instead of local variable, if so looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

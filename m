From: Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Date: Thu, 22 Oct 2020 00:45:55 +0000
Subject: Re: [PATCH 03/17] vhost net: use goto error handling in open
Message-Id: <BYAPR04MB4965B45205A531226FAD1843861D0@BYAPR04MB4965.namprd04.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-4-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "mst@redhat.com" <mst@redhat.com>, "jasowang@redhat.com" <jasowang@redhat.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "stefanha@redhat.com" <stefanha@redhat.com>, "virtualization@lists.linux-foundation.org" <virtualization@lists.linux-foundation.org>

On 10/21/20 17:35, Mike Christie wrote:
> In the next patches vhost_dev_init will be able to fail. This patch has
> vhost_net_open use goto error handling like is done in the other vhost
> code to make handling vhost_dev_init failures easier to handle and
> extend in the future.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---

Also, not it reduces the repeated kfree() calls in the code for vqs and

n, looks good.

Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

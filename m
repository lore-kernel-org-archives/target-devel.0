From: Jason Wang <jasowang@redhat.com>
Date: Mon, 26 Oct 2020 03:51:26 +0000
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
Message-Id: <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org


On 2020/10/22 上午8:34, Mike Christie wrote:
> Each vhost-scsi device will need a evt and ctl queue, but the number
> of IO queues depends on whatever the user has configured in userspace.
> This patch has vhost-scsi create the evt, ctl and one IO vq at device
> open time. We then create the other IO vqs when userspace starts to
> set them up. We still waste some mem on the vq and scsi vq structs,
> but we don't waste mem on iovec related arrays and for later patches
> we know which queues are used by the dev->nvqs value.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/vhost/scsi.c | 19 +++++++++++++++----
>   1 file changed, 15 insertions(+), 4 deletions(-)


Not familiar with SCSI. But I wonder if it could behave like vhost-net.

E.g userspace should known the number of virtqueues so it can just open 
and close multiple vhost-scsi file descriptors.

Thanks

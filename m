From: Jason Wang <jasowang@redhat.com>
Date: Tue, 22 Sep 2020 02:01:09 +0000
Subject: Re: [PATCH 7/8] vhost: remove work arg from vhost_work_flush
Message-Id: <ce8af213-1eff-7c4e-b5e8-660267b8ff31@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-8-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1600712588-9514-8-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org


On 2020/9/22 上午2:23, Mike Christie wrote:
> vhost_work_flush doesn't do anything with the work arg. This patch drops
> it and then renames vhost_work_flush to vhost_work_dev_flush to reflect
> that the function flushes all the works in the dev and not just a
> specific queue or work item.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/scsi.c  | 4 ++--
>   drivers/vhost/vhost.c | 8 ++++----
>   drivers/vhost/vhost.h | 2 +-
>   drivers/vhost/vsock.c | 2 +-
>   4 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 8791db8..5833059 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1469,8 +1469,8 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
>   	/* Flush both the vhost poll and vhost work */
>   	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
>   		vhost_scsi_flush_vq(vs, i);
> -	vhost_work_flush(&vs->dev, &vs->vs_completion_work);
> -	vhost_work_flush(&vs->dev, &vs->vs_event_work);
> +	vhost_work_dev_flush(&vs->dev);
> +	vhost_work_dev_flush(&vs->dev);
>   
>   	/* Wait for all reqs issued before the flush to be finished */
>   	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5dd9eb1..f83674e 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -231,7 +231,7 @@ void vhost_poll_stop(struct vhost_poll *poll)
>   }
>   EXPORT_SYMBOL_GPL(vhost_poll_stop);
>   
> -void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work)
> +void vhost_work_dev_flush(struct vhost_dev *dev)
>   {
>   	struct vhost_flush_struct flush;
>   
> @@ -243,13 +243,13 @@ void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work)
>   		wait_for_completion(&flush.wait_event);
>   	}
>   }
> -EXPORT_SYMBOL_GPL(vhost_work_flush);
> +EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
>   
>   /* Flush any work that has been scheduled. When calling this, don't hold any
>    * locks that are also used by the callback. */
>   void vhost_poll_flush(struct vhost_poll *poll)
>   {
> -	vhost_work_flush(poll->dev, &poll->work);
> +	vhost_work_dev_flush(poll->dev);
>   }
>   EXPORT_SYMBOL_GPL(vhost_poll_flush);
>   
> @@ -542,7 +542,7 @@ static int vhost_attach_cgroups(struct vhost_dev *dev)
>   	attach.owner = current;
>   	vhost_work_init(&attach.work, vhost_attach_cgroups_work);
>   	vhost_work_queue(dev, &attach.work);
> -	vhost_work_flush(dev, &attach.work);
> +	vhost_work_dev_flush(dev);
>   	return attach.ret;
>   }
>   
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 3d30b3d..b91efb5 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -46,7 +46,7 @@ void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
>   void vhost_poll_stop(struct vhost_poll *poll);
>   void vhost_poll_flush(struct vhost_poll *poll);
>   void vhost_poll_queue(struct vhost_poll *poll);
> -void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work);
> +void vhost_work_dev_flush(struct vhost_dev *dev);
>   long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
>   
>   struct vhost_log {
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index a483cec..f40205f 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -652,7 +652,7 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
>   	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
>   		if (vsock->vqs[i].handle_kick)
>   			vhost_poll_flush(&vsock->vqs[i].poll);
> -	vhost_work_flush(&vsock->dev, &vsock->send_pkt_work);
> +	vhost_work_dev_flush(&vsock->dev);
>   }
>   
>   static void vhost_vsock_reset_orphans(struct sock *sk)

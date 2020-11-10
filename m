From: Jason Wang <jasowang@redhat.com>
Date: Tue, 10 Nov 2020 07:20:42 +0000
Subject: Re: [PATCH 1/5] vhost: add helper to check if a vq has been setup
Message-Id: <8ca030cf-593b-3b43-1551-7de37ebe4187@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
 <1604986403-4931-2-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1604986403-4931-2-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org


On 2020/11/10 下午1:33, Mike Christie wrote:
> This adds a helper check if a vq has been setup. The next patches
> will use this when we move the vhost scsi cmd preallocation from per
> session to per vq. In the per vq case, we only want to allocate cmds
> for vqs that have actually been setup and not for all the possible
> vqs.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/vhost/vhost.c | 6 ++++++
>   drivers/vhost/vhost.h | 1 +
>   2 files changed, 7 insertions(+)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5c835a2..a262e12 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -304,6 +304,12 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
>   	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer));
>   }
>   
> +bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
> +{
> +	return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq);
> +}
> +EXPORT_SYMBOL_GPL(vhost_vq_is_setup);
> +
>   static void vhost_vq_reset(struct vhost_dev *dev,
>   			   struct vhost_virtqueue *vq)
>   {
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index e016cd3..b063324 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -190,6 +190,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
>   		      struct vhost_log *log, unsigned int *log_num);
>   void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
>   
> +bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
>   int vhost_vq_init_access(struct vhost_virtqueue *);
>   int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
>   int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,


Acked-by: Jason Wang <jasowang@redhat.com>

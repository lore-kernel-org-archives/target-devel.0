From: Jason Wang <jasowang@redhat.com>
Date: Mon, 26 Oct 2020 03:34:45 +0000
Subject: Re: [PATCH 03/17] vhost net: use goto error handling in open
Message-Id: <8a3779da-74e6-7eff-28c4-5bfd2c981728@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-4-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-4-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org


On 2020/10/22 上午8:34, Mike Christie wrote:
> In the next patches vhost_dev_init will be able to fail. This patch has
> vhost_net_open use goto error handling like is done in the other vhost
> code to make handling vhost_dev_init failures easier to handle and
> extend in the future.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/net.c | 29 ++++++++++++++---------------
>   1 file changed, 14 insertions(+), 15 deletions(-)
>
> diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
> index 531a00d..831d824 100644
> --- a/drivers/vhost/net.c
> +++ b/drivers/vhost/net.c
> @@ -1286,27 +1286,18 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>   	if (!n)
>   		return -ENOMEM;
>   	vqs = kmalloc_array(VHOST_NET_VQ_MAX, sizeof(*vqs), GFP_KERNEL);
> -	if (!vqs) {
> -		kvfree(n);
> -		return -ENOMEM;
> -	}
> +	if (!vqs)
> +		goto err_vqs;
>   
>   	queue = kmalloc_array(VHOST_NET_BATCH, sizeof(void *),
>   			      GFP_KERNEL);
> -	if (!queue) {
> -		kfree(vqs);
> -		kvfree(n);
> -		return -ENOMEM;
> -	}
> +	if (!queue)
> +		goto err_queue;
>   	n->vqs[VHOST_NET_VQ_RX].rxq.queue = queue;
>   
>   	xdp = kmalloc_array(VHOST_NET_BATCH, sizeof(*xdp), GFP_KERNEL);
> -	if (!xdp) {
> -		kfree(vqs);
> -		kvfree(n);
> -		kfree(queue);
> -		return -ENOMEM;
> -	}
> +	if (!xdp)
> +		goto err_xdp;
>   	n->vqs[VHOST_NET_VQ_TX].xdp = xdp;
>   
>   	dev = &n->dev;
> @@ -1338,6 +1329,14 @@ static int vhost_net_open(struct inode *inode, struct file *f)
>   	n->refcnt_bias = 0;
>   
>   	return 0;
> +
> +err_xdp:
> +	kfree(queue);
> +err_queue:
> +	kfree(vqs);
> +err_vqs:
> +	kvfree(n);
> +	return -ENOMEM;
>   }
>   
>   static struct socket *vhost_net_stop_vq(struct vhost_net *n,

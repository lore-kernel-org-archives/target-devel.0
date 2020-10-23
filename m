From: Mike Christie <michael.christie@oracle.com>
Date: Fri, 23 Oct 2020 16:15:47 +0000
Subject: Re: [PATCH 04/17] vhost: prep vhost_dev_init users to handle failures
Message-Id: <8663f5b8-d743-2a75-4bf1-350e3690957b@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-5-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1603326903-27052-5-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On 10/21/20 7:34 PM, Mike Christie wrote:
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 86617bb..63ba363 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1632,14 +1632,17 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
>   		vqs[i] = &vs->vqs[i].vq;
>   		vs->vqs[i].vq.handle_kick = vhost_scsi_handle_kick;
>   	}
> -	vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
> -		       VHOST_SCSI_WEIGHT, 0, true, NULL);
> +	if (vhost_dev_init(&vs->dev, vqs, VHOST_SCSI_MAX_VQ, UIO_MAXIOV,
> +			   VHOST_SCSI_WEIGHT, 0, true, NULL))


> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index f40205f..a1a35e1 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -630,9 +630,10 @@ static int vhost_vsock_dev_open(struct inode *inode, struct file *file)
>   	vsock->vqs[VSOCK_VQ_TX].handle_kick = vhost_vsock_handle_tx_kick;
>   	vsock->vqs[VSOCK_VQ_RX].handle_kick = vhost_vsock_handle_rx_kick;
>   
> -	vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
> -		       UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
> -		       VHOST_VSOCK_WEIGHT, true, NULL);
> +	if (vhost_dev_init(&vsock->dev, vqs, ARRAY_SIZE(vsock->vqs),
> +			   UIO_MAXIOV, VHOST_VSOCK_PKT_WEIGHT,
>

Just giving myself a review comment, so it doesn't happen like last time 
where multiple people waste their time and hit the same issue :)

I will fix this one found by the kernel test robot and fix up a similar 
scsi.c case where the return value is not propagated above.

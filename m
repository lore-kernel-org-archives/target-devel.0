From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 22 Sep 2020 02:45:12 +0000
Subject: Re: [PATCH 2/8] vhost: add helper to check if a vq has been setup
Message-Id: <ce73f019-a247-7913-47fd-b3e5e7bdf81f@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On 2020-09-21 11:23, Mike Christie wrote:
> +bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
> +{
> +	if (vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq))
> +		return true;
> +	else
> +		return false;
> +}

Has it been considered changing the body of this function into
"return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq)"? I'm
concerned otherwise one or another build bot will suggest to make that
change.

Thanks,

Bart.

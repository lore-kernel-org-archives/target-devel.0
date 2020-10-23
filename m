From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Fri, 23 Oct 2020 15:46:08 +0000
Subject: Re: [PATCH 00/16 V2] vhost: fix scsi cmd handling and IOPs
Message-Id: <20201023114539-mutt-send-email-mst@kernel.org>
List-Id: <target-devel.vger.kernel.org>
References: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1602104101-5592-1-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On Wed, Oct 07, 2020 at 03:54:45PM -0500, Mike Christie wrote:
> The following patches were made over Michael's vhost branch here:
> https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost
>  
> The patches also apply to Linus's or Martin's trees if you apply
> https://patchwork.kernel.org/patch/11790681/
> which was merged into mst's tree already.
> 
> The following patches are a follow up to this post:
> https://patchwork.kernel.org/cover/11790763/
> which originally was fixing how vhost-scsi handled cmds so we would
> not get IO errors when sending more than 256 cmds.
> 
> In that patchset I needed to detect if a vq was in use and for this
> patch:
> https://patchwork.kernel.org/patch/11790685/
> it was suggested to add support for VHOST_RING_ENABLE. While doing
> that though I hit a couple problems:
> 
> 1. The patches moved how vhost-scsi allocated cmds from per lio
> session to per vhost vq. To support both VHOST_RING_ENABLE and
> where userspace didn't support it, I would have to keep around the
> old per session/device cmd allocator/completion and then also maintain
> the new code. Or, I would still have to use this patch
> patchwork.kernel.org/cover/11790763/ for the compat case so there
> adding the new ioctl would not help much.
> 
> 2. For vhost-scsi I also wanted to prevent where we allocate iovecs
> for 128 vqs even though we normally use a couple. To do this, I needed
> something similar to #1, but the problem is that the VHOST_RING_ENABLE
> call would come too late.
> 
> To try and balance #1 and #2, these patches just allow vhost-scsi
> to setup a vq when userspace starts to config it. This allows the
> driver to only fully setup (we still waste some memory to support older
> setups but do not have to preallocate everything like before) what
> is used plus I do not need to maintain 2 code paths.
> 
> Note that in this posting I am also including additional patches
> that create multiple vhost worker threads, because I wanted to see
> if people felt that maybe to support that and for this enablement
> issue we want a completely a new ioctl.
> 
> 
> V2:
> - fix use before set cpu var errors
> - drop vhost_vq_is_setup
> - include patches to do a worker thread per scsi IO vq

Stefan, Paolo, Jason any input?

-- 
MST

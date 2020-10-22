From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 22 Oct 2020 00:34:46 +0000
Subject: [PATCH 00/17 V3] vhost: fix scsi cmd handling and cgroup support
Message-Id: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

In-Reply-To: 

The following patches were made over Michael's vhost branch here:

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost

They fix a couple issues with vhost-scsi when we hit the 256 cmd limit
that result in the guest getting IO errors, add LUN reset support so
devices are not offlined during transient errors, allow us to manage
vhost scsi IO with cgroups, and imrpove IOPs up to 2X.

The following patches are a follow up to this post:
https://patchwork.kernel.org/project/target-devel/cover/1600712588-9514-1-git-send-email-michael.christie@oracle.com/
which originally was fixing how vhost-scsi handled cmds so we would
not get IO errors when sending more than 256 cmds.

In that patchset I needed to detect if a vq was in use and for this
patch:
https://patchwork.kernel.org/project/target-devel/patch/1600712588-9514-3-git-send-email-michael.christie@oracle.com/
It was suggested to add support for VHOST_RING_ENABLE. While doing
that though I hit a couple problems:

1. The patches moved how vhost-scsi allocated cmds from per lio
session to per vhost vq. To support both VHOST_RING_ENABLE and
where userspace didn't support it, I would have to keep around the
old per session/device cmd allocator/completion and then also maintain
the new code. Or, I would still have to use this patch
patchwork.kernel.org/cover/11790763/ for the compat case so there
adding the new ioctl would not help much.

2. For vhost-scsi I also wanted to prevent where we allocate iovecs
for 128 vqs even though we normally use a couple. To do this, I needed
something similar to #1, but the problem is that the VHOST_RING_ENABLE
call would come too late.

To try and balance #1 and #2, these patches just allow vhost-scsi
to setup a vq when userspace starts to config it. This allows the
driver to only fully setup (we still waste some memory to support older
setups but do not have to preallocate everything like before) what
is used plus I do not need to maintain 2 code paths.

V3:
- fix compile errors
- fix possible crash where cmd could be freed while adding it to
completion list
- fix issue where we added the worker thread to the blk cgroup but
the blk IO was submitted by a driver workqueue.

V2:
- fix use before set cpu var errors
- drop vhost_vq_is_setup
- include patches to do a worker thread per scsi IO vq

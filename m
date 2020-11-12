From: Mike Christie <michael.christie@oracle.com>
Date: Thu, 12 Nov 2020 23:18:59 +0000
Subject: [PATCH 00/10] vhost/qemu: thread per IO SCSI vq
Message-Id: <1605223150-10888-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: stefanha@redhat.com, qemu-devel@nongnu.org, fam@euphon.net, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, virtualization@lists.linux-foundation.org

The following kernel patches were made over Michael's vhost branch:

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost

and the vhost-scsi bug fix patchset:

https://lore.kernel.org/linux-scsi/20201112170008.GB1555653@stefanha-x1.localdomain/T/#t

And the qemu patch was made over the qemu master branch.

vhost-scsi currently supports multiple queues with the num_queues
setting, but we end up with a setup where the guest's scsi/block
layer can do a queue per vCPU and the layers below vhost can do
a queue per CPU. vhost-scsi will then do a num_queue virtqueues,
but all IO gets set on and completed on a single vhost-scsi thread.
After 2 - 4 vqs this becomes a bottleneck.

This patchset allows us to create a worker thread per IO vq, so we
can better utilize multiple CPUs with the multiple queues. It
implments Jason's suggestion to create the initial worker like
normal, then create the extra workers for IO vqs with the
VHOST_SET_VRING_ENABLE ioctl command added in this patchset.

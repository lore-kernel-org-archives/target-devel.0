From: Mike Christie <michael.christie@oracle.com>
Date: Tue, 10 Nov 2020 05:33:18 +0000
Subject: [PATCH 0/5 V5] vhost-scsi: IO error fixups
Message-Id: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

The following patches were made over Michael's vhost branch:

https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git/log/?h=vhost

They fixe a couple issues where the guest is getting IO errors:
1. The admin may set num_queues and cmd_per_lun/virtqueue_size
in a way that allows the guest to send more IO that vhost-scsi
was coded for.

2. A race where vhost-scsi completes the cmd to the guest before
it's fully completed in the target/vhost-scsi layers so if the
guest sends a new IO too quicky we fail it.

3. If the real/physical storage (lio backend device) hits a transient
error then vhost-scsi would fail commands instead of relying on
the lower levels error recovery to do what the admin had set up.

V5:
- Bring back V1 but move flush patches to a separate clean up set
- Modify test in vhost_vq_is_setup

V4:
- really really fix compile errors
- dropped threading patches so we can figure that out separately.

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

From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 22 Sep 2020 02:48:04 +0000
Subject: Re: [PATCH 4/8] vhost scsi: fix cmd completion race
Message-Id: <cf8e5b11-dfd2-4570-1dab-25486c591dde@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-5-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1600712588-9514-5-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On 2020-09-21 11:23, Mike Christie wrote:
> We might not do the final se_cmd put from vhost_scsi_complete_cmd_work.
> If the last put happens a little later then we could race where
> vhost_scsi_complete_cmd_work does vhost_signal, the guest runs and sends
> more IO, and vhost_scsi_handle_vq runs but does not find any free cmds.
> 
> This patch has us delay completing the cmd until the last lio core ref
> is dropped. We then know that once we signal to the guest that the cmd
> is completed that if it queues a new command it will find a free cmd.

It seems weird to me to see a reference to LIO in the description of a
vhost patch? Since this driver supports more backends than LIO, shouldn't
the patch description be made more generic?

Thanks,

Bart.

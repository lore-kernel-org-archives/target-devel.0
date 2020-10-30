From: Paolo Bonzini <pbonzini@redhat.com>
Date: Fri, 30 Oct 2020 16:04:12 +0000
Subject: Re: [PATCH 09/17] vhost scsi: fix cmd completion race
Message-Id: <5c319f1a-cf4c-f522-ecde-5b6b5a2e1ddd@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-10-git-send-email-michael.christie@oracle.com>
 <20201030045053-mutt-send-email-mst@kernel.org>
In-Reply-To: <20201030045053-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Michael S. Tsirkin" <mst@redhat.com>, Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, jasowang@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On 30/10/20 09:51, Michael S. Tsirkin wrote:
> On Wed, Oct 21, 2020 at 07:34:55PM -0500, Mike Christie wrote:
>> We might not do the final se_cmd put from vhost_scsi_complete_cmd_work.
>> When the last put happens a little later then we could race where
>> vhost_scsi_complete_cmd_work does vhost_signal, the guest runs and sends
>> more IO, and vhost_scsi_handle_vq runs but does not find any free cmds.
>>
>> This patch has us delay completing the cmd until the last lio core ref
>> is dropped. We then know that once we signal to the guest that the cmd
>> is completed that if it queues a new command it will find a free cmd.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> Paolo, could you review this one?

I don't know how LIO does all the callbacks, honestly (I have only ever
worked on the virtio-scsi driver, not vhost-scsi, and I have only ever
reviewed some virtio-scsi spec bits of vhost-scsi).

The vhost_scsi_complete_cmd_work parts look fine, but I have no idea why
vhost_scsi_queue_data_in and vhost_scsi_queue_status call.

Paolo

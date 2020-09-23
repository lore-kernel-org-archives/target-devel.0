From: Mike Christie <michael.christie@oracle.com>
Date: Wed, 23 Sep 2020 19:12:51 +0000
Subject: Re: [PATCH 2/8] vhost: add helper to check if a vq has been setup
Message-Id: <63094bae-1f26-c21e-9b3c-3a6aa99a7e24@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
 <e2d16333-d5ed-4c5c-58b3-7b5d0a9da47a@redhat.com>
In-Reply-To: <e2d16333-d5ed-4c5c-58b3-7b5d0a9da47a@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Jason Wang <jasowang@redhat.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On 9/21/20 9:02 PM, Jason Wang wrote:
> 
> On 2020/9/22 上午2:23, Mike Christie wrote:
>> This adds a helper check if a vq has been setup. The next patches
>> will use this when we move the vhost scsi cmd preallocation from per
>> session to per vq. In the per vq case, we only want to allocate cmds
>> for vqs that have actually been setup and not for all the possible
>> vqs.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/vhost/vhost.c | 9 +++++++++
>>   drivers/vhost/vhost.h | 1 +
>>   2 files changed, 10 insertions(+)
>>
>> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
>> index b45519c..5dd9eb1 100644
>> --- a/drivers/vhost/vhost.c
>> +++ b/drivers/vhost/vhost.c
>> @@ -305,6 +305,15 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
>>       spin_lock_init(&call_ctx->ctx_lock);
>>   }
>>   +bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
>> +{
>> +    if (vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq))
>> +        return true;
>> +    else
>> +        return false;
>> +}
>> +EXPORT_SYMBOL_GPL(vhost_vq_is_setup);
> 
> 
> This is probably ok but I wonder maybe we should have something like what vDPA did (VHOST_SET_VRING_ENABLE) to match virtio 1.0 device definition.

It looks like I can make that work. Some questions:

1. Do you mean a generic VHOST_SET_VRING_ENABLE or a SCSI specific one VHOST_SCSI_SET_VRING_ENABLE?

2. I can see the VHOST_VDPA_SET_VRING_ENABLE kernel code and the vhost_set_vring_enable qemu code, so I have an idea of how it should work for vhost scsi. However, I'm not sure the requirements for a generic VHOST_SET_VRING_ENABLE if that is what you meant. I could not find it in the spec either. Could you send me a pointer to the section?

For example, for vhost-net we seem to enable a device in the VHOST_NET_SET_BACKEND ioctl, so I'm not sure what behavior should be or needs to be implemented for net and vsock.

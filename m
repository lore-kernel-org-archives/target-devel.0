From: Jason Wang <jasowang@redhat.com>
Date: Wed, 28 Oct 2020 01:55:15 +0000
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
Message-Id: <adcaeb64-b1da-2195-6656-ecc19f12e5ed@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
 <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
In-Reply-To: <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org


On 2020/10/27 下午1:47, Mike Christie wrote:
> On 10/25/20 10:51 PM, Jason Wang wrote:
>>
>> On 2020/10/22 上午8:34, Mike Christie wrote:
>>> Each vhost-scsi device will need a evt and ctl queue, but the number
>>> of IO queues depends on whatever the user has configured in userspace.
>>> This patch has vhost-scsi create the evt, ctl and one IO vq at device
>>> open time. We then create the other IO vqs when userspace starts to
>>> set them up. We still waste some mem on the vq and scsi vq structs,
>>> but we don't waste mem on iovec related arrays and for later patches
>>> we know which queues are used by the dev->nvqs value.
>>>
>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>> ---
>>>   drivers/vhost/scsi.c | 19 +++++++++++++++----
>>>   1 file changed, 15 insertions(+), 4 deletions(-)
>>
>>
>> Not familiar with SCSI. But I wonder if it could behave like vhost-net.
>>
>> E.g userspace should known the number of virtqueues so it can just 
>> open and close multiple vhost-scsi file descriptors.
>>
>
> One hiccup I'm hitting is that we might end up creating about 3x more 
> vqs than we need. The problem is that for scsi each vhost device has:
>
> vq=0: special control vq
> vq=1: event vq
> vq=2 and above: SCSI CMD/IO vqs. We want to create N of these.
>
> Today we do:
>
> Uerspace does open(/dev/vhost-scsi)
>         vhost_dev_init(create 128 vqs and then later we setup and use 
> N of them);
>
> Qemu does ioctl(VHOST_SET_OWNER)
>         vhost_dev_set_owner()
>
> For N vqs userspace does:
>         // virtqueue setup related ioctls
>
> Qemu does ioctl(VHOST_SCSI_SET_ENDPOINT)
>         - match LIO/target port to vhost_dev
>
>
> So we could change that to:
>
> For N IO vqs userspace does
>         open(/dev/vhost-scsi)
>                 vhost_dev_init(create IO, evt, and ctl);
>
> for N IO vqs Qemu does:
>         ioctl(VHOST_SET_OWNER)
>                 vhost_dev_set_owner()
>
> for N IO vqs Qemu does:
>         // virtqueue setup related ioctls
>
> for N IO vqs Qemu does:
>         ioctl(VHOST_SCSI_SET_ENDPOINT)
>                 - match LIO/target port to vhost_dev and assemble the 
> multiple vhost_dev device.
>
> The problem is that we have to setup some of the evt/ctl specific 
> parts at open() time when vhost_dev_init does vhost_poll_init for 
> example.
>
> - At open time, we don't know if this vhost_dev is going to be part of 
> a multiple vhost_device device or a single one so we need to create at 
> least 3 of them
> - If it is a multiple device we don't know if its the first device 
> being created for the device or the N'th, so we don't know if the 
> dev's vqs will be used for IO or ctls/evts, so we have to create all 3.
>
> When we get the first VHOST_SCSI_SET_ENDPOINT call for a new style 
> multiple vhost_dev device, we can use that dev's evt/ctl vqs for 
> events/controls requests. When we get the other 
> VHOST_SCSI_SET_ENDPOINT calls for the multiple vhost_dev device then 
> those dev's evt/ctl vqs will be ignored and we will only use their IO 
> vqs. So we end up with a lot of extra vqs.


Right, so in this case we can use this patch to address this issue 
probably. If evt/ctl vq is not used, we won't even create them.


>
>
> One other question/issue I have is that qemu can open the 
> /dev/vhost-scsi device or it allows tools like libvirtd to open the 
> device and pass in the fd to use.


It allows libvirt to open and pass fds to qemu. This is how multie-queue 
virtio-net is done, libvirt is in charge of opening multiple file 
descriptors and pass them to qemu.


> For the latter case, would we continue to have those tools pass in the 
> leading fd, then have qemu do the other num_queues - 1 
> open(/dev/vhost-scsi) calls? Or do these apps that pass in the fd need 
> to know about all of the fds for some management reason?


Usually qemu is running without privilege. So it depends on the 
management to open the device.

Note that I'm not object your proposal, just want to see if it could be 
done via a more easy way. During the development if multiqueue 
virito-net, something similar as you've done was proposed but we end up 
with the multiple vhost-net fd model which keeps kernel code unchanged.

Thanks

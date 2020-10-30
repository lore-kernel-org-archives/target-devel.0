From: Mike Christie <michael.christie@oracle.com>
Date: Fri, 30 Oct 2020 17:26:54 +0000
Subject: Re: [PATCH 07/17] vhost scsi: support delayed IO vq creation
Message-Id: <e78d5787-45f5-4b94-9d3b-116639af3c1c@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-8-git-send-email-michael.christie@oracle.com>
 <9e97ea2a-bc57-d4aa-4711-35dba20b3b9e@redhat.com>
 <49c2fc29-348c-06db-4823-392f7476d318@oracle.com>
 <20201030044402-mutt-send-email-mst@kernel.org>
 <d53ae860-5b7e-7fd6-d34b-122c03162be1@oracle.com>
In-Reply-To: <d53ae860-5b7e-7fd6-d34b-122c03162be1@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, pbonzini@redhat.com, stefanha@redhat.com, virtualization@lists.linux-foundation.org

On 10/30/20 11:30 AM, Mike Christie wrote:
> On 10/30/20 3:47 AM, Michael S. Tsirkin wrote:
>> On Tue, Oct 27, 2020 at 12:47:34AM -0500, Mike Christie wrote:
>>> On 10/25/20 10:51 PM, Jason Wang wrote:
>>>>
>>>> On 2020/10/22 上午8:34, Mike Christie wrote:
>>>>> Each vhost-scsi device will need a evt and ctl queue, but the number
>>>>> of IO queues depends on whatever the user has configured in userspace.
>>>>> This patch has vhost-scsi create the evt, ctl and one IO vq at device
>>>>> open time. We then create the other IO vqs when userspace starts to
>>>>> set them up. We still waste some mem on the vq and scsi vq structs,
>>>>> but we don't waste mem on iovec related arrays and for later patches
>>>>> we know which queues are used by the dev->nvqs value.
>>>>>
>>>>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>>>>> ---
>>>>>    drivers/vhost/scsi.c | 19 +++++++++++++++----
>>>>>    1 file changed, 15 insertions(+), 4 deletions(-)
>>>>
>>>>
>>>> Not familiar with SCSI. But I wonder if it could behave like vhost-net.
>>>>
>>>> E.g userspace should known the number of virtqueues so it can just open
>>>> and close multiple vhost-scsi file descriptors.
>>>>
>>>
>>> One hiccup I'm hitting is that we might end up creating about 3x more 
>>> vqs
>>> than we need. The problem is that for scsi each vhost device has:
>>>
>>> vq=0: special control vq
>>> vq=1: event vq
>>> vq=2 and above: SCSI CMD/IO vqs. We want to create N of these.
>>>
>>> Today we do:
>>>
>>> Uerspace does open(/dev/vhost-scsi)
>>>          vhost_dev_init(create 128 vqs and then later we setup and 
>>> use N of
>>> them);
>>>
>>> Qemu does ioctl(VHOST_SET_OWNER)
>>>          vhost_dev_set_owner()
>>>
>>> For N vqs userspace does:
>>>          // virtqueue setup related ioctls
>>>
>>> Qemu does ioctl(VHOST_SCSI_SET_ENDPOINT)
>>>          - match LIO/target port to vhost_dev
>>>
>>>
>>> So we could change that to:
>>>
>>> For N IO vqs userspace does
>>>          open(/dev/vhost-scsi)
>>>                  vhost_dev_init(create IO, evt, and ctl);
>>>
>>> for N IO vqs Qemu does:
>>>          ioctl(VHOST_SET_OWNER)
>>>                  vhost_dev_set_owner()
>>>
>>> for N IO vqs Qemu does:
>>>          // virtqueue setup related ioctls
>>>
>>> for N IO vqs Qemu does:
>>>          ioctl(VHOST_SCSI_SET_ENDPOINT)
>>>                  - match LIO/target port to vhost_dev and assemble the
>>> multiple vhost_dev device.
>>>
>>> The problem is that we have to setup some of the evt/ctl specific 
>>> parts at
>>> open() time when vhost_dev_init does vhost_poll_init for example.
>>>
>>> - At open time, we don't know if this vhost_dev is going to be part of a
>>> multiple vhost_device device or a single one so we need to create at 
>>> least 3
>>> of them
>>> - If it is a multiple device we don't know if its the first device being
>>> created for the device or the N'th, so we don't know if the dev's vqs 
>>> will
>>> be used for IO or ctls/evts, so we have to create all 3.
>>>
>>> When we get the first VHOST_SCSI_SET_ENDPOINT call for a new style 
>>> multiple
>>> vhost_dev device, we can use that dev's evt/ctl vqs for events/controls
>>> requests. When we get the other VHOST_SCSI_SET_ENDPOINT calls for the
>>> multiple vhost_dev device then those dev's evt/ctl vqs will be 
>>> ignored and
>>> we will only use their IO vqs. So we end up with a lot of extra vqs.
>>
>> The issue Jason's hinting at is how can admins control the amount
>> of resources a given qemu instance can consume?
>> After all vhost vqs all live in host kernel memory ...
>> Limiting # of open fds would be one way to do that ...
> 
> If I understand you, then the answer is vhost scsi has a setting 
> num_queues already that controls the number of vqs. The upstream 
> kernel's vhost scsi driver and qemu's vhost scsi code support multiqueue 
> today. To enable it, the admin is setting the qemu property num_queues 
> (qemu/hw/scsi/host-scsi.c). In the current code, we are already doing 
> what I described in "Today we do:".
> 
> In the second chunk of patches (patches 13 - 16) I'm just trying to make 
> it so vhost-scsi gets a thread per IO vq.
> 
> Patch 17 then fixes up the cgroup support so the user can control the IO 
> vqs with cgroups. Today for vhost scsi the vhost work thread takes the 
> request from the vq, then passes it to a workqueue_struct workqueue to 
> submit it to the block layer. So today we are putting the vhost work 
> thread in the cgroup, but it's a different thread interacting with the 
> block layer, and the cgroup settings/limits are not applying.
> 

Ah, I think I did misundestand you. Today, you can set the fd limit to N 
and that would limit the total number of devices. But right now the user 
can set each of those N device's to have anywhere from num_queues=1 - 
128 which could be a wide range of resource use. You want something 
finer grained right?

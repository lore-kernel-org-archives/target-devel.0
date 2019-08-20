From: Mike Christie <mchristi@redhat.com>
Date: Tue, 20 Aug 2019 17:19:25 +0000
Subject: Re: [PATCH v2 1/2] scsi: target/tcm_loop: ignore already deleted scsi device
Message-Id: <5D5C2B9D.1070307@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190820090429.1961085-1-naohiro.aota@wdc.com>
 <1973f310-ad00-ff88-fe08-a31f81dc5c33@acm.org> <5D5C1159.4030507@redhat.com>
 <737dd6be-a8c9-492c-8057-1f16b3d90519@acm.org>
In-Reply-To: <737dd6be-a8c9-492c-8057-1f16b3d90519@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, Naohiro Aota <naohiro.aota@wdc.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, "Martin K . Petersen" <martin.petersen@oracle.com>

On 08/20/2019 10:43 AM, Bart Van Assche wrote:
> On 8/20/19 8:27 AM, Mike Christie wrote:
>> tcm loop does not take a reference to the scsi_device at creation/link
>> time then need to release at removal/unlink time. The above
>> scsi_device_put is for the successful scsi_device_lookup call. tcm loop
>> works like a scsi host driver that does its own scanning via
>> scsi_add_device (maybe similar to scsi drivers that are raid cards).
>> Like other host drivers it does not take a reference to the device when
>> it is added and relies on scsi-ml to handle all that for it before doing
>> operations like queuecommand.
>>
>> The leak is if you removed the scsi_device via the scsi ml sysfs
>> interface then there is no way to completely unlink the lio port because
>> if scsi_device_lookup fails we return from the function and do not do
>> not release our refcount on the tl_tpg_port_count.
> 
> Hi Mike,
> 
> Does this mean that you think that this patch is the right way to
> address the reported issue?
> 

It fixes that very specific issue, but it leaves others. Maybe it could
be used in a patchset that builds on it?

I think we could hit issues like:

1. tcm_loop_port_unlink runs and releases tl_tpg_port_count count.
2. userspace initiated scan commands were in progress and complete.
target_fabric_port_unlink->core_dev_del_lun->core_tpg_remove_lun was
waiting for those last IOs and now completes and deletes the mapped lun
from lio.
3. scsi-ml scan completed before the unmapping and so now we have a
scsi_device but no lio lun mapping.


The problem with this is that:

1. We can hit mismatched settings like this:

A. We now have this scsi_device at LUN0, but no lio mapping. User thinks
everything got cleaned up ok, so they decide to map another lio lun.
B. tcm_loop_port_link just does a scsi_add_device which does
scsi_probe_and_add_lun with rescan=true. So the original scsi_device is
returned. It is not reprobed so whatever settings the old device has
will be used. Maybe that scsi_device was for a disk and now the user was
adding a CD.

2. And hit races like:

A. tl_tpg_port_count might now be zero so the tpg and nexus can be removed.
B. That removal can race with IO being sent to the scsi_device. If a
command has passed tcm_loop_submission_work's NULL tl_nexus check then
we will hit a NULL pointer crash later in the function.

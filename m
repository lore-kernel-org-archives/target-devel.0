From: Mike Christie <mchristi@redhat.com>
Date: Tue, 06 Aug 2019 17:42:20 +0000
Subject: Re: [PATCH] scsi: target/tcm_loop: update upper limit of LUN
Message-Id: <5D49BBFC.7020402@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190805062313.343221-1-naohiro.aota@wdc.com>
In-Reply-To: <20190805062313.343221-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/05/2019 09:45 PM, Naohiro Aota wrote:
> On Mon, Aug 05, 2019 at 11:33:26AM -0500, Mike Christie wrote:
>> On 08/05/2019 01:23 AM, Naohiro Aota wrote:
>>> targetcli-fb (or its library: rtslib-fb) allows us to create LUN up to
>>> 65535. On the other hand, the kernel driver is limiting max_lun to 0.
>>>
>>> This limitation causes an actual problem when you delete a loopback
>>> device
>>> (using /sys/class/scsi_device/${lun}/device/delete) and rescan it (using
>>> /sys/class/scsi_host/host${h}/scan). You can delete the device, but
>>> cannot
>>> rescan it because its LUN is larger than the max_lun and so the scan
>>> request results in -EINVAL error in scsi_scan_host_selected().
>>
>> How are you kicking off this rescan?
>>
>> Just to make sure I understood you, does the initial LU have LUN 0, you
>> delete that, then are you creating another LU with a LUN value that is
>> not 0?
> 
> Not exactly. I'm working on a case multiple device is added at once to
> one loopback scsi host. You can create two or more device using
> "targetcli" command and they may have their LUN larger than 0. For
> example,
> 
> $ sudo targetcli
> /backstores/fileio> cd /loopback
> /loopback> create
> Created target naa.5001405218077d66.
> /loopback> exit
> $ sudo truncate -s 1048576 /mnt/nvme/foo{1,2,3}
> $ sudo targetcli /backstores/fileio create name=foo1
> file_or_dev=/mnt/nvme/foo1
> Created fileio foo1 with size 1048576
> $ sudo targetcli /loopback/naa.5001405218077d66/luns create
> /backstores/fileio/foo1
> Created LUN 0.
> (Do the same above for foo2 and foo3)
> 
> Then, you'll see each of them has LUN 0, 1, 2 assigned: (rtslib scans
> used LUN and assign free one)
> 
> $ lsscsi
> ...
> [7:0:1:0]    disk    LIO-ORG  foo1             4.0   /dev/sdd
> [7:0:1:1]    disk    LIO-ORG  foo2             4.0   /dev/sde
> [7:0:1:2]    disk    LIO-ORG  foo3             4.0   /dev/sdf
> 
> Now, you can delete one of these device:
> 
> $ echo 1 > /sys/class/scsi_device/7\:0\:1\:2/device/delete
> $ lsscsi
> ...
> [7:0:1:0]    disk    LIO-ORG  foo1             4.0   /dev/sdd
> [7:0:1:1]    disk    LIO-ORG  foo2             4.0   /dev/sde
> 
> But, you cannot recover it by the scanning:
> 

Why are you using the scsi sysfs interface instead of the target
configfs interface?

I know the comment for max_lun says it wants to support 1 LUN, but the
code like in tcm_loop_port_link seems to support multiple LUNs, so your
patch looks like it could be ok. I would just set max_luns to the kernel
(scsi-ml/lio) limit and not some userspace value.

I think the only problem you might have with your patch is that if you
delete the device via the scsi sysfs interface you will not be able to
unmap the LUN from LIO until you add it back due to tcm_loop_port_unlink
failing to look up the device and being able to decrement the tpg refcount.

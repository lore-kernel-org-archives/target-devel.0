From: Naohiro Aota <naohiro.aota@wdc.com>
Date: Tue, 06 Aug 2019 02:45:05 +0000
Subject: Re: [PATCH] scsi: target/tcm_loop: update upper limit of LUN
Message-Id: <20190806024505.gpabcyu57vhvnrto@naota.dhcp.fujisawa.hgst.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190805062313.343221-1-naohiro.aota@wdc.com>
In-Reply-To: <20190805062313.343221-1-naohiro.aota@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Aug 05, 2019 at 11:33:26AM -0500, Mike Christie wrote:
>On 08/05/2019 01:23 AM, Naohiro Aota wrote:
>> targetcli-fb (or its library: rtslib-fb) allows us to create LUN up to
>> 65535. On the other hand, the kernel driver is limiting max_lun to 0.
>>
>> This limitation causes an actual problem when you delete a loopback device
>> (using /sys/class/scsi_device/${lun}/device/delete) and rescan it (using
>> /sys/class/scsi_host/host${h}/scan). You can delete the device, but cannot
>> rescan it because its LUN is larger than the max_lun and so the scan
>> request results in -EINVAL error in scsi_scan_host_selected().
>
>How are you kicking off this rescan?
>
>Just to make sure I understood you, does the initial LU have LUN 0, you
>delete that, then are you creating another LU with a LUN value that is
>not 0?

Not exactly. I'm working on a case multiple device is added at once to
one loopback scsi host. You can create two or more device using
"targetcli" command and they may have their LUN larger than 0. For
example,

$ sudo targetcli
/backstores/fileio> cd /loopback
/loopback> create
Created target naa.5001405218077d66.
/loopback> exit
$ sudo truncate -s 1048576 /mnt/nvme/foo{1,2,3}
$ sudo targetcli /backstores/fileio create name=foo1 file_or_dev=/mnt/nvme/foo1
Created fileio foo1 with size 1048576
$ sudo targetcli /loopback/naa.5001405218077d66/luns create /backstores/fileio/foo1
Created LUN 0.
(Do the same above for foo2 and foo3)

Then, you'll see each of them has LUN 0, 1, 2 assigned: (rtslib scans used LUN and assign free one)

$ lsscsi
...
[7:0:1:0]    disk    LIO-ORG  foo1             4.0   /dev/sdd
[7:0:1:1]    disk    LIO-ORG  foo2             4.0   /dev/sde
[7:0:1:2]    disk    LIO-ORG  foo3             4.0   /dev/sdf

Now, you can delete one of these device:

$ echo 1 > /sys/class/scsi_device/7\:0\:1\:2/device/delete
$ lsscsi
...
[7:0:1:0]    disk    LIO-ORG  foo1             4.0   /dev/sdd
[7:0:1:1]    disk    LIO-ORG  foo2             4.0   /dev/sde

But, you cannot recover it by the scanning:

$ echo "0 1 2" > /sys/class/scsi_host/host7/scan 
-bash: echo: write error: Invalid argument

This command is failing with -EINVAL because "LUN (= 2) >= max_lun (= 0)".

and, even WILDCARD scan cannot recover it.

$ echo "0 1 -" > /sys/class/scsi_host/host7/scan
$ lsscsi
...
[7:0:1:0]    disk    LIO-ORG  foo1             4.0   /dev/sdd 
[7:0:1:1]    disk    LIO-ORG  foo2             4.0   /dev/sde 

Actually, you cannot even rescan LUN 0, at least with a specific scan:

$ echo 1 > /sys/class/scsi_device/7\:0\:1\:0/device/delete 
$ echo "0 1 0" > /sys/class/scsi_host/host7/scan 
-bash: echo: write error: Invalid argument
$ lsscsi 
...
[7:0:1:1]    disk    LIO-ORG  foo2             4.0   /dev/sde 

Though, it can be revived using wildcard scan:

$ echo "0 1 -" > /sys/class/scsi_host/host7/scan
$ lsscsi
...
[7:0:1:0]    disk    LIO-ORG  foo1             4.0   /dev/sdd 
[7:0:1:1]    disk    LIO-ORG  foo2             4.0   /dev/sde 

>Is it rtslib that is giving the new LU a LUN that is not 0?

Yes. As I said above, it use the first free one.

>>
>> This commit fix the upper limit to be as same as rtslib-fb allows.
>>
>> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
>> ---
>>  drivers/target/loopback/tcm_loop.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
>> index 3305b47fdf53..3db541ad727d 100644
>> --- a/drivers/target/loopback/tcm_loop.c
>> +++ b/drivers/target/loopback/tcm_loop.c
>> @@ -336,10 +336,10 @@ static int tcm_loop_driver_probe(struct device *dev)
>>  	 */
>>  	*((struct tcm_loop_hba **)sh->hostdata) = tl_hba;
>>  	/*
>> -	 * Setup single ID, Channel and LUN for now..
>> +	 * Setup single ID, and Channel for now..
>>  	 */
>>  	sh->max_id = 2;
>> -	sh->max_lun = 0;
>> +	sh->max_lun = 65536;
>>  	sh->max_channel = 0;
>>  	sh->max_cmd_len = SCSI_MAX_VARLEN_CDB_SIZE;
>>
>>
>

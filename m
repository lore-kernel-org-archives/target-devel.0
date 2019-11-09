From: Damien Le Moal <Damien.LeMoal@wdc.com>
Date: Sat, 09 Nov 2019 02:18:43 +0000
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
Message-Id: <BYAPR04MB5816047492FC58019387A33CE77A0@BYAPR04MB5816.namprd04.prod.outlook.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191108082901.417950-1-damien.lemoal@wdc.com>
 <cefdcca4-e839-829e-54aa-b95e77825d1d@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc: Mike Christie <mchristi@redhat.com>

On 2019/11/09 1:22, Bart Van Assche wrote:
> On 11/8/19 12:29 AM, Damien Le Moal wrote:
>> Prevent recursion into the IO path under low memory conditions by using
>> GFP_NOIO in place of GFP_KERNEL when allocating a new command with
>> tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().
>>
>> Reported-by: Masato Suzuki <masato.suzuki@wdc.com>
>> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
>> ---
>>
>> Changes from v1:
>> * Added reported-by tag
>>
>>   drivers/target/target_core_user.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
> 
> The patch subject is weird. Shouldn't the patch subject start with 
> "tcmu" instead of "target: core"?

I was not sure what to put there since the file being touched is
target_core_user.c (it has both core and user). May be "target: user" is
better ?

Martin,

Please let me know if you want me to resend with a fixed header (and
what that header should be).

> Has the recursion mentioned in the patch description been observed or is 
> this a theoretical issue? I'm asking this because GFP_NOIO only prevents 
> recursion if it is used inside a block driver or filesystem. The tcmu 
> driver is neither - it submits block I/O or filesystem I/O instead of 
> implementing a block driver or filesystem. Should we really disallow 
> tcmu to use the swap subsystem?

As Mike confirmed already, the problem was observed and actually fairly
easy to recreate. Our go-to setup to test this is:

fio->XFS->dm-zoned->tcmu-runner ZBC handler (emulated ZBC
drive)->ext4->regular disk.

Without this patch and Mike's proposed prctl() patch adding NOIO through
prctl() in tcmu-runner context, memory reclaim recursions causing
deadlocks are triggered very quickly.

> 
> Thanks,
> 
> Bart.
> 
> 


-- 
Damien Le Moal
Western Digital Research

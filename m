From: Mike Christie <mchristi@redhat.com>
Date: Fri, 08 Nov 2019 16:34:16 +0000
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
Message-Id: <5DC59908.5010600@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20191108082901.417950-1-damien.lemoal@wdc.com>
 <cefdcca4-e839-829e-54aa-b95e77825d1d@acm.org>
In-Reply-To: <cefdcca4-e839-829e-54aa-b95e77825d1d@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bart Van Assche <bvanassche@acm.org>, Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org

On 11/08/2019 10:22 AM, Bart Van Assche wrote:
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
> 
> Has the recursion mentioned in the patch description been observed or is
> this a theoretical issue? I'm asking this because GFP_NOIO only prevents

Observed.

> recursion if it is used inside a block driver or filesystem. The tcmu
> driver is neither - it submits block I/O or filesystem I/O instead of
> implementing a block driver or filesystem. Should we really disallow
> tcmu to use the swap subsystem?

A common use is tcm loop on the frontend and tcmu on the backend. You
see this with virt and containers, where some app is used to interacting
SCSI devices, but then the storage is backed by something that people
didn't want to put in the kernel. It's similar to nbd when you use
AF_UNIX sockets with a local running daemon.

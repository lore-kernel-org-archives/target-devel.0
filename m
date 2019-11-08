From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 08 Nov 2019 16:22:21 +0000
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
Message-Id: <cefdcca4-e839-829e-54aa-b95e77825d1d@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191108082901.417950-1-damien.lemoal@wdc.com>
In-Reply-To: <20191108082901.417950-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org
Cc: Mike Christie <mchristi@redhat.com>

On 11/8/19 12:29 AM, Damien Le Moal wrote:
> Prevent recursion into the IO path under low memory conditions by using
> GFP_NOIO in place of GFP_KERNEL when allocating a new command with
> tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().
> 
> Reported-by: Masato Suzuki <masato.suzuki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
> 
> Changes from v1:
> * Added reported-by tag
> 
>   drivers/target/target_core_user.c | 6 +++---
>   1 file changed, 3 insertions(+), 3 deletions(-)

The patch subject is weird. Shouldn't the patch subject start with 
"tcmu" instead of "target: core"?

Has the recursion mentioned in the patch description been observed or is 
this a theoretical issue? I'm asking this because GFP_NOIO only prevents 
recursion if it is used inside a block driver or filesystem. The tcmu 
driver is neither - it submits block I/O or filesystem I/O instead of 
implementing a block driver or filesystem. Should we really disallow 
tcmu to use the swap subsystem?

Thanks,

Bart.

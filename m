From: Bart Van Assche <bvanassche@acm.org>
Date: Fri, 08 Nov 2019 17:02:45 +0000
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
Message-Id: <05e7e1e7-ac6e-eeb2-e764-00936e8a9647@acm.org>
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

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

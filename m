From: Mike Christie <mchristi@redhat.com>
Date: Tue, 01 Oct 2019 21:00:35 +0000
Subject: Re: [PATCH] target: Remove tpg_list and se_portal_group.se_tpg_node
Message-Id: <5D93BE73.3080809@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190930232224.58980-1-bvanassche@acm.org>
In-Reply-To: <20190930232224.58980-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 09/30/2019 06:22 PM, Bart Van Assche wrote:
> Maintaining tpg_list without ever iterating over it is not useful. Hence
> remove tpg_list. This patch does not change the behavior of the SCSI
> target code.
> 
> Cc: Mike Christie <mchristie@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/target/target_core_tpg.c   | 12 ------------
>  drivers/target/target_core_xcopy.c |  1 -
>  include/target/target_core_base.h  |  1 -
>  3 files changed, 14 deletions(-)
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>

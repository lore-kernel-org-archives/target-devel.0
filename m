From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 13:59:52 +0000
Subject: Re: [PATCH 05/11] target/iscsi: Define OFFLOAD_BUF_SIZE once
Message-Id: <3bc567aa-9eca-9650-7c91-51015939fe4d@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> The constant OFFLOAD_BUF_SIZE is defined twice - once in
> iscsi_target_seq_pdu_list.c and once in iscsi_target_erl1.c. Since
> that constant is not used in the former source file, remove its
> definition from that source file.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_seq_pdu_list.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
> index e446a09c886b..f65e5e584212 100644
> --- a/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
> +++ b/drivers/target/iscsi/iscsi_target_seq_pdu_list.c
> @@ -25,8 +25,6 @@
>  #include "iscsi_target_tpg.h"
>  #include "iscsi_target_seq_pdu_list.h"
>  
> -#define OFFLOAD_BUF_SIZE	32768
> -
>  #ifdef DEBUG
>  static void iscsit_dump_seq_list(struct iscsi_cmd *cmd)
>  {
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 14:00:19 +0000
Subject: Re: [PATCH 06/11] target/iscsi: Use min() in iscsit_dump_data_payload() instead of open-coding it
Message-Id: <6365cd76-dbb2-a9a9-95d1-6095120770ca@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_erl1.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_erl1.c b/drivers/target/iscsi/iscsi_target_erl1.c
> index fe9b7f1e44ac..659efafb43ec 100644
> --- a/drivers/target/iscsi/iscsi_target_erl1.c
> +++ b/drivers/target/iscsi/iscsi_target_erl1.c
> @@ -34,7 +34,7 @@
>  #include "iscsi_target_erl2.h"
>  #include "iscsi_target.h"
>  
> -#define OFFLOAD_BUF_SIZE	32768
> +#define OFFLOAD_BUF_SIZE	32768U
>  
>  /*
>   *	Used to dump excess datain payload for certain error recovery
> @@ -56,7 +56,7 @@ int iscsit_dump_data_payload(
>  	if (conn->sess->sess_ops->RDMAExtensions)
>  		return 0;
>  
> -	length = (buf_len > OFFLOAD_BUF_SIZE) ? OFFLOAD_BUF_SIZE : buf_len;
> +	length = min(buf_len, OFFLOAD_BUF_SIZE);
>  
>  	buf = kzalloc(length, GFP_ATOMIC);
>  	if (!buf) {
> @@ -67,8 +67,7 @@ int iscsit_dump_data_payload(
>  	memset(&iov, 0, sizeof(struct kvec));
>  
>  	while (offset < buf_len) {
> -		size = ((offset + length) > buf_len) ?
> -			(buf_len - offset) : length;
> +		size = min(buf_len - offset, length);
>  
>  		iov.iov_len = size;
>  		iov.iov_base = buf;
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

From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 14:00:44 +0000
Subject: Re: [PATCH 07/11] target/iscsi: Fix endianness in an error message
Message-Id: <ef430254-fa83-a967-caa0-272405e6f89a@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> Since hdr->offset is a big endian number, convert it to CPU endian
> before printing it.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 5001261f5d69..37bc8a37401d 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1460,9 +1460,9 @@ __iscsit_check_dataout_hdr(struct iscsi_conn *conn, void *buf,
>  	iscsit_mod_dataout_timer(cmd);
>  
>  	if ((be32_to_cpu(hdr->offset) + payload_length) > cmd->se_cmd.data_length) {
> -		pr_err("DataOut Offset: %u, Length %u greater than"
> -			" iSCSI Command EDTL %u, protocol error.\n",
> -			hdr->offset, payload_length, cmd->se_cmd.data_length);
> +		pr_err("DataOut Offset: %u, Length %u greater than iSCSI Command EDTL %u, protocol error.\n",
> +		       be32_to_cpu(hdr->offset), payload_length,
> +		       cmd->se_cmd.data_length);
>  		return iscsit_reject_cmd(cmd, ISCSI_REASON_BOOKMARK_INVALID, buf);
>  	}
>  
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

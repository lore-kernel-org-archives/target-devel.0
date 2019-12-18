From: Hannes Reinecke <hare@suse.de>
Date: Wed, 18 Dec 2019 11:12:52 +0000
Subject: Re: [PATCH] scsi: libfc: remove unnecessary assertion on ep variable
Message-Id: <ca12f639-2ee0-55eb-c927-c1ce97208c00@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20191217212214.30722-1-pakki001@umn.edu>
In-Reply-To: <20191217212214.30722-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, "Martin K. Petersen" <martin.petersen@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ira Weiny <ira.weiny@intel.com>, Allison Randal <allison@lohutok.net>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/17/19 10:22 PM, Aditya Pakki wrote:
> In ft_recv_write_data(), the pointer ep is dereferenced first and
> then asserts for NULL. The patch removes the unnecessary assertion.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
>   drivers/target/tcm_fc/tfc_io.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/target/tcm_fc/tfc_io.c b/drivers/target/tcm_fc/tfc_io.c
> index 1354a157e9af..6a38ff936389 100644
> --- a/drivers/target/tcm_fc/tfc_io.c
> +++ b/drivers/target/tcm_fc/tfc_io.c
> @@ -221,7 +221,6 @@ void ft_recv_write_data(struct ft_cmd *cmd, struct fc_frame *fp)
>   	ep = fc_seq_exch(seq);
>   	lport = ep->lp;
>   	if (cmd->was_ddp_setup) {
> -		BUG_ON(!ep);
>   		BUG_ON(!lport);
>   		/*
>   		 * Since DDP (Large Rx offload) was setup for this request,
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

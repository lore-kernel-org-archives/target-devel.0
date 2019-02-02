From: Mike Christie <mchristi@redhat.com>
Date: Sat, 02 Feb 2019 00:15:43 +0000
Subject: Re: [PATCH 06/16] RDMA/srpt: Fix handling of command / TMF submission failure
Message-Id: <5C54E12F.6070107@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190125183458.220477-7-bvanassche@acm.org>
In-Reply-To: <20190125183458.220477-7-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 01/25/2019 12:34 PM, Bart Van Assche wrote:
> If submitting an SRP IU to the target core fails, send the SCSI
> response "BUSY" to the initiator instead of not sending any
> response.
> 
> Reviewed-by: Hannes Reinecke <hare@suse.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 9 ++++-----
>  1 file changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 8cee8c6c6be9..4fc901d1c0c1 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -1505,7 +1505,7 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
>  			pr_err("0x%llx: parsing SRP descriptor table failed.\n",
>  			       srp_cmd->tag);
>  		}
> -		goto release_ioctx;
> +		goto busy;
>  	}
>  
>  	rc = target_submit_cmd_map_sgls(cmd, ch->sess, srp_cmd->cdb,
> @@ -1516,13 +1516,12 @@ static void srpt_handle_cmd(struct srpt_rdma_ch *ch,
>  	if (rc != 0) {
>  		pr_debug("target_submit_cmd() returned %d for tag %#llx\n", rc,
>  			 srp_cmd->tag);
> -		goto release_ioctx;
> +		goto busy;
>  	}
>  	return;
>  
> -release_ioctx:
> -	send_ioctx->state = SRPT_STATE_DONE;
> -	srpt_release_cmd(cmd);
> +busy:
> +	target_send_busy(cmd);
>  }
>  
>  static int srp_tmr_to_tcm(int fn)
> 

Can you not do transport_generic_request_failure(cmd, TCM_LUN_BUSY),
because some of the cmd's bits are not yet set?

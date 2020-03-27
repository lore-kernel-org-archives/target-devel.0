From: Christoph Hellwig <hch@infradead.org>
Date: Fri, 27 Mar 2020 09:27:27 +0000
Subject: Re: [PATCH v2 5/5] scsi: target: use the stack for XCOPY passthrough cmds
Message-Id: <20200327092727.GB7952@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200326221505.5303-1-ddiss@suse.de>
 <20200326221505.5303-6-ddiss@suse.de>
In-Reply-To: <20200326221505.5303-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org

On Thu, Mar 26, 2020 at 11:15:05PM +0100, David Disseldorp wrote:
> Reads and writes in the XCOPY loop are synchronous, so needn't be
> heap allocated / freed with each loop.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But a few cleanup opportunities if you don't mind a respin:

> -	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, src_dev, &cdb[0],
> +	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
>  				remote_port);
>  	if (rc < 0) {
> -		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
> +		ec_cmd->scsi_status = se_cmd->scsi_status;
>  		transport_generic_free_cmd(se_cmd, 0);
>  		return rc;
>  	}
> @@ -603,13 +598,14 @@ static int target_xcopy_read_source(
>  	pr_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ"
>  		" memory\n", xop->xop_data_sg, xop->xop_data_nents);
>  
> -	rc = target_xcopy_issue_pt_cmd(xpt_cmd);
> +	rc = target_xcopy_issue_pt_cmd(&xpt_cmd);
>  	if (rc < 0) {
> -		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
> +		ec_cmd->scsi_status = se_cmd->scsi_status;
>  		transport_generic_free_cmd(se_cmd, 0);
>  		return rc;
>  	}
>  
> +	transport_generic_free_cmd(se_cmd, 0);
>  	return 0;

I think this should use a common label to free the command.  Same
for the write side.

>  		if (rc < 0) {
> -			transport_generic_free_cmd(&xop->src_pt_cmd->se_cmd, 0);
>  			goto out;
>  		}

No need for the braces now.

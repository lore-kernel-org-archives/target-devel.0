From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 24 Mar 2020 09:16:33 +0000
Subject: Re: [RFC PATCH 3/5] scsi: target: avoid per-loop XCOPY buffer allocations
Message-Id: <20200324091633.GC18399@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200323165410.24423-1-ddiss@suse.de>
 <20200323165410.24423-4-ddiss@suse.de>
In-Reply-To: <20200323165410.24423-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, bvanassche@acm.org

> +	/*
> +	 * Here the previously allocated SGLs for the XCOPY are mapped zero-copy
> +	 * to the internal READ or WRITE.
> +	 */

This comments is rather pointless and a little confusing.  I'd use the
chance to kill it rather than bringing it over from the previous code.

> +	sense_rc = transport_generic_map_mem_to_cmd(cmd,
> +				xop->xop_data_sg, xop->xop_data_nents,
> +				NULL, 0);
> +	if (sense_rc) {
> +		ret = -EINVAL;
> +		goto out;
>  	}

This could simply be:

	if (transport_generic_map_mem_to_cmd(cmd, xop->xop_data_sg,
			xop->xop_data_nents, NULL, 0))
		return -EINVAL;

> +			rc = target_alloc_sgl(&xop->xop_data_sg,
> +					      &xop->xop_data_nents,
> +					      cur_bytes,
> +					      false, false);
> +			if (rc < 0) {
> +				goto out;
> +			}

			rc = target_alloc_sgl(&xop->xop_data_sg,
					&xop->xop_data_nents, cur_bytes,
					false, false);
			if (rc < 0)
				goto out;

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

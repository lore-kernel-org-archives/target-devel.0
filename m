From: Christoph Hellwig <hch@infradead.org>
Date: Tue, 19 Jun 2018 14:34:08 +0000
Subject: Re: [PATCH v2] target: fix truncated PR-in ReadKeys response
Message-Id: <20180619143408.GA30839@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20180605100025.12112-1-ddiss@suse.de>
In-Reply-To: <20180605100025.12112-1-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Disseldorp <ddiss@suse.de>
Cc: target-devel@vger.kernel.org, stable@vger.kernel.org

> +		if ((off + 8) <= cmd->data_length) {

No need for the inner braces.

> +			put_unaligned_be64(pr_reg->pr_res_key, &buf[off]);
> +			off += 8;
> +		}
> +		/*
> +		 * SPC5r17: 6.16.2 READ KEYS service action
> +		 * The ADDITIONAL LENGTH field indicates the number of bytes in
> +		 * the Reservation key list. The contents of the ADDITIONAL
> +		 * LENGTH field are not altered based on the allocation length
> +		 */
>  		add_len += 8;
>  	}
>  	spin_unlock(&dev->t10_pr.registration_lock);

Otherwise looks fine:

Reviewed-by: Christoph Hellwig <hch@lst.de>

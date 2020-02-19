From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 19 Feb 2020 17:37:48 +0000
Subject: Re: [PATCH v2 2/2] scsi: target: convert boolean se_dev_attrib types to bool
Message-Id: <b68f71dc-a0df-dfdf-2790-6e4d3ced075a@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200219130136.18946-3-ddiss@suse.de>
In-Reply-To: <20200219130136.18946-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2/19/20 5:01 AM, David Disseldorp wrote:
>   struct se_dev_attrib {
> -	int		emulate_model_alias;
> -	int		emulate_dpo;
> -	int		emulate_fua_write;
> -	int		emulate_fua_read;
> -	int		emulate_write_cache;
> +	bool		emulate_model_alias;
> +	bool		emulate_dpo;		/* deprecated */
> +	bool		emulate_fua_write;
> +	bool		emulate_fua_read;	/* deprecated */
> +	bool		emulate_write_cache;
>   	int		emulate_ua_intlck_ctrl;
> -	int		emulate_tas;
> -	int		emulate_tpu;
> -	int		emulate_tpws;
> -	int		emulate_caw;
> -	int		emulate_3pc;
> -	int		emulate_pr;
> +	bool		emulate_tas;
> +	bool		emulate_tpu;
> +	bool		emulate_tpws;
> +	bool		emulate_caw;
> +	bool		emulate_3pc;
> +	bool		emulate_pr;
>   	enum target_prot_type pi_prot_type;
>   	enum target_prot_type hw_pi_prot_type;
> -	int		pi_prot_verify;
> -	int		enforce_pr_isids;
> -	int		force_pr_aptpl;
> -	int		is_nonrot;
> -	int		emulate_rest_reord;
> +	bool		pi_prot_verify;
> +	bool		enforce_pr_isids;
> +	bool		force_pr_aptpl;
> +	bool		is_nonrot;
> +	bool		emulate_rest_reord;
>   	bool		unmap_zeroes_data;
>   	u32		hw_block_size;
>   	u32		block_size;

How about introducing an enum type for emulate_ua_intlck_ctrl? Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

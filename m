From: David Disseldorp <ddiss@suse.de>
Date: Thu, 02 Apr 2020 23:30:37 +0000
Subject: Re: [PATCH] target: tcmu: add missing pr attributes to passthrough backends
Message-Id: <20200403013037.3da74123@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200401132153.23501-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200401132153.23501-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Hi,

On Wed,  1 Apr 2020 15:21:53 +0200, Bodo Stroesser wrote:

> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index ff82b21fdcce..c5a974c5b31d 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1203,6 +1203,9 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
>  	&attr_hw_block_size,
>  	&attr_hw_max_sectors,
>  	&attr_hw_queue_depth,
> +	&attr_emulate_pr,
> +	&attr_enforce_pr_isids,
> +	&attr_force_pr_aptpl,
>  	&attr_alua_support,
>  	&attr_pgr_support,
>  	NULL,

The attr_emulate_pr addition here looks fine. If you and Mike agree to
proceed with the other two attrs then it probably makes sense to add
them via a separate patch.

Cheers, David

From: Michael Christie <mchristi@redhat.com>
Date: Wed, 01 Apr 2020 20:05:24 +0000
Subject: Re: [PATCH] target: tcmu: add missing pr attributes to passthrough backends
Message-Id: <76689136-62a7-65d7-7eb8-44c459f95aa7@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200401132153.23501-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200401132153.23501-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/01/2020 08:21 AM, Bodo Stroesser wrote:
> In commit b49d6f7885306ee636d5c1af52170f3069ccf5f7 the new attribute> emulate_pr was added.
> passthrough_parse_cdb() uses the attribute's value to distinguish,
> whether reservation commands should be rejected or not.
> But the new attribute was not added to passthrough_attrib_attrs, so in
> pscsi and tcmu - the users of passthrough_parse_cdb() - the attribute
> is not available to change parser's behavior.
> This patch adds the new attribute as well as the "pr control" attributes
> enforce_pr_isids and force_pr_aptpl to passthrough_attrib_attrs.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
>  drivers/target/target_core_configfs.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index ff82b21fdcce..c5a974c5b31d 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -1203,6 +1203,9 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
>  	&attr_hw_block_size,
>  	&attr_hw_max_sectors,
>  	&attr_hw_queue_depth,
> +	&attr_emulate_pr,

This one seems ok here, because it works for both pscsi and tcmu.

> +	&attr_enforce_pr_isids,
> +	&attr_force_pr_aptpl,

These only work for tcmu. pscsi will do whatever the physical device
does, and we can't control it. I guess the options would be:

1. Just add them above.

2. Add them above and add some TRANSPORT_FLAG_PASSTHROUGH_PGR checks in
functions like force_pr_aptpl_store like we did for the pr functions, so
the user gets some feedback if they try to use them for pscsi. We would
have to add a isid function too.

3. Export the attrs or some common lib/helper functions to get/set the
values then target_core_user.c can setup the attrs and add it to
tcmu_attrib_attrs.


>  	&attr_alua_support,
>  	&attr_pgr_support,
>  	NULL,

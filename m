From: Christoph Hellwig <hch@infradead.org>
Date: Wed, 18 Oct 2017 06:32:41 +0000
Subject: Re: [PATCH v2 2/2] target: fix ALUA state file path truncation
Message-Id: <20171018063241.GB19667@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20171017235913.16786-3-ddiss@suse.de>
In-Reply-To: <20171017235913.16786-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Wed, Oct 18, 2017 at 01:59:13AM +0200, David Disseldorp wrote:
> A sufficiently long Unit Serial string, dbroot path, and/or ALUA target
> portal group name may result in truncation of the ALUA state file path
> prior to usage. Fix this by using kasprintf() instead.
> 
> Fixes: fdddf932269a ("target: use new "dbroot" target attribute")
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_alua.c | 49 ++++++++++++++++++++++-----------------
>  drivers/target/target_core_alua.h |  9 -------
>  2 files changed, 28 insertions(+), 30 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index 928127642574..fddb2066710a 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -918,7 +918,7 @@ static int core_alua_update_tpg_primary_metadata(
>  {
>  	unsigned char *md_buf;
>  	struct t10_wwn *wwn = &tg_pt_gp->tg_pt_gp_dev->t10_wwn;
> -	char path[ALUA_METADATA_PATH_LEN];
> +	char *path;
>  	int len, rc;
>  
>  	md_buf = kzalloc(ALUA_MD_BUF_LEN, GFP_KERNEL);
> @@ -927,8 +927,6 @@ static int core_alua_update_tpg_primary_metadata(
>  		return -ENOMEM;
>  	}
>  
> -	memset(path, 0, ALUA_METADATA_PATH_LEN);
> -
>  	len = snprintf(md_buf, ALUA_MD_BUF_LEN,
>  			"tg_pt_gp_id=%hu\n"
>  			"alua_access_state=0x%02x\n"
> @@ -937,11 +935,16 @@ static int core_alua_update_tpg_primary_metadata(
>  			tg_pt_gp->tg_pt_gp_alua_access_state,
>  			tg_pt_gp->tg_pt_gp_alua_access_status);
>  
> -	snprintf(path, ALUA_METADATA_PATH_LEN,
> -		"%s/alua/tpgs_%s/%s", db_root, &wwn->unit_serial[0],
> -		config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
> +	path = kasprintf(GFP_KERNEL, "%s/alua/tpgs_%s/%s", db_root,
> +			&wwn->unit_serial[0],
> +			config_item_name(&tg_pt_gp->tg_pt_gp_group.cg_item));
> +	if (!path) {
> +		kfree(md_buf);
> +		return -ENOMEM;
> +	}
>  
>  	rc = core_alua_write_tpg_metadata(path, md_buf, len);
> +	kfree(path);
>  	kfree(md_buf);
>  	return rc;

Maybe write this as:

	rc =  -ENOMEM
	path = kasprintf(...);
	if (path) {
	  	rc = core_alua_write_tpg_metadata(path, md_buf, len);
		kfree(path);
	}
 	kfree(md_buf);
 	return rc;

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

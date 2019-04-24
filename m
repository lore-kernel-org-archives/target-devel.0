From: Mike Christie <mchristi@redhat.com>
Date: Wed, 24 Apr 2019 15:23:43 +0000
Subject: Re: [PATCH 1/1] iscsi target: fix discovery auth enforcement
Message-Id: <5CC07F7F.80004@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190424015216.16757-1-mchristi@redhat.com>
In-Reply-To: <20190424015216.16757-1-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Martin, Do not merge this patch. I am going to self nack it. It could
add a regression where CHAP is not used if an app initializes this file
to 0 during loading before it has setup CHAP then later sets up CHAP
assuming we would use CHAP,None.

On 04/23/2019 08:52 PM, Mike Christie wrote:
> If the user writes 0 to enforce_discovery_auth to disable CHAP during
> discovery we will set the AuthMethod arguments to CHAP,None even if
> there are no CHAP settings. The initiator can then only login if it has
> its AuthMethod set to only None. If it is set to CHAP,None, login will
> fail, because the target sees CHAP and will try to do that, but it will
> always fail since there are no CHAP settings setup.
> 
> This has us use CHAP,None if CHAP is setup when writing 0 to
> enforce_discovery_auth file and None if CHAP is not setup.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_configfs.c | 24 ++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index cac94c94ef5d..bfc4a7966a2d 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -1276,6 +1276,7 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
>  {
>  	struct iscsi_param *param;
>  	struct iscsi_portal_group *discovery_tpg = iscsit_global->discovery_tpg;
> +	struct iscsi_node_auth *auth = &iscsit_global->discovery_acl.node_auth;
>  	u32 op;
>  	int err;
>  
> @@ -1306,19 +1307,34 @@ static ssize_t iscsi_disc_enforce_discovery_auth_store(struct config_item *item,
>  			return -EINVAL;
>  
>  		discovery_tpg->tpg_attrib.authentication = 1;
> -		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 1;
> +		auth->enforce_discovery_auth = 1;
>  		pr_debug("LIO-CORE[0] Successfully enabled"
>  			" authentication enforcement for iSCSI"
>  			" Discovery TPG\n");
> -	} else {
> +	} else if ((auth->naf_flags & NAF_USERID_SET &&
> +		   auth->naf_flags & NAF_PASSWORD_SET) ||
> +		   (auth->naf_flags & NAF_USERID_IN_SET &&
> +		   auth->naf_flags & NAF_PASSWORD_IN_SET)) {
>  		/*
> -		 * Reset the AuthMethod key to CHAP,None
> +		 * Partially disable. Reset AuthMethod key to CHAP,None
>  		 */
>  		if (iscsi_update_param_value(param, "CHAP,None") < 0)
>  			return -EINVAL;
>  
>  		discovery_tpg->tpg_attrib.authentication = 0;
> -		iscsit_global->discovery_acl.node_auth.enforce_discovery_auth = 0;
> +		auth->enforce_discovery_auth = 0;
> +		pr_debug("LIO-CORE[0] Partially disabled"
> +			" authentication enforcement for iSCSI"
> +			" Discovery TPG\n");
> +	} else {
> +		/*
> +		 * Fully disable. Reset AuthMethod key to None
> +		 */
> +		if (iscsi_update_param_value(param, "None") < 0)
> +			return -EINVAL;
> +
> +		discovery_tpg->tpg_attrib.authentication = 0;
> +		auth->enforce_discovery_auth = 0;
>  		pr_debug("LIO-CORE[0] Successfully disabled"
>  			" authentication enforcement for iSCSI"
>  			" Discovery TPG\n");
> 

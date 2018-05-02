From: Mike Christie <mchristi@redhat.com>
Date: Wed, 02 May 2018 18:27:31 +0000
Subject: Re: [PATCHv4 1/3] target/configfs: add module wide action support
Message-Id: <5AEA0313.5050306@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1524123964-21347-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1524123964-21347-2-git-send-email-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/19/2018 02:46 AM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> For some case we need some module wide configfs to contol some
> attributes of the whole transport module.

When I suggested to move it module wide I just meant to add another mod
param like the global max data area param. I like the approach below
though, because rtslib can work similar to how it does for other
objects. However for tcmu we will have a mix of types, so I am not sure
how you are going to deal with compat. Maybe add a module level attrs
attr and add a max data area there that calls the same mod param code.
There would still be a kernel where it is not supported though.

Add some comments below if we go this route.


> 
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  drivers/target/target_core_configfs.c | 46 +++++++++++++++++++++++++++++++++++
>  drivers/target/target_core_hba.c      | 11 +++++++++
>  drivers/target/target_core_internal.h |  5 ++++
>  include/target/target_core_backend.h  |  1 +
>  4 files changed, 63 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index 3f4bf12..a1ee716 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -79,6 +79,7 @@
>  static struct config_group target_core_hbagroup;
>  static struct config_group alua_group;
>  static struct config_group alua_lu_gps_group;
> +static struct config_group action_group;
>  
>  static inline struct se_hba *
>  item_to_hba(struct config_item *item)
> @@ -1198,6 +1199,7 @@ struct configfs_attribute *passthrough_attrib_attrs[] = {
>  
>  TB_CIT_SETUP_DRV(dev_attrib, NULL, NULL);
>  TB_CIT_SETUP_DRV(dev_action, NULL, NULL);
> +TB_CIT_SETUP_DRV(mod_action, NULL, NULL);
>  
>  /* End functions for struct config_item_type tb_dev_attrib_cit */
>  
> @@ -2893,6 +2895,20 @@ static void target_core_alua_drop_tg_pt_gp(
>  
>  /* End functions for struct config_item_type target_core_alua_cit */
>  
> +/* Start functions for struct config_item_type target_core_action_cit */
> +
> +/*
> + * target_core_action_cit is a ConfigFS group that lives under
> + * /sys/kernel/config/target/core/action.
> + */
> +static const struct config_item_type target_core_action_cit = {
> +	.ct_item_ops		= NULL,
> +	.ct_attrs		= NULL,
> +	.ct_owner		= THIS_MODULE,
> +};
> +
> +/* End functions for struct config_item_type target_core_action_cit */
> +
>  /* Start functions for struct config_item_type tb_dev_stat_cit */
>  
>  static struct config_group *target_core_stat_mkdir(
> @@ -3211,6 +3227,30 @@ void target_setup_backend_cits(struct target_backend *tb)
>  	target_core_setup_dev_wwn_cit(tb);
>  	target_core_setup_dev_alua_tg_pt_gps_cit(tb);
>  	target_core_setup_dev_stat_cit(tb);
> +
> +	target_core_setup_mod_action_cit(tb);
> +}
> +
> +int target_setup_backend_action(struct target_backend *tb)


I think it might be best to rename these to:

target_register_backend_action_group
target_unregister_backend_action_group

It seems we are doing the setup and un/registration and unset is not a
common name type in the existing code.



> +{
> +	if (!tb->ops->tb_mod_action_attrs)
> +		return 0;
> +
> +	tb->action_group = configfs_register_default_group(&action_group,
> +						tb->ops->name,
> +						&tb->tb_mod_action_cit);
> +	if (!tb->action_group)

I think you need to do

if (IS_ERR(tb->action_group))


> +		return PTR_ERR(tb->action_group);
> +
> +	return 0;
> +}
> +
> +void target_unset_backend_action(struct target_backend *tb)
> +{
> +	if (!tb->ops->tb_mod_action_attrs)
> +		return;
> +
> +	configfs_unregister_default_group(tb->action_group);
>  }
>  
>  static int __init target_core_init_configfs(void)
> @@ -3267,6 +3307,12 @@ static int __init target_core_init_configfs(void)
>  	default_lu_gp = lu_gp;
>  
>  	/*
> +	 * Create ALUA infrastructure under /sys/kernel/config/target/core/action/

Fix up the ALUA reference in the comment.

> +	 */
> +	config_group_init_type_name(&action_group, "action", &target_core_action_cit);
> +	configfs_add_default_group(&action_group, &target_core_hbagroup);
> +
> +	/*
>  	 * Register the target_core_mod subsystem with configfs.
>  	 */
>  	ret = configfs_register_subsystem(subsys);
> diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_core_hba.c
> index 22390e0..6903087 100644
> --- a/drivers/target/target_core_hba.c
> +++ b/drivers/target/target_core_hba.c
> @@ -51,6 +51,7 @@
>  int transport_backend_register(const struct target_backend_ops *ops)
>  {
>  	struct target_backend *tb, *old;
> +	int ret;
>  
>  	tb = kzalloc(sizeof(*tb), GFP_KERNEL);
>  	if (!tb)
> @@ -67,11 +68,20 @@ int transport_backend_register(const struct target_backend_ops *ops)
>  		}
>  	}
>  	target_setup_backend_cits(tb);
> +
> +	ret = target_setup_backend_action(tb);
> +	if (ret) {
> +		mutex_unlock(&backend_mutex);
> +		kfree(tb);

Just do a goto since we have multiple places doing the same cleanup with
this addition.

> +		return ret;
> +	}
> +
>  	list_add_tail(&tb->list, &backend_list);
>  	mutex_unlock(&backend_mutex);
>  
>  	pr_debug("TCM: Registered subsystem plugin: %s struct module: %p\n",
>  			ops->name, ops->owner);
> +

Don't add extra formatting.


From: Xiubo Li <xiubli@redhat.com>
Date: Thu, 03 May 2018 00:54:42 +0000
Subject: Re: [PATCHv4 1/3] target/configfs: add module wide action support
Message-Id: <f65768c7-2df8-3ec4-8f58-a28beb105f9c@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1524123964-21347-2-git-send-email-xiubli@redhat.com>
In-Reply-To: <1524123964-21347-2-git-send-email-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
To: target-devel@vger.kernel.org

On 2018/5/3 2:27, Mike Christie wrote:
> On 04/19/2018 02:46 AM, xiubli@redhat.com wrote:
>> From: Xiubo Li <xiubli@redhat.com>
>>
>> For some case we need some module wide configfs to contol some
>> attributes of the whole transport module.
> When I suggested to move it module wide I just meant to add another mod
> param like the global max data area param. I like the approach below
> though, because rtslib can work similar to how it does for other
> objects. However for tcmu we will have a mix of types, so I am not sure
> how you are going to deal with compat. Maybe add a module level attrs
> attr and add a max data area there that calls the same mod param code.
> There would still be a kernel where it is not supported though.
Hey Mike,

I just thought currently approach will be more flexible.
Yeah,=A0 for the compat issue it should be a little painful to deal with.=20
It's up to you and I am okay for both approaches.

BRs
Thanks,




> Add some comments below if we go this route.
>
>
>> Signed-off-by: Xiubo Li <xiubli@redhat.com>
>> ---
>>   drivers/target/target_core_configfs.c | 46 +++++++++++++++++++++++++++=
++++++++
>>   drivers/target/target_core_hba.c      | 11 +++++++++
>>   drivers/target/target_core_internal.h |  5 ++++
>>   include/target/target_core_backend.h  |  1 +
>>   4 files changed, 63 insertions(+)
>>
>> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/targ=
et_core_configfs.c
>> index 3f4bf12..a1ee716 100644
>> --- a/drivers/target/target_core_configfs.c
>> +++ b/drivers/target/target_core_configfs.c
>> @@ -79,6 +79,7 @@
>>   static struct config_group target_core_hbagroup;
>>   static struct config_group alua_group;
>>   static struct config_group alua_lu_gps_group;
>> +static struct config_group action_group;
>>  =20
>>   static inline struct se_hba *
>>   item_to_hba(struct config_item *item)
>> @@ -1198,6 +1199,7 @@ struct configfs_attribute *passthrough_attrib_attr=
s[] =3D {
>>  =20
>>   TB_CIT_SETUP_DRV(dev_attrib, NULL, NULL);
>>   TB_CIT_SETUP_DRV(dev_action, NULL, NULL);
>> +TB_CIT_SETUP_DRV(mod_action, NULL, NULL);
>>  =20
>>   /* End functions for struct config_item_type tb_dev_attrib_cit */
>>  =20
>> @@ -2893,6 +2895,20 @@ static void target_core_alua_drop_tg_pt_gp(
>>  =20
>>   /* End functions for struct config_item_type target_core_alua_cit */
>>  =20
>> +/* Start functions for struct config_item_type target_core_action_cit */
>> +
>> +/*
>> + * target_core_action_cit is a ConfigFS group that lives under
>> + * /sys/kernel/config/target/core/action.
>> + */
>> +static const struct config_item_type target_core_action_cit =3D {
>> +	.ct_item_ops		=3D NULL,
>> +	.ct_attrs		=3D NULL,
>> +	.ct_owner		=3D THIS_MODULE,
>> +};
>> +
>> +/* End functions for struct config_item_type target_core_action_cit */
>> +
>>   /* Start functions for struct config_item_type tb_dev_stat_cit */
>>  =20
>>   static struct config_group *target_core_stat_mkdir(
>> @@ -3211,6 +3227,30 @@ void target_setup_backend_cits(struct target_back=
end *tb)
>>   	target_core_setup_dev_wwn_cit(tb);
>>   	target_core_setup_dev_alua_tg_pt_gps_cit(tb);
>>   	target_core_setup_dev_stat_cit(tb);
>> +
>> +	target_core_setup_mod_action_cit(tb);
>> +}
>> +
>> +int target_setup_backend_action(struct target_backend *tb)
>
> I think it might be best to rename these to:
>
> target_register_backend_action_group
> target_unregister_backend_action_group
>
> It seems we are doing the setup and un/registration and unset is not a
> common name type in the existing code.
>
>
>
>> +{
>> +	if (!tb->ops->tb_mod_action_attrs)
>> +		return 0;
>> +
>> +	tb->action_group =3D configfs_register_default_group(&action_group,
>> +						tb->ops->name,
>> +						&tb->tb_mod_action_cit);
>> +	if (!tb->action_group)
> I think you need to do
>
> if (IS_ERR(tb->action_group))
>
>
>> +		return PTR_ERR(tb->action_group);
>> +
>> +	return 0;
>> +}
>> +
>> +void target_unset_backend_action(struct target_backend *tb)
>> +{
>> +	if (!tb->ops->tb_mod_action_attrs)
>> +		return;
>> +
>> +	configfs_unregister_default_group(tb->action_group);
>>   }
>>  =20
>>   static int __init target_core_init_configfs(void)
>> @@ -3267,6 +3307,12 @@ static int __init target_core_init_configfs(void)
>>   	default_lu_gp =3D lu_gp;
>>  =20
>>   	/*
>> +	 * Create ALUA infrastructure under /sys/kernel/config/target/core/act=
ion/
> Fix up the ALUA reference in the comment.
>
>> +	 */
>> +	config_group_init_type_name(&action_group, "action", &target_core_acti=
on_cit);
>> +	configfs_add_default_group(&action_group, &target_core_hbagroup);
>> +
>> +	/*
>>   	 * Register the target_core_mod subsystem with configfs.
>>   	 */
>>   	ret =3D configfs_register_subsystem(subsys);
>> diff --git a/drivers/target/target_core_hba.c b/drivers/target/target_co=
re_hba.c
>> index 22390e0..6903087 100644
>> --- a/drivers/target/target_core_hba.c
>> +++ b/drivers/target/target_core_hba.c
>> @@ -51,6 +51,7 @@
>>   int transport_backend_register(const struct target_backend_ops *ops)
>>   {
>>   	struct target_backend *tb, *old;
>> +	int ret;
>>  =20
>>   	tb =3D kzalloc(sizeof(*tb), GFP_KERNEL);
>>   	if (!tb)
>> @@ -67,11 +68,20 @@ int transport_backend_register(const struct target_b=
ackend_ops *ops)
>>   		}
>>   	}
>>   	target_setup_backend_cits(tb);
>> +
>> +	ret =3D target_setup_backend_action(tb);
>> +	if (ret) {
>> +		mutex_unlock(&backend_mutex);
>> +		kfree(tb);
> Just do a goto since we have multiple places doing the same cleanup with
> this addition.
>
>> +		return ret;
>> +	}
>> +
>>   	list_add_tail(&tb->list, &backend_list);
>>   	mutex_unlock(&backend_mutex);
>>  =20
>>   	pr_debug("TCM: Registered subsystem plugin: %s struct module: %p\n",
>>   			ops->name, ops->owner);
>> +
> Don't add extra formatting.
>
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



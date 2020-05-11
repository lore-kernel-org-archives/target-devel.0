From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 11 May 2020 18:39:20 +0000
Subject: Re: [PATCH 12/15] target: add sysfs session helper functions
Message-Id: <66e9bbf8-fdb2-d819-a496-75a1dea779cf@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-13-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-13-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On 05/10/20 23:57, Mike Christie wrote:
> This patch adds helpers to add/remove a dir per session. There is only 2
> files/dirs initially.
> 

...

> +
> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
> +			     struct se_session *se_sess)
> +{
> +	int ret;
> +
> +	/*
> +	 * Copy ACL name so we don't have to worry about mixing configfs
> +	 * and sysfs refcounts.
> +	 */
> +	if (!se_sess->se_node_acl->dynamic_node_acl) {
> +		se_sess->acl_name = kstrdup(se_sess->se_node_acl->initiatorname,
> +					    GFP_KERNEL);
> +		if (!se_sess->acl_name)
> +			return -ENOMEM;
> +	}
> +
> +	ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "%s-%d",
> +			  se_sess->tpt_id->name, se_sess->sid);
> +	if (ret) {
> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
> +		       se_sess->sid, ret);
> +		goto free_acl_name;
> +	}
> +
> +	ret = add_transport_id_attrs(se_sess);
> +	if (ret)
> +		goto del_kobj;
> +
> +	if (se_sess->tfo->session_attrs) {
> +		ret = sysfs_create_group(&se_sess->kobj,
> +					 se_sess->tfo->session_attrs);
> +		if (ret)
> +			goto rm_tpt_id_grps;
> +	}
> +
> +	ret = sysfs_create_link(tcm_core_sessions_kobj, &se_sess->kobj,
> +				se_sess->kobj.name);

I would prefer to have links named "session-%d" or "%d" only, of course
with se_sess->sid as the value for '%d'.

If userspace knows the session-id only, such names make it easier to
find the corresponding link.

> +	if (ret)
> +		goto rm_fabric_grps;
> +
> +	se_sess->sysfs_added = true;
> +	return 0;
> +
> +rm_fabric_grps:
> +	if (se_sess->tfo->session_attrs)
> +		sysfs_remove_group(&se_sess->kobj, se_sess->tfo->session_attrs);
> +rm_tpt_id_grps:
> +	remove_transport_id_attrs(se_sess);
> +del_kobj:
> +	kobject_del(&se_sess->kobj);
> +free_acl_name:
> +	kfree(se_sess->acl_name);
> +	se_sess->acl_name = NULL;
> +	return ret;
> +}
> +EXPORT_SYMBOL(target_sysfs_add_session);
> +
> +void target_sysfs_remove_session(struct se_session *se_sess)
> +{
> +	/* discovery sessions are normally not added to sysfs */
> +	if (!se_sess->sysfs_added)
> +		return;
> +
> +	sysfs_remove_link(tcm_core_sessions_kobj, se_sess->kobj.name);
> +	if (se_sess->tfo->session_attrs)
> +		sysfs_remove_group(&se_sess->kobj, se_sess->tfo->session_attrs);
> +	remove_transport_id_attrs(se_sess);
> +	kobject_del(&se_sess->kobj);
> +}
> +EXPORT_SYMBOL(target_sysfs_remove_session);
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index fdf84db..04cb042 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -42,6 +42,7 @@
>   
>   static struct workqueue_struct *target_completion_wq;
>   static struct kmem_cache *se_sess_cache;
> +static DEFINE_IDA(se_sess_ida);
>   struct kmem_cache *se_ua_cache;
>   struct kmem_cache *t10_pr_reg_cache;
>   struct kmem_cache *t10_alua_lu_gp_cache;
> @@ -251,14 +252,27 @@ struct se_session *transport_alloc_session(enum target_prot_op sup_prot_ops)
>   				" se_sess_cache\n");
>   		return ERR_PTR(-ENOMEM);
>   	}
> -	ret = transport_init_session(se_sess);
> +
> +	ret = ida_simple_get(&se_sess_ida, 1, 0, GFP_KERNEL);
>   	if (ret < 0) {
> -		kmem_cache_free(se_sess_cache, se_sess);
> -		return ERR_PTR(ret);
> +		pr_err("Unable to allocate session index.\n");
> +		goto free_sess;
>   	}
> -	se_sess->sup_prot_ops = sup_prot_ops;
> +	se_sess->sid = ret;
> +
> +	ret = transport_init_session(se_sess);
> +	if (ret < 0)
> +		goto free_sid;
>   
> +	se_sess->sup_prot_ops = sup_prot_ops;
> +	target_sysfs_init_session(se_sess);
>   	return se_sess;
> +
> +free_sid:
> +	ida_simple_remove(&se_sess_ida, se_sess->sid);
> +free_sess:
> +	kmem_cache_free(se_sess_cache, se_sess);
> +	return ERR_PTR(ret);
>   }
>   EXPORT_SYMBOL(transport_alloc_session);
>   
> @@ -597,12 +611,21 @@ void transport_free_session(struct se_session *se_sess)
>   		sbitmap_queue_free(&se_sess->sess_tag_pool);
>   		kvfree(se_sess->sess_cmd_map);
>   	}
> -	target_free_transport_id(se_sess->tpt_id);
>   	percpu_ref_exit(&se_sess->cmd_count);
> -	kmem_cache_free(se_sess_cache, se_sess);
> +	kobject_put(&se_sess->kobj);
>   }
>   EXPORT_SYMBOL(transport_free_session);
>   
> +void __target_free_session(struct se_session *se_sess)
> +{
> +	kfree(se_sess->acl_name);
> +	target_free_transport_id(se_sess->tpt_id);
> +
> +	ida_simple_remove(&se_sess_ida, se_sess->sid);
> +
> +	kmem_cache_free(se_sess_cache, se_sess);
> +}
> +
>   static int target_release_res(struct se_device *dev, void *data)
>   {
>   	struct se_session *sess = data;
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index b7f7e02..34d89cb 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -9,6 +9,7 @@
>   #include <linux/semaphore.h>     /* struct semaphore */
>   #include <linux/completion.h>
>   #include <linux/kobject.h>
> +#include <linux/idr.h>
>   
>   #define TARGET_CORE_VERSION		"v5.0"
>   
> @@ -626,6 +627,7 @@ struct se_session {
>   	enum target_prot_op	sup_prot_ops;
>   	enum target_prot_type	sess_prot_type;
>   	struct se_node_acl	*se_node_acl;
> +	char			*acl_name;
>   	struct se_portal_group *se_tpg;
>   	void			*fabric_sess_ptr;
>   	struct percpu_ref	cmd_count;
> @@ -636,6 +638,10 @@ struct se_session {
>   	wait_queue_head_t	cmd_list_wq;
>   	void			*sess_cmd_map;
>   	struct sbitmap_queue	sess_tag_pool;
> +	struct kobject		kobj;
> +	int			sid;
> +	bool			sysfs_added;
> +	const struct target_core_fabric_ops *tfo;
>   };
>   
>   struct se_device;
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index ced377f..f876a05 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -74,6 +74,10 @@ struct target_core_fabric_ops {
>   	int (*queue_status)(struct se_cmd *);
>   	void (*queue_tm_rsp)(struct se_cmd *);
>   	void (*aborted_task)(struct se_cmd *);
> +
> +	/* Optional session management and sysfs callouts */
> +	const struct attribute_group *session_attrs;
> +
>   	/*
>   	 * fabric module calls for target_core_fabric_configfs.c
>   	 */
> @@ -145,7 +149,9 @@ void	transport_register_session(struct se_portal_group *,
>   void	target_put_nacl(struct se_node_acl *);
>   void	transport_deregister_session_configfs(struct se_session *);
>   void	transport_deregister_session(struct se_session *);
> -
> +void	target_sysfs_remove_session(struct se_session *se_sess);
> +int	target_sysfs_add_session(struct se_portal_group *se_tpg,
> +				 struct se_session *se_sess);
>   
>   void	transport_init_se_cmd(struct se_cmd *,
>   		const struct target_core_fabric_ops *,
> 

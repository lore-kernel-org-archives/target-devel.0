From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 08 Jun 2020 12:18:02 +0000
Subject: Re: [PATCH 11/17] target: add session sysfs class support
Message-Id: <20200608121802.GB306451@kroah.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <michael.christie@oracle.com>
Cc: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Sun, Jun 07, 2020 at 03:35:58PM -0500, Mike Christie wrote:
> +#define target_attr_show(field)						\
> +static ssize_t show_target_##field(struct device *dev,			\
> +				   struct device_attribute *attr, char *buf) \
> +{									\
> +	struct se_session *se_sess = dev_to_se_sess(dev);		\
> +									\
> +	if (!se_sess->field##_name)					\
> +		return 0;						\
> +									\
> +	return snprintf(buf, PAGE_SIZE, "%s", se_sess->field##_name);	\

Nit, you do not need to call snprintf() as you "know" your buffer is big
enough, right?  Please just use sprintf() for sysfs show functions to
enforce that.

> +/* transportID attrs */
> +#define tpt_id_attr_show(name, fmt_str)					\
> +static ssize_t show_tpid_##name(struct device *dev,			\
> +				struct device_attribute *attr, char *buf) \
> +{									\
> +	struct se_session *se_sess = dev_to_se_sess(dev);		\
> +	return snprintf(buf, PAGE_SIZE, fmt_str, se_sess->tpt_id->name); \

sprintf() as above.  Same for all of the other show calls in this file.

thanks,

greg k-h


> +}
> +
> +#define tpt_id_attr(name, fmt_str)		\
> +	tpt_id_attr_show(name, fmt_str)		\
> +static DEVICE_ATTR(name, S_IRUGO, show_tpid_##name, NULL)
> +
> +tpt_id_attr(proto, "0x%x");
> +tpt_id_attr(name, "%s");
> +
> +static ssize_t session_id_show(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct se_session *se_sess = dev_to_se_sess(dev);
> +
> +	if (!se_sess->tpt_id->session_id)
> +		return 0;
> +
> +	return snprintf(buf, PAGE_SIZE, "0x%s", se_sess->tpt_id->session_id);
> +}
> +
> +static DEVICE_ATTR(session_id, S_IRUGO, session_id_show, NULL);

DEVICE_ATTR_RO().

> +
> +static struct attribute *tpt_id_attrs[] = {
> +	&dev_attr_proto.attr,
> +	&dev_attr_name.attr,
> +	&dev_attr_session_id.attr,
> +	NULL,
> +};
> +
> +static const struct attribute_group tpt_id_group = {
> +	.name = "transport_id",
> +	.attrs = tpt_id_attrs,
> +};
> +
> +static const struct attribute_group *def_session_groups[] = {
> +	&tpt_id_group,
> +	&target_endpoint_group,
> +	NULL,
> +};
> +
> +static struct class session_class = {
> +	.owner		= THIS_MODULE,
> +	.name		= "scsi_target_session",
> +	.dev_release	= target_sysfs_session_release,
> +	.dev_groups	= def_session_groups,
> +};
> +
> +int target_sysfs_init_session(struct se_session *se_sess)
> +{
> +	int ret;
> +
> +	ret = ida_simple_get(&session_ida, 1, 0, GFP_KERNEL);
> +	if (ret < 0) {
> +		pr_err("Unable to allocate session index.\n");
> +		return ret;
> +	}
> +	se_sess->sid = ret;
> +
> +	device_initialize(&se_sess->dev);
> +	se_sess->dev.class = &session_class;
> +
> +	ret = dev_set_name(&se_sess->dev, "session-%d", se_sess->sid);
> +	if (ret)
> +		goto put_dev;
> +
> +	return 0;
> +
> +put_dev:
> +	put_device(&se_sess->dev);
> +	return ret;
> +}
> +
> +static int target_cp_endpoint_strs(struct se_portal_group *se_tpg,
> +				   struct se_session *se_sess)
> +{
> +	/*
> +	 * Copy configfs dir/object names so userspace can match the session
> +	 * to its target, and we also don't have to worry about mixing configfs
> +	 * refcounts with sysfs.
> +	 */
> +	if (!se_sess->se_node_acl->dynamic_node_acl) {
> +		se_sess->acl_name = kstrdup(se_sess->se_node_acl->initiatorname,
> +					    GFP_KERNEL);
> +		if (!se_sess->acl_name)
> +			return -ENOMEM;
> +	}
> +
> +	se_sess->target_name = kstrdup(se_tpg->se_tpg_wwn->wwn_group.cg_item.ci_name,
> +				       GFP_KERNEL);
> +	if (!se_sess->target_name)
> +		goto free_acl;
> +
> +	if (se_sess->tfo->fabric_alias)
> +		se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_alias,
> +					       GFP_KERNEL);
> +	else
> +		se_sess->fabric_name = kstrdup(se_sess->tfo->fabric_name,
> +					       GFP_KERNEL);
> +	if (!se_sess->fabric_name)
> +		goto free_target;
> +
> +	se_sess->tpg_name = kstrdup(se_tpg->tpg_group.cg_item.ci_name,
> +				    GFP_KERNEL);
> +	if (!se_sess->tpg_name)
> +		goto free_fabric;
> +
> +	return 0;
> +
> +free_fabric:
> +	kfree(se_sess->fabric_name);
> +	se_sess->fabric_name = NULL;
> +free_target:
> +	kfree(se_sess->target_name);
> +	se_sess->target_name = NULL;
> +free_acl:
> +	kfree(se_sess->acl_name);
> +	se_sess->acl_name = NULL;
> +	return -ENOMEM;
> +}
> +
> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
> +			     struct se_session *se_sess)
> +{
> +	struct t10_transport_id *tpt_id = se_sess->tpt_id;
> +	int ret;
> +
> +	if (!try_module_get(se_sess->tfo->module))
> +		return -EINVAL;
> +
> +	ret = target_cp_endpoint_strs(se_tpg, se_sess);
> +	if (ret)
> +		goto put_mod;
> +
> +	se_sess->dev.groups = se_sess->tfo->session_attr_groups;
> +	ret = device_add(&se_sess->dev);
> +	if (ret) {
> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
> +		       se_sess->sid, ret);
> +		goto free_ep_strs;
> +	}
> +
> +	pr_info("TCM added session-%d from [fabric: %s, target: %s, tpg %s, acl: %s] to [initiator port: %s%s%s]",
> +		se_sess->sid, se_sess->fabric_name, se_sess->target_name,
> +		se_sess->tpg_name, se_sess->acl_name ? se_sess->acl_name : "dynamic",
> +		tpt_id->name, tpt_id->session_id ? "," : "",
> +		tpt_id->session_id ? tpt_id->session_id : "");
> +
> +	se_sess->sysfs_added = true;
> +	return 0;
> +
> +free_ep_strs:
> +	target_free_endpoint_strs(se_sess);
> +put_mod:
> +	module_put(se_sess->tfo->module);
> +	return ret;
> +}
> +EXPORT_SYMBOL(target_sysfs_add_session);
> +
> +void target_sysfs_remove_session(struct se_session *se_sess)
> +{
> +	struct t10_transport_id *tpt_id = se_sess->tpt_id;
> +
> +	/* discovery sessions are normally not added to sysfs */
> +	if (!se_sess->sysfs_added)
> +		return;
> +	se_sess->sysfs_added = false;
> +
> +	pr_info("TCM removed session-%d from [fabric: %s, target: %s, tpg %s, acl: %s] to [initiator port: %s%s%s]",
> +		se_sess->sid, se_sess->fabric_name, se_sess->target_name,
> +		se_sess->tpg_name, se_sess->acl_name ? se_sess->acl_name : "dynamic",
> +		tpt_id->name, tpt_id->session_id ? "," : "",
> +		tpt_id->session_id ? tpt_id->session_id : "");
> +
> +	device_del(&se_sess->dev);
> +}
> +EXPORT_SYMBOL(target_sysfs_remove_session);
> +
> +void target_sysfs_init(void)
> +{
> +	class_register(&session_class);
> +}
> +
> +void target_sysfs_exit(void)
> +{
> +	class_unregister(&session_class);

I think you forgot to cleanup your ida structure here, right?

thanks,

greg k-h

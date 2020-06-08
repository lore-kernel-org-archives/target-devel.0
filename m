From: Mike Christie <michael.christie@oracle.com>
Date: Mon, 08 Jun 2020 15:35:56 +0000
Subject: Re: [PATCH 11/17] target: add session sysfs class support
Message-Id: <1bb2e8f9-d433-de3b-3c4a-2ded2fa54240@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-12-git-send-email-michael.christie@oracle.com>
 <20200608053259.GA241877@kroah.com>
In-Reply-To: <20200608053259.GA241877@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



On 6/8/20 12:32 AM, Greg Kroah-Hartman wrote:
> On Sun, Jun 07, 2020 at 03:35:58PM -0500, Mike Christie wrote:
>> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
>> +			     struct se_session *se_sess)
>> +{
>> +	struct t10_transport_id *tpt_id = se_sess->tpt_id;
>> +	int ret;
>> +
>> +	if (!try_module_get(se_sess->tfo->module))
>> +		return -EINVAL;
>> +
>> +	ret = target_cp_endpoint_strs(se_tpg, se_sess);
>> +	if (ret)
>> +		goto put_mod;
>> +
>> +	se_sess->dev.groups = se_sess->tfo->session_attr_groups;
>> +	ret = device_add(&se_sess->dev);
>> +	if (ret) {
>> +		pr_err("Could not add session%d to sysfs. Error %d.\n",
>> +		       se_sess->sid, ret);
>> +		goto free_ep_strs;
>> +	}
>> +
>> +	pr_info("TCM added session-%d from [fabric: %s, target: %s, tpg %s, acl: %s] to [initiator port: %s%s%s]",
>> +		se_sess->sid, se_sess->fabric_name, se_sess->target_name,
>> +		se_sess->tpg_name, se_sess->acl_name ? se_sess->acl_name : "dynamic",
>> +		tpt_id->name, tpt_id->session_id ? "," : "",
>> +		tpt_id->session_id ? tpt_id->session_id : "");
> 
> You have a 'struct device', so please use it, no need for pr_info(),
> always use the dev_*() calls instead.
> 
> but, when drivers and kernel code is all working properly, no need to be
> noisy at all, this should just be a dev_dbg() call, right?

I liked the info one, because the the code can work correctly, but the 
remote devices we are connecting to are normally going to hit issues.

For example every time the storage network goes down temporarily the 
driver code will call remove function, then call the add again when it 
comes back up. Having it always logged helps us figure out the root 
problem later when the customer only has logs available.

> 
>> +
>> +	se_sess->sysfs_added = true;
>> +	return 0;
>> +
>> +free_ep_strs:
>> +	target_free_endpoint_strs(se_sess);
>> +put_mod:
>> +	module_put(se_sess->tfo->module);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(target_sysfs_add_session);
> 
> I have to ask, EXPORT_SYMBOL_GPL()?
> 

Just a cp mistake. The original author/maintainer of the target code 
used the non GPL calls, and I just blindly copied it over. I will use 
the GPL ones on the resend.


I agree with your other review comments in this mail and the others and 
will fix on the resend. Thanks,

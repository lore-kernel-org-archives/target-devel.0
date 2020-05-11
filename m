From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 11 May 2020 06:30:02 +0000
Subject: Re: [PATCH 11/15] target: add sysfs support
Message-Id: <20200511063002.GA1260895@kroah.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-12-mchristi@redhat.com>
In-Reply-To: <20200510215744.21999-12-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>
Cc: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On Sun, May 10, 2020 at 04:57:40PM -0500, Mike Christie wrote:
> These next two patches add a sysfs interface that reports the target
> layer's I_T nexuses/sessions. For the non-SCSI people cc'd, this just means
> we are reporting a server's connections to remote clients.
> 
> This patch adds the upper level dirs which shows/organizes our local port
> (tpgts below) and the connection (session below). The next patch will then
> add the dirs/files for each connection/session which exports info like
> ACL/permissions and SCSI port values.
> 
> Here is the general layout:
> 
> [sys]# tree scsi_target/
> scsi_target/
> |-- fabric/target module
> |   `-- target name
> |       `-- tpgt_$target_port_group_number
> |           `-- sessions
> |               `-- initiator name - session ID number
> |                   |-- acl
> |                   `-- transport_id
> |                       |-- name
> |                       |-- proto
> |                       `-- session_id
> 
> Here is an example with the scsi target layer's iSCSI driver:
> 
> scsi_target/
> |-- iscsi
> |   `-- iqn.1999-09.com.tcmu:minna
> |       `-- tpgt_1
> |           `-- sessions
> |               `-- iqn.2005-03.com.ceph:ini1-1
> |                   |-- acl
> |                   `-- transport_id
> |                       |-- name
> |                       |-- proto
> |                       `-- session_id
> |-- fc
> |-- loopback
> |-- qla2xxx_tcm
> 
> 
> Note/Question for Greg:
> 
> We are not exporting info in the upper level dirs like "fabric/target
> module", "target name", tpgt, etc and just need those dirs to be able to
> organize/view the endpoints of the session. So, in this patch I made a new
> top level dir scsi_target and made the other dirs with
> kobject_create_and_add. It looks like we could also add device structs in
> the target related structs, use classes, and build the tree/hierarchy that
> way too. It was not clear to me when to use one or the other.

Never use kobject calls in a driver subsystem like you have here, as
those objects will not be seen by userspace tools that get uevents.
Just use real 'struct devices' if you really really need a deep
directory tree.

But I would push back here, why do you feel you want such a deep tree?
What are you getting from this?  Why do you need that "sessions"
directory at all?

Try doing this with just attributes and if you really really need it,
child devices.

> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
> 
> V3:
> - delay tpg deletion to allow fabric modules time to remove their
>   sessions.
> - Added root sessions dir for easier lookup if userspace has the
>   session id.
> 
> V2:
> - rename top level dir to scsi_target
> 
>  drivers/target/target_core_configfs.c        | 30 +++++++++++++++++++++
>  drivers/target/target_core_fabric_configfs.c | 40 ++++++++++++++++++++++++++++
>  drivers/target/target_core_internal.h        |  1 +
>  include/target/target_core_base.h            |  4 +++
>  4 files changed, 75 insertions(+)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index ff82b21f..3eb2566 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -63,6 +63,9 @@
>  	pr_debug("Setup generic %s\n", __stringify(_name));		\
>  }
>  
> +static struct kobject *tcm_core_kobj;
> +static struct kobject *tcm_core_sessions_kobj;

Static kobjects for multiple devices?

> +
>  extern struct t10_alua_lu_gp *default_lu_gp;
>  
>  static LIST_HEAD(g_tf_list);
> @@ -245,6 +248,11 @@ static struct config_group *target_core_register_fabric(
>  	}
>  	pr_debug("Target_Core_ConfigFS: REGISTER -> Located fabric:"
>  			" %s\n", tf->tf_ops->fabric_name);
> +
> +	tf->kobj = kobject_create_and_add(name, tcm_core_kobj);
> +	if (!tf->kobj)
> +		goto dec_tf;

You just created a kobject here that did not send any information to
userspace :(

What are you using this kobject for?


> +
>  	/*
>  	 * On a successful target_core_get_fabric() look, the returned
>  	 * struct target_fabric_configfs *tf will contain a usage reference.
> @@ -261,6 +269,10 @@ static struct config_group *target_core_register_fabric(
>  	pr_debug("Target_Core_ConfigFS: REGISTER -> Allocated Fabric: %s\n",
>  		 config_item_name(&tf->tf_group.cg_item));
>  	return &tf->tf_group;
> +
> +dec_tf:
> +	atomic_dec(&tf->tf_access_cnt);
> +	return ERR_PTR(-EINVAL);
>  }
>  
>  /*
> @@ -283,6 +295,9 @@ static void target_core_deregister_fabric(
>  	pr_debug("Target_Core_ConfigFS: DEREGISTER -> Releasing ci"
>  			" %s\n", config_item_name(item));
>  
> +	kobject_del(tf->kobj);
> +	kobject_put(tf->kobj);
> +
>  	configfs_remove_default_groups(&tf->tf_group);
>  	config_item_put(item);
>  }
> @@ -3538,6 +3553,15 @@ static int __init target_core_init_configfs(void)
>  
>  	target_init_dbroot();
>  
> +	tcm_core_kobj = kobject_create_and_add("scsi_target", NULL);
> +	if (!tcm_core_kobj)
> +		goto out;

A brand new sysfs root directory?  No, please do not do that at all.
Why can't you use your driver's directory?  Or your bus's directory,
what is wrong with that?

> +
> +	tcm_core_sessions_kobj = kobject_create_and_add("sessions",
> +							tcm_core_kobj);

And a subdir under that for no reason as well?  Again, no, please do not
do that.

For this reason alone I do not like this patch, no new root directories
in sysfs please unless you can really justify it.  A "mere" driver
subsystem does not pass that test at all, sorry.

thanks,

greg k-h

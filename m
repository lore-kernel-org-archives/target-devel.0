From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 28 Apr 2020 16:14:48 +0000
Subject: Re: [PATCH 02/11] target: separate acl name from port ids
Message-Id: <81c299f2-cb40-d910-f5ca-3ba0e700365f@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200428061109.3042-1-mchristi@redhat.com>
 <20200428061109.3042-3-mchristi@redhat.com>
In-Reply-To: <20200428061109.3042-3-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 2020-04-27 23:11, Mike Christie wrote:
> The PGR code assumes the ACL name is going to be based on the SPC4
> transportID type of values. The problem is that for iSCSI we have an
> extra session id as part of the SCSI port id and some fabric modules
> support or would like to support non transportID values for the ACL
> name. For example, iSCSI and SRP would like to use the source address
> for the ACL name, but that is not a valud transportID value that you
> can get in a PGR request.
> 
> This patch adds a new transport_id struct which maps to the SPC
> transportID. In the future will be used for PGR commands instead of
> the ACL name. In this patchset, it is used to export the initiator
> info in the session's sysfs dir, so tools can disply the info and
                                                ^^^^^^
                                                display?
> daemons that execute commands like PGRs in userspace can build a
> session id to I_T nexus mapping.

[ ... ]

> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -725,10 +725,11 @@ static int tcm_loop_alloc_sess_cb(struct se_portal_group *se_tpg,
>  
>  static int tcm_loop_make_nexus(
>  	struct tcm_loop_tpg *tl_tpg,
> -	const char *name)
> +	char *name)
>  {

What needs to be changed to keep the type of the argument as 'const char
*'? How about removing the target_cp_transport_id() call from
target_setup_session() and making all transports allocate the transport
ID dynamically such that target_setup_session() does not have to
duplicate the transport ID?

> +struct t10_transport_id *target_cp_transport_id(struct t10_transport_id *src)
> +{
> +	struct t10_transport_id *dst;
> +
> +	dst = kzalloc(sizeof(*dst), GFP_KERNEL);
> +	if (!dst)
> +		return NULL;
> +	dst->proto = src->proto;
> +
> +	dst->name = kstrdup(src->name, GFP_KERNEL);
> +	if (!dst->name)
> +		goto free_tpid;
> +
> +	if (src->session_id) {
> +		dst->session_id = kstrdup(src->session_id, GFP_KERNEL);
> +		if (!dst->session_id)
> +			goto free_name;
> +	}
> +
> +	return dst;
> +
> +free_name:
> +	kfree(dst->name);
> +free_tpid:
> +	kfree(dst);
> +	return NULL;
> +}
> +EXPORT_SYMBOL(target_cp_transport_id);

How about changing "cp" into "dup" in the name of the
target_cp_transport_id() function?

> -static int scsiback_make_nexus(struct scsiback_tpg *tpg,
> -				const char *name)
> +static int scsiback_make_nexus(struct scsiback_tpg *tpg, char *name)
>  {

Also for this function, is it possible to keep the type of 'name' as
'const char *'?

Thanks,

Bart.

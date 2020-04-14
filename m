From: Mike Christie <mchristi@redhat.com>
Date: Tue, 14 Apr 2020 05:28:35 +0000
Subject: Re: [RFC PATCH 3/5] target: add target_setup_session sysfs support
Message-Id: <5E954A03.7020802@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-4-mchristi@redhat.com>
In-Reply-To: <20200414051514.7296-4-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org

On 04/14/2020 12:15 AM, Mike Christie wrote:
> +/**
> + * target_setup_session - alloc and add a session to lio core
> + * @tpg: parent tpg
> + * @tag_num: if non-zero max num in-flight commands.
> + * @tag_size: if tag_num is non-zero, fabric driver's per cmd data in bytes.
> + * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
> + * @fabric_attrs: opt fabric driver session level attrs.
> + * @private: if setup_cb is non-NULL private will be passed to setup_cb.
> + * @setup_cb: opt function called before session has been added to lio core.
> + * @free_cb: function called during removal when all user refs have dropped.
> + *
> + * If the caller passes in a setup_cb that allocates resource a free_cb is
> + * required to free those resource during session removal.
> + *
> + * If the caller passes in fabric_attrs a free_cb is required, so resources
> + * it may access are freed when all users have dropped their references.
> + */
>  struct se_session *
>  target_setup_session(struct se_portal_group *tpg,
>  		     unsigned int tag_num, unsigned int tag_size,
>  		     enum target_prot_op prot_op,
> -		     const char *initiatorname, void *private,
> -		     int (*callback)(struct se_portal_group *,
> -				     struct se_session *, void *))
> +		     const char *initiatorname,
> +		     struct attribute_group *fabric_attrs, void *private,
> +		     int (*setup_cb)(struct se_portal_group *,
> +				     struct se_session *, void *),
> +		     void (*free_cb)(struct se_session *))
>  {
>  	struct se_session *sess;
> +	int rc;
>  

Hey James,

For this, I just added a single attribute group. For elx will you want
to add multiple dirs under the session? Would just an array of attribute
groups work or do you want multiple nested dirs?

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 20 Apr 2020 17:39:59 +0000
Subject: Re: [RFC PATCH 2/5] target: add sysfs session helper functions
Message-Id: <4416ba8f-5eae-9dfd-7e39-0f91d37d62e3@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-3-mchristi@redhat.com>
In-Reply-To: <20200414051514.7296-3-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org



On 04/14/20 07:15, Mike Christie wrote:
> +static ssize_t session_acl_show(struct se_session *se_sess, char *page)
> +{
> +	struct se_node_acl *acl;
> +	ssize_t len;
> +
> +	acl = se_sess->se_node_acl;
> +	if (!acl)
> +		return -ENOTCONN;
> +
> +	if (acl->dynamic_node_acl) {
> +		page[0] = '\0';
> +		len = 0;
> +	} else {
> +		len = snprintf(page, PAGE_SIZE, "%s\n", acl->initiatorname);
> +	}
> +
> +	return len;
> +}

Would it be a good idea to provide more info about initiators using
dynamic acl?

For example the file could be named "initiatorname" instead of "acl" and
always provide the initiatorname, while a boolean file "acl" could 
return "Y" or "1" for explicit acls, but "N" or "0" for dynamic acls.

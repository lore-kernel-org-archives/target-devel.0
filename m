From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 15 Apr 2020 02:37:42 +0000
Subject: Re: [RFC PATCH 3/5] target: add target_setup_session sysfs support
Message-Id: <0267ebe3-8168-ef02-b414-6d14a756277b@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-4-mchristi@redhat.com>
In-Reply-To: <20200414051514.7296-4-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org

On 2020-04-13 22:15, Mike Christie wrote:
>  struct se_session *target_setup_session(struct se_portal_group *,
>  		unsigned int, unsigned int, enum target_prot_op prot_op,
> -		const char *, void *,
> -		int (*callback)(struct se_portal_group *,
> -				struct se_session *, void *));
> +		const char *, struct attribute_group *, void *,
> +		int (*setup_cb)(struct se_portal_group *,
> +				struct se_session *, void *),
> +		void (*free_cb)(struct se_session *));

The argument list of target_setup_session() is getting really long. How
about moving the attribute_group, setup_cb and free_cb arguments into
struct target_core_fabric_ops? Would that make it easier to extend
session sysfs attribute support in the future?

Thanks,

Bart.

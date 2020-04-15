From: Bart Van Assche <bvanassche@acm.org>
Date: Wed, 15 Apr 2020 02:30:20 +0000
Subject: Re: [RFC PATCH 2/5] target: add sysfs session helper functions
Message-Id: <20ecaf0e-698c-fb9c-26fd-a1f2dc79392e@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-3-mchristi@redhat.com>
In-Reply-To: <20200414051514.7296-3-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org

On 2020-04-13 22:15, Mike Christie wrote:
> @@ -537,8 +538,15 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
>  }
>  EXPORT_SYMBOL(transport_deregister_session_configfs);
>  
> +

A single blank line is probably sufficient here?

>  void transport_free_session(struct se_session *se_sess)
>  {
> +	kobject_put(&se_sess->kobj);
> +}
> +EXPORT_SYMBOL(transport_free_session);
> +
> +void __target_free_session(struct se_session *se_sess)
> +{
>  	struct se_node_acl *se_nacl = se_sess->se_node_acl;
>  
>  	/*
> @@ -582,7 +590,6 @@ void transport_free_session(struct se_session *se_sess)
>  	percpu_ref_exit(&se_sess->cmd_count);
>  	kmem_cache_free(se_sess_cache, se_sess);
>  }
> -EXPORT_SYMBOL(transport_free_session);

Does this patch defer execution of the code inside
transport_free_session() from when transport_free_session() is called to
when the last reference to a session is dropped? Can that have
unintended side effects? How about keeping most of the code that occurs
in transport_free_session() in that function and only freeing the memory
associated with the session if the last reference is dropped?

Thanks,

Bart.

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 21 Apr 2020 14:58:38 +0000
Subject: Re: [RFC PATCH 04/12] target: use tpid in target_stat_iport_port_ident_show
Message-Id: <be44ad27-76fe-156f-6f48-11d522212db1@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200420191426.17055-1-mchristi@redhat.com>
 <20200420191426.17055-5-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-5-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com, bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 04/20/20 21:14, Mike Christie wrote:
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index 237309d..cc9c966 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -1309,8 +1309,8 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
>   	struct se_node_acl *nacl = lacl->se_lun_nacl;
>   	struct se_session *se_sess;
>   	struct se_portal_group *tpg;
> +	char *session_id = NULL;
>   	ssize_t ret;
> -	unsigned char buf[64];
>   
>   	spin_lock_irq(&nacl->nacl_sess_lock);
>   	se_sess = nacl->nacl_sess;
> @@ -1319,13 +1319,13 @@ static ssize_t target_stat_iport_port_ident_show(struct config_item *item,
>   		return -ENODEV;
>   	}
>   
> +	session_id = transport_id_get_sid(se_sess->tpid);
> +	if (!session_id)
> +		session_id = "";
>   	tpg = nacl->se_tpg;
>   	/* scsiAttIntrPortName+scsiAttIntrPortIdentifier */
> -	memset(buf, 0, 64);
> -	if (tpg->se_tpg_tfo->sess_get_initiator_sid != NULL)
> -		tpg->se_tpg_tfo->sess_get_initiator_sid(se_sess, buf, 64);
> -
> -	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname, buf);
> +	ret = snprintf(page, PAGE_SIZE, "%s+i+%s\n", nacl->initiatorname,
> +		       session_id);
>   	spin_unlock_irq(&nacl->nacl_sess_lock);
>   	return ret;
>   }
> 
AFAICS, after the change "struct se_portal_group tpg" is no longer
necessary and can be removed completely.

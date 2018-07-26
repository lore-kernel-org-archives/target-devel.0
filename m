From: Mike Christie <mchristi@redhat.com>
Date: Thu, 26 Jul 2018 17:31:41 +0000
Subject: Re: [PATCH] Revert "scsi: target/iscsi: Reduce number of __iscsit_free_cmd() callers"
Message-Id: <5B5A057D.1050101@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180726172037.2658-1-bart.vanassche@wdc.com>
In-Reply-To: <20180726172037.2658-1-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/26/2018 12:20 PM, Bart Van Assche wrote:
> The cxgbit driver expects that __iscsit_free_cmd() is called before the
> target core frees the command page list. Since this patch breaks the
> cxgbit driver, revert it.
> 
> Reported-by: Varun Prakash <varun@chelsio.com>
> Fixes: ed88f055788a ("scsi: target/iscsi: Reduce number of __iscsit_free_cmd() callers")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Varun Prakash <varun@chelsio.com>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/target/iscsi/iscsi_target.c          | 2 ++
>  drivers/target/iscsi/iscsi_target_configfs.c | 1 -
>  drivers/target/iscsi/iscsi_target_util.c     | 4 +++-
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index d547dcd625d9..8e223799347a 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -497,6 +497,8 @@ void iscsit_aborted_task(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
>  	    !(cmd->se_cmd.transport_state & CMD_T_FABRIC_STOP))
>  		list_del_init(&cmd->i_conn_node);
>  	spin_unlock_bh(&conn->cmd_lock);
> +
> +	__iscsit_free_cmd(cmd, true);
>  }
>  EXPORT_SYMBOL(iscsit_aborted_task);
>  
> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
> index 1fcd9bc7189d..95d0a22b2ad6 100644
> --- a/drivers/target/iscsi/iscsi_target_configfs.c
> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
> @@ -1544,7 +1544,6 @@ static void lio_release_cmd(struct se_cmd *se_cmd)
>  	struct iscsi_cmd *cmd = container_of(se_cmd, struct iscsi_cmd, se_cmd);
>  
>  	pr_debug("Entering lio_release_cmd for se_cmd: %p\n", se_cmd);
> -	__iscsit_free_cmd(cmd, true);
>  	iscsit_release_cmd(cmd);
>  }
>  
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 5a645b5f1eb4..8cfcf9033507 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -772,8 +772,10 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
>  	__iscsit_free_cmd(cmd, shutdown);
>  	if (se_cmd) {
>  		rc = transport_generic_free_cmd(se_cmd, shutdown);
> -		if (!rc && shutdown && se_cmd->se_sess)
> +		if (!rc && shutdown && se_cmd->se_sess) {
> +			__iscsit_free_cmd(cmd, shutdown);
>  			target_put_sess_cmd(se_cmd);
> +		}
>  	} else {
>  		iscsit_release_cmd(cmd);
>  	}
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>

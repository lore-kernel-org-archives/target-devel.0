From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 08 Oct 2020 02:15:49 +0000
Subject: Re: [PATCH 1/2] target: iscsi: prevent a race condition in iscsit_unmap_cmd()
Message-Id: <1bff131d-d451-2597-7751-fac0269a6e37@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20201007145326.56850-1-mlombard@redhat.com>
 <20201007145326.56850-2-mlombard@redhat.com>
In-Reply-To: <20201007145326.56850-2-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, michael.christie@oracle.com

On 2020-10-07 07:53, Maurizio Lombardi wrote:
> A potential race condition may occur in iscsit_unmap_cmd() if the
> __iscsit_free_cmd() function is called by two different threads.
> 
> This patch adds a spinlock to serialize the calls to
> iscsit_unmap_cmd()
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_login.c | 1 +
>  drivers/target/iscsi/iscsi_target_util.c  | 5 ++++-
>  include/target/iscsi/iscsi_target_core.h  | 1 +
>  3 files changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index 893d1b406c29..e16ceee87bba 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c
> @@ -1110,6 +1110,7 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
>  	spin_lock_init(&conn->nopin_timer_lock);
>  	spin_lock_init(&conn->response_queue_lock);
>  	spin_lock_init(&conn->state_lock);
> +	spin_lock_init(&conn->unmap_cmd_lock);
>  
>  	timer_setup(&conn->nopin_response_timer,
>  		    iscsit_handle_nopin_response_timeout, 0);
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 45ba07c6ec27..3082f5bde9fa 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -755,8 +755,11 @@ void __iscsit_free_cmd(struct iscsi_cmd *cmd, bool check_queues)
>  		iscsit_remove_cmd_from_response_queue(cmd, conn);
>  	}
>  
> -	if (conn && conn->conn_transport->iscsit_unmap_cmd)
> +	if (conn && conn->conn_transport->iscsit_unmap_cmd) {
> +		spin_lock(&conn->unmap_cmd_lock);
>  		conn->conn_transport->iscsit_unmap_cmd(conn, cmd);
> +		spin_unlock(&conn->unmap_cmd_lock);
> +	}
>  }

This looks weird to me. Shouldn't the iSCSI target code make sure that
__iscsit_free_cmd() is called once per command instead of allowing concurrent
calls of that function and serializing iscsit_unmap_cmd() calls?

Thanks,

Bart.

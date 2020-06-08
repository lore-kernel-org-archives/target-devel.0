From: Hannes Reinecke <hare@suse.de>
Date: Mon, 08 Jun 2020 06:20:20 +0000
Subject: Re: [PATCH 15/17] iscsi target: hook iscsi target into sysfs API
Message-Id: <5922c71f-3fd9-69f3-b39a-0ef28554dc4c@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-16-git-send-email-michael.christie@oracle.com>
In-Reply-To: <1591562164-9766-16-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 6/7/20 10:36 PM, Mike Christie wrote:
> Have the iscsi target export it's sessions in sysfs.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/iscsi/iscsi_target.c      | 2 ++
>   drivers/target/iscsi/iscsi_target_nego.c | 9 +++++++++
>   2 files changed, 11 insertions(+)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 4c73374..f26d364 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4383,6 +4383,8 @@ int iscsit_close_session(struct iscsi_session *sess)
>   		}
>   	}
>   
> +	target_sysfs_remove_session(sess->se_sess);
> +
>   	if (sess->sess_ops->ErrorRecoveryLevel = 2)
>   		iscsit_free_connection_recovery_entries(sess);
>   
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index c44613a2..6dcb8ff 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -359,6 +359,13 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
>   					    ISCSI_LOGIN_STATUS_NO_RESOURCES);
>   			return -1;
>   		}
> +
> +		if (target_sysfs_add_session(&conn->tpg->tpg_se_tpg,
> +					     conn->sess->se_sess)) {
> +			iscsit_tx_login_rsp(conn, ISCSI_STATUS_CLS_TARGET_ERR,
> +					    ISCSI_LOGIN_STATUS_NO_RESOURCES);
> +			return -1;
> +		}
>   	}
>   
>   	if (conn->conn_transport->iscsit_put_login_tx(conn, login,
> @@ -371,6 +378,8 @@ static int iscsi_target_do_tx_login_io(struct iscsi_conn *conn, struct iscsi_log
>   
>   err:
>   	if (login->login_complete) {
> +		target_sysfs_remove_session(conn->sess->se_sess);
> +
>   		if (conn->rx_thread && conn->rx_thread_active) {
>   			send_sig(SIGINT, conn->rx_thread, 1);
>   			complete(&conn->rx_login_comp);
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer

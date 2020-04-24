From: Mike Christie <mchristi@redhat.com>
Date: Fri, 24 Apr 2020 17:23:34 +0000
Subject: Re: [PATCH] target: iscsi: remove the iscsi_data_count structure
Message-Id: <844cc331-22a2-ed33-d9cd-fffe543a9b64@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200424113913.17237-1-mlombard@redhat.com>
In-Reply-To: <20200424113913.17237-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 4/24/20 6:39 AM, Maurizio Lombardi wrote:
> This patch removes the iscsi_data_count structure and the
> iscsit_do_rx_data() function because they are used only by rx_data()
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target_util.c | 30 +++++-------------------
>  include/target/iscsi/iscsi_target_core.h | 10 --------
>  2 files changed, 6 insertions(+), 34 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index fae85bfd790e..25677e2865be 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -1236,18 +1236,20 @@ void iscsit_print_session_params(struct iscsi_session *sess)
>  	iscsi_dump_sess_ops(sess->sess_ops);
>  }
>  
> -static int iscsit_do_rx_data(
> +int rx_data(
>  	struct iscsi_conn *conn,
> -	struct iscsi_data_count *count)
> +	struct kvec *iov,
> +	int iov_count,
> +	int data)
>  {
> -	int data = count->data_length, rx_loop = 0, total_rx = 0;
> +	int rx_loop = 0, total_rx = 0;
>  	struct msghdr msg;
>  
>  	if (!conn || !conn->sock || !conn->conn_ops)
>  		return -1;
>  
>  	memset(&msg, 0, sizeof(struct msghdr));
> -	iov_iter_kvec(&msg.msg_iter, READ, count->iov, count->iov_count, data);
> +	iov_iter_kvec(&msg.msg_iter, READ, iov, iov_count, data);
>  
>  	while (msg_data_left(&msg)) {
>  		rx_loop = sock_recvmsg(conn->sock, &msg, MSG_WAITALL);
> @@ -1264,26 +1266,6 @@ static int iscsit_do_rx_data(
>  	return total_rx;
>  }
>  
> -int rx_data(
> -	struct iscsi_conn *conn,
> -	struct kvec *iov,
> -	int iov_count,
> -	int data)
> -{
> -	struct iscsi_data_count c;
> -
> -	if (!conn || !conn->sock || !conn->conn_ops)
> -		return -1;
> -
> -	memset(&c, 0, sizeof(struct iscsi_data_count));
> -	c.iov = iov;
> -	c.iov_count = iov_count;
> -	c.data_length = data;
> -	c.type = ISCSI_RX_DATA;
> -
> -	return iscsit_do_rx_data(conn, &c);
> -}
> -
>  int tx_data(
>  	struct iscsi_conn *conn,
>  	struct kvec *iov,
> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
> index a49d37140a64..c2de9274c57a 100644
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -301,16 +301,6 @@ struct iscsi_queue_req {
>  	struct list_head	qr_list;
>  };
>  
> -struct iscsi_data_count {
> -	int			data_length;
> -	int			sync_and_steering;
> -	enum data_count_type	type;
> -	u32			iov_count;
> -	u32			ss_iov_count;
> -	u32			ss_marker_count;
> -	struct kvec		*iov;
> -};
> -
>  struct iscsi_param_list {
>  	bool			iser;
>  	struct list_head	param_list;
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>

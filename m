From: Mike Christie <mchristi@redhat.com>
Date: Wed, 22 Apr 2020 23:12:06 +0000
Subject: Re: [PATCH 1/2] iscsi-target: fix login error when receiving is too fast
Message-Id: <54e574b1-10b4-4385-11fb-773ef152fc2c@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200415080819.27327-1-houpu@bytedance.com>
 <20200415080819.27327-2-houpu@bytedance.com>
In-Reply-To: <20200415080819.27327-2-houpu@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Pu Hou <houpu@bytedance.com>, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 4/15/20 3:08 AM, Pu Hou wrote:
> iscsi_target_sk_data_ready() could be invoked indirectly
> by iscsi_target_do_login_rx() from workqueue like following:
> 
> iscsi_target_do_login_rx()
>   iscsi_target_do_login()
>     iscsi_target_do_tx_login_io()
>       iscsit_put_login_tx()
>         iscsi_login_tx_data()
>           tx_data()
>             sock_sendmsg_nosec()
>               tcp_sendmsg()
>                 release_sock()
>                   sk_backlog_rcv()
>                     tcp_v4_do_rcv()
>                       tcp_data_ready()
>                         iscsi_target_sk_data_ready()
> 
> At that time LOGIN_FLAGS_READ_ACTIVE is not cleared.
> and iscsi_target_sk_data_ready will not read data
> from the socket. And some iscsi initiator(i.e. libiscsi)
> will wait forever for a reply.
> 
> LOGIN_FLAGS_READ_ACTIVE should be cleared early just after
> doing the receive and before writing to the socket in
> iscsi_target_do_login_rx.
> 
> But sad news is that LOGIN_FLAGS_READ_ACTIVE is also used
> by sk_state_change to do login cleanup if a socket was closed
> at login time. It is supposed to be cleared after the login
> pdu is successfully processed and reponsed.
> 
> So introduce another flag LOGIN_FLAGS_WRITE_ACTIVE to cover
> the transmit part so that sk_state_change could work well
> and clear LOGIN_FLAGS_READ_ACTIVE early so that sk_data_ready
> could also work.
> 
> Signed-off-by: Pu Hou <houpu@bytedance.com>
> ---
>  drivers/target/iscsi/iscsi_target_nego.c | 29 +++++++++++++++++++++++++----
>  include/target/iscsi/iscsi_target_core.h |  1 +
>  2 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> index 685d771b51d4..950339655778 100644
> --- a/drivers/target/iscsi/iscsi_target_nego.c
> +++ b/drivers/target/iscsi/iscsi_target_nego.c
> @@ -622,6 +622,26 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  	if (rc < 0)
>  		goto err;
>  
> +	/*
> +	 * LOGIN_FLAGS_READ_ACTIVE is cleared so that sk_data_ready
> +	 * could be trigger again after this.
> +	 *
> +	 * LOGIN_FLAGS_WRITE_ACTIVE is cleared after we successfully
> +	 * processing a login pdu. So that sk_state_chage could do login

I think we need to drop "ing" from processing and do:

process a login pdu, so that sk_state_chage could do login


> +	 * cleanup as need if the socket is closed. If a delay work is
> +	 * ongoing LOGIN_FLAGS_WRITE_ACTIVE or LOGIN_FLAGS_READ_ACTIVE),
> +	 * sk_state_change will leave the cleanup to the delayed work or
> +	 * it will schedule a delayed work to do cleanup.
> +	 */
> +	if (conn->sock) {
> +		struct sock *sk = conn->sock->sk;
> +
> +		write_lock_bh(&sk->sk_callback_lock);
> +		clear_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags);
> +		set_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags);
> +		write_unlock_bh(&sk->sk_callback_lock);
> +	}
> +
>  	pr_debug("iscsi_target_do_login_rx after rx_login_io, %p, %s:%d\n",
>  			conn, current->comm, current->pid);
>  
> @@ -629,7 +649,7 @@ static void iscsi_target_do_login_rx(struct work_struct *work)
>  	if (rc < 0) {
>  		goto err;
>  	} else if (!rc) {
> -		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_READ_ACTIVE))
> +		if (iscsi_target_sk_check_and_clear(conn, LOGIN_FLAGS_WRITE_ACTIVE))
>  			goto err;
>  	} else if (rc = 1) {
>  		iscsi_target_nego_release(conn);
> @@ -670,9 +690,10 @@ static void iscsi_target_sk_state_change(struct sock *sk)
>  	state = __iscsi_target_sk_check_close(sk);
>  	pr_debug("__iscsi_target_sk_close_change: state: %d\n", state);
>  
> -	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
> -		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1 sk_state_change"
> -			 " conn: %p\n", conn);
> +	if (test_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags) ||
> +	    test_bit(LOGIN_FLAGS_WRITE_ACTIVE, &conn->login_flags)) {
> +		pr_debug("Got LOGIN_FLAGS_{READ|WRITE}_ACTIVE=1"
> +			 "sk_state_change conn: %p\n", conn);
>  		if (state)
>  			set_bit(LOGIN_FLAGS_CLOSED, &conn->login_flags);
>  		write_unlock_bh(&sk->sk_callback_lock);
> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
> index 591cd9e4692c..0c2dfc81bf8b 100644
> --- a/include/target/iscsi/iscsi_target_core.h
> +++ b/include/target/iscsi/iscsi_target_core.h
> @@ -570,6 +570,7 @@ struct iscsi_conn {
>  #define LOGIN_FLAGS_CLOSED		2
>  #define LOGIN_FLAGS_READY		4
>  #define LOGIN_FLAGS_INITIAL_PDU		8
> +#define LOGIN_FLAGS_WRITE_ACTIVE	12

12 works but seems odd. The current code uses test/set/clear_bit, so we
want these to be:

#define LOGIN_FLAGS_CLOSED 0
#define LOGIN_FLAGS_READY 1
#define LOGIN_FLAGS_INITIAL_PDU 2
#define LOGIN_FLAGS_WRITE_ACTIVE 3

right?

2, 4, 8 was probably from a time we set the bits our self like:

login_flags |= LOGIN_FLAGS_CLOSED;


>  	unsigned long		login_flags;
>  	struct delayed_work	login_work;
>  	struct iscsi_login	*login;
> 

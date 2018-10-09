From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 09 Oct 2018 13:56:29 +0000
Subject: Re: [PATCH 3/4] target: stash sess_err_stats on Data-Out timeout
Message-Id: <b43a81fd-f13c-ce3c-b3c0-dbbe600136e1@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20181009113706.27696-4-ddiss@suse.de>
In-Reply-To: <20181009113706.27696-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/9/18 4:37 AM, David Disseldorp wrote:
>   failure:
>   	spin_unlock_bh(&cmd->dataout_timeout_lock);
> +	{
> +	struct iscsi_portal_group *tpg = conn->sess->tpg;
> +	struct iscsi_tiqn *tiqn = tpg->tpg_tiqn;
> +
> +	if (tiqn) {
> +		spin_lock_bh(&tiqn->sess_err_stats.lock);
> +		strcpy(tiqn->sess_err_stats.last_sess_fail_rem_name,
> +				conn->sess->sess_ops->InitiatorName);
> +		tiqn->sess_err_stats.last_sess_failure_type > +				ISCSI_SESS_ERR_CXN_TIMEOUT;
> +		tiqn->sess_err_stats.cxn_timeout_errors++;
> +		atomic_long_inc(&conn->sess->conn_timeout_errors);
> +		spin_unlock_bh(&tiqn->sess_err_stats.lock);
> +	}
> +	}
>   	iscsit_cause_connection_reinstatement(conn, 0);
>   	iscsit_dec_conn_usage_count(conn);
>   }

Please introduce a helper function instead of not indenting a nested
code block.

Thanks,

Bart.

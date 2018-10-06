From: Christoph Hellwig <hch@lst.de>
Date: Sat, 06 Oct 2018 12:05:51 +0000
Subject: Re: [PATCH 05/17] target/core: Make sure that target_wait_for_sess_cmds() waits long enough
Message-Id: <20181006120551.GA7723@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-6-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Sep 17, 2018 at 02:35:42PM -0700, Bart Van Assche wrote:
> A session must only be released after all code that accesses the session
> structure has finished. Make sure that this is the case by introducing a
> new command counter per session that is only decremented after the
> .release_cmd() callback has finished.

Can you explain what problems we are running into right now due to the
lack of a refcount?

> @@ -2897,6 +2907,8 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
>  	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>  	se_sess->sess_tearing_down = 1;
>  	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +
> +	percpu_ref_kill_and_confirm(&se_sess->cmd_count, NULL);

This is equivalent ot a plain percpu_ref_kill call.

> @@ -2911,17 +2923,14 @@ void target_wait_for_sess_cmds(struct se_session *se_sess)
>  
>  	WARN_ON_ONCE(!se_sess->sess_tearing_down);
>  
> -	spin_lock_irq(&se_sess->sess_cmd_lock);
>  	do {
> -		ret = wait_event_interruptible_lock_irq_timeout(
> -				se_sess->cmd_list_wq,
> -				list_empty(&se_sess->sess_cmd_list),
> -				se_sess->sess_cmd_lock, 180 * HZ);
> +		ret = wait_event_timeout(se_sess->cmd_list_wq,
> +				percpu_ref_is_zero(&se_sess->cmd_count),
> +				180 * HZ);

So this is basically the big change - check for a zero reference instead
of the list_empty.

I fail to see how this makes a difference, and also why we even need a
percpu ref as the get/pull calls are under, or right next to
sess_cmd_lock critical sections.

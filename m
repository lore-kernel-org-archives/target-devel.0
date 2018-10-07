From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Sun, 07 Oct 2018 03:28:34 +0000
Subject: Re: [PATCH 05/17] target/core: Make sure that target_wait_for_sess_cmds() waits long enough
Message-Id: <1538882914.14891.2.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-6-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-6-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-09-17 at 14:35 -0700, Bart Van Assche wrote:
> A session must only be released after all code that accesses the session
> structure has finished. Make sure that this is the case by introducing a
> new command counter per session that is only decremented after the
> .release_cmd() callback has finished.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_transport.c | 27 +++++++++++++++++---------
>  include/target/target_core_base.h      |  1 +
>  2 files changed, 19 insertions(+), 9 deletions(-)
> 

Per HCH's earlier comment.  Is this required to fix a regression
introduced by commit 00d909a107 in mainline..?  Is it SRPT specific..?

Btw, I'm not completely against moving to a se_sess percpu_ref for
tracking se_cmd association to a session for the purposes of active I/O
shutdown.  However, inter-mixing it with existing se_sess->sess_cmd_lock
+ se_sess->sess_cmd_list for the single benefit of dropping
->sess_cmd_lock during non fast-path code in target_wait_for_sess_cmd()
doesn't really make sense.

That said, what would be better is utilize a new se_sess percpu_ref that
eliminates se_sess->sess_cmd_lock + se_sess->sess_cmd_list all-together!

How..?  Well, what about using the newly sbitmap converted (thanks
willy) se_sess->sess_tag_pool instead..?  Similar to how
blk_mq_queue_tag_busy_iter() uses sbitmap_for_each_set(), the same could
be done to eliminate se_sess->sess_cmd_list all together.

However, that would depend on all upstream fabric drivers using
se_sess->sess_tag_pool.  This is true in all but one case since 4.6.x,
the SRPT driver.

In addition, there would likely be some hairy TMR ABORT_TASK issues to
resolve no doubt, but killing se_sess->sess_cmd_[lock,list] and moving
to per se_session percpu_ref counting is a good goal.

Anyways, I'll review this patch as a starting point to remove
se_sess->sess_cmd_[lock,list] all-together.  Comments inline below.

> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 94e9d03af99d..54ccd8f56a57 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -224,6 +224,13 @@ void transport_subsystem_check_init(void)
>  	sub_api_initialized = 1;
>  }
>  
> +static void target_release_sess_cmd_refcnt(struct percpu_ref *ref)
> +{
> +	struct se_session *sess = container_of(ref, typeof(*sess), cmd_count);
> +
> +	wake_up(&sess->cmd_list_wq);
> +}
> +
>  /**
>   * transport_init_session - initialize a session object
>   * @se_sess: Session object pointer.
> @@ -237,7 +244,8 @@ int transport_init_session(struct se_session *se_sess)
>  	INIT_LIST_HEAD(&se_sess->sess_cmd_list);
>  	spin_lock_init(&se_sess->sess_cmd_lock);
>  	init_waitqueue_head(&se_sess->cmd_list_wq);
> -	return 0;
> +	return percpu_ref_init(&se_sess->cmd_count,
> +			       target_release_sess_cmd_refcnt, 0, GFP_KERNEL);
>  }
>  EXPORT_SYMBOL(transport_init_session);
>  
> @@ -587,6 +595,7 @@ void transport_free_session(struct se_session *se_sess)
>  		sbitmap_queue_free(&se_sess->sess_tag_pool);
>  		kvfree(se_sess->sess_cmd_map);
>  	}
> +	percpu_ref_exit(&se_sess->cmd_count);
>  	kmem_cache_free(se_sess_cache, se_sess);
>  }
>  EXPORT_SYMBOL(transport_free_session);
> @@ -2730,6 +2739,7 @@ int target_get_sess_cmd(struct se_cmd *se_cmd, bool ack_kref)
>  	}
>  	se_cmd->transport_state |= CMD_T_PRE_EXECUTE;
>  	list_add_tail(&se_cmd->se_cmd_list, &se_sess->sess_cmd_list);
> +	percpu_ref_get(&se_sess->cmd_count);
>  out:
>  	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>  

This would need to be a percpu_ref_tryget_live() before
CMD_T_PRE_EXECUTE is assigned, replacing the sess->sess_tearing_down
check.

> @@ -2760,8 +2770,6 @@ static void target_release_cmd_kref(struct kref *kref)
>  	if (se_sess) {
>  		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>  		list_del_init(&se_cmd->se_cmd_list);
> -		if (list_empty(&se_sess->sess_cmd_list))
> -			wake_up(&se_sess->cmd_list_wq);
>  		spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
>  	}
>  

Btw, I noticed this small regression as part of your commit 00d909a1 in
mainline, seperate from this patch.

That is, for a iodepth=1 workload the new wake_up() above in
target_release_cmd_kref() is getting called every se_cmd->cmd_kref
release, even during the normal case when a session is not actually
being shutdown..

To address this for <= v4.19 separate from further changes:

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 049a966..0473bf5 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2760,7 +2760,7 @@ static void target_release_cmd_kref(struct kref *kref)
        if (se_sess) {
                spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
                list_del_init(&se_cmd->se_cmd_list);
-               if (list_empty(&se_sess->sess_cmd_list))
+               if (se_sess->sess_tearing_down && list_empty(&se_sess->sess_cmd_list))
                        wake_up(&se_sess->cmd_list_wq);
                spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
        }

I'll send it out separately for MKP to pick up.

> @@ -2769,6 +2777,8 @@ static void target_release_cmd_kref(struct kref *kref)
>  	se_cmd->se_tfo->release_cmd(se_cmd);
>  	if (compl)
>  		complete(compl);
> +
> +	percpu_ref_put(&se_sess->cmd_count);
>  }
>  
>  /**
> @@ -2897,6 +2907,8 @@ void target_sess_cmd_list_set_waiting(struct se_session *se_sess)
>  	spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>  	se_sess->sess_tearing_down = 1;
>  	spin_unlock_irqrestore(&se_sess->sess_cmd_lock, flags);
> +
> +	percpu_ref_kill_and_confirm(&se_sess->cmd_count, NULL);
>  }
>  EXPORT_SYMBOL(target_sess_cmd_list_set_waiting);
>  

Here is where percpu-ref and RCU grace-period magic comes in..

As a (future) consequence of relying solely upon se_sess->cmd_count, the
percpu_ref_kill_and_confirm() needs a percpu_ref->confirm_switch()
callback to work correctly, along with a matching local
wait_for_completion() within target_sess_cmd_list_set_waiting().

That is, the completion waits for percpu_ref_switch_to_atomic_rcu()
to call percpu_ref->confirm_switch() after a RCU grade-period has
elapsed so se_sess->cmd_count is seen as __PERCPU_REF_DEAD on all CPUs.

From there, se_sess->cmd_count is switched to atomic_t mode so that
percpu_ref_tryget_live() lookup of se_sess->cmd_count fails for all new
incoming I/O.

This is exactly how se_lun->lun_ref works today. See commit bd4e2d2907f
for more information.

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
>  		list_for_each_entry(cmd, &se_sess->sess_cmd_list, se_cmd_list)
>  			target_show_cmd("session shutdown: still waiting for ",
>  					cmd);
>  	} while (ret <= 0);
> -	spin_unlock_irq(&se_sess->sess_cmd_lock);
>  }
>  EXPORT_SYMBOL(target_wait_for_sess_cmds);


It would be useful to move the hardcoded '180' into a tunable at some
point.

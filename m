From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Date: Sun, 07 Oct 2018 03:44:06 +0000
Subject: Re: [PATCH 10/17] target/core: Make it possible to wait from more than one context for command compl
Message-Id: <1538883846.14891.10.camel@haakon3.daterainc.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180917213554.987-11-bvanassche@acm.org>
In-Reply-To: <20180917213554.987-11-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, 2018-09-17 at 14:35 -0700, Bart Van Assche wrote:
> This patch does not change any functionality but makes the next patch
> easier to read.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Mike Christie <mchristi@redhat.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/target/target_core_transport.c | 69 ++++++++++++++++++++++----
>  include/target/target_core_base.h      |  2 +-
>  2 files changed, 60 insertions(+), 11 deletions(-)
> 

<SNIP>

> @@ -2759,9 +2802,16 @@ static void target_release_cmd_kref(struct kref *kref)
>  {
>  	struct se_cmd *se_cmd = container_of(kref, struct se_cmd, cmd_kref);
>  	struct se_session *se_sess = se_cmd->se_sess;
> -	struct completion *compl = se_cmd->compl;
> +	struct wait_queue_head release_wq;
>  	unsigned long flags;
>  
> +	init_waitqueue_head(&release_wq);
> +	/*
> +	 * No locking is required since we are in the release function and
> +	 * adding to release_wq is only allowed while holding a reference.
> +	 */
> +	list_splice_init(&se_cmd->release_wq.head, &release_wq.head);
> +
>  	if (se_sess) {
>  		spin_lock_irqsave(&se_sess->sess_cmd_lock, flags);
>  		list_del_init(&se_cmd->se_cmd_list);
> @@ -2770,8 +2820,7 @@ static void target_release_cmd_kref(struct kref *kref)
>  
>  	target_free_cmd_mem(se_cmd);
>  	se_cmd->se_tfo->release_cmd(se_cmd);
> -	if (compl)
> -		complete(compl);
> +	wake_up_all(&release_wq);
>  
>  	percpu_ref_put(&se_sess->cmd_count);
>  }

Your earlier commit 7b2cc7dc0 in mainline to use a local stack compl in
transport_generic_free_cmd() was a reasonable change, because fast-path
code in target_release_cmd_kref() was only doing a complete() when the
se_cmd was actually being quiesced..

However, the addition of wake_up_all() above for every se_cmd means a
__wake_up_common_lock() happens no matter what every time in fast-path
code.

Please, don't do this.

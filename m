From: Mike Christie <mchristi@redhat.com>
Date: Wed, 02 May 2018 19:53:20 +0000
Subject: Re: [PATCHv4 3/3] tcmu: add module wide action/reset_netlink support
Message-Id: <5AEA1730.1000102@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1524123964-21347-4-git-send-email-xiubli@redhat.com>
In-Reply-To: <1524123964-21347-4-git-send-email-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/19/2018 02:46 AM, xiubli@redhat.com wrote:
> @@ -1572,13 +1579,16 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
>  	if (udev->nl_reply_supported <= 0)
>  		return 0;
>  
> +	spin_lock(&udev->nl_cmd_lock);
> +	nl_cmd->waiter++;

I think this will allow races.

1. It is not likely, but if userspace crashed after the nl event was
sent to userspace (maybe it crashed during the handling of the event),
and then restarted before we did waiter++ we would miss this cmd and not
clean it up.

2. With your userspace patch, we reset outstanding events with watier
incremented, but the event could still be queued in the netlink socket.
When runner starts to read what is in the socket it will start to handle
events that had waiter incremented but the reset operation has force failed.

I think we could add a block/unblock type of operation where we do

1. block. Fail new cmds or put the reqeuster to sleep.
2. userspace dequeues events in nl socket and handles them.
3. userspace resets nl like we do like in this patch and fail
outstanding cmds that were already dequeued and we have no info about.
4. unblock.

Or maybe I think we could add a list/queue and we could figure out what
has been dequeued vs run vs is waiting for a completion.


> +	spin_unlock(&udev->nl_cmd_lock);
> +
>  	pr_debug("sleeping for nl reply\n");
> -	wait_for_completion(&nl_cmd->complete);
> +	wait_event(udev->complete_wq, nl_cmd->status != 1);
>  
>  	spin_lock(&udev->nl_cmd_lock);
>  	nl_cmd->cmd = TCMU_CMD_UNSPEC;
>  	ret = nl_cmd->status;
> -	nl_cmd->status = 0;
>  	spin_unlock(&udev->nl_cmd_lock);
>  
>  	wake_up_all(&udev->nl_cmd_wq);
> @@ -2366,6 +2376,54 @@ static ssize_t tcmu_reset_ring_store(struct config_item *item, const char *page,
>  	NULL,
>  };
>  
> +static int tcmu_complete_wake_up_iter(struct se_device *se_dev, void *data)
> +{

I think it's best to do this after we know it's a tcmu device


> +	struct tcmu_dev *udev = TCMU_DEV(se_dev);
> +	struct tcmu_nl_cmd *nl_cmd;
> +
> +	if (se_dev->transport != &tcmu_ops)
> +		return 0;
> +

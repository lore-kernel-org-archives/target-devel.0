From: Mike Christie <mchristi@redhat.com>
Date: Thu, 30 Apr 2020 15:59:24 +0000
Subject: Re: [RFC] tcmu: wrong input from userspace can confuse tcmu
Message-Id: <90283f89-c4e7-19c0-2fdf-64c791f33221@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200430151041.31053-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200430151041.31053-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 4/30/20 10:10 AM, Bodo Stroesser wrote:
> Hi,
> 
> When tcmu queues a new command - no matter whether in command
> ring or in qfull_queue - a cmd_id from IDR udev->commands is
> assigned to the command.
> 
> If userspaces sends a wrong command completion containing the
> cmd_id of a command on the qfull_queue, tcmu_handle_completions()
> finds the command in the IDR and calls tcmu_handle_completion()
> for it. This might do some nasty things, because commands in
> qfull_queue do not have a valid dbi list.
> 
> Of course this is easy to fix. E.g.:
> 
> 
> --- a/drivers/target/target_core_user.c	2020-04-30 14:15:36.177184668 +0200
> +++ b/drivers/target/target_core_user.c	2020-04-30 14:29:43.331882066 +0200
> @@ -1242,13 +1242,14 @@ static unsigned int tcmu_handle_completi
>  		}
>  		WARN_ON(tcmu_hdr_get_op(entry->hdr.len_op) != TCMU_OP_CMD);
>  
> -		cmd = idr_remove(&udev->commands, entry->hdr.cmd_id);
> -		if (!cmd) {
> +		cmd = idr_find(&udev->commands, entry->hdr.cmd_id);
> +		if (!cmd || !test_bit(TCMU_CMD_BIT_INFLIGHT, &cmd->flags)) {
>  			pr_err("cmd_id %u not found, ring is broken\n",
>  			       entry->hdr.cmd_id);
>  			set_bit(TCMU_DEV_BIT_BROKEN, &udev->flags);
>  			break;
>  		}
> +		idr_remove(&udev->commands, entry->hdr.cmd_id);
>  
>  		tcmu_handle_completion(cmd, entry);
>  
> 
> To avoid the second idr_*() call in main data path, it would also
> be possible to not replace the idr_remove() by idr_find(), but
> in case cmd was found without TCMU_CMD_BIT_INFLIGHT being set,
> during error handling re-add the cmd to the idr with the same id
> as before by calling idr_alloc(...,cmd_id, crmdd_id+1, ...).
> 
> 
> OTOH, I'm wondering whether the better solution would be to
> remove idr_alloc() from tcmu_setup_cmd_timer() and add it
> to queue_cmd_ring() immediately before or after it calls
> tcmu_setup_cmd_timer().
> Doing so would mean that commands in qfull_queue no longer have
> a cmd_id (which is not necessary AFAICS) and therefore the problem

It's done for logging, but its only debug logging so we could just print
the pointer value.

> cannot happen, because tcmu_handle_completions() cannot find them
> in the IDR.
> 

This is probably best if it's not a lot of trouble.

If you go this route then in tcmu_reset_ring I think I made a mistake
and we just continue the loop if TCMU_CMD_BIT_INFLIGHT is not set. I
think we want to do:

for cmd in qfull_list
    target_complete_cmd()

for cmd in idr
     target_complete_cmd()

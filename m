From: Mike Christie <mchristi@redhat.com>
Date: Thu, 19 Jul 2018 15:49:31 +0000
Subject: Re: [PATCH] tcmu: fix crash for dereferencing the released udev->mb_addr memory
Message-Id: <5B50B30B.9020907@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1532010659-4657-1-git-send-email-xiubli@redhat.com>
In-Reply-To: <1532010659-4657-1-git-send-email-xiubli@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 07/19/2018 09:30 AM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
> 
> The logs are:
> 
> BUG: unable to handle kernel NULL pointer dereference at 0000000000000040
> IP: [<ffffffffc072b9a9>] tcmu_reset_ring_store+0x149/0x240 [target_core_user]
> PGD 800000000e254067 PUD e255067 PMD 0
> Oops: 0002 [#1] SMP
> [...]
> CPU: 0 PID: 36077 Comm: tcmu-runner Kdump: loaded Not tainted 3.10.0-924.el7.test.x86_64 #1


It is not clear to me how you hit this. It's not a RHEL only bug is it?
Are you sure you are hitting it during device removal?

If we are calling tcmu_reset_ring_store isn't there a refcount on the
item? So we cannot call tcmu_destroy_device -> tcmu_dev_kref_release
until after that has been released, so they would never run at the same
time. And, if userspace were to try to open/write to that reset file
after the rmdir has been done on the se_device then configfs detects
this and fails the open.

I think we can hit your bug during initialization. We do not setup the
mb_addr until the device is configured, but the configfs files are
exported to userspace at device creation time. So between those times,
userspace could be writing to the reset file and hitting this bug. Is
that maybe what you hit?

If that is the bug, we need to grab the cmdr_lock in
tcmu_configure_device when we are setting up the mb_addr and in the
failure path in that function. In tcmu_reset_ring then I think we also
need a check for a NULL mb_addr.



> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 847707a..8d7274e 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1587,16 +1587,16 @@ static void tcmu_dev_kref_release(struct kref *kref)
>  	bool all_expired = true;
>  	int i;
>  
> -	vfree(udev->mb_addr);
> -	udev->mb_addr = NULL;
> -
>  	spin_lock_bh(&timed_out_udevs_lock);
>  	if (!list_empty(&udev->timedout_entry))
>  		list_del(&udev->timedout_entry);
>  	spin_unlock_bh(&timed_out_udevs_lock);
>  
> -	/* Upper layer should drain all requests before calling this */
>  	mutex_lock(&udev->cmdr_lock);
> +	vfree(udev->mb_addr);
> +	udev->mb_addr = NULL;
> +
> +	/* Upper layer should drain all requests before calling this */
>  	idr_for_each_entry(&udev->commands, cmd, i) {
>  		if (tcmu_check_and_free_pending_cmd(cmd) != 0)
>  			all_expired = false;
> 


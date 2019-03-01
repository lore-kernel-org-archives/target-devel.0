From: Mike Christie <mchristi@redhat.com>
Date: Fri, 01 Mar 2019 21:17:06 +0000
Subject: Re: [PATCH] tcmu: wait for nl reply only if there are listeners or during an add
Message-Id: <5C79A152.8080705@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1549076481-15420-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1549076481-15420-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 02/28/2019 01:28 PM, Cathy Avery wrote:
> genlmsg_multicast_allns now returns the correct statuses when a
> message is sent to a listener. However in the case of adding a
> device we want to wait for the listener otherwise we may miss the
> the device during startup.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> ---
>  drivers/target/target_core_user.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 5831e0eecea1..2d3f8f5403d8 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1794,11 +1794,12 @@ static int tcmu_netlink_event_send(struct tcmu_dev *udev,
>  
>  	ret = genlmsg_multicast_allns(&tcmu_genl_family, skb, 0,
>  				      TCMU_MCGRP_CONFIG, GFP_KERNEL);
> -	/* We don't care if no one is listening */
> -	if (ret = -ESRCH)
> -		ret = 0;
> -	if (!ret)
> -		ret = tcmu_wait_genl_cmd_reply(udev);
> +
> +	/* Wait during an add as the listener may not be up yet */
> +	if (ret = 0 ||
> +	   (ret = -ESRCH && cmd = TCMU_CMD_ADDED_DEVICE))
> +		return tcmu_wait_genl_cmd_reply(udev);
> +
>  	return ret;
>  }

Looks ok to me.

Acked-by: Mike Christie <mchristi@redhat.com>

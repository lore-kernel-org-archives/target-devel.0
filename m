From: Mike Christie <mchristi@redhat.com>
Date: Tue, 05 Feb 2019 17:46:19 +0000
Subject: Re: [PATCH] tcmu: wait for nl reply only if there are listeners
Message-Id: <5C59CBEB.7090803@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1549076481-15420-1-git-send-email-mchristi@redhat.com>
In-Reply-To: <1549076481-15420-1-git-send-email-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Martin, I am self nacking this patch for now.


On 02/01/2019 09:01 PM, Mike Christie wrote:
> genlmsg_multicast_allns used to return -ESRCH even if the message was
> successfully sent to a listener. With commit:
> 
> commit cb9f7a9a5c96a773bbc9c70660dc600cfff82f82
> Author: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> Date:   Tue Feb 6 14:48:32 2018 +0100
> 
>     netlink: ensure to loop over all netns in genlmsg_multicast_allns()
> 
> it now will return success if the message was sent to a listener. With
> that patch, tcmu can now immediately fail if -ESRCH is returned because
> we know there will be no reply.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> 
> ---
>  drivers/target/target_core_user.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 5831e0e..dccc13c 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1794,9 +1794,6 @@ static int tcmu_netlink_event_send(struct tcmu_dev *udev,
>  
>  	ret = genlmsg_multicast_allns(&tcmu_genl_family, skb, 0,
>  				      TCMU_MCGRP_CONFIG, GFP_KERNEL);
> -	/* We don't care if no one is listening */
> -	if (ret = -ESRCH)
> -		ret = 0;
>  	if (!ret)
>  		ret = tcmu_wait_genl_cmd_reply(udev);
>  	return ret;
> 

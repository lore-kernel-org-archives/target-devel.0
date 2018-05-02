From: Mike Christie <mchristi@redhat.com>
Date: Wed, 02 May 2018 17:11:24 +0000
Subject: Re: [RESEND V2 1/6] tcmu: add new netlink events helpers
Message-Id: <5AE9F13C.4010700@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180502031344.3120-1-lszhu@suse.com>
In-Reply-To: <20180502031344.3120-1-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

Thanks. Patchset looks ok to me.

Acked-by: Mike Christie <mchristi@redhat.com>


On 05/01/2018 10:13 PM, Zhu Lingshan wrote:
> Add new netlink events helpers tcmu_netlink_event_init() and
> tcmu_netlink_event_send(). These new functions intend to replace
> exsiting netlink events helper function tcmu_netlink_event().
> 
> The exsiting function tcmu_netlink_event() works well for events
> like TCMU_ADDED_DEVICE and TCMU_REMOVED_DEVICE which only has one
> netlink attribute. But if there is a command requires more than
> one attributes to send out, we have to use a struct to adapt the
> paremeter reconfig_data, it is hard to use one struct or a union
> in one struct to adapt every command with different attributes,
> it may get long and ugly.
> 
> With the new two functions, we can call tcmu_netlink_event_init()
> to initialize a netlink event, then add all attributes we need by
> using nla_put_xxx(), at last use tcmu_netlink_event_send() to
> send it out. So that we don't need to use a long struct or union
> if we want to send mulitple attributes for different commands.
> 
> Signed-off-by: Zhu Lingshan <lszhu@suse.com>
> ---
> Changes in V2:
>   - Add new blank lines for better code style, easier to
>     scan the chunks
> 
>  drivers/target/target_core_user.c | 59 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 59 insertions(+)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 4ad89ea71a70..d8f6a53f6bca 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1653,6 +1653,65 @@ static int tcmu_netlink_event(struct tcmu_dev *udev, enum tcmu_genl_cmd cmd,
>  	return ret;
>  }
>  
> +static int tcmu_netlink_event_init(struct tcmu_dev *udev,
> +				   enum tcmu_genl_cmd cmd,
> +				   struct sk_buff **buf, void **hdr)
> +{
> +	struct sk_buff *skb;
> +	void *msg_header;
> +	int ret = -ENOMEM;
> +
> +	skb = genlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
> +	if (!skb)
> +		return ret;
> +
> +	msg_header = genlmsg_put(skb, 0, 0, &tcmu_genl_family, 0, cmd);
> +	if (!msg_header)
> +		goto free_skb;
> +
> +	ret = nla_put_string(skb, TCMU_ATTR_DEVICE, udev->uio_info.name);
> +	if (ret < 0)
> +		goto free_skb;
> +
> +	ret = nla_put_u32(skb, TCMU_ATTR_MINOR, udev->uio_info.uio_dev->minor);
> +	if (ret < 0)
> +		goto free_skb;
> +
> +	ret = nla_put_u32(skb, TCMU_ATTR_DEVICE_ID, udev->se_dev.dev_index);
> +	if (ret < 0)
> +		goto free_skb;
> +
> +	*buf = skb;
> +	*hdr = msg_header;
> +	return ret;
> +
> +free_skb:
> +	nlmsg_free(skb);
> +	return ret;
> +}
> +
> +static int tcmu_netlink_event_send(struct tcmu_dev *udev,
> +				   enum tcmu_genl_cmd cmd,
> +				   struct sk_buff **buf, void **hdr)
> +{
> +	int ret = 0;
> +	struct sk_buff *skb = *buf;
> +	void *msg_header = *hdr;
> +
> +	genlmsg_end(skb, msg_header);
> +
> +	tcmu_init_genl_cmd_reply(udev, cmd);
> +
> +	ret = genlmsg_multicast_allns(&tcmu_genl_family, skb, 0,
> +				      TCMU_MCGRP_CONFIG, GFP_KERNEL);
> +       /* We don't care if no one is listening */
> +	if (ret = -ESRCH)
> +		ret = 0;
> +	if (!ret)
> +		ret = tcmu_wait_genl_cmd_reply(udev);
> +	return ret;
> +}
> +
>  static int tcmu_update_uio_info(struct tcmu_dev *udev)
>  {
>  	struct tcmu_hba *hba = udev->hba->hba_ptr;
> 


From: Mike Christie <mchristi@redhat.com>
Date: Thu, 19 Apr 2018 00:05:27 +0000
Subject: Re: [PATCH 1/6] tcmu: add new netlink events helpers
Message-Id: <5AD7DD47.4060006@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180416110428.5273-1-lszhu@suse.com>
In-Reply-To: <20180416110428.5273-1-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/16/2018 06:04 AM, Zhu Lingshan wrote:
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
>  drivers/target/target_core_user.c | 57 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 57 insertions(+)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 4ad89ea71a70..98013d359d75 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1653,6 +1653,63 @@ static int tcmu_netlink_event(struct tcmu_dev *udev, enum tcmu_genl_cmd cmd,
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

Just a nit. Add a new line here.

> +	*buf = skb;
> +	*hdr = msg_header;
> +	return ret;

Add a newline here too. It makes it a little easier to scan the
different chunks and follows the existing coding style.

> +free_skb:
> +	nlmsg_free(skb);
> +	return ret;
> +}
> +

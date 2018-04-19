From: Mike Christie <mchristi@redhat.com>
Date: Thu, 19 Apr 2018 00:06:19 +0000
Subject: Re: [PATCH 2/6] tcmu: refactor add_device cmd with new nl helpers
Message-Id: <5AD7DD7B.5050808@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180416110428.5273-2-lszhu@suse.com>
In-Reply-To: <20180416110428.5273-2-lszhu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 04/16/2018 06:04 AM, Zhu Lingshan wrote:
> use new netlink events helpers tcmu_netlink_init() and
> tcmu_netlink_send() to refactor netlink event
> TCMU_CMD_ADDED_DEVICE
> 
> Signed-off-by: Zhu Lingshan <lszhu@suse.com>
> ---
>  drivers/target/target_core_user.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 98013d359d75..47b73debd9fd 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1710,6 +1710,22 @@ static int tcmu_netlink_event_send(struct tcmu_dev *udev,
>  	return ret;
>  }
>  
> +static int tcmu_send_dev_add_event(struct tcmu_dev *udev)
> +{
> +	struct sk_buff *skb = NULL;
> +	void *msg_header = NULL;
> +	int ret = 0;
> +
> +	ret = tcmu_netlink_event_init(udev, TCMU_CMD_ADDED_DEVICE, &skb,
> +				      &msg_header);
> +	if (ret < 0)
> +		return ret;
> +	ret = tcmu_netlink_event_send(udev, TCMU_CMD_ADDED_DEVICE, &skb,
> +				      &msg_header);
> +
> +	return ret;
> +}

For this patch and next ones, just do:

return tcmu_netlink_event_send(udev, TCMU_CMD_ADDED_DEVICE, &skb,

no need to set to ret then do a return ret.

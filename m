From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Date: Wed, 13 Sep 2017 15:10:56 +0000
Subject: Re: [PATCH] target: Add netlink command reply supported option for each device
Message-Id: <1601b354-f586-9c0c-6149-ceb2b58faba9@linux.vnet.ibm.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
In-Reply-To: <20170913050122.13731-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


On 9/13/17 12:01 AM, Kenjiro Nakayama wrote:

> Currently netlink command reply support option
> (TCMU_ATTR_SUPP_KERN_CMD_REPLY) can be enabled only on module
> scope. Because of that, once an application enables the netlink
> command reply support, all applications using target_core_user.ko
> would be expected to support the netlink reply. To make matters worse,
> users will not be able to add a device via configfs manually.
>
> To fix these issues, this patch adds an option to make netlink command
> reply disabled on each device through configfs. Original
> TCMU_ATTR_SUPP_KERN_CMD_REPLY is still enabled on module scope to keep
> backward-compatibility and used by default, however once users set
> nl_reply_supported=<NAGATIVE_VALUE> via configfs for a particular
> device, the device disables the netlink command reply support.
>
> Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
> ---
>   drivers/target/target_core_user.c | 59 ++++++++++++++++++++++++++++++++++++++-
>   1 file changed, 58 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 942d094269fb..709c27ed4206 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -150,6 +150,8 @@ struct tcmu_dev {
>   	wait_queue_head_t nl_cmd_wq;
>
>   	char dev_config[TCMU_CONFIG_LEN];
> +
> +	int nl_reply_supported;
>   };
>
>   #define TCMU_DEV(_se_dev) container_of(_se_dev, struct tcmu_dev, se_dev)
> @@ -1306,6 +1308,10 @@ static void tcmu_init_genl_cmd_reply(struct tcmu_dev *udev, int cmd)
>
>   	if (!tcmu_kern_cmd_reply_supported)
>   		return;
> +
> +	if (udev->nl_reply_supported <= 0)
> +		return;
> +
>   relock:
>   	spin_lock(&udev->nl_cmd_lock);
>
> @@ -1332,6 +1338,9 @@ static int tcmu_wait_genl_cmd_reply(struct tcmu_dev *udev)
>   	if (!tcmu_kern_cmd_reply_supported)
>   		return 0;
>
> +	if (udev->nl_reply_supported <= 0)
> +		return 0;
> +
>   	pr_debug("sleeping for nl reply\n");
>   	wait_for_completion(&nl_cmd->complete);
>
> @@ -1506,6 +1515,12 @@ static int tcmu_configure_device(struct se_device *dev)
>   		dev->dev_attrib.emulate_write_cache = 0;
>   	dev->dev_attrib.hw_queue_depth = 128;
>
> +	/* If user didn't explicitly disable netlink reply support, use
> +	 * module scope setting.
> +	 */
> +	if (udev->nl_reply_supported >= 0)
> +		udev->nl_reply_supported = tcmu_kern_cmd_reply_supported;
> +
>   	/*
>   	 * Get a ref incase userspace does a close on the uio device before
>   	 * LIO has initiated tcmu_free_device.
> @@ -1610,7 +1625,7 @@ static void tcmu_destroy_device(struct se_device *dev)
>
>   enum {
>   	Opt_dev_config, Opt_dev_size, Opt_hw_block_size, Opt_hw_max_sectors,
> -	Opt_err,
> +	Opt_nl_reply_supported, Opt_err,
>   };
>
>   static match_table_t tokens = {
> @@ -1618,6 +1633,7 @@ static match_table_t tokens = {
>   	{Opt_dev_size, "dev_size=%u"},
>   	{Opt_hw_block_size, "hw_block_size=%u"},
>   	{Opt_hw_max_sectors, "hw_max_sectors=%u"},
> +	{Opt_nl_reply_supported, "nl_reply_supported=%d"},
>   	{Opt_err, NULL}
>   };
>
> @@ -1692,6 +1708,18 @@ static ssize_t tcmu_set_configfs_dev_params(struct se_device *dev,
>   			ret = tcmu_set_dev_attrib(&args[0],
>   					&(dev->dev_attrib.hw_max_sectors));
>   			break;
> +		case Opt_nl_reply_supported:
> +			arg_p = match_strdup(&args[0]);
> +			if (!arg_p) {
> +				ret = -ENOMEM;
> +				break;
> +			}
> +			ret = kstrtol(arg_p, 0,
> +					(long int *) &udev->nl_reply_supported);
> +			kfree(arg_p);
> +			if (ret < 0)
> +				pr_err("kstrtoul() failed for nl_reply_supported=\n");
> +			break;
>   		default:
>   			break;
>   		}
> @@ -1842,6 +1870,34 @@ static ssize_t tcmu_dev_size_store(struct config_item *item, const char *page,
>   }
>   CONFIGFS_ATTR(tcmu_, dev_size);
>
> +static ssize_t tcmu_nl_reply_supported_show(struct config_item *item,
> +		char *page)
> +{
> +	struct se_dev_attrib *da = container_of(to_config_group(item),
> +						struct se_dev_attrib, da_group);
> +	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
> +
> +	return snprintf(page, PAGE_SIZE, "%d\n", udev->nl_reply_supported);
> +}
> +
> +static ssize_t tcmu_nl_reply_supported_store(struct config_item *item,
> +		const char *page, size_t count)
> +{
> +	struct se_dev_attrib *da = container_of(to_config_group(item),
> +						struct se_dev_attrib, da_group);
> +	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
> +	s8 val;
> +	int ret;
> +
> +	ret = kstrtos8(page, 0, &val);
> +	if (ret < 0)
> +		return ret;
> +
> +	udev->nl_reply_supported = val;
> +	return count;
> +}
> +CONFIGFS_ATTR(tcmu_, nl_reply_supported);
> +
>   static ssize_t tcmu_emulate_write_cache_show(struct config_item *item,
>   					     char *page)
>   {
> @@ -1884,6 +1940,7 @@ static struct configfs_attribute *tcmu_attrib_attrs[] = {
>   	&tcmu_attr_dev_config,
>   	&tcmu_attr_dev_size,
>   	&tcmu_attr_emulate_write_cache,
> +	&tcmu_attr_nl_reply_supported,
>   	NULL,
>   };
>

The problem with this patch is that for tcmu-runner/targetcli-fb users 
the code will depend
on the genl_info structure that contains whether or not a netlink reply 
is supported. You will
need to fix that path where if you were to update the configfs to 
disable netlink reply and if a user
already has stuff setup then things will get messy. Userspace will think 
netlink reply is supported,
but kernel doesn't expect one.

-Bryant


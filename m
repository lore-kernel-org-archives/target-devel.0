From: Lee Duncan <lduncan@suse.com>
Date: Thu, 29 Nov 2018 01:33:28 +0000
Subject: Re: [PATCH v4 7/7] target: use printf width specifier for t10_wwn field dumps
Message-Id: <e0cfb00b-a44e-b59a-c6a2-555a99731286@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-8-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-8-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/28/18 5:01 PM, David Disseldorp wrote:
> From: Bart Van Assche <bvanassche@acm.org>
> 
> The existing for loops step over null-terminators for right-padding.
> Padding can be achieved in a much simpler way using printf width
> specifiers.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_device.c | 35 ++++++++---------------------------
>  drivers/target/target_core_stat.c   | 32 +++++++-------------------------
>  2 files changed, 15 insertions(+), 52 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index b3d0bd1ab09f..7f2d307e411b 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -720,36 +720,17 @@ void core_dev_free_initiator_node_lun_acl(
>  static void scsi_dump_inquiry(struct se_device *dev)
>  {
>  	struct t10_wwn *wwn = &dev->t10_wwn;
> -	char buf[INQUIRY_MODEL_LEN + 1];
> -	int i, device_type;
> +	int device_type = dev->transport->get_device_type(dev);
> +
>  	/*
>  	 * Print Linux/SCSI style INQUIRY formatting to the kernel ring buffer
>  	 */
> -	for (i = 0; i < INQUIRY_VENDOR_LEN; i++)
> -		if (wwn->vendor[i] >= 0x20)
> -			buf[i] = wwn->vendor[i];
> -		else
> -			buf[i] = ' ';
> -	buf[i] = '\0';
> -	pr_debug("  Vendor: %s\n", buf);
> -
> -	for (i = 0; i < INQUIRY_MODEL_LEN; i++)
> -		if (wwn->model[i] >= 0x20)
> -			buf[i] = wwn->model[i];
> -		else
> -			buf[i] = ' ';
> -	buf[i] = '\0';
> -	pr_debug("  Model: %s\n", buf);
> -
> -	for (i = 0; i < INQUIRY_REVISION_LEN; i++)
> -		if (wwn->revision[i] >= 0x20)
> -			buf[i] = wwn->revision[i];
> -		else
> -			buf[i] = ' ';
> -	buf[i] = '\0';
> -	pr_debug("  Revision: %s\n", buf);
> -
> -	device_type = dev->transport->get_device_type(dev);
> +	pr_debug("  Vendor: %-" __stringify(INQUIRY_VENDOR_LEN) "s\n",
> +		wwn->vendor);
> +	pr_debug("  Model: %-" __stringify(INQUIRY_MODEL_LEN) "s\n",
> +		wwn->model);
> +	pr_debug("  Revision: %-" __stringify(INQUIRY_REVISION_LEN) "s\n",
> +		wwn->revision);
>  	pr_debug("  Type:   %s ", scsi_device_type(device_type));
>  }
>  
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index e437ba494865..87fd2b11fe3b 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -246,43 +246,25 @@ static ssize_t target_stat_lu_lu_name_show(struct config_item *item, char *page)
>  static ssize_t target_stat_lu_vend_show(struct config_item *item, char *page)
>  {
>  	struct se_device *dev = to_stat_lu_dev(item);
> -	int i;
> -	char str[INQUIRY_VENDOR_LEN+1];
>  
> -	/* scsiLuVendorId */
> -	for (i = 0; i < INQUIRY_VENDOR_LEN; i++)
> -		str[i] = ISPRINT(dev->t10_wwn.vendor[i]) ?
> -			dev->t10_wwn.vendor[i] : ' ';
> -	str[i] = '\0';
> -	return snprintf(page, PAGE_SIZE, "%s\n", str);
> +	return snprintf(page, PAGE_SIZE, "%-" __stringify(INQUIRY_VENDOR_LEN)
> +			"s\n", dev->t10_wwn.vendor);
>  }
>  
>  static ssize_t target_stat_lu_prod_show(struct config_item *item, char *page)
>  {
>  	struct se_device *dev = to_stat_lu_dev(item);
> -	int i;
> -	char str[INQUIRY_MODEL_LEN+1];
>  
> -	/* scsiLuProductId */
> -	for (i = 0; i < INQUIRY_MODEL_LEN; i++)
> -		str[i] = ISPRINT(dev->t10_wwn.model[i]) ?
> -			dev->t10_wwn.model[i] : ' ';
> -	str[i] = '\0';
> -	return snprintf(page, PAGE_SIZE, "%s\n", str);
> +	return snprintf(page, PAGE_SIZE, "%-" __stringify(INQUIRY_MODEL_LEN)
> +			"s\n", dev->t10_wwn.model);
>  }
>  
>  static ssize_t target_stat_lu_rev_show(struct config_item *item, char *page)
>  {
>  	struct se_device *dev = to_stat_lu_dev(item);
> -	int i;
> -	char str[INQUIRY_REVISION_LEN+1];
> -
> -	/* scsiLuRevisionId */
> -	for (i = 0; i < INQUIRY_REVISION_LEN; i++)
> -		str[i] = ISPRINT(dev->t10_wwn.revision[i]) ?
> -			dev->t10_wwn.revision[i] : ' ';
> -	str[i] = '\0';
> -	return snprintf(page, PAGE_SIZE, "%s\n", str);
> +
> +	return snprintf(page, PAGE_SIZE, "%-" __stringify(INQUIRY_REVISION_LEN)
> +			"s\n", dev->t10_wwn.revision);
>  }
>  
>  static ssize_t target_stat_lu_dev_type_show(struct config_item *item, char *page)
> 


Reviewed-by: Lee Duncan <lduncan@suse.com>

From: Lee Duncan <lduncan@suse.com>
Date: Thu, 29 Nov 2018 01:26:50 +0000
Subject: Re: [PATCH v4 3/7] target: consistently null-terminate t10_wwn.model
Message-Id: <c4aab565-354e-136f-e56a-079ac21b4d6a@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-4-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-4-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/28/18 5:01 PM, David Disseldorp wrote:
> The pscsi_set_inquiry_info() and emulate_model_alias_store() codepaths
> don't currently explicitly null-terminate t10_wwn.model.
> Add an extra byte to the t10_wwn.model buffer and perform null string
> termination in all cases.
> 
> dev_set_t10_wwn_model_alias() continues to truncate at the same length
> to avoid changing the model string for existing deployments.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_configfs.c | 8 +++++---
>  drivers/target/target_core_device.c   | 8 +++++---
>  drivers/target/target_core_pscsi.c    | 6 ++++--
>  drivers/target/target_core_spc.c      | 2 +-
>  drivers/target/target_core_stat.c     | 4 ++--
>  include/target/target_core_base.h     | 3 ++-
>  6 files changed, 19 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index f6b1549f4142..9f49b1afd685 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -613,12 +613,12 @@ static void dev_set_t10_wwn_model_alias(struct se_device *dev)
>  	const char *configname;
>  
>  	configname = config_item_name(&dev->dev_group.cg_item);
> -	if (strlen(configname) >= 16) {
> +	if (strlen(configname) >= INQUIRY_MODEL_LEN) {
>  		pr_warn("dev[%p]: Backstore name '%s' is too long for "
>  			"INQUIRY_MODEL, truncating to 16 bytes\n", dev,
>  			configname);
>  	}
> -	snprintf(&dev->t10_wwn.model[0], 16, "%s", configname);
> +	snprintf(&dev->t10_wwn.model[0], INQUIRY_MODEL_LEN, "%s", configname);
>  }
>  
>  static ssize_t emulate_model_alias_store(struct config_item *item,
> @@ -640,11 +640,13 @@ static ssize_t emulate_model_alias_store(struct config_item *item,
>  	if (ret < 0)
>  		return ret;
>  
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
>  	if (flag) {
>  		dev_set_t10_wwn_model_alias(dev);
>  	} else {
>  		strncpy(&dev->t10_wwn.model[0],
> -			dev->transport->inquiry_prod, 16);
> +			dev->transport->inquiry_prod, INQUIRY_MODEL_LEN);
> +		dev->t10_wwn.model[INQUIRY_MODEL_LEN] = '\0';
>  	}
>  	da->emulate_model_alias = flag;
>  	return count;
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index fe4c4db51137..0d7382efb2d4 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -720,7 +720,7 @@ void core_dev_free_initiator_node_lun_acl(
>  static void scsi_dump_inquiry(struct se_device *dev)
>  {
>  	struct t10_wwn *wwn = &dev->t10_wwn;
> -	char buf[17];
> +	char buf[INQUIRY_MODEL_LEN + 1];
>  	int i, device_type;
>  	/*
>  	 * Print Linux/SCSI style INQUIRY formatting to the kernel ring buffer
> @@ -733,7 +733,7 @@ static void scsi_dump_inquiry(struct se_device *dev)
>  	buf[i] = '\0';
>  	pr_debug("  Vendor: %s\n", buf);
>  
> -	for (i = 0; i < 16; i++)
> +	for (i = 0; i < INQUIRY_MODEL_LEN; i++)
>  		if (wwn->model[i] >= 0x20)
>  			buf[i] = wwn->model[i];
>  		else
> @@ -1009,11 +1009,13 @@ int target_configure_device(struct se_device *dev)
>  	 * passthrough because this is being provided by the backend LLD.
>  	 */
>  	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
>  	if (!(dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)) {
>  		strncpy(&dev->t10_wwn.vendor[0], "LIO-ORG", INQUIRY_VENDOR_LEN);
>  		dev->t10_wwn.vendor[INQUIRY_VENDOR_LEN] = '\0';
>  		strncpy(&dev->t10_wwn.model[0],
> -			dev->transport->inquiry_prod, 16);
> +			dev->transport->inquiry_prod, INQUIRY_MODEL_LEN);
> +		dev->t10_wwn.model[INQUIRY_MODEL_LEN] = '\0';
>  		strncpy(&dev->t10_wwn.revision[0],
>  			dev->transport->inquiry_rev, 4);
>  	}
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index ee65b5bb674c..1633babc2d4e 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -193,7 +193,9 @@ pscsi_set_inquiry_info(struct scsi_device *sdev, struct t10_wwn *wwn)
>  	BUILD_BUG_ON(sizeof(wwn->vendor) != INQUIRY_VENDOR_LEN + 1);
>  	memcpy(&wwn->vendor[0], &buf[8], INQUIRY_VENDOR_LEN);
>  	wwn->vendor[INQUIRY_VENDOR_LEN] = '\0';
> -	memcpy(&wwn->model[0], &buf[16], sizeof(wwn->model));
> +	BUILD_BUG_ON(sizeof(wwn->model) != INQUIRY_MODEL_LEN + 1);
> +	memcpy(&wwn->model[0], &buf[16], INQUIRY_MODEL_LEN);
> +	wwn->model[INQUIRY_MODEL_LEN] = '\0';
>  	memcpy(&wwn->revision[0], &buf[32], sizeof(wwn->revision));
>  }
>  
> @@ -835,7 +837,7 @@ static ssize_t pscsi_show_configfs_dev_params(struct se_device *dev, char *b)
>  				bl += sprintf(b + bl, " ");
>  		}
>  		bl += sprintf(b + bl, " Model: ");
> -		for (i = 0; i < 16; i++) {
> +		for (i = 0; i < INQUIRY_MODEL_LEN; i++) {
>  			if (ISPRINT(sd->model[i]))   /* printable character ? */
>  				bl += sprintf(b + bl, "%c", sd->model[i]);
>  			else
> diff --git a/drivers/target/target_core_spc.c b/drivers/target/target_core_spc.c
> index c37dd36ec77d..78eddee4b6e6 100644
> --- a/drivers/target/target_core_spc.c
> +++ b/drivers/target/target_core_spc.c
> @@ -116,7 +116,7 @@ spc_emulate_inquiry_std(struct se_cmd *cmd, unsigned char *buf)
>  	memset(&buf[8], 0x20, 8 + 16 + 4);
>  	memcpy(&buf[8], "LIO-ORG", sizeof("LIO-ORG") - 1);
>  	memcpy(&buf[16], dev->t10_wwn.model,
> -	       strnlen(dev->t10_wwn.model, 16));
> +	       strnlen(dev->t10_wwn.model, INQUIRY_MODEL_LEN));
>  	memcpy(&buf[32], dev->t10_wwn.revision,
>  	       strnlen(dev->t10_wwn.revision, 4));
>  	buf[4] = 31; /* Set additional length to 31 */
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index 4210cf625d84..9123c5137da5 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -261,10 +261,10 @@ static ssize_t target_stat_lu_prod_show(struct config_item *item, char *page)
>  {
>  	struct se_device *dev = to_stat_lu_dev(item);
>  	int i;
> -	char str[sizeof(dev->t10_wwn.model)+1];
> +	char str[INQUIRY_MODEL_LEN+1];
>  
>  	/* scsiLuProductId */
> -	for (i = 0; i < sizeof(dev->t10_wwn.model); i++)
> +	for (i = 0; i < INQUIRY_MODEL_LEN; i++)
>  		str[i] = ISPRINT(dev->t10_wwn.model[i]) ?
>  			dev->t10_wwn.model[i] : ' ';
>  	str[i] = '\0';
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index cb1f3f574e2a..cfc279686cf4 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -47,6 +47,7 @@
>  #define INQUIRY_VPD_DEVICE_IDENTIFIER_LEN	254
>  
>  #define INQUIRY_VENDOR_LEN			8
> +#define INQUIRY_MODEL_LEN			16
>  
>  /* Attempts before moving from SHORT to LONG */
>  #define PYX_TRANSPORT_WINDOW_CLOSED_THRESHOLD	3
> @@ -321,7 +322,7 @@ struct t10_wwn {
>  	 * null terminator is always present.
>  	 */
>  	char vendor[INQUIRY_VENDOR_LEN + 1];
> -	char model[16];
> +	char model[INQUIRY_MODEL_LEN + 1];
>  	char revision[4];
>  	char unit_serial[INQUIRY_VPD_SERIAL_LEN];
>  	spinlock_t t10_vpd_lock;
> 


Reviewed-by: Lee Duncan <lduncan@suse.com>

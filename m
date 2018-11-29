From: Lee Duncan <lduncan@suse.com>
Date: Thu, 29 Nov 2018 01:25:41 +0000
Subject: Re: [PATCH v4 2/7] target: consistently null-terminate t10_wwn.vendor
Message-Id: <a64c9587-5e8f-4cf1-5a02-ae5fa370de35@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181129010157.12687-3-ddiss@suse.de>
In-Reply-To: <20181129010157.12687-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/28/18 5:01 PM, David Disseldorp wrote:
> In preparation for supporting user provided vendor strings, add an extra
> byte to t10_wwn.vendor which will ensure null string termination when an
> eight byte vendor string is provided by the user.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_device.c | 6 ++++--
>  drivers/target/target_core_pscsi.c  | 6 ++++--
>  drivers/target/target_core_stat.c   | 4 ++--
>  include/target/target_core_base.h   | 8 +++++++-
>  4 files changed, 17 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 47b5ef153135..fe4c4db51137 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -725,7 +725,7 @@ static void scsi_dump_inquiry(struct se_device *dev)
>  	/*
>  	 * Print Linux/SCSI style INQUIRY formatting to the kernel ring buffer
>  	 */
> -	for (i = 0; i < 8; i++)
> +	for (i = 0; i < INQUIRY_VENDOR_LEN; i++)
>  		if (wwn->vendor[i] >= 0x20)
>  			buf[i] = wwn->vendor[i];
>  		else
> @@ -1008,8 +1008,10 @@ int target_configure_device(struct se_device *dev)
>  	 * anything virtual (IBLOCK, FILEIO, RAMDISK), but not for TCM/pSCSI
>  	 * passthrough because this is being provided by the backend LLD.
>  	 */
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
>  	if (!(dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)) {
> -		strncpy(&dev->t10_wwn.vendor[0], "LIO-ORG", 8);
> +		strncpy(&dev->t10_wwn.vendor[0], "LIO-ORG", INQUIRY_VENDOR_LEN);
> +		dev->t10_wwn.vendor[INQUIRY_VENDOR_LEN] = '\0';
>  		strncpy(&dev->t10_wwn.model[0],
>  			dev->transport->inquiry_prod, 16);
>  		strncpy(&dev->t10_wwn.revision[0],
> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 47d76c862014..ee65b5bb674c 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -190,7 +190,9 @@ pscsi_set_inquiry_info(struct scsi_device *sdev, struct t10_wwn *wwn)
>  	/*
>  	 * Use sdev->inquiry from drivers/scsi/scsi_scan.c:scsi_alloc_sdev()
>  	 */
> -	memcpy(&wwn->vendor[0], &buf[8], sizeof(wwn->vendor));
> +	BUILD_BUG_ON(sizeof(wwn->vendor) != INQUIRY_VENDOR_LEN + 1);
> +	memcpy(&wwn->vendor[0], &buf[8], INQUIRY_VENDOR_LEN);
> +	wwn->vendor[INQUIRY_VENDOR_LEN] = '\0';
>  	memcpy(&wwn->model[0], &buf[16], sizeof(wwn->model));
>  	memcpy(&wwn->revision[0], &buf[32], sizeof(wwn->revision));
>  }
> @@ -826,7 +828,7 @@ static ssize_t pscsi_show_configfs_dev_params(struct se_device *dev, char *b)
>  	if (sd) {
>  		bl += sprintf(b + bl, "        ");
>  		bl += sprintf(b + bl, "Vendor: ");
> -		for (i = 0; i < 8; i++) {
> +		for (i = 0; i < INQUIRY_VENDOR_LEN; i++) {
>  			if (ISPRINT(sd->vendor[i]))   /* printable character? */
>  				bl += sprintf(b + bl, "%c", sd->vendor[i]);
>  			else
> diff --git a/drivers/target/target_core_stat.c b/drivers/target/target_core_stat.c
> index f0db91ebd735..4210cf625d84 100644
> --- a/drivers/target/target_core_stat.c
> +++ b/drivers/target/target_core_stat.c
> @@ -247,10 +247,10 @@ static ssize_t target_stat_lu_vend_show(struct config_item *item, char *page)
>  {
>  	struct se_device *dev = to_stat_lu_dev(item);
>  	int i;
> -	char str[sizeof(dev->t10_wwn.vendor)+1];
> +	char str[INQUIRY_VENDOR_LEN+1];
>  
>  	/* scsiLuVendorId */
> -	for (i = 0; i < sizeof(dev->t10_wwn.vendor); i++)
> +	for (i = 0; i < INQUIRY_VENDOR_LEN; i++)
>  		str[i] = ISPRINT(dev->t10_wwn.vendor[i]) ?
>  			dev->t10_wwn.vendor[i] : ' ';
>  	str[i] = '\0';
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index e3bdb0550a59..cb1f3f574e2a 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -46,6 +46,8 @@
>  /* Used by transport_get_inquiry_vpd_device_ident() */
>  #define INQUIRY_VPD_DEVICE_IDENTIFIER_LEN	254
>  
> +#define INQUIRY_VENDOR_LEN			8
> +
>  /* Attempts before moving from SHORT to LONG */
>  #define PYX_TRANSPORT_WINDOW_CLOSED_THRESHOLD	3
>  #define PYX_TRANSPORT_WINDOW_CLOSED_WAIT_SHORT	3  /* In milliseconds */
> @@ -314,7 +316,11 @@ struct t10_vpd {
>  };
>  
>  struct t10_wwn {
> -	char vendor[8];
> +	/*
> +	 * SCSI left aligned strings may not be null terminated. +1 to ensure a
> +	 * null terminator is always present.
> +	 */
> +	char vendor[INQUIRY_VENDOR_LEN + 1];
>  	char model[16];
>  	char revision[4];
>  	char unit_serial[INQUIRY_VPD_SERIAL_LEN];
> 


Reviewed-by: Lee Duncan <lduncan@suse.com>

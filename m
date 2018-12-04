From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Tue, 04 Dec 2018 11:31:57 +0000
Subject: Re: [PATCH v5 2/5] target: consistently null-terminate t10_wwn strings
Message-Id: <20181204113157.xofgmjjc54eaqbqt@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20181130233423.26556-3-ddiss@suse.de>
In-Reply-To: <20181130233423.26556-3-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, Dec 01, 2018 at 12:34:20AM +0100, David Disseldorp wrote:
> In preparation for supporting user provided vendor strings, add an extra
> byte to the vendor, model and revision arrays in struct t10_wwn. This
> ensures that the full INQUIRY data can be carried in the arrays along
> with a null-terminator.
> 
> Change a number of array readers and writers so that they account for
> explicit null-termination:
> - The pscsi_set_inquiry_info() and emulate_model_alias_store() codepaths
>   don't currently explicitly null-terminate; fix this.
> - Existing t10_wwn field dumps use for-loops which step over
>   null-terminators for right-padding.
>   + Use printf with width specifiers instead.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>  drivers/target/target_core_configfs.c | 14 +++++++---
>  drivers/target/target_core_device.c   | 49 ++++++++++++-----------------------
>  drivers/target/target_core_pscsi.c    | 18 ++++++++-----
>  drivers/target/target_core_spc.c      |  7 ++---
>  drivers/target/target_core_stat.c     | 32 +++++------------------
>  include/target/target_core_base.h     | 14 +++++++---
>  6 files changed, 61 insertions(+), 73 deletions(-)
> 
> diff --git a/drivers/target/target_core_configfs.c b/drivers/target/target_core_configfs.c
> index f6b1549f4142..34872f24e8bf 100644
> --- a/drivers/target/target_core_configfs.c
> +++ b/drivers/target/target_core_configfs.c
> @@ -613,12 +613,17 @@ static void dev_set_t10_wwn_model_alias(struct se_device *dev)
>  	const char *configname;
>  
>  	configname = config_item_name(&dev->dev_group.cg_item);
> -	if (strlen(configname) >= 16) {
> +	if (strlen(configname) >= INQUIRY_MODEL_LEN) {
>  		pr_warn("dev[%p]: Backstore name '%s' is too long for "
>  			"INQUIRY_MODEL, truncating to 16 bytes\n", dev,

The warning (which I understand predates your patch) is misleading, it
should mention truncation to 15 instead of 16 bytes and your comment
just below explains this.

>  			configname);
>  	}
> -	snprintf(&dev->t10_wwn.model[0], 16, "%s", configname);
> +	/*
> +	 * XXX We can't use sizeof(dev->t10_wwn.model) (INQUIRY_MODEL_LEN + 1)
> +	 * here without potentially breaking existing setups, so continue to
> +	 * truncate one byte shorter than what can be carried in INQUIRY.
> +	 */
> +	strlcpy(dev->t10_wwn.model, configname, INQUIRY_MODEL_LEN);
>  }
>  

> diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
> index 47b5ef153135..5512871f50e4 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -1008,12 +989,16 @@ int target_configure_device(struct se_device *dev)
>  	 * anything virtual (IBLOCK, FILEIO, RAMDISK), but not for TCM/pSCSI
>  	 * passthrough because this is being provided by the backend LLD.
>  	 */
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);


I'm sorry I'm missing something. Why BUILD_BUG_ON is added in many
places?

> diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
> index 47d76c862014..1002829f2038 100644
> --- a/drivers/target/target_core_pscsi.c
> +++ b/drivers/target/target_core_pscsi.c
> @@ -190,9 +190,15 @@ pscsi_set_inquiry_info(struct scsi_device *sdev, struct t10_wwn *wwn)
>  	/*
>  	 * Use sdev->inquiry from drivers/scsi/scsi_scan.c:scsi_alloc_sdev()
>  	 */
> -	memcpy(&wwn->vendor[0], &buf[8], sizeof(wwn->vendor));
> -	memcpy(&wwn->model[0], &buf[16], sizeof(wwn->model));
> -	memcpy(&wwn->revision[0], &buf[32], sizeof(wwn->revision));
> +	BUILD_BUG_ON(sizeof(wwn->vendor) != INQUIRY_VENDOR_LEN + 1);
> +	snprintf(wwn->vendor, sizeof(wwn->vendor),
> +		 "%." __stringify(INQUIRY_VENDOR_LEN) "s", &buf[8]);
> +	BUILD_BUG_ON(sizeof(wwn->model) != INQUIRY_MODEL_LEN + 1);
> +	snprintf(wwn->model, sizeof(wwn->model),
> +		 "%." __stringify(INQUIRY_MODEL_LEN) "s", &buf[16]);
> +	BUILD_BUG_ON(sizeof(wwn->revision) != INQUIRY_REVISION_LEN + 1);
> +	snprintf(wwn->revision, sizeof(wwn->revision),
> +		 "%." __stringify(INQUIRY_REVISION_LEN) "s", &buf[32]);
>  }
>  

The parts of the sdev->inquiry have been already right-padded with
spaces by scsi_sanitize_inquiry_string in scsi_probe_lun. Thus, it's
enough to replace sizeof with the new length definitions. Also, it's
possible to use sdev->model,vendor,rev pointers like in
pscsi_show_configfs_dev_params instead of explicit offsets &buf[8],
&buf[16], &buf[32].

>  static int
> @@ -826,21 +832,21 @@ static ssize_t pscsi_show_configfs_dev_params(struct se_device *dev, char *b)
>  	if (sd) {
>  		bl += sprintf(b + bl, "        ");
>  		bl += sprintf(b + bl, "Vendor: ");
> -		for (i = 0; i < 8; i++) {
> +		for (i = 0; i < INQUIRY_VENDOR_LEN; i++) {
>  			if (ISPRINT(sd->vendor[i]))   /* printable character? */
>  				bl += sprintf(b + bl, "%c", sd->vendor[i]);
>  			else
>  				bl += sprintf(b + bl, " ");
>  		}
>  		bl += sprintf(b + bl, " Model: ");
> -		for (i = 0; i < 16; i++) {
> +		for (i = 0; i < INQUIRY_MODEL_LEN; i++) {
>  			if (ISPRINT(sd->model[i]))   /* printable character ? */
>  				bl += sprintf(b + bl, "%c", sd->model[i]);
>  			else
>  				bl += sprintf(b + bl, " ");
>  		}
>  		bl += sprintf(b + bl, " Rev: ");
> -		for (i = 0; i < 4; i++) {
> +		for (i = 0; i < INQUIRY_REVISION_LEN; i++) {
>  			if (ISPRINT(sd->rev[i]))   /* printable character ? */
>  				bl += sprintf(b + bl, "%c", sd->rev[i]);
>  			else

Likewise, the loops are redundant as sd->vendor/model/rev have been
right padded with spaces by scsi_sanitize_inquiry_string in
scsi_probe_lun.

Thank you,
Roman

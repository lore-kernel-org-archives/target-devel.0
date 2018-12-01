From: Hannes Reinecke <hare@suse.com>
Date: Sat, 01 Dec 2018 14:59:25 +0000
Subject: Re: [PATCH v5 5/5] target: perform t10_wwn ID initialisation in target_alloc_device()
Message-Id: <4c55b1cf-9fdf-7f4f-c358-89d7d5f9be1e@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20181130233423.26556-6-ddiss@suse.de>
In-Reply-To: <20181130233423.26556-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 12/1/18 12:34 AM, David Disseldorp wrote:
> Initialise the t10_wwn vendor, model and revision defaults when a
> device is allocated instead of when it's enabled. This ensures that
> custom vendor or model strings set prior to enablement are not later
> overwritten with default values.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>
> ---
>   drivers/target/target_core_device.c | 34 +++++++++++++++++-----------------
>   1 file changed, 17 insertions(+), 17 deletions(-)
>  > diff --git a/drivers/target/target_core_device.c 
b/drivers/target/target_core_device.c
> index 5512871f50e4..6318d59a1564 100644
> --- a/drivers/target/target_core_device.c
> +++ b/drivers/target/target_core_device.c
> @@ -810,6 +810,23 @@ struct se_device *target_alloc_device(struct se_hba *hba, const char *name)
>   	mutex_init(&xcopy_lun->lun_tg_pt_md_mutex);
>   	xcopy_lun->lun_tpg = &xcopy_pt_tpg;
>   
> +	/*
> +	 * Preload the initial INQUIRY const values if we are doing
> +	 * anything virtual (IBLOCK, FILEIO, RAMDISK), but not for TCM/pSCSI
> +	 * passthrough because this is being provided by the backend LLD.
> +	 */
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.vendor) != INQUIRY_VENDOR_LEN + 1);
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.model) != INQUIRY_MODEL_LEN + 1);
> +	BUILD_BUG_ON(sizeof(dev->t10_wwn.revision) != INQUIRY_REVISION_LEN + 1);
> +	if (!(dev->transport->transport_flags & TRANSPORT_FLAG_PASSTHROUGH)) {
> +		strlcpy(dev->t10_wwn.vendor, "LIO-ORG",
> +			sizeof(dev->t10_wwn.vendor));
> +		strlcpy(dev->t10_wwn.model, dev->transport->inquiry_prod,
> +			sizeof(dev->t10_wwn.model));
> +		strlcpy(dev->t10_wwn.revision, dev->transport->inquiry_rev,
> +			sizeof(dev->t10_wwn.revision));
> +	}
> +
>   	return dev;
>   }
>   
This is odd. I'd rather have it consistent across backends, ie either 
move the initialisation into the backends, or provide a means to check 
if the inquiry data has already been pre-filled.
But this check really is awkward.

Cheers,

Hannes

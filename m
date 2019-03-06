From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 06 Mar 2019 17:52:07 +0000
Subject: Re: [PATCH v1] scsi: tcmu: Switch to bitmap_zalloc()
Message-Id: <yq1o96nyjp4.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190304094434.57965-1-andriy.shevchenko@linux.intel.com>
In-Reply-To: <20190304094434.57965-1-andriy.shevchenko@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Mike,

Please review!

> Switch to bitmap_zalloc() to show clearly what we are allocating.
> Besides that it returns pointer of bitmap type instead of opaque void *.
>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/target/target_core_user.c | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 5831e0eecea1..c726c029affe 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1663,7 +1663,7 @@ static void tcmu_dev_kref_release(struct kref *kref)
>  	WARN_ON(!all_expired);
>  
>  	tcmu_blocks_release(&udev->data_blocks, 0, udev->dbi_max + 1);
> -	kfree(udev->data_bitmap);
> +	bitmap_free(udev->data_bitmap);
>  	mutex_unlock(&udev->cmdr_lock);
>  
>  	call_rcu(&dev->rcu_head, tcmu_dev_call_rcu);
> @@ -1870,9 +1870,7 @@ static int tcmu_configure_device(struct se_device *dev)
>  	info = &udev->uio_info;
>  
>  	mutex_lock(&udev->cmdr_lock);
> -	udev->data_bitmap = kcalloc(BITS_TO_LONGS(udev->max_blocks),
> -				    sizeof(unsigned long),
> -				    GFP_KERNEL);
> +	udev->data_bitmap = bitmap_zalloc(udev->max_blocks, GFP_KERNEL);
>  	mutex_unlock(&udev->cmdr_lock);
>  	if (!udev->data_bitmap) {
>  		ret = -ENOMEM;
> @@ -1959,7 +1957,7 @@ static int tcmu_configure_device(struct se_device *dev)
>  	vfree(udev->mb_addr);
>  	udev->mb_addr = NULL;
>  err_vzalloc:
> -	kfree(udev->data_bitmap);
> +	bitmap_free(udev->data_bitmap);
>  	udev->data_bitmap = NULL;
>  err_bitmap_alloc:
>  	kfree(info->name);

-- 
Martin K. Petersen	Oracle Linux Engineering

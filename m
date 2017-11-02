From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 13:56:46 +0000
Subject: Re: [PATCH 01/11] target: Move a declaration of a global variable into a header file
Message-Id: <41ef0df6-87b4-1308-ecc9-dfa73877de4f@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> This patch avoids that sparse reports the following warning:
> 
> drivers/target/target_core_configfs.c:2267:33: warning: symbol 'target_core_dev_item_ops' was not declared. Should it be static?
> 
> Fixes: c17cd24959cd ("target/configfs: Kill se_device->dev_link_magic")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/target_core_fabric_configfs.c | 2 --
>  drivers/target/target_core_internal.h        | 1 +
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_fabric_configfs.c b/drivers/target/target_core_fabric_configfs.c
> index e9e917cc6441..e1416b007aa4 100644
> --- a/drivers/target/target_core_fabric_configfs.c
> +++ b/drivers/target/target_core_fabric_configfs.c
> @@ -623,8 +623,6 @@ static struct configfs_attribute *target_fabric_port_attrs[] = {
>  	NULL,
>  };
>  
> -extern struct configfs_item_operations target_core_dev_item_ops;
> -
>  static int target_fabric_port_link(
>  	struct config_item *lun_ci,
>  	struct config_item *se_dev_ci)
> diff --git a/drivers/target/target_core_internal.h b/drivers/target/target_core_internal.h
> index f30e8ac13386..2c5004ffb581 100644
> --- a/drivers/target/target_core_internal.h
> +++ b/drivers/target/target_core_internal.h
> @@ -88,6 +88,7 @@ int	target_for_each_device(int (*fn)(struct se_device *dev, void *data),
>  			       void *data);
>  
>  /* target_core_configfs.c */
> +extern struct configfs_item_operations target_core_dev_item_ops;
>  void	target_setup_backend_cits(struct target_backend *);
>  
>  /* target_core_fabric_configfs.c */
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

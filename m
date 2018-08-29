From: Mike Christie <mchristi@redhat.com>
Date: Wed, 29 Aug 2018 23:23:52 +0000
Subject: Re: [PATCH v2] target/iblock: split T10 PI SGL across command bios
Message-Id: <5B872B08.1050908@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180829203631.11753-1-gedwards@ddn.com>
In-Reply-To: <20180829203631.11753-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 08/29/2018 03:36 PM, Greg Edwards wrote:
> When T10 PI is enabled on a backing device for the iblock backstore, the
> PI SGL for the entire command is attached to the first bio only.  This
> works fine if the command is covered by a single bio, but can result in
> ref tag errors in the client for the other bios in a multi-bio command,
> e.g.
> 
> [   47.631236] sda: ref tag error at location 2048 (rcvd 0)
> [   47.637658] sda: ref tag error at location 4096 (rcvd 0)
> [   47.644228] sda: ref tag error at location 6144 (rcvd 0)
> 
> The command will be split into multiple bios if the number of data SG
> elements exceeds BIO_MAX_PAGES (see iblock_get_bio()).
> 
> The bios may later be split again in the block layer on the host after
> iblock_submit_bios(), depending on the queue limits of the backing
> device.  The block and SCSI layers will pass through the whole PI SGL
> down to the LLDD however that first bio is split up, but the LLDD may
> only use the portion that corresponds to the data length (depends on the
> LLDD, tested with scsi_debug).
> 
> Split the PI SGL across the bios in the command, so each bio's
> bio_integrity_payload contains the protection information for the data
> in the bio.  Use an sg_mapping_iter to keep track of where we are in PI
> SGL, so we know where to start with the next bio.
> 
> Signed-off-by: Greg Edwards <gedwards@ddn.com>
> ---
> Changes v1 -> v2:
>   * expand commit message
>   * use an sg_mapping_iter to track where we are in the PI SGL
> 
> 
>  drivers/target/target_core_iblock.c | 51 ++++++++++++++++++++---------
>  1 file changed, 35 insertions(+), 16 deletions(-)
> 
> diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
> index ce1321a5cb7b..9f9c3c934ce1 100644
> --- a/drivers/target/target_core_iblock.c
> +++ b/drivers/target/target_core_iblock.c
> @@ -635,14 +635,15 @@ static ssize_t iblock_show_configfs_dev_params(struct se_device *dev, char *b)
>  }
>  
>  static int
> -iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
> +iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio,
> +		 struct sg_mapping_iter *miter)
>  {
>  	struct se_device *dev = cmd->se_dev;
>  	struct blk_integrity *bi;
>  	struct bio_integrity_payload *bip;
>  	struct iblock_dev *ib_dev = IBLOCK_DEV(dev);
> -	struct scatterlist *sg;
> -	int i, rc;
> +	int rc;
> +	size_t resid, len;
>  
>  	bi = bdev_get_integrity(ib_dev->ibd_bd);
>  	if (!bi) {
> @@ -656,25 +657,32 @@ iblock_alloc_bip(struct se_cmd *cmd, struct bio *bio)
>  		return PTR_ERR(bip);
>  	}

Can you still hit the issue where t_prot_nents > BIO_MAX_PAGES so
bio_integrity_alloc fails or is t_prot_nents always going to be smaller.
Was wondering why you dropped that from the last patch.

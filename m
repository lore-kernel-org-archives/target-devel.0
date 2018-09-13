From: Mike Christie <mchristi@redhat.com>
Date: Thu, 13 Sep 2018 23:46:08 +0000
Subject: Re: [PATCH v5] target/iblock: split T10 PI SGL across command bios
Message-Id: <5B9AF6C0.9080303@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180904171910.21802-1-gedwards@ddn.com>
In-Reply-To: <20180904171910.21802-1-gedwards@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 09/04/2018 12:19 PM, Greg Edwards wrote:
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
> Changes from v4:
>   * use %zu for size_t in pr_debug()
> 
> Changes from v3:
>   * cast a size_t as unsigned long in a pr_debug() for 32-bit arches,
>     turned up by the kbuild test robot
> 
> Changes from v2:
>   * add back min(cmd->t_prot_nents, BIO_MAX_PAGES) for bio_integrity_alloc()
>     from v1
> 
> Changes from v1:
>   * expand commit message
>   * use an sg_mapping_iter to track where we are in the PI SGL
> 


Looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>

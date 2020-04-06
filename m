From: David Disseldorp <ddiss@suse.de>
Date: Mon, 06 Apr 2020 23:05:08 +0000
Subject: Re: strange dm-crypt problem with qemu / LIO / vhost
Message-Id: <20200407010508.70bd36c6@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <5e29cc94-a21d-2506-9bac-48d8d29ab85b@posteo.de>
In-Reply-To: <5e29cc94-a21d-2506-9bac-48d8d29ab85b@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue, 7 Apr 2020 00:01:49 +0200, Andreas Kinzler wrote:

> > It's normally a good idea to provide your kernel version with any
> > bug reports...  
> 
> Sorry. Kernel is 5.3.18 vanilla from kernel.org

Thanks.

> >> [ 3683.414936] bio error: 0000000024d02dea,  err: 10
> >> This is from target_core_iblock.c function "iblock_bio_done".
> >> Any ideas? Hints?  
> > This looks like an I/O error from the block layer / underlying dm-crypt
> > block device. It's not much to go on, but I'd suggest tracing the I/O
> > further down the stack.  
> 
> In the meantime, I was able to debug further. Actually in Windows only 
> the "format disk" operation fails. If you do that otherwise and later 
> use the formatted disk, it seems to work. So I assume it is a special 
> SCSI opcode that is only used during "format disk" that fails.
> 
> What would be a simple debug statement in iblock_bio_done to print the 
> SCSI opcode to find out which operation failed?

You could print the SCSI opcode value with something like:

--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -290,7 +290,8 @@ static void iblock_bio_done(struct bio *bio)
        struct iblock_req *ibr = cmd->priv;
 
        if (bio->bi_status) {
-               pr_err("bio error: %p,  err: %d\n", bio, bio->bi_status);
+               pr_err("op: %#x, bio error: %p, err: %d\n", cmd->t_task_cdb[0],
+                      bio, bio->bi_status);
                /*
                 * Bump the ib_bio_err_cnt and release bio.
                 */


include/scsi/scsi_proto.h should allow you to lookup the name.

Cheers, David

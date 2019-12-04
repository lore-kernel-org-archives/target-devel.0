From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 04 Dec 2019 02:39:39 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <20191204023939.GD3910@ming.t460p>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p>
 <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p>
 <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p>
 <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
 <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
 <20191203124558.GA22805@ming.t460p>
 <CAAFE1bfB2Km+e=T0ahwq0r9BQrBMnSguQQ+y=yzYi3tursS+TQ@mail.gmail.com>
In-Reply-To: <CAAFE1bfB2Km+e=T0ahwq0r9BQrBMnSguQQ+y=yzYi3tursS+TQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>

On Tue, Dec 03, 2019 at 02:56:08PM -0500, Stephen Rust wrote:
> Hi Ming,
> 
> Thanks very much for the patch.
> 
> > BTW, you may try the attached test patch. If the issue can be fixed by
> > this patch, that means it is really caused by un-aligned buffer, and
> > the iser driver needs to be fixed.
> 
> I have tried the patch, and re-run the test. Results are mixed.
> 
> To recap, our test writes the last bytes of an iser attached iscsi
> device. The target device is a LIO iblock, backed by a brd ramdisk.
> The client does a simple `dd`, doing a seek to "size - offset" of the
> device, and writing a buffer of "length" which is equivalent to the
> offset.
> 
> For example, to test a write at a 512 offset, seek to device "size -
> 512", and write a length of data 512 bytes.
> 
> WITHOUT the patch, writing data at the following offsets from the end
> of the device failed to write all the correct data (rather, the write
> succeeded, but reading the data back it was invalid):
> 
> - failed: 512,1024, 2048, 4096, 8192
> 
> Anything larger worked fine.
> 
> WITH the patch applied, writing data up to an offset of 4096 all now
> worked and verified correctly. However, offsets between 4096 and 8192
> all still failed. I started at 512, and incremented by 512 all the way
> up to 16384. The following offsets all failed to verify the write:
> 
> - failed: 4608, 5120, 5632, 6144, 6656, 7168, 7680, 8192
> 
> Anything larger continues to work fine with the patch.
> 
> As an example, for the failed 8192 case, the `bpftrace lio.bt` trace shows:
> 
> 8192 76
> 4096 0
> 4096 0
> 8192 76
> 4096 0
> 4096 0

The following delta change against last patch should fix the issue
with >4096 bvec length:

diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index 9ea1894c820d..49e37a7dda63 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -308,7 +308,7 @@ static blk_qc_t brd_make_request(struct request_queue *q, struct bio *bio)
                if (err)
                        goto io_error;
                sector += secs;
-               offset_in_sec = len - (secs << SECTOR_SHIFT);
+               offset_in_sec += len - (secs << SECTOR_SHIFT);
        }

        bio_endio(bio);

However, the change on brd is a workaround just for confirming the
issue.


Thanks, 
Ming

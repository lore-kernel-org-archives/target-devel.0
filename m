From: Stephen Rust <srust@blockbridge.com>
Date: Thu, 05 Dec 2019 02:28:43 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <CAAFE1bcwcdVuzAG5+x1UNcTaa22bf0tOaT=QOWrTup98sFXxuQ@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p> <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p> <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
 <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
 <20191203124558.GA22805@ming.t460p> <CAAFE1bfB2Km+e=T0ahwq0r9BQrBMnSguQQ+y=yzYi3tursS+TQ@mail.gmail.com>
 <20191204010529.GA3910@ming.t460p> <CAAFE1bcJmRP5OSu=5asNTpvkF=kjEZu=GafaS9h52776tVgpPA@mail.gmail.com>
 <20191204230225.GA26189@ming.t460p>
In-Reply-To: <20191204230225.GA26189@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei@redhat.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>

Hi Ming,

Thanks for all your help and insight. I really appreciate it.

> > Presumably non-brd devices, ie: real scsi devices work for these test
> > cases because they accept un-aligned buffers?
>
> Right, not every driver supports such un-aligned buffer.

Can you please clarify: does the block layer require that it is called
with 512-byte aligned buffers? If that is the case, would it make
sense for the block interface (bio_add_page() or other) to reject
buffers that are not aligned?

It seems that passing these buffers on to underlying drivers that
don't support un-aligned buffers can result in silent data corruption.
Perhaps it would be better to fail the I/O up front. This would also
help future proof the block interface when changes/new target drivers
are added.

I'm also curious how these same unaligned buffers from iSER made it to
brd and were written successfully in the pre "multi-page bvec" world.
(Just trying to understand, if you have any thoughts, as this same
test case worked fine in 4.14+ until 5.1)

> I am not familiar with RDMA, but from the trace we have done so far,
> it is highly related with iser driver.

Do you think it is fair to say that the iSER/block integration is
causing corruption by using un-aligned buffers?

Thanks,
Steve

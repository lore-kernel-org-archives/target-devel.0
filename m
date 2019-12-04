From: Ming Lei <ming.lei@redhat.com>
Date: Wed, 04 Dec 2019 23:02:25 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <20191204230225.GA26189@ming.t460p>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p>
 <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p>
 <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
 <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
 <20191203124558.GA22805@ming.t460p>
 <CAAFE1bfB2Km+e=T0ahwq0r9BQrBMnSguQQ+y=yzYi3tursS+TQ@mail.gmail.com>
 <20191204010529.GA3910@ming.t460p>
 <CAAFE1bcJmRP5OSu=5asNTpvkF=kjEZu=GafaS9h52776tVgpPA@mail.gmail.com>
In-Reply-To: <CAAFE1bcJmRP5OSu=5asNTpvkF=kjEZu=GafaS9h52776tVgpPA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Sagi Grimberg <sagi@grimberg.me>, Max Gurtovoy <maxg@mellanox.com>

On Wed, Dec 04, 2019 at 12:23:39PM -0500, Stephen Rust wrote:
> Hi Ming,
> 
> I have tried your latest "workaround" patch in brd including the fix
> for large offsets, and it does appear to work. I tried the same tests
> and the data was written correctly for all offsets I tried. Thanks!
> 
> I include the updated additional bpftrace below.
> 
> > So firstly, I'd suggest to investigate from RDMA driver side to see why
> > un-aligned buffer is passed to block layer.
> >
> > According to previous discussion, 512 aligned buffer should be provided
> > to block layer.
> >
> > So looks the driver needs to be fixed.
> 
> If it does appear to be an RDMA driver issue, do you know who we
> should follow up with directly from the RDMA driver side of the world?
> 
> Presumably non-brd devices, ie: real scsi devices work for these test
> cases because they accept un-aligned buffers?

Right, not every driver supports such un-aligned buffer.

I am not familiar with RDMA, but from the trace we have done so far,
it is highly related with iser driver. 


Thanks,
Ming

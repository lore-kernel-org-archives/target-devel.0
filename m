From: Stephen Rust <srust@blockbridge.com>
Date: Wed, 04 Dec 2019 17:23:39 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <CAAFE1bcJmRP5OSu=5asNTpvkF=kjEZu=GafaS9h52776tVgpPA@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p> <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p> <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p> <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
 <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
 <20191203124558.GA22805@ming.t460p> <CAAFE1bfB2Km+e=T0ahwq0r9BQrBMnSguQQ+y=yzYi3tursS+TQ@mail.gmail.com>
 <20191204010529.GA3910@ming.t460p>
In-Reply-To: <20191204010529.GA3910@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei@redhat.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>

Hi Ming,

I have tried your latest "workaround" patch in brd including the fix
for large offsets, and it does appear to work. I tried the same tests
and the data was written correctly for all offsets I tried. Thanks!

I include the updated additional bpftrace below.

> So firstly, I'd suggest to investigate from RDMA driver side to see why
> un-aligned buffer is passed to block layer.
>
> According to previous discussion, 512 aligned buffer should be provided
> to block layer.
>
> So looks the driver needs to be fixed.

If it does appear to be an RDMA driver issue, do you know who we
should follow up with directly from the RDMA driver side of the world?

Presumably non-brd devices, ie: real scsi devices work for these test
cases because they accept un-aligned buffers?

> The patch might not cover the big offset case, could you collect bpftrace
> via the following script when you reproduce the issue with >4096 offset?

Here is the updated bpftrace output for an offset of 8192:

8192 76
4020 76 1 131056
4096 0 1 131063
76 0 1 131071
4096 0
4096 0 0 0
4096 0
4096 0 0 8
4096 0
4096 0 0 130944
8192 76
4020 76 1 131056
4096 0 1 131063
76 0 1 131071
4096 0
4096 0 0 130808
4096 0
4096 0
4096 0 0 131056
4096 0 0 131064
[snip]

Thanks,
Steve

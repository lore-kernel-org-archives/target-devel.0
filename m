From: Stephen Rust <srust@blockbridge.com>
Date: Thu, 05 Dec 2019 14:36:25 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <CAAFE1bcgKAuzmE+eYXvcj6y4SykoaWfXgzR+f2N73K_2RfZ6LA@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p> <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p> <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
 <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
 <20191203124558.GA22805@ming.t460p> <CAAFE1bfB2Km+e=T0ahwq0r9BQrBMnSguQQ+y=yzYi3tursS+TQ@mail.gmail.com>
 <20191204010529.GA3910@ming.t460p> <CAAFE1bcJmRP5OSu=5asNTpvkF=kjEZu=GafaS9h52776tVgpPA@mail.gmail.com>
 <20191204230225.GA26189@ming.t460p> <d9d39d10-d3f3-f2d8-b32e-96896ba0cdb2@grimberg.me>
In-Reply-To: <d9d39d10-d3f3-f2d8-b32e-96896ba0cdb2@grimberg.me>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Ming Lei <ming.lei@redhat.com>, Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Max Gurtovoy <maxg@mellanox.com>

Hi Sagi,

On Thu, Dec 5, 2019 at 4:17 AM Sagi Grimberg <sagi@grimberg.me> wrote:
>
> Just got this one (Thanks for CCing me Ming, been extremely busy
> lately).

No problem, thanks for looking into it!

> So it looks from the report that this is the immediate-data and
> unsolicited data-out flows, which indeed seem to violate the alignment
> assumption. The reason is that isert post recv a contig rx_desc which
> has both the headers and the data, and when it gets immediate_data it
> will set the data sg to rx_desc+offset (which are the headers).
>
> Stephen,
> As a work-around for now, you should turn off immediate-data in your LIO
> target. I'll work on a fix.

I have confirmed that turning off ImmediateData in the target (and
reconnecting) is a successful workaround for this test case. All of
the I/O as reported by bio_add_page() is aligned.

Using the previously described bpftrace script with 512 offset:

# bpftrace lio.bt
Attaching 4 probes...
512 0
512 0 1 131071
4096 0
4096 0 0 0
4096 0
4096 0 0 8
4096 0
4096 0 0 131064
4096 0
4096 0 1 131064
4096 0
4096 0 0 0
4096 0
4096 0 0 8
512 0
512 0 0 131071
4096 0
4096 0 0 130944
4096 0
4096 0 0 131056

> Thanks for reporting!

Please let me know if you need any additional information, or if I can
assist further. I would be happy to test any patches when you are
ready.

Thanks,
Steve

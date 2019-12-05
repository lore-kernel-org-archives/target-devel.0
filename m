From: Sagi Grimberg <sagi@grimberg.me>
Date: Thu, 05 Dec 2019 09:17:41 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <d9d39d10-d3f3-f2d8-b32e-96896ba0cdb2@grimberg.me>
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
 <20191204230225.GA26189@ming.t460p>
In-Reply-To: <20191204230225.GA26189@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei@redhat.com>, Stephen Rust <srust@blockbridge.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Max Gurtovoy <maxg@mellanox.com>


>> Hi Ming,
>>
>> I have tried your latest "workaround" patch in brd including the fix
>> for large offsets, and it does appear to work. I tried the same tests
>> and the data was written correctly for all offsets I tried. Thanks!
>>
>> I include the updated additional bpftrace below.
>>
>>> So firstly, I'd suggest to investigate from RDMA driver side to see why
>>> un-aligned buffer is passed to block layer.
>>>
>>> According to previous discussion, 512 aligned buffer should be provided
>>> to block layer.
>>>
>>> So looks the driver needs to be fixed.
>>
>> If it does appear to be an RDMA driver issue, do you know who we
>> should follow up with directly from the RDMA driver side of the world?
>>
>> Presumably non-brd devices, ie: real scsi devices work for these test
>> cases because they accept un-aligned buffers?
> 
> Right, not every driver supports such un-aligned buffer.
> 
> I am not familiar with RDMA, but from the trace we have done so far,
> it is highly related with iser driver.

Hi guys,

Just got this one (Thanks for CCing me Ming, been extremely busy
lately).

So it looks from the report that this is the immediate-data and
unsolicited data-out flows, which indeed seem to violate the alignment
assumption. The reason is that isert post recv a contig rx_desc which
has both the headers and the data, and when it gets immediate_data it
will set the data sg to rx_desc+offset (which are the headers).

Stephen,
As a work-around for now, you should turn off immediate-data in your LIO
target. I'll work on a fix.

Thanks for reporting!

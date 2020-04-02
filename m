From: Sagi Grimberg <sagi@grimberg.me>
Date: Thu, 02 Apr 2020 22:16:53 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <1f6bc60e-7f2b-d959-f1ce-5055752e2323@grimberg.me>
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
 <d9d39d10-d3f3-f2d8-b32e-96896ba0cdb2@grimberg.me>
 <CAAFE1beqFBQS_zVYEXFTD2qu8PAF9hBSW4j1k9ZD6MhU_gWg5Q@mail.gmail.com>
 <d2f633f1-57ef-4618-c3a6-c5ff0afead5b@grimberg.me>
 <CAAFE1bdAbKfqbf05pKBcMUj+58fijDMT-8WBSuwiKk2Bmm4v2w@mail.gmail.com>
 <95750c05-eb49-d1db-311f-4edf9b4fd6ec@grimberg.me>
 <CAAFE1bcmFxb6MYbicUVdVsK6QNjweaow3v+vHe6szwfFN6K-=A@mail.gmail.com>
In-Reply-To: <CAAFE1bcmFxb6MYbicUVdVsK6QNjweaow3v+vHe6szwfFN6K-=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Ming Lei <ming.lei@redhat.com>, Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Max Gurtovoy <maxg@mellanox.com>


> Hi Sagi,
> 
>> Does the attached patch work for you?
> 
> This patch _does_ work for our tests. I see all the writes aligned to
> 512 bytes as, I think, would be expected. Thanks!

Good to hear, I'll wait for your further testing before submitting
it as a patch as I don't have resources to test this thoroughly
at the moment.

Thanks,
Sagi

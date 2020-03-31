From: Sagi Grimberg <sagi@grimberg.me>
Date: Tue, 31 Mar 2020 01:07:13 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <82bbbdf2-cf61-d523-29e0-d756b7f208f4@grimberg.me>
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
In-Reply-To: <CAAFE1bdAbKfqbf05pKBcMUj+58fijDMT-8WBSuwiKk2Bmm4v2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Ming Lei <ming.lei@redhat.com>, Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Max Gurtovoy <maxg@mellanox.com>


>> Can you try attached patch and see if it solves your issue?
>> WARNING: very lightly tested...
> 
> I have run our tests against this patch and it is working well for our
> "basic" testing as well. The test case that previously failed, now
> passes with this patch. So that's encouraging! Thanks for the quick
> response and quick patch.

Good to know..

> One question we had is regarding the hard coded header length: What
> happens if the initiator sends an extended CDB, like a WRITE32? Are
> there any concerns with an additional header segment (AHS)?

You are absolutely correct! t10-dif is broken with this patch as
32 byte cdb would break into two buffers which is not expected
by the target core...

I take back this patch, I guess we should keep contiguous allocation but
just make the recv wr such that the data is aligned for 16 bytes cdbs,
and for 32-byte cdbs we never support immediate data anyways...

From: Ming Lei <ming.lei@redhat.com>
Date: Tue, 03 Dec 2019 03:14:44 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <20191203031444.GB6245@ming.t460p>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p>
 <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p>
 <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p>
 <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p>
 <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
In-Reply-To: <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org

On Mon, Dec 02, 2019 at 10:04:20PM -0500, Stephen Rust wrote:
> Hi Ming,
> 
> The log you requested with the (arg4 & 512 != 0) predicate did not

oops, it should have been (arg4 & 511) != 0.

Thanks,
Ming

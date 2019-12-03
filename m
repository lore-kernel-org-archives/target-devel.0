From: Ming Lei <ming.lei@redhat.com>
Date: Tue, 03 Dec 2019 00:58:49 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <20191203005849.GB25002@ming.t460p>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p>
 <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p>
 <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p>
 <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
In-Reply-To: <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org

On Mon, Dec 02, 2019 at 01:42:15PM -0500, Stephen Rust wrote:
> Hi Ming,
> 
> > I may get one machine with Mellanox NIC, is it easy to setup & reproduce
> > just in the local machine(both host and target are setup on same machine)?
> 
> Yes, I have reproduced locally on one machine (using the IP address of
> the Mellanox NIC as the target IP), with iser enabled on the target,
> and iscsiadm connected via iser.
> 
> e.g.:
> target:
> /iscsi/iqn.20.../0.0.0.0:3260> enable_iser true
> iSER enable now: True
> 
>   | |   o- portals
> ....................................................................................................
> [Portals: 1]
>   | |     o- 0.0.0.0:3260
> ...................................................................................................
> [iser]
> 
> client:
> # iscsiadm -m node -o update --targetname <target> -n
> iface.transport_name -v iser
> # iscsiadm -m node --targetname <target> --login
> # iscsiadm -m session
> iser: [3] 172.16.XX.XX:3260,1
> iqn.2003-01.org.linux-iscsi.x8664:sn.c46c084919b0 (non-flash)
> 
> > Please try to trace bio_add_page() a bit via 'bpftrace ./ilo.bt'.
> 
> Here is the output of this trace from a failed run:
> 
> # bpftrace lio.bt
> modprobe: FATAL: Module kheaders not found.
> Attaching 3 probes...
> 512 76
> 4096 0
> 4096 0
> 4096 0
> 4096 76

The above buffer might be the reason, 4096 is length, and 76 is the
offset, that means the added buffer crosses two pages, meantime the
buffer isn't aligned.

We need to figure out why the magic 76 offset is passed from target or
driver.

Please install bcc and collect the following log:

/usr/share/bcc/tools/trace -K 'bio_add_page ((arg4 & 512) != 0) "%d %d", arg3, arg4 '


Thanks,
Ming

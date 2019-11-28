From: Ming Lei <ming.lei@redhat.com>
Date: Thu, 28 Nov 2019 09:12:10 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <20191128091210.GC15549@ming.t460p>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p>
 <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p>
 <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
In-Reply-To: <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org

On Wed, Nov 27, 2019 at 11:14:46PM -0500, Stephen Rust wrote:
> Hi,
> 
> Thanks for your reply.
> 
> I agree it does seem surprising that the git bisect pointed to this
> particular commit when tracking down this issue.
> 
> The ramdisk we export in LIO is a standard "brd" module ramdisk (ie:
> /dev/ram*). We configure it as a "block" backstore in LIO, not using the
> built-in LIO ramdisk.

Then it isn't strange any more, since iblock code uses bio interface.

> 
> LIO configuration is as follows:
> 
>   o- backstores ..........................................................
> [...]
>   | o- block .............................................. [Storage
> Objects: 1]
>   | | o- Blockbridge-952f0334-2535-5fae-9581-6c6524165067
>  [/dev/ram-bb.952f0334-2535-5fae-9581-6c6524165067.cm2 (16.0MiB) write-thru
> activated]
>   | |   o- alua ............................................... [ALUA
> Groups: 1]
>   | |     o- default_tg_pt_gp ................... [ALUA state:
> Active/optimized]
>   | o- fileio ............................................. [Storage
> Objects: 0]
>   | o- pscsi .............................................. [Storage
> Objects: 0]
>   | o- ramdisk ............................................ [Storage
> Objects: 0]
>   o- iscsi ........................................................
> [Targets: 1]
>   | o-
> iqn.2009-12.com.blockbridge:rda:1:952f0334-2535-5fae-9581-6c6524165067:rda
>  [TPGs: 1]
>   |   o- tpg1 ...................................... [no-gen-acls, auth
> per-acl]
>   |     o- acls ......................................................
> [ACLs: 1]
>   |     | o- iqn.1994-05.com.redhat:115ecc56a5c .. [mutual auth, Mapped
> LUNs: 1]
>   |     |   o- mapped_lun0  [lun0
> block/Blockbridge-952f0334-2535-5fae-9581-6c6524165067 (rw)]
>   |     o- luns ......................................................
> [LUNs: 1]
>   |     | o- lun0  [block/Blockbridge-952f0334-2535-5fae-9581-6c6524165067
> (/dev/ram-bb.952f0334-2535-5fae-9581-6c6524165067.cm2) (default_tg_pt_gp)]
>   |     o- portals ................................................
> [Portals: 1]
>   |       o- 0.0.0.0:3260 ...............................................
> [iser]
> 
> 
> iSER is the iSCSI extension for RDMA, and it is important to note that we
> have _only_ reproduced this when the writes occur over RDMA, with the
> target portal in LIO having enabled "iser". The iscsi client (using
> iscsiadm) connects to the target directly over iSER. We use the Mellanox
> ConnectX-5 Ethernet NICs (mlx5* module) for this purpose, which utilizes
> RoCE (RDMA over Converged Ethernet) instead of TCP.

I may get one machine with Mellanox NIC, is it easy to setup & reproduce
just in the local machine(both host and target are setup on same machine)?

> 
> The identical ramdisk configuration using TCP/IP target in LIO has _not_
> reproduced this issue for us.

Yeah, I just tried iblock over brd, and can't reproduce it.

> 
> I installed bcc and used the stackcount tool to trace rd_execute_rw, but I
> suspect because we are not using the built-in LIO ramdisk this did not
> catch anything. Are there other function traces we can provide for you?

Please try to trace bio_add_page() a bit via 'bpftrace ./ilo.bt'.

[root@ktest-01 func]# cat ilo.bt
kprobe:iblock_execute_rw
{
    @start[tid]=1;
}

kretprobe:iblock_execute_rw
{
    @start[tid]=0;
}

kprobe:bio_add_page
/@start[tid]/
{
  printf("%d %d\n", arg2, arg3);
}



Thanks, 
Ming

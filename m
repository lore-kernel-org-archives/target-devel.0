From: Rob Townley <rob.townley@gmail.com>
Date: Thu, 28 Nov 2019 05:51:56 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <CA+VdTb-HTXidfFVmzV2ynJgOGdmb-Ps=j9vQfZ-iZBPFm4RWJg@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p> <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p> <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <CAAFE1bdGCx96tLKgSkNf7=MDZEZMnC==PJghpsRctvZpPLaX5w@mail.gmail.com>
In-Reply-To: <CAAFE1bdGCx96tLKgSkNf7=MDZEZMnC==PJghpsRctvZpPLaX5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org

Interesting case to follow as there are many types of RamDisks.  The
common tmpfs kind will use its RAM allocation and all free harddrive
space.

The ramdisk in CentOS 7 backed by LIO will overflow its size in RAM
and fill up all remaining free space on spinning platters.  So if the
RamDisk is 4GB out of 192GB RAM in the lightly used machine. Free
filesystem space is 16GB.  Writes to the 4GB RamDisk will only error
out at 21GB when there is no space left on filesystem.

dd if=/dev/zero of=/dev/iscsiRamDisk
Will keep writing way past 4GB and not stop till hardrive is full
which is totally different than normal disks.

Wonder what exact kind of RamDisk is in that kernel?

On Wed, Nov 27, 2019 at 10:26 PM Stephen Rust <srust@blockbridge.com> wrote:
>
> [Apologies for dup, re-sending without text formatting to lists]
>
> Hi,
>
> Thanks for your reply.
>
> I agree it does seem surprising that the git bisect pointed to this
> particular commit when tracking down this issue.
>
> > Stephen, could you share us how you setup the ramdisk in your test?
>
> The ramdisk we export in LIO is a standard "brd" module ramdisk (ie:
> /dev/ram*). We configure it as a "block" backstore in LIO, not using
> the built-in LIO ramdisk.
>
> LIO configuration is as follows:
>
>   o- backstores .......................................................... [...]
>   | o- block .............................................. [Storage Objects: 1]
>   | | o- Blockbridge-952f0334-2535-5fae-9581-6c6524165067
> [/dev/ram-bb.952f0334-2535-5fae-9581-6c6524165067.cm2 (16.0MiB)
> write-thru activated]
>   | |   o- alua ............................................... [ALUA Groups: 1]
>   | |     o- default_tg_pt_gp ................... [ALUA state: Active/optimized]
>   | o- fileio ............................................. [Storage Objects: 0]
>   | o- pscsi .............................................. [Storage Objects: 0]
>   | o- ramdisk ............................................ [Storage Objects: 0]
>   o- iscsi ........................................................ [Targets: 1]
>   | o- iqn.2009-12.com.blockbridge:rda:1:952f0334-2535-5fae-9581-6c6524165067:rda
>  [TPGs: 1]
>   |   o- tpg1 ...................................... [no-gen-acls, auth per-acl]
>   |     o- acls ...................................................... [ACLs: 1]
>   |     | o- iqn.1994-05.com.redhat:115ecc56a5c .. [mutual auth, Mapped LUNs: 1]
>   |     |   o- mapped_lun0  [lun0
> block/Blockbridge-952f0334-2535-5fae-9581-6c6524165067 (rw)]
>   |     o- luns ...................................................... [LUNs: 1]
>   |     | o- lun0
> [block/Blockbridge-952f0334-2535-5fae-9581-6c6524165067
> (/dev/ram-bb.952f0334-2535-5fae-9581-6c6524165067.cm2)
> (default_tg_pt_gp)]
>   |     o- portals ................................................ [Portals: 1]
>   |       o- 0.0.0.0:3260 ............................................... [iser]
>
> > > > Could you explain a bit what is iSCSI attached with iSER / RDMA? Is the
> > > > actual transport TCP over RDMA? What is related target driver involved?
>
> iSER is the iSCSI extension for RDMA, and it is important to note that
> we have _only_ reproduced this when the writes occur over RDMA, with
> the target portal in LIO having enabled "iser". The iscsi client
> (using iscsiadm) connects to the target directly over iSER. We use the
> Mellanox ConnectX-5 Ethernet NICs (mlx5* module) for this purpose,
> which utilizes RoCE (RDMA over Converged Ethernet) instead of TCP.
>
> The identical ramdisk configuration using TCP/IP target in LIO has
> _not_ reproduced this issue for us.
>
> > > > /usr/share/bcc/tools/stackcount -K rd_execute_rw
>
> I installed bcc and used the stackcount tool to trace rd_execute_rw,
> but I suspect because we are not using the built-in LIO ramdisk this
> did not catch anything. Are there other function traces we can provide
> for you?
>
> Thanks,
> Steve

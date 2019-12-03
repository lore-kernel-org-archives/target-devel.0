From: Stephen Rust <srust@blockbridge.com>
Date: Tue, 03 Dec 2019 03:04:20 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p> <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p> <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p> <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p>
In-Reply-To: <20191203005849.GB25002@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei@redhat.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org

Hi Ming,

The log you requested with the (arg4 & 512 != 0) predicate did not
match anything. However, I checked specifically for the offset of "76"
and came up with the following stack traces:

# /usr/share/bcc/tools/trace -K 'bio_add_page ((arg4 = 76)) "%d %d",
arg3, arg4 '
PID     TID     COMM            FUNC             -
7782    7782    kworker/19:1H   bio_add_page     512 76
        bio_add_page+0x1 [kernel]
        sbc_execute_rw+0x28 [kernel]
        __target_execute_cmd+0x2e [kernel]
        target_execute_cmd+0x1c1 [kernel]
        iscsit_execute_cmd+0x1e7 [kernel]
        iscsit_sequence_cmd+0xdc [kernel]
        isert_recv_done+0x780 [kernel]
        __ib_process_cq+0x78 [kernel]
        ib_cq_poll_work+0x29 [kernel]
        process_one_work+0x179 [kernel]
        worker_thread+0x4f [kernel]
        kthread+0x105 [kernel]
        ret_from_fork+0x1f [kernel]

14475   14475   kworker/13:1H   bio_add_page     4096 76
        bio_add_page+0x1 [kernel]
        sbc_execute_rw+0x28 [kernel]
        __target_execute_cmd+0x2e [kernel]
        target_execute_cmd+0x1c1 [kernel]
        iscsit_execute_cmd+0x1e7 [kernel]
        iscsit_sequence_cmd+0xdc [kernel]
        isert_recv_done+0x780 [kernel]
        __ib_process_cq+0x78 [kernel]
        ib_cq_poll_work+0x29 [kernel]
        process_one_work+0x179 [kernel]
        worker_thread+0x4f [kernel]
        kthread+0x105 [kernel]
        ret_from_fork+0x1f [kernel]

Thanks,
Steve

On Mon, Dec 2, 2019 at 7:59 PM Ming Lei <ming.lei@redhat.com> wrote:
>
> On Mon, Dec 02, 2019 at 01:42:15PM -0500, Stephen Rust wrote:
> > Hi Ming,
> >
> > > I may get one machine with Mellanox NIC, is it easy to setup & reproduce
> > > just in the local machine(both host and target are setup on same machine)?
> >
> > Yes, I have reproduced locally on one machine (using the IP address of
> > the Mellanox NIC as the target IP), with iser enabled on the target,
> > and iscsiadm connected via iser.
> >
> > e.g.:
> > target:
> > /iscsi/iqn.20.../0.0.0.0:3260> enable_iser true
> > iSER enable now: True
> >
> >   | |   o- portals
> > ....................................................................................................
> > [Portals: 1]
> >   | |     o- 0.0.0.0:3260
> > ...................................................................................................
> > [iser]
> >
> > client:
> > # iscsiadm -m node -o update --targetname <target> -n
> > iface.transport_name -v iser
> > # iscsiadm -m node --targetname <target> --login
> > # iscsiadm -m session
> > iser: [3] 172.16.XX.XX:3260,1
> > iqn.2003-01.org.linux-iscsi.x8664:sn.c46c084919b0 (non-flash)
> >
> > > Please try to trace bio_add_page() a bit via 'bpftrace ./ilo.bt'.
> >
> > Here is the output of this trace from a failed run:
> >
> > # bpftrace lio.bt
> > modprobe: FATAL: Module kheaders not found.
> > Attaching 3 probes...
> > 512 76
> > 4096 0
> > 4096 0
> > 4096 0
> > 4096 76
>
> The above buffer might be the reason, 4096 is length, and 76 is the
> offset, that means the added buffer crosses two pages, meantime the
> buffer isn't aligned.
>
> We need to figure out why the magic 76 offset is passed from target or
> driver.
>
> Please install bcc and collect the following log:
>
> /usr/share/bcc/tools/trace -K 'bio_add_page ((arg4 & 512) != 0) "%d %d", arg3, arg4 '
>
>
> Thanks,
> Ming
>

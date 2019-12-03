From: Ming Lei <ming.lei@redhat.com>
Date: Tue, 03 Dec 2019 04:15:04 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <20191203041504.GC6245@ming.t460p>
List-Id: <target-devel.vger.kernel.org>
References: <20191128015748.GA3277@ming.t460p>
 <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p>
 <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p>
 <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p>
 <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p>
 <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
In-Reply-To: <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Rust <srust@blockbridge.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org

On Mon, Dec 02, 2019 at 10:26:28PM -0500, Stephen Rust wrote:
> > oops, it should have been (arg4 & 511) != 0.
> 
> Yep, there they are:
> 
> # /usr/share/bcc/tools/trace -K 'bio_add_page ((arg4 & 511) != 0) "%d
> %d", arg3, arg4'
> PID     TID     COMM            FUNC             -
> 7411    7411    kworker/31:1H   bio_add_page     512 76
>         bio_add_page+0x1 [kernel]
>         sbc_execute_rw+0x28 [kernel]
>         __target_execute_cmd+0x2e [kernel]
>         target_execute_cmd+0x1c1 [kernel]
>         iscsit_execute_cmd+0x1e7 [kernel]
>         iscsit_sequence_cmd+0xdc [kernel]
>         isert_recv_done+0x780 [kernel]
>         __ib_process_cq+0x78 [kernel]
>         ib_cq_poll_work+0x29 [kernel]
>         process_one_work+0x179 [kernel]
>         worker_thread+0x4f [kernel]
>         kthread+0x105 [kernel]
>         ret_from_fork+0x1f [kernel]
> 
> 7753    7753    kworker/26:1H   bio_add_page     4096 76

The issue should be in brd_make_request() which assumes that
bvec.bv_len is 512bytes align.

I will figure out one patch for you tomorrow.

Thanks,
Ming

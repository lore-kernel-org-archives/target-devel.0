From: Stephen Rust <srust@blockbridge.com>
Date: Tue, 03 Dec 2019 03:50:32 +0000
Subject: Re: Data corruption in kernel 5.1+ with iSER attached ramdisk
Message-Id: <CAAFE1bfpUWCZrtR8v3S++0-+gi8DJ79X3e0XqDe93i8nuGTnNg@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
References: <CAAFE1bd9wuuobpe4VK7Ty175j7mWT+kRmHCNhVD+6R8MWEAqmw@mail.gmail.com>
 <20191128015748.GA3277@ming.t460p> <CA+VdTb_-CGaPjKUQteKVFSGqDz-5o-tuRRkJYqt8B9iOQypiwQ@mail.gmail.com>
 <20191128025822.GC3277@ming.t460p> <CAAFE1bfsXsKGyw7SU_z4NanT+wmtuJT=XejBYbHHMCDQwm73sw@mail.gmail.com>
 <20191128091210.GC15549@ming.t460p> <CAAFE1beMkvyRctGqpffd3o_QtDH0CrmQSb=fV4GzqMUXWzPyOw@mail.gmail.com>
 <20191203005849.GB25002@ming.t460p> <CAAFE1bcG8c1Q3iwh-LUjruBMAuFTJ4qWxNGsnhfKvGWHNLAeEQ@mail.gmail.com>
 <20191203031444.GB6245@ming.t460p> <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
In-Reply-To: <CAAFE1besnb=HV4C_buORYpWbkXecmtybwX8d_Ka2NsKmiym53w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ming Lei <ming.lei@redhat.com>
Cc: Rob Townley <rob.townley@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, target-devel@vger.kernel.org

Hi,

Another datapoint.

I enabled "isert_debug" tracing and re-ran the test. Here is a small
snippet of the debug data. FWIW, the "length of 76" in the "lkey
mismatch" is a pattern that repeats quite often during the exchange.


Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: DMA:
0x10a6457000, iSCSI opcode: 0x01, ITT: 0x00000023, flags: 0x81 dlen: 0
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: ISER ISCSI_CTRL PDU
Dec 03 03:41:12 host-2 kernel: isert: __isert_create_send_desc:
tx_desc 000000009bbe54ca lkey mismatch, fixing
Dec 03 03:41:12 host-2 kernel: isert: isert_init_tx_hdrs: Setup
tx_sg[0].addr: 0x4ce45010 length: 76 lkey: 0x80480
Dec 03 03:41:12 host-2 kernel: isert: isert_put_response: Posting SCSI Response
Dec 03 03:41:12 host-2 kernel: isert: isert_send_done: Cmd 00000000238f9047
Dec 03 03:41:12 host-2 kernel: isert: isert_unmap_tx_desc: unmap
single for tx_desc->dma_addr
Dec 03 03:41:12 host-2 kernel: isert: isert_put_cmd: Cmd 00000000238f9047
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: DMA:
0x10a645a000, iSCSI opcode: 0x01, ITT: 0x00000024, flags: 0xa1 dlen:
512
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: ISER ISCSI_CTRL PDU
Dec 03 03:41:12 host-2 kernel: isert: isert_handle_scsi_cmd: Transfer
Immediate imm_data_len: 512
Dec 03 03:41:12 host-2 kernel: isert: __isert_create_send_desc:
tx_desc 000000004b902cb9 lkey mismatch, fixing
Dec 03 03:41:12 host-2 kernel: isert: isert_init_tx_hdrs: Setup
tx_sg[0].addr: 0x4ce55b70 length: 76 lkey: 0x80480
Dec 03 03:41:12 host-2 kernel: isert: isert_put_response: Posting SCSI Response
Dec 03 03:41:12 host-2 kernel: isert: isert_send_done: Cmd 0000000069929548
Dec 03 03:41:12 host-2 kernel: isert: isert_unmap_tx_desc: unmap
single for tx_desc->dma_addr
Dec 03 03:41:12 host-2 kernel: isert: isert_put_cmd: Cmd 0000000069929548
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: DMA:
0x10a645d000, iSCSI opcode: 0x01, ITT: 0x00000025, flags: 0x81 dlen: 0
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: ISER ISCSI_CTRL PDU
Dec 03 03:41:12 host-2 kernel: isert: __isert_create_send_desc:
tx_desc 000000006d694fe9 lkey mismatch, fixing
Dec 03 03:41:12 host-2 kernel: isert: isert_init_tx_hdrs: Setup
tx_sg[0].addr: 0x4ce56140 length: 76 lkey: 0x80480
Dec 03 03:41:12 host-2 kernel: isert: isert_put_response: Posting SCSI Response
Dec 03 03:41:12 host-2 kernel: isert: isert_send_done: Cmd 00000000a666ae3c
Dec 03 03:41:12 host-2 kernel: isert: isert_unmap_tx_desc: unmap
single for tx_desc->dma_addr
Dec 03 03:41:12 host-2 kernel: isert: isert_put_cmd: Cmd 00000000a666ae3c
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: DMA:
0x10a6460000, iSCSI opcode: 0x01, ITT: 0x00000026, flags: 0x81 dlen: 0
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: ISER ISCSI_CTRL PDU
Dec 03 03:41:12 host-2 kernel: isert: __isert_create_send_desc:
tx_desc 00000000dd22ea75 lkey mismatch, fixing
Dec 03 03:41:12 host-2 kernel: isert: isert_init_tx_hdrs: Setup
tx_sg[0].addr: 0x4ce5e6f0 length: 76 lkey: 0x80480
Dec 03 03:41:12 host-2 kernel: isert: isert_put_response: Posting SCSI Response
Dec 03 03:41:12 host-2 kernel: isert: isert_send_done: Cmd 000000009b63dcb0
Dec 03 03:41:12 host-2 kernel: isert: isert_unmap_tx_desc: unmap
single for tx_desc->dma_addr
Dec 03 03:41:12 host-2 kernel: isert: isert_put_cmd: Cmd 000000009b63dcb0
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: DMA:
0x10a6463000, iSCSI opcode: 0x01, ITT: 0x00000027, flags: 0xc1 dlen: 0
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: ISER_RSV:
read_stag: 0x4000009a read_va: 0xac29e6800
Dec 03 03:41:12 host-2 kernel: isert: isert_recv_done: ISER ISCSI_CTRL PDU
Dec 03 03:41:12 host-2 kernel: isert: isert_put_datain: Cmd:
00000000fe3d39bf RDMA_WRITE data_length: 32
Dec 03 03:41:12 host-2 kernel: isert: __isert_create_send_desc:
tx_desc 00000000f5f10cf7 lkey mismatch, fixing
Dec 03 03:41:12 host-2 kernel: isert: isert_init_tx_hdrs: Setup
tx_sg[0].addr: 0x4ce56710 length: 76 lkey: 0x80480
Dec 03 03:41:12 host-2 kernel: isert: isert_put_datain: Cmd:
00000000fe3d39bf posted RDMA_WRITE for iSER Data READ rc: 0
Dec 03 03:41:12 host-2 kernel: isert: isert_send_done: Cmd 00000000fe3d39bf
Dec 03 03:41:12 host-2 kernel: isert: isert_unmap_tx_desc: unmap
single for tx_desc->dma_addr
Dec 03 03:41:12 host-2 kernel: isert: isert_put_cmd: Cmd 00000000fe3d39bf

[snip]

I could post the whole isert debug log somewhere if you'd like?

Thanks,
Steve

On Mon, Dec 2, 2019 at 10:26 PM Stephen Rust <srust@blockbridge.com> wrote:
>
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

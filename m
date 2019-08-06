From: Christoph Hellwig <hch@lst.de>
Date: Tue, 06 Aug 2019 05:19:11 +0000
Subject: Re: [PATCH] block: Remove request_queue argument from blk_execute_rq_nowait
Message-Id: <20190806051911.GA13409@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20190806011754.7722-1-marcos.souza.org@gmail.com>
In-Reply-To: <20190806011754.7722-1-marcos.souza.org@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Marcos Paulo de Souza <marcos.souza.org@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Doug Gilbert <dgilbert@interlog.com>, Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>, Hannes Reinecke <hare@suse.com>, Omar Sandoval <osandov@fb.com>, Ming Lei <ming.lei@redhat.com>, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, Damien Le Moal <damien.lemoal@wdc.com>, Bart Van Assche <bvanassche@acm.org>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>, "open list:SCSI SUBSYSTEM" <linux-scsi@vger.kernel.org>, "open list:SCSI TARGET SUBSYSTEM" <target-devel@vger.kernel.org>

On Mon, Aug 05, 2019 at 10:17:51PM -0300, Marcos Paulo de Souza wrote:
> +void blk_execute_rq_nowait(struct gendisk *bd_disk, struct request *rq,
> +			int at_head, rq_end_io_fn *done)

We store a ->rq_disk in struct request, so we should also not need
that.  And at_head should either become a bool, or be replaced with
a flags argument, ints used boolean are usually not a good idea.

> @@ -81,7 +80,7 @@ void blk_execute_rq(struct request_queue *q, struct gendisk *bd_disk,

And all the same argument changes that apply to blk_execute_rq_nowait
apply to blk_execute_rq as well.

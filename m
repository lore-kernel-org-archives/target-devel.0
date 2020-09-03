From: Christoph Hellwig <hch@lst.de>
Date: Thu, 03 Sep 2020 08:26:09 +0000
Subject: Re: [PATCH 2/9] block: add a bdev_is_partition helper
Message-Id: <20200903082609.GA23498@lst.de>
List-Id: <target-devel.vger.kernel.org>
References: <20200903054104.228829-1-hch@lst.de> <20200903054104.228829-3-hch@lst.de> <CAPDyKFrkcpziGFPmSd8Kx4bzhoN6zxF1E8MagLQSa4sBmnicOg@mail.gmail.com>
In-Reply-To: <CAPDyKFrkcpziGFPmSd8Kx4bzhoN6zxF1E8MagLQSa4sBmnicOg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, dm-devel@redhat.com, Linux Documentation <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block <linux-block@vger.kernel.org>, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>, linux-s390@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, target-devel@vger.kernel.org

On Thu, Sep 03, 2020 at 10:19:34AM +0200, Ulf Hansson wrote:
> On Thu, 3 Sep 2020 at 07:42, Christoph Hellwig <hch@lst.de> wrote:
> >
> > Add a littler helper to make the somewhat arcane bd_contains checks a
> > little more obvious.
> >
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Not sure why we have both "bd_contains" and "bd_partno", nevertheless,
> feel free to add:

Right now both are needed for how blkdev_get/put work.  But I plan to
eventual kill off bd_contains after some major surgery to that code.

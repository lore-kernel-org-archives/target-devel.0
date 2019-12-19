From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 19 Dec 2019 23:51:02 +0000
Subject: Re: [PATCH] scsi: target/iblock: Fix protection error with sectors greater than 512B
Message-Id: <yq1r20zan89.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1576078562-15240-1-git-send-email-israelr@mellanox.com>
In-Reply-To: <1576078562-15240-1-git-send-email-israelr@mellanox.com> (Israel
        Rukshin's message of "Wed, 11 Dec 2019 17:36:02 +0200")
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Israel Rukshin <israelr@mellanox.com>
Cc: Target-devel <target-devel@vger.kernel.org>, Linux-scsi <linux-scsi@vger.kernel.org>, Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>


Israel,

> The sector size of the block layer is 512 bytes, but integrity
> interval size might be different (in case of 4K block size of the
> media). At the initiator side the virtual start sector is the one that
> was originally submitted by the block layer (512 bytes) for the Reftag
> usage. The initiator converts the Reftag to integrity interval units
> and sends it to the target. So the target virtual start sector should
> be calculated at integrity interval units. prepare_fn() and
> complete_fn() don't remap correctly the Reftag when using incorrect
> units of the virtual start sector, which leads to the following
> protection error at the device:

Applied to 5.5/scsi-fixes, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

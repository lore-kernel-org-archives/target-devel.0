From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Tue, 13 Oct 2020 22:42:52 +0000
Subject: Re: [PATCH 00/14] drop double zeroing
Message-Id: <160262862433.3018.13907233755506910409.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
In-Reply-To: <1600601186-7420-1-git-send-email-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-spi@vger.kernel.org, Julia Lawall <Julia.Lawall@inria.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, dmaengine@vger.kernel.org, kernel-janitors@vger.kernel.org, linux-media@vger.kernel.org, target-devel@vger.kernel.org, linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org, netdev@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, linux-serial@vger.kernel.org, linux-nfs@vger.kernel.org, linux-scsi@vger.kernel.org, Yossi Leybovich <sleybo@amazon.com>, linux-block@vger.kernel.org, rds-devel@oss.oracle.com

On Sun, 20 Sep 2020 13:26:12 +0200, Julia Lawall wrote:

> sg_init_table zeroes its first argument, so the allocation of that argument
> doesn't have to.

Applied to 5.10/scsi-queue, thanks!

[02/14] scsi: target: rd: Drop double zeroing
        https://git.kernel.org/mkp/scsi/c/4b217e015b75

-- 
Martin K. Petersen	Oracle Linux Engineering

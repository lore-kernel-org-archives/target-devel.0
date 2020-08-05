From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Wed, 05 Aug 2020 01:17:33 +0000
Subject: Re: [PATCH 1/1] target: make iscsit_register_transport() return void
Message-Id: <159659019689.15726.3035694434346153928.b4-ty@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200803150008.83920-1-maxg@mellanox.com>
In-Reply-To: <20200803150008.83920-1-maxg@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: sagi@grimberg.me, target-devel@vger.kernel.org, michael.christie@oracle.com, linux-scsi@vger.kernel.org, bvanassche@acm.org, Max Gurtovoy <maxg@mellanox.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, oren@mellanox.com

On Mon, 3 Aug 2020 18:00:08 +0300, Max Gurtovoy wrote:

> This function always return 0 now, we can make it return void to
> simplify the code. Also, no caller ever check the return value of this
> function.

Applied to 5.9/scsi-queue, thanks!

[1/1] scsi: target: Make iscsit_register_transport() return void
      https://git.kernel.org/mkp/scsi/c/a8ac78357d9b

-- 
Martin K. Petersen	Oracle Linux Engineering

From: Jason Gunthorpe <jgg@nvidia.com>
Date: Mon, 26 Oct 2020 22:54:59 +0000
Subject: Re: [PATCH-next 0/4] RDMA: sprintf to sysfs_emit conversions
Message-Id: <20201026225459.GA2152135@nvidia.com>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1602122879.git.joe@perches.com>
In-Reply-To: <cover.1602122879.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 07, 2020 at 07:36:23PM -0700, Joe Perches wrote:
> A recent commit added a sysfs_emit and sysfs_emit_at to allow various
> sysfs show functions to ensure that the PAGE_SIZE buffer argument is
> never overrun and always NUL terminated.
> 
> Convert the RDMA/InfiniBand subsystem to use these new functions.
> 
> The first 2 patches exclusively used coccinelle to convert uses.
> The third and fourth patches were done manually.
> 
> Compiled allyesconfig and defconfig with all infiniband options selected
> no warnings, but untested, no hardward
> 
> Overall object size is reduced
> 
> total size: allyesconfig x86-64
> new: 8364003	1680968	 131520	10176491 9b47eb	(TOTALS)
> old: 8365883	1681032	 131520	10178435 9b4f83	(TOTALS)
> 
> total size: defconfig x86-64 with all infiniband selected
> new; 1359153	 131228	   1910  1492291 16c543	(TOTALS)
> old: 1359422	 131228	   1910  1492560 16c650	(TOTALS)
> 
> Joe Perches (4):
>   RDMA: Convert sysfs device * show functions to use sysfs_emit()
>   RDMA: Convert sysfs kobject * show functions to use sysfs_emit()

First two applied to for-next

>   RDMA: manual changes for sysfs_emit and neatening
>   RDMA: Convert various random sprintf sysfs _show uses to sysfs_emit

Will probably do these two later this week/next

Thanks,
Jason

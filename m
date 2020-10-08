From: Leon Romanovsky <leon@kernel.org>
Date: Thu, 08 Oct 2020 05:41:28 +0000
Subject: Re: [PATCH-next 0/4] RDMA: sprintf to sysfs_emit conversions
Message-Id: <20201008054128.GD13580@unreal>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1602122879.git.joe@perches.com>
In-Reply-To: <cover.1602122879.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Oct 07, 2020 at 07:36:23PM -0700, Joe Perches wrote:
> A recent commit added a sysfs_emit and sysfs_emit_at to allow various
> sysfs show functions to ensure that the PAGE_SIZE buffer argument is
> never overrun and always NUL terminated.

Unfortunately but the sysfs_emit commit is not in rdma-next tree yet.

Thanks

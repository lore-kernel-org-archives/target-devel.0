From: Joe Perches <joe@perches.com>
Date: Thu, 15 Oct 2020 05:29:20 +0000
Subject: Re: [PATCH-next 0/4] RDMA: sprintf to sysfs_emit conversions
Message-Id: <497ed8109393bdcf6ba9642e3a527d7d25972e4f.camel@perches.com>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1602122879.git.joe@perches.com>
         <20201008054128.GD13580@unreal>
In-Reply-To: <20201008054128.GD13580@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2020-10-08 at 08:41 +0300, Leon Romanovsky wrote:
> On Wed, Oct 07, 2020 at 07:36:23PM -0700, Joe Perches wrote:
> > A recent commit added a sysfs_emit and sysfs_emit_at to allow various
> > sysfs show functions to ensure that the PAGE_SIZE buffer argument is
> > never overrun and always NUL terminated.
> 
> Unfortunately but the sysfs_emit commit is not in rdma-next tree yet.

It is in Linus' tree now.

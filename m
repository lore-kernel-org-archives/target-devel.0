From: Jason Gunthorpe <jgg@nvidia.com>
Date: Thu, 12 Nov 2020 16:38:34 +0000
Subject: Re: [PATCH -next] IB/isert: Fix warning Comparison to bool
Message-Id: <20201112163834.GA917430@nvidia.com>
List-Id: <target-devel.vger.kernel.org>
References: <1604404674-32998-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1604404674-32998-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zou Wei <zou_wei@huawei.com>
Cc: sagi@grimberg.me, dledford@redhat.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 03, 2020 at 07:57:54PM +0800, Zou Wei wrote:
> Fix below warning reported by coccicheck:
> 
> ./ib_isert.c:1104:12-24: WARNING: Comparison to bool
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next, thanks

Jason

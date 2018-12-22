From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Sat, 22 Dec 2018 23:09:31 +0000
Subject: Re: [PATCH -next] RDMA/srpt: Use kmem_cache_free() instead of kfree()
Message-Id: <20181222230931.GC20963@ziepe.ca>
List-Id: <target-devel.vger.kernel.org>
References: <1545474630-123120-1-git-send-email-weiyongjun1@huawei.com>
In-Reply-To: <1545474630-123120-1-git-send-email-weiyongjun1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Sat, Dec 22, 2018 at 10:30:30AM +0000, Wei Yongjun wrote:
> memory allocated by kmem_cache_alloc() should be freed using
> kmem_cache_free(), not kfree().
> 
> Fixes: 5dabcd0456d7 ("RDMA/srpt: Add support for immediate data")
> Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied to for-next

Thanks,
Jason

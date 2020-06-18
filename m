From: Jason Gunthorpe <jgg@nvidia.com>
Date: Thu, 18 Jun 2020 18:18:16 +0000
Subject: Re: [PATCH v3] IB/srpt: Remove WARN_ON from srpt_cm_req_recv
Message-Id: <20200618181816.GA2453631@mellanox.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200617140803.181333-1-jingxiangfeng@huawei.com>
In-Reply-To: <20200617140803.181333-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: bvanassche@acm.org, dledford@redhat.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, Jun 17, 2020 at 10:08:03PM +0800, Jing Xiangfeng wrote:
> The callers pass the pointer '&req' or 'private_data' to
> srpt_cm_req_recv(), and 'private_data' is initialized in srp_send_req().
> 'sdev' is allocated and stored in srpt_add_one(). It's easy to show that
> sdev and req are always valid. So we remove unnecessary WARN_ON.
> 
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 3 ---
>  1 file changed, 3 deletions(-)

Applied to for-next, thanks

Jason

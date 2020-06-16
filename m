From: Leon Romanovsky <leon@kernel.org>
Date: Tue, 16 Jun 2020 06:20:19 +0000
Subject: Re: [PATCH v2] IB/srpt: Remove WARN_ON from srpt_cm_req_recv
Message-Id: <20200616062019.GA2141420@unreal>
List-Id: <target-devel.vger.kernel.org>
References: <20200616011715.140197-1-jingxiangfeng@huawei.com>
In-Reply-To: <20200616011715.140197-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: bvanassche@acm.org, dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Tue, Jun 16, 2020 at 09:17:15AM +0800, Jing Xiangfeng wrote:
> It's easy to show that sdev and req are always valid,
> so we remove unnecessary WARN_ON.

So show it in the commit message, please.

>
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 3 ---
>  1 file changed, 3 deletions(-)
>
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index ef7fcd3..0fa65c6 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2156,9 +2156,6 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
>
>  	WARN_ON_ONCE(irqs_disabled());
>
> -	if (WARN_ON(!sdev || !req))
> -		return -EINVAL;
> -
>  	it_iu_len = be32_to_cpu(req->req_it_iu_len);
>
>  	pr_info("Received SRP_LOGIN_REQ with i_port_id %pI6, t_port_id %pI6 and it_iu_len %d on port %d (guid=%pI6); pkey %#04x\n",
> --
> 1.8.3.1
>
>

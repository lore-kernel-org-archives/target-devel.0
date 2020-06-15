From: Bart Van Assche <bvanassche@acm.org>
Date: Mon, 15 Jun 2020 13:37:56 +0000
Subject: Re: [PATCH] IB/srpt: Fix a potential null pointer dereference
Message-Id: <7366b608-4474-cfaa-c465-957fd2d2366d@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200615091220.6439-1-jingxiangfeng@huawei.com>
In-Reply-To: <20200615091220.6439-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jing Xiangfeng <jingxiangfeng@huawei.com>, dledford@redhat.com, jgg@ziepe.ca
Cc: linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On 2020-06-15 02:12, Jing Xiangfeng wrote:
> In srpt_cm_req_recv(), it is possible that sdev is NULL,
> so we should test sdev before using it.
> 
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 98552749d71c..72053254bf84 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2143,7 +2143,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
>  			    const struct srp_login_req *req,
>  			    const char *src_addr)
>  {
> -	struct srpt_port *sport = &sdev->port[port_num - 1];
> +	struct srpt_port *sport;
>  	struct srpt_nexus *nexus;
>  	struct srp_login_rsp *rsp = NULL;
>  	struct srp_login_rej *rej = NULL;
> @@ -2162,6 +2162,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
>  	if (WARN_ON(!sdev || !req))
>  		return -EINVAL;
>  
> +	sport = &sdev->port[port_num - 1];
>  	it_iu_len = be32_to_cpu(req->req_it_iu_len);
>  

Please remove the (!sdev || !req) check instead of making the above
change. It's easy to show that both pointers are always valid.

Thanks,

Bart.

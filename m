From: Sagi Grimberg <sagi@grimberg.me>
Date: Sun, 26 Nov 2017 13:59:09 +0000
Subject: Re: [PATCH] iser-target: Fix possible use-after-free in connection establishment error
Message-Id: <3676820c-544e-8ced-859a-ade8e6a0ef53@grimberg.me>
List-Id: <target-devel.vger.kernel.org>
References: <20171126133104.22710-1-sagi@grimberg.me>
In-Reply-To: <20171126133104.22710-1-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

Oops,

This should go via the target tree, CCing target-devel and nab

On 11/26/2017 03:31 PM, Sagi Grimberg wrote:
> In case we fail to establish the connection we must drain our pre-posted
> login recieve work request before continuing safely with connection
> teardown.
> 
> Reported-by: Amrani, Ram <Ram.Amrani@cavium.com>
> Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
> ---
>   drivers/infiniband/ulp/isert/ib_isert.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
> index ceabdb85df8b..9d4785ba24cb 100644
> --- a/drivers/infiniband/ulp/isert/ib_isert.c
> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
> @@ -741,6 +741,7 @@ isert_connect_error(struct rdma_cm_id *cma_id)
>   {
>   	struct isert_conn *isert_conn = cma_id->qp->qp_context;
>   
> +	ib_drain_qp(isert_conn->qp);
>   	list_del_init(&isert_conn->node);
>   	isert_conn->cm_id = NULL;
>   	isert_put_conn(isert_conn);
> 

From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 22 Oct 2020 00:25:44 +0000
Subject: Re: [PATCH v3 4/6] IB/srpt: docs: add a description for cq_size member
Message-Id: <cb5944e2-bdea-e320-d4d1-2f9bc9539a19@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1603282193.git.mchehab+huawei@kernel.org>
 <32f4060a4300c20894b38f2504ee76ccfa497215.1603282193.git.mchehab+huawei@kernel.org>
In-Reply-To: <32f4060a4300c20894b38f2504ee76ccfa497215.1603282193.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Yamin Friedman <yaminf@mellanox.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org

On 10/21/20 5:17 AM, Mauro Carvalho Chehab wrote:
> Changeset c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
> added a new member for struct srpt_rdma_ch, but didn't add the
> corresponding kernel-doc markup, as repoted when doing
> "make htmldocs":
> 
> 	./drivers/infiniband/ulp/srpt/ib_srpt.h:331: warning: Function parameter or member 'cq_size' not described in 'srpt_rdma_ch'
> 
> Add a description for it.
> 
> Fixes: c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.h b/drivers/infiniband/ulp/srpt/ib_srpt.h
> index 41435a699b53..bdeb010efee6 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> @@ -256,6 +256,7 @@ enum rdma_ch_state {
>   * @rdma_cm:	   See below.
>   * @rdma_cm.cm_id: RDMA CM ID associated with the channel.
>   * @cq:            IB completion queue for this channel.
> + * @cq_size:	   Number of CQEs in @cq.
>   * @zw_cqe:	   Zero-length write CQE.
>   * @rcu:           RCU head.
>   * @kref:	   kref for this channel.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

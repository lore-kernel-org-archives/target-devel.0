From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 15 Oct 2020 04:32:01 +0000
Subject: Re: [PATCH v6 69/80] IB/srpt: docs: add a description for cq_size member
Message-Id: <f283f15e-073c-ee42-d022-5b543f041d0b@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1602589096.git.mchehab+huawei@kernel.org>
 <d44a565b1638481c8dd282f01cae1fda3adf9fad.1602589096.git.mchehab+huawei@kernel.org>
In-Reply-To: <d44a565b1638481c8dd282f01cae1fda3adf9fad.1602589096.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Max Gurtovoy <maxg@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Yamin Friedman <yaminf@mellanox.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org

On 10/13/20 4:54 AM, Mauro Carvalho Chehab wrote:
> Changeset c804af2c1d31 ("IB/srpt: use new shared CQ mechanism")
> added a new member for struct srpt_rdma_ch, but didn't add the
> corresponding kernel-doc markup, as repoted when doing
> "make htmldocs":
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
> index 41435a699b53..e5d6af14d073 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.h
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.h
> @@ -256,6 +256,7 @@ enum rdma_ch_state {
>   * @rdma_cm:	   See below.
>   * @rdma_cm.cm_id: RDMA CM ID associated with the channel.
>   * @cq:            IB completion queue for this channel.
> + * @cq_size:	   Size of the @cq pool.
>   * @zw_cqe:	   Zero-length write CQE.
>   * @rcu:           RCU head.
>   * @kref:	   kref for this channel.

That doesn't seem correct to me. My understanding is that cq_size is the
number of CQEs in @cq. @cq is a completion queue and not a CQ pool.

Bart.

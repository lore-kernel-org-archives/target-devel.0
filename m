From: Max Gurtovoy <mgurtovoy@nvidia.com>
Date: Sat, 24 Oct 2020 21:50:23 +0000
Subject: Re: [PATCH v3 14/56] IB: fix kernel-doc markups
Message-Id: <eec938e4-0a00-c35a-fc0d-8d0d4af30678@nvidia.com>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1603469755.git.mchehab+huawei@kernel.org>
 <f201c81b58f7087425387672b24af5b85aa04b1a.1603469755.git.mchehab+huawei@kernel.org>
In-Reply-To: <f201c81b58f7087425387672b24af5b85aa04b1a.1603469755.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: "Gustavo A. R. Silva" <gustavoars@kernel.org>, =?UTF-8?Q?H=c3=a5kon_Bugge?= <haakon.bugge@oracle.com>, Jonathan Corbet <corbet@lwn.net>, Bart Van Assche <bvanassche@acm.org>, Chuck Lever <chuck.lever@oracle.com>, Danit Goldberg <danitg@mellanox.com>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Divya Indi <divya.indi@oracle.com>, Doug Ledford <dledford@redhat.com>, Gal Pressman <galpress@amazon.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>, Moni Shoua <monis@mellanox.com>, Parav Pandit <parav@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Ursula Braun <ubraun@linux.ibm.com>, Xi Wang <wangxi11@huawei.com>, Yamin Friedman <yaminf@mellanox.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org

Thanks Mauro, small fix for iser

On 10/23/2020 7:33 PM, Mauro Carvalho Chehab wrote:
> Some functions have different names between their prototypes
> and the kernel-doc markup.
>
> Others need to be fixed, as kernel-doc markups should use this format:
>          identifier - description
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
>
> diff --git a/drivers/infiniband/ulp/iser/iscsi_iser.c b/drivers/infiniband/ulp/iser/iscsi_iser.c
> index 3690e28cc7ea..84cebf937680 100644
> --- a/drivers/infiniband/ulp/iser/iscsi_iser.c
> +++ b/drivers/infiniband/ulp/iser/iscsi_iser.c
> @@ -739,7 +739,7 @@ iscsi_iser_set_param(struct iscsi_cls_conn *cls_conn,
>   }
>   
>   /**
> - * iscsi_iser_set_param() - set class connection parameter
> + * iscsi_iser_conn_get_stats() - set class connection parameter

iscsi_iser_conn_get_stats() - get iscsi connection statistics


>    * @cls_conn:    iscsi class connection
>    * @stats:       iscsi stats to output
>    *
>   

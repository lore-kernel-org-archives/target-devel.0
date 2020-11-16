From: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date: Mon, 16 Nov 2020 10:36:16 +0000
Subject: Re: [PATCH v4 07/27] IB: fix kernel-doc markups
Message-Id: <20201116103616.GA13162@embeddedor>
List-Id: <target-devel.vger.kernel.org>
References: <cover.1605521731.git.mchehab+huawei@kernel.org>
 <4983a0c6fe5dbc2c779d2b5950a6f90f81a16d56.1605521731.git.mchehab+huawei@kernel.org>
In-Reply-To: <4983a0c6fe5dbc2c779d2b5950a6f90f81a16d56.1605521731.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, =?iso-8859-1?Q?H=E5kon?= Bugge <haakon.bugge@oracle.com>, Jonathan Corbet <corbet@lwn.net>, Bart Van Assche <bvanassche@acm.org>, Chuck Lever <chuck.lever@oracle.com>, Danit Goldberg <danitg@mellanox.com>, Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>, Divya Indi <divya.indi@oracle.com>, Doug Ledford <dledford@redhat.com>, Gal Pressman <galpress@amazon.com>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Maor Gottlieb <maorg@mellanox.com>, Max Gurtovoy <mgurtovoy@nvidia.com>, Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>, Moni Shoua <monis@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Parav Pandit <parav@mellanox.com>, Sagi Grimberg <sagi@grimberg.me>, Ursula Braun <ubraun@linux.ibm.com>, Xi Wang <wangxi11@huawei.com>, Yamin Friedman <yaminf@mellanox.com>, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org

On Mon, Nov 16, 2020 at 11:18:03AM +0100, Mauro Carvalho Chehab wrote:

[..]

> diff --git a/drivers/infiniband/sw/rdmavt/ah.c b/drivers/infiniband/sw/rdmavt/ah.c
> index f9754dcd250b..480b621d1a9f 100644
> --- a/drivers/infiniband/sw/rdmavt/ah.c
> +++ b/drivers/infiniband/sw/rdmavt/ah.c
[..]
>  /**
> - * rvt_destory_ah - Destory an address handle
> + * rvt_destroy_ah - Destory an address handle

s/Destory/Destroy

>   * @ibah: address handle
>   * @destroy_flags: destroy address handle flags (see enum rdma_destroy_ah_flags)
>   * Return: 0 on success
>   */
>  int rvt_destroy_ah(struct ib_ah *ibah, u32 destroy_flags)
>  {
>  	struct rvt_dev_info *dev = ib_to_rvt(ibah->device);
>  	struct rvt_ah *ah = ibah_to_rvtah(ibah);
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&dev->n_ahs_lock, flags);
>  	dev->n_ahs_allocated--;
>  	spin_unlock_irqrestore(&dev->n_ahs_lock, flags);
>  
>  	rdma_destroy_ah_attr(&ah->attr);
>  	return 0;
>  }

--
Gustavo

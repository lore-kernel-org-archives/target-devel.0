From: Jason Gunthorpe <jgg@nvidia.com>
Date: Mon, 02 Nov 2020 19:25:21 +0000
Subject: Re: [PATCH rdma-next v2] IB/srpt: Fix memory leak in srpt_add_one
Message-Id: <20201102192521.GA3710231@nvidia.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201028065051.112430-1-leon@kernel.org>
In-Reply-To: <20201028065051.112430-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Maor Gottlieb <maorg@nvidia.com>, Bart Van Assche <bvanassche@acm.org>, linux-rdma@vger.kernel.org, "Nicholas A. Bellinger" <nab@risingtidesystems.com>, target-devel@vger.kernel.org

On Wed, Oct 28, 2020 at 08:50:51AM +0200, Leon Romanovsky wrote:
> From: Maor Gottlieb <maorg@nvidia.com>
> 
> Failure in srpt_refresh_port() for the second port will leave MAD
> registered for the first one, however, the srpt_add_one() will be
> marked as "failed" and SRPT will leak resources for that registered
> but not used and released first port.
> 
> Unregister the MAD agent for all ports in case of failure.
> 
> Fixes: a42d985bd5b2 ("ib_srpt: Initial SRP Target merge for v3.3-rc1")
> Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
> Changelog:
> v2:
>  * Added an extra parameter to srpt_unregister_mad_agent() to eliminate
>    an extra obfuscation call.
> v1:
> https://lore.kernel.org/linux-rdma/20201027055920.1760663-1-leon@kernel.org
>  * Fixed and updated commit message.
>  * Remove port_cnt check from __srpt_unregister_mad_agent().
> v0:
> https://lore.kernel.org/linux-rdma/20201026132737.1338171-1-leon@kernel.org
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 13 ++++++++-----
>  1 file changed, 8 insertions(+), 5 deletions(-)

Applied to for-rc, thanks

Jason

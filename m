From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 29 Oct 2020 03:31:59 +0000
Subject: Re: [PATCH rdma-next v2] IB/srpt: Fix memory leak in srpt_add_one
Message-Id: <620b6f78-c3e2-a9ab-5942-36cc2b7fe32e@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20201028065051.112430-1-leon@kernel.org>
In-Reply-To: <20201028065051.112430-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@nvidia.com>
Cc: Maor Gottlieb <maorg@nvidia.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org

On 10/27/20 11:50 PM, Leon Romanovsky wrote:
> Failure in srpt_refresh_port() for the second port will leave MAD
> registered for the first one, however, the srpt_add_one() will be
> marked as "failed" and SRPT will leak resources for that registered
> but not used and released first port.
> 
> Unregister the MAD agent for all ports in case of failure.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

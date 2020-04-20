From: Leon Romanovsky <leonro@mellanox.com>
Date: Mon, 20 Apr 2020 13:36:07 +0000
Subject: Re: [PATCH rdma-next v2 0/7] Add Enhanced Connection Established (ECE)
Message-Id: <20200420133607.GD121146@unreal>
List-Id: <target-devel.vger.kernel.org>
References: <20200413141538.935574-1-leon@kernel.org>
In-Reply-To: <20200413141538.935574-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: rds-devel@oss.oracle.com, Bart Van Assche <bvanassche@acm.org>, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@oracle.com>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, "David S. Miller" <davem@davemloft.net>, Sagi Grimberg <sagi@grimberg.me>

On Mon, Apr 13, 2020 at 05:15:31PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> Changelog:
>  v2:
>  * Rebased on latest rdma-next and removed already accepted patches.
>  * Updated all rdma_reject in-kernel users to provide reject reason.
>  v1: Dropped field_avail patch in favor of mass conversion to use function
>      which already exists in the kernel code.
>  https://lore.kernel.org/lkml/20200310091438.248429-1-leon@kernel.org
>  v0: https://lore.kernel.org/lkml/20200305150105.207959-1-leon@kernel.org
>
> Enhanced Connection Established or ECE is new negotiation scheme
> introduced in IBTA v1.4 to exchange extra information about nodes
> capabilities and later negotiate them at the connection establishment
> phase.
>
> The RDMA-CM messages (REQ, REP, SIDR_REQ and SIDR_REP) were extended
> to carry two fields, one new and another gained new functionality:
>  * VendorID is a new field that indicates that common subset of vendor
>    option bits are supported as indicated by that VendorID.
>  * AttributeModifier already exists, but overloaded to indicate which
>    vendor options are supported by this VendorID.
>
> This is kernel part of such functionality which is responsible to get data
> from librdmacm and properly create and handle RDMA-CM messages.
>
> Thanks
>
> Leon Romanovsky (7):
>   RDMA/cm: Add Enhanced Connection Establishment (ECE) bits
>   RDMA/uapi: Add ECE definitions to UCMA
>   RDMA/ucma: Extend ucma_connect to receive ECE parameters
>   RDMA/ucma: Deliver ECE parameters through UCMA events
>   RDMA/cm: Send and receive ECE parameter over the wire
>   RDMA/cma: Connect ECE to rdma_accept
>   RDMA/cma: Provide ECE reject reason

PR: https://github.com/linux-rdma/rdma-core/pull/745

Thanks

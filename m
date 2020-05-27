From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Wed, 27 May 2020 19:14:24 +0000
Subject: Re: [PATCH rdma-next v3 0/6] Add Enhanced Connection Established (ECE)
Message-Id: <20200527191424.GA20778@ziepe.ca>
List-Id: <target-devel.vger.kernel.org>
References: <20200526103304.196371-1-leon@kernel.org>
In-Reply-To: <20200526103304.196371-1-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>
Cc: rds-devel@oss.oracle.com, Bart Van Assche <bvanassche@acm.org>, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@oracle.com>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, "David S. Miller" <davem@davemloft.net>, Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, target-devel@vger.kernel.org, Danil Kipnis <danil.kipnis@cloud.ionos.com>, Jakub Kicinski <kuba@kernel.org>, Jack Wang <jinpu.wang@cloud.ionos.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>

On Tue, May 26, 2020 at 01:32:58PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Changelog:
>  v3:
>  * Rebased on top of ebd6e96b33a2 RDMA/ipoib: Remove can_sleep parameter from iboib_mcast_alloc
>  * Updated rdma_reject patch to include newly added RTR ulp
>  * Remove empty hunks added by rebase
>  * Changed signature of rdma_reject so kernel users will provide reason by themselves
>  * Squashed UAPI patch to other patches which add functionality
>  * Removed define of the IBTA reason from UAPI
>  v2: https://lore.kernel.org/linux-rdma/20200413141538.935574-1-leon@kernel.org/
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
> Leon Romanovsky (6):
>   RDMA/cm: Add Enhanced Connection Establishment (ECE) bits
>   RDMA/ucma: Extend ucma_connect to receive ECE parameters
>   RDMA/ucma: Deliver ECE parameters through UCMA events
>   RDMA/cm: Send and receive ECE parameter over the wire
>   RDMA/cma: Connect ECE to rdma_accept
>   RDMA/cma: Provide ECE reject reason

Applied to for-next, thanks

Jason

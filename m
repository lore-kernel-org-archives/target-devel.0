From: Leon Romanovsky <leonro@mellanox.com>
Date: Tue, 26 May 2020 11:36:28 +0000
Subject: Re: [PATCH rdma-next v3 6/6] RDMA/cma: Provide ECE reject reason
Message-Id: <20200526113628.GC100179@unreal>
List-Id: <target-devel.vger.kernel.org>
References: <20200526103304.196371-1-leon@kernel.org>
 <20200526103304.196371-7-leon@kernel.org>
In-Reply-To: <20200526103304.196371-7-leon@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: rds-devel@oss.oracle.com, Bart Van Assche <bvanassche@acm.org>, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, Santosh Shilimkar <santosh.shilimkar@oracle.com>, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@lst.de>, target-devel@vger.kernel.org, Danil Kipnis <danil.kipnis@cloud.ionos.com>, Jakub Kicinski <kuba@kernel.org>, Jack Wang <jinpu.wang@cloud.ionos.com>, "David S. Miller" <davem@davemloft.net>, Sagi Grimberg <sagi@grimberg.me>

On Tue, May 26, 2020 at 01:33:04PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
>
> IBTA declares "vendor option not supported" reject reason in REJ
> messages if passive side doesn't want to accept proposed ECE options.
>
> Due to the fact that ECE is managed by userspace, there is a need to let
> users to provide such rejected reason.
>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> ---
>  drivers/infiniband/core/cma.c           |  9 ++++-----
>  drivers/infiniband/core/ucma.c          | 15 ++++++++++++++-
>  drivers/infiniband/ulp/isert/ib_isert.c |  4 ++--
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c  |  2 +-
>  drivers/infiniband/ulp/srpt/ib_srpt.c   |  3 ++-
>  drivers/nvme/target/rdma.c              |  3 ++-
>  include/rdma/rdma_cm.h                  |  2 +-
>  include/uapi/rdma/rdma_user_cm.h        |  3 ++-
>  net/rds/ib_cm.c                         |  4 +++-
>  9 files changed, 31 insertions(+), 14 deletions(-)

For some reason didn't get the failure in CI, this small fixup is
needed.

commit af02a4a50ec0d18fe9bfb86b96411dfb42054f97 (HEAD -> rdma-next)
Author: Leon Romanovsky <leon@kernel.org>
Date:   Tue May 26 14:34:34 2020 +0300

    fixup! RDMA/cma: Provide ECE reject reason

    Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 30a0a9adaddd..d84765f66d49 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -18,6 +18,7 @@
 #include <asm/unaligned.h>

 #include <rdma/ib_verbs.h>
+#include <rdma/ib_cm.h>
 #include <rdma/rdma_cm.h>
 #include <rdma/rw.h>

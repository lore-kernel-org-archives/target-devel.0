From: "Steve Wise" <swise@opengridcomputing.com>
Date: Fri, 21 Sep 2018 16:44:22 +0000
Subject: RE: [PATCH 6/6] RDMA/ulp: Use dev_name instead of ibdev->name
Message-Id: <03dd01d451ca$59b6e8b0$0d24ba10$@opengridcomputing.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180920224227.9988-7-jgg@ziepe.ca>
In-Reply-To: <20180920224227.9988-7-jgg@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

> From: Jason Gunthorpe <jgg@mellanox.com>
> 
> These return the same thing but dev_name is a more conventional use of the
> kernel API.
> 
> Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>

Reviewed-by: Steve Wise <swise@opengridcomputing.com>

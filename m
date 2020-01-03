From: Jason Gunthorpe <jgg@ziepe.ca>
Date: Fri, 03 Jan 2020 20:23:23 +0000
Subject: Re: [PATCH v2] scsi: RDMA/srpt: remove unnecessary assertion in srpt_queue_response
Message-Id: <20200103202323.GA15557@ziepe.ca>
List-Id: <target-devel.vger.kernel.org>
References: <20191217194437.25568-1-pakki001@umn.edu>
In-Reply-To: <20191217194437.25568-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Bart Van Assche <bvanassche@acm.org>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 17, 2019 at 01:44:37PM -0600, Aditya Pakki wrote:
> Currently, BUG_ON in srpt_queue_response, is used as an assertion for
> empty rdma channel. However, if the channel is NULL, the call trace
> on console is sufficient for diagnosis.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> ---
> v1: Avoid potential NULL pointer derefernce of ch. Current fix
> suggested by Bart Van Assche
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 2 --
>  1 file changed, 2 deletions(-)

Applied to for-next with the reworked commit message Bart suggested

Thanks,
Jason

From: Bart Van Assche <bvanassche@acm.org>
Date: Tue, 17 Dec 2019 20:34:44 +0000
Subject: Re: [PATCH v2] scsi: RDMA/srpt: remove unnecessary assertion in srpt_queue_response
Message-Id: <d497d620-9aff-616c-67ae-bfb93f39b926@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20191217194437.25568-1-pakki001@umn.edu>
In-Reply-To: <20191217194437.25568-1-pakki001@umn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aditya Pakki <pakki001@umn.edu>
Cc: kjlu@umn.edu, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On 12/17/19 11:44 AM, Aditya Pakki wrote:
> Currently, BUG_ON in srpt_queue_response, is used as an assertion for
> empty rdma channel. However, if the channel is NULL, the call trace
> on console is sufficient for diagnosis.
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>
> ---
> v1: Avoid potential NULL pointer derefernce of ch. Current fix
> suggested by Bart Van Assche
> ---
>   drivers/infiniband/ulp/srpt/ib_srpt.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 23c782e3d49a..98552749d71c 100644
> --- a/drivers/infiniband/ulp/srpt/ib_srpt.c
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2810,8 +2810,6 @@ static void srpt_queue_response(struct se_cmd *cmd)
>   	int resp_len, ret, i;
>   	u8 srp_tm_status;
>   
> -	BUG_ON(!ch);
> -
>   	state = ioctx->state;
>   	switch (state) {
>   	case SRPT_STATE_NEW:

I think the description of this patch should also mention that this 
patch removes a check of a pointer after it has already been 
dereferenced. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

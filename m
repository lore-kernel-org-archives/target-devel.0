From: Jason Gunthorpe <jgg@nvidia.com>
Date: Thu, 12 Nov 2020 17:20:08 +0000
Subject: Re: [PATCH] IB/srpt: Fix passing zero to 'PTR_ERR'
Message-Id: <20201112172008.GA944848@nvidia.com>
List-Id: <target-devel.vger.kernel.org>
References: <20201112145443.17832-1-yuehaibing@huawei.com>
In-Reply-To: <20201112145443.17832-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: YueHaibing <yuehaibing@huawei.com>
Cc: bvanassche@acm.org, dledford@redhat.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Nov 12, 2020 at 10:54:43PM +0800, YueHaibing wrote:
> Fix smatch warning:
> 
> drivers/infiniband/ulp/srpt/ib_srpt.c:2341 srpt_cm_req_recv() warn: passing zero to 'PTR_ERR'
> 
> Use PTR_ERR_OR_ZERO instead of PTR_ERR
> 
> Fixes: 847462de3a0a ("IB/srpt: Fix srpt_cm_req_recv() error path (1/2)")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>  drivers/infiniband/ulp/srpt/ib_srpt.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
> index 6be60aa5ffe2..3ff24b5048ac 100644
> +++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
> @@ -2338,7 +2338,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
>  
>  	if (IS_ERR_OR_NULL(ch->sess)) {
>  		WARN_ON_ONCE(ch->sess = NULL);
> -		ret = PTR_ERR(ch->sess);
> +		ret = PTR_ERR_OR_ZERO(ch->sess);
>  		ch->sess = NULL;
>  		pr_info("Rejected login for initiator %s: ret = %d.\n",
>  			ch->sess_name, ret);

I think it should be like this, Bart?

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 6017d525084a0c..80f9673956ced2 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2311,7 +2311,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 
 	mutex_lock(&sport->port_guid_id.mutex);
 	list_for_each_entry(stpg, &sport->port_guid_id.tpg_list, entry) {
-		if (!IS_ERR_OR_NULL(ch->sess))
+		if (ch->sess)
 			break;
 		ch->sess = target_setup_session(&stpg->tpg, tag_num,
 						tag_size, TARGET_PROT_NORMAL,
@@ -2321,12 +2321,12 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 
 	mutex_lock(&sport->port_gid_id.mutex);
 	list_for_each_entry(stpg, &sport->port_gid_id.tpg_list, entry) {
-		if (!IS_ERR_OR_NULL(ch->sess))
+		if (ch->sess)
 			break;
 		ch->sess = target_setup_session(&stpg->tpg, tag_num,
 					tag_size, TARGET_PROT_NORMAL, i_port_id,
 					ch, NULL);
-		if (!IS_ERR_OR_NULL(ch->sess))
+		if (ch->sess)
 			break;
 		/* Retry without leading "0x" */
 		ch->sess = target_setup_session(&stpg->tpg, tag_num,
@@ -2335,7 +2335,9 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 	}
 	mutex_unlock(&sport->port_gid_id.mutex);
 
-	if (IS_ERR_OR_NULL(ch->sess)) {
+	if (!ch->sess)
+		ch->sess = ERR_PTR(-ENOENT);
+	if (IS_ERR(ch->sess)) {
 		WARN_ON_ONCE(ch->sess = NULL);
 		ret = PTR_ERR(ch->sess);
 		ch->sess = NULL;

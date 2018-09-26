From: Dennis Dalessandro <dennis.dalessandro@intel.com>
Date: Wed, 26 Sep 2018 13:18:27 +0000
Subject: Re: [PATCH 6/6] RDMA/ulp: Use dev_name instead of ibdev->name
Message-Id: <b28f3b86-0417-e96a-3764-a65fac76290b@intel.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180920224227.9988-7-jgg@ziepe.ca>
In-Reply-To: <20180920224227.9988-7-jgg@ziepe.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 9/20/2018 6:42 PM, Jason Gunthorpe wrote:
> diff --git a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
> index 15711dcc6f5856..d119d9afa845a7 100644
> --- a/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
> +++ b/drivers/infiniband/ulp/opa_vnic/opa_vnic_vema.c
> @@ -888,7 +888,8 @@ static void opa_vnic_event(struct ib_event_handler *handler,
>   		return;
>   
>   	c_dbg("OPA_VNIC received event %d on device %s port %d\n",
> -	      record->event, record->device->name, record->element.port_num);
> +	      record->event, dev_name(&record->device->dev),
> +	      record->element.port_num);

Looks fine.

> diff --git a/include/rdma/rdma_vt.h b/include/rdma/rdma_vt.h
> index 496f31ac9d8421..db4739eb253e86 100644
> --- a/include/rdma/rdma_vt.h
> +++ b/include/rdma/rdma_vt.h
> @@ -427,7 +427,7 @@ struct rvt_dev_info {
>    */
>   static inline const char *rvt_get_ibdev_name(const struct rvt_dev_info *rdi)
>   {
> -	return rdi->ibdev.name;
> +	return dev_name(&rdi->ibdev.dev);
>   }
>   
>   static inline struct rvt_pd *ibpd_to_rvtpd(struct ib_pd *ibpd)
> 

I think this would have been better to be included in the other patch. 
This isn't really "ulp" related.

Codewise I'm OK with this.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro@intel.com>

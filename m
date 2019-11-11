From: Roman Bolshakov <r.bolshakov@yadro.com>
Date: Mon, 11 Nov 2019 19:03:11 +0000
Subject: Re: [PATCH 1/2] target/core: Declare target_release_reservation() 'static'
Message-Id: <20191111190311.bqavf2nydri73u7n@SPB-NB-133.local>
List-Id: <target-devel.vger.kernel.org>
References: <20191111182944.191123-2-bvanassche@acm.org>
In-Reply-To: <20191111182944.191123-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Mon, Nov 11, 2019 at 10:29:43AM -0800, Bart Van Assche wrote:
> Since this function is only used inside the source file in which it has
> been defined, declare it 'static'. See also commit fae43461f8f2 ("scsi:
> target/core: Rework the SPC-2 reservation handling code").
> 
> Cc: Mike Christie <mchristi@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/target/target_core_pr.c | 2 +-
>  drivers/target/target_core_pr.h | 1 -
>  2 files changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_pr.c b/drivers/target/target_core_pr.c
> index 5e931690e697..6a72b61e0076 100644
> --- a/drivers/target/target_core_pr.c
> +++ b/drivers/target/target_core_pr.c
> @@ -187,7 +187,7 @@ static int target_check_scsi2_reservation_conflict(struct se_cmd *cmd)
>  	return 0;
>  }
>  
> -void target_release_reservation(struct se_device *dev)
> +static void target_release_reservation(struct se_device *dev)
>  {
>  	dev->reservation_holder = NULL;
>  	dev->dev_reservation_flags &= ~DRF_SPC2_RESERVATIONS;
> diff --git a/drivers/target/target_core_pr.h b/drivers/target/target_core_pr.h
> index a31c93e4e19c..198fad5c89dc 100644
> --- a/drivers/target/target_core_pr.h
> +++ b/drivers/target/target_core_pr.h
> @@ -58,7 +58,6 @@ extern struct kmem_cache *t10_pr_reg_cache;
>  
>  extern void core_pr_dump_initiator_port(struct t10_pr_registration *,
>  			char *, u32);
> -extern void target_release_reservation(struct se_device *dev);
>  extern sense_reason_t target_scsi2_reservation_release(struct se_cmd *);
>  extern sense_reason_t target_scsi2_reservation_reserve(struct se_cmd *);
>  extern int core_scsi3_alloc_aptpl_registration(
> -- 
> 2.24.0.rc1.363.gb1bccd3e3d-goog
> 

Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>

Thanks,
Roman

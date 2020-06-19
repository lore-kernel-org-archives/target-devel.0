From: Michael Christie <michael.christie@oracle.com>
Date: Fri, 19 Jun 2020 23:27:27 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Remove unnecessary bit TCMU_CMD_BIT_INFLIGHT
Message-Id: <526E97E2-5116-4100-A96D-46B6C790B7F1@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200619173806.5016-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200619173806.5016-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org



> On Jun 19, 2020, at 12:38 PM, Bodo Stroesser <bstroesser@ts.fujitsu.com> wrote:
> 
> Since
> commit 61fb24822166 ("scsi: target: tcmu: Userspace must not complete
> queued commands")
> tcmu_cmd bit TCMU_CMD_BIT_INFLIGHT is set but never checked.
> So we can remove it safely.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> ---
> drivers/target/target_core_user.c | 2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 560bfec933bc..b38da27e033f 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -181,7 +181,6 @@ struct tcmu_cmd {
> 	unsigned long deadline;
> 
> #define TCMU_CMD_BIT_EXPIRED 0
> -#define TCMU_CMD_BIT_INFLIGHT 1
> 	unsigned long flags;
> };
> /*
> @@ -1078,7 +1077,6 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
> 	tcmu_flush_dcache_range(mb, sizeof(*mb));
> 
> 	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);
> -	set_bit(TCMU_CMD_BIT_INFLIGHT, &tcmu_cmd->flags);
> 
> 	/* TODO: only if FLUSH and FUA? */
> 	uio_event_notify(&udev->uio_info);

Acked-by: Mike Christie <michael.crhsitie@oracle.com>

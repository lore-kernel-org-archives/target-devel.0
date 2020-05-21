From: Mike Christie <mchristi@redhat.com>
Date: Thu, 21 May 2020 20:06:05 +0000
Subject: Re: [PATCH 3/3] target: rename target_setup_cmd_from_cdb() to target_parse_cdb()
Message-Id: <8cde32d4-eef3-ec4c-9a0e-54c896e90ccc@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1590082959-1034-1-git-send-email-sudhakar.panneerselvam@oracle.com>
In-Reply-To: <1590082959-1034-1-git-send-email-sudhakar.panneerselvam@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>, martin.petersen@oracle.com, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: shirley.ma@oracle.com, ssudhakarp@gmail.com

On 5/21/20 12:42 PM, Sudhakar Panneerselvam wrote:
> This commit also removes the unused argument, cdb that was passed
> to this function.
> 
> Signed-off-by: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
> ---
>  drivers/target/iscsi/iscsi_target.c    | 2 +-
>  drivers/target/target_core_transport.c | 6 +++---
>  drivers/target/target_core_xcopy.c     | 2 +-
>  include/target/target_core_fabric.h    | 2 +-
>  4 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index a90b80aee9d8..38b14291eb76 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -1185,7 +1185,7 @@ int iscsit_setup_scsi_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>  
>  	/* only used for printks or comparing with ->ref_task_tag */
>  	cmd->se_cmd.tag = (__force u32)cmd->init_task_tag;
> -	cmd->sense_reason = target_setup_cmd_from_cdb(&cmd->se_cmd, hdr->cdb);
> +	cmd->sense_reason = target_parse_cdb(&cmd->se_cmd);
>  	if (cmd->sense_reason)
>  		goto attach_cmd;
>  
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 2e878188dff7..329c301129c2 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1450,7 +1450,7 @@ void transport_init_se_cmd(
>  EXPORT_SYMBOL(target_init_cmd_from_cdb);
>  
>  sense_reason_t
> -target_setup_cmd_from_cdb(struct se_cmd *cmd, unsigned char *cdb)
> +target_parse_cdb(struct se_cmd *cmd)
>  {
>  	struct se_device *dev = cmd->se_dev;
>  	sense_reason_t ret;
> @@ -1472,7 +1472,7 @@ void transport_init_se_cmd(
>  	atomic_long_inc(&cmd->se_lun->lun_stats.cmd_pdus);
>  	return 0;
>  }
> -EXPORT_SYMBOL(target_setup_cmd_from_cdb);
> +EXPORT_SYMBOL(target_parse_cdb);
>  
>  /*
>   * Used by fabric module frontends to queue tasks directly.
> @@ -1636,7 +1636,7 @@ int target_submit_cmd_map_sgls(struct se_cmd *se_cmd, struct se_session *se_sess
>  		return 0;
>  	}
>  
> -	rc = target_setup_cmd_from_cdb(se_cmd, cdb);
> +	rc = target_parse_cdb(se_cmd);
>  	if (rc != 0) {
>  		transport_generic_request_failure(se_cmd, rc);
>  		return 0;
> diff --git a/drivers/target/target_core_xcopy.c b/drivers/target/target_core_xcopy.c
> index b20c25343cf1..5cd1e81b33f8 100644
> --- a/drivers/target/target_core_xcopy.c
> +++ b/drivers/target/target_core_xcopy.c
> @@ -530,7 +530,7 @@ static int target_xcopy_setup_pt_cmd(
>  		return -EINVAL;
>  
>  	cmd->tag = 0;
> -	if (target_setup_cmd_from_cdb(cmd, cdb))
> +	if (target_parse_cdb(cmd))
>  		return -EINVAL;
>  
>  	if (transport_generic_map_mem_to_cmd(cmd, xop->xop_data_sg,
> diff --git a/include/target/target_core_fabric.h b/include/target/target_core_fabric.h
> index 5c92a5ccc9f0..6eb04a87ca97 100644
> --- a/include/target/target_core_fabric.h
> +++ b/include/target/target_core_fabric.h
> @@ -153,7 +153,7 @@ void	transport_init_se_cmd(struct se_cmd *,
>  		struct se_session *, u32, int, int, unsigned char *);
>  sense_reason_t transport_lookup_cmd_lun(struct se_cmd *, u64);
>  sense_reason_t target_init_cmd_from_cdb(struct se_cmd *, unsigned char *);
> -sense_reason_t target_setup_cmd_from_cdb(struct se_cmd *, unsigned char *);
> +sense_reason_t target_parse_cdb(struct se_cmd *);
>  int	target_submit_cmd_map_sgls(struct se_cmd *, struct se_session *,
>  		unsigned char *, unsigned char *, u64, u32, int, int, int,
>  		struct scatterlist *, u32, struct scatterlist *, u32,
> 

Maybe the naming would be nicer if we did:

target_init_cmd_cdb
and
target_parse_cmd_cdb

This would match each other's pattern and also match the style of the
other cmd related function naming where its "target or transport"
prefix, verb, cmd then optionally something extra.

Or maybe:

target_cmd_init_cdb
and
target_cmd_parse_cdb

so they at least match each other and you get an idea they pair together.

Just a suggestion and not a requirement, because I'm pretty bad at
naming, so I have no idea if its better or not.

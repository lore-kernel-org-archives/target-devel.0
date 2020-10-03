From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 03 Oct 2020 00:23:40 +0000
Subject: Re: [PATCH] Revert "scsi: target/iscsi: Detect conn_cmd_list corruption early"
Message-Id: <ce44115e-f8ac-0307-88bd-f6a2e9d7f7f3@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20201002073341.12470-1-mlombard@redhat.com>
In-Reply-To: <20201002073341.12470-1-mlombard@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Maurizio Lombardi <mlombard@redhat.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 10/2/20 12:33 AM, Maurizio Lombardi wrote:
> This reverts commit b0055acaedf56a2717a6e2a4b700f1959a1b60df.
> 
> This warning is duplicated because the very same condition
> is already checked in __iscsit_free_cmd().
> 
> Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
> ---
>   drivers/target/iscsi/iscsi_target_util.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target_util.c b/drivers/target/iscsi/iscsi_target_util.c
> index 45ba07c6ec27..ff7830ddbd7b 100644
> --- a/drivers/target/iscsi/iscsi_target_util.c
> +++ b/drivers/target/iscsi/iscsi_target_util.c
> @@ -764,8 +764,6 @@ void iscsit_free_cmd(struct iscsi_cmd *cmd, bool shutdown)
>   	struct se_cmd *se_cmd = cmd->se_cmd.se_tfo ? &cmd->se_cmd : NULL;
>   	int rc;
>   
> -	WARN_ON(!list_empty(&cmd->i_conn_node));
> -
>   	__iscsit_free_cmd(cmd, shutdown);
>   	if (se_cmd) {
>   		rc = transport_generic_free_cmd(se_cmd, shutdown);

Hi Maurizio,

I agree that the same WARN_ON() occurs inside __iscsit_free_cmd(). What is not
clear to me is how removing the WARN_ON() statement from iscsit_free_cmd() can
help since an identical statement occurs inside __iscsit_free_cmd()?

Thanks,

Bart.

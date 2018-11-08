From: David Disseldorp <ddiss@suse.de>
Date: Thu, 08 Nov 2018 11:56:04 +0000
Subject: Re: [PATCH 01/10] target/tcmu: Fix queue_cmd_ring() declaration
Message-Id: <20181108125604.23af996b@suse.de>
List-Id: <target-devel.vger.kernel.org>
References: <20181106171718.89594-2-bvanassche@acm.org>
In-Reply-To: <20181106171718.89594-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On Tue,  6 Nov 2018 09:17:09 -0800, Bart Van Assche wrote:

...
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -958,7 +958,7 @@ static int add_to_cmdr_queue(struct tcmu_cmd *tcmu_cmd)
>   *  0 success
>   *  1 internally queued to wait for ring memory to free.
>   */
> -static sense_reason_t queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, int *scsi_err)
> +static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>  {
>  	struct tcmu_dev *udev = tcmu_cmd->tcmu_dev;
>  	struct se_cmd *se_cmd = tcmu_cmd->se_cmd;

Looks good.

Reviewed-by: David Disseldorp <ddiss@suse.de>

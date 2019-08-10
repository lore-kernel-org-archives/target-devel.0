From: Mike Christie <mchristi@redhat.com>
Date: Sat, 10 Aug 2019 23:55:56 +0000
Subject: Re: [PATCH] tcmu: avoid use-after-free after command timeout
Message-Id: <5D4F598C.9000207@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20190810211903.6572-1-dmitry.fomichev@wdc.com>
In-Reply-To: <20190810211903.6572-1-dmitry.fomichev@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dmitry Fomichev <dmitry.fomichev@wdc.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, target-devel@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Cc: Damien Le Moal <damien.lemoal@wdc.com>

On 08/10/2019 04:19 PM, Dmitry Fomichev wrote:
> In tcmu_handle_completion() function, the variable called read_len is
> always initialized with a value taken from se_cmd structure. If this
> function is called to complete an expired (timed out) out command, the
> session command pointed by se_cmd is likely to be already deallocated by
> the target core at that moment. As the result, this access triggers a
> use-after-free warning from KASAN.
> 
> This patch fixes the code not to touch se_cmd when completing timed out
> TCMU commands. It also resets the pointer to se_cmd at the time when the
> TCMU_CMD_BIT_EXPIRED flag is set because it is going to become invalid
> after calling target_complete_cmd() later in the same function,
> tcmu_check_expired_cmd().
> 
> Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
> ---
>  drivers/target/target_core_user.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 04eda111920e..a0231491fa36 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1132,14 +1132,16 @@ static void tcmu_handle_completion(struct tcmu_cmd *cmd, struct tcmu_cmd_entry *
>  	struct se_cmd *se_cmd = cmd->se_cmd;
>  	struct tcmu_dev *udev = cmd->tcmu_dev;
>  	bool read_len_valid = false;
> -	uint32_t read_len = se_cmd->data_length;
> +	uint32_t read_len;
>  
>  	/*
>  	 * cmd has been completed already from timeout, just reclaim
>  	 * data area space and free cmd
>  	 */
> -	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags))
> +	if (test_bit(TCMU_CMD_BIT_EXPIRED, &cmd->flags)) {
> +		WARN_ON_ONCE(se_cmd);

If you are adding a warn here, I think you want to also add a warn in
tcmu_reset_ring where there is another code path we do the same sequence
of operations where we check the bit then access the se_cmd after if not
set.

From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 14:28:11 +0000
Subject: Re: [PATCH 09/11] target/iscsi: Fix a race condition in iscsit_add_reject_from_cmd()
Message-Id: <3b4c9b07-9c4d-67bb-3ceb-082336820817@suse.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> Avoid that cmd->se_cmd.se_tfo is read after a command has already been
> freed.
> 
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Mike Christie <mchristi@redhat.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index 91fbada7cdc2..541f66a875fc 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -833,6 +833,7 @@ static int iscsit_add_reject_from_cmd(
>  	unsigned char *buf)
>  {
>  	struct iscsi_conn *conn;
> +	const bool do_put = cmd->se_cmd.se_tfo != NULL;
>  
>  	if (!cmd->conn) {
>  		pr_err("cmd->conn is NULL for ITT: 0x%08x\n",
> @@ -863,7 +864,7 @@ static int iscsit_add_reject_from_cmd(
>  	 * Perform the kref_put now if se_cmd has already been setup by
>  	 * scsit_setup_scsi_cmd()
>  	 */
> -	if (cmd->se_cmd.se_tfo != NULL) {
> +	if (do_put) {
>  		pr_debug("iscsi reject: calling target_put_sess_cmd >>>>>>\n");
>  		target_put_sess_cmd(&cmd->se_cmd);
>  	}
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

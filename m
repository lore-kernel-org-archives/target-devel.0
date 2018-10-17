From: Mike Christie <mchristi@redhat.com>
Date: Wed, 17 Oct 2018 17:46:21 +0000
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Remove target_wait_for_sess_cmd()
Message-Id: <5BC7756D.4080109@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1539711249-12634-1-git-send-email-bly@catalogicsoftware.com>
In-Reply-To: <1539711249-12634-1-git-send-email-bly@catalogicsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 10/16/2018 12:34 PM, Ly, Bryant wrote:
> From: "Bryant G. Ly" <bly@catalogicsoftware.com>
> 
> There is currently a bug with the driver where there is never a
> call to target_sess_cmd_list_set_waiting(), it only called
> target_wait_for_sess_cmd(), which basically means that the
> sess_wait_list would always be empty.
> 
> Thus, list_empty(&sess->sess_wait_list) = true,
> (eg: no se_cmd I/O is quiesced, because no se_cmd in sess_wait_list),
> since commit 712db3eb2c35 ("scsi: ibmvscsis: Properly deregister
> target sessions") in 4.9.y code.
> 
> ibmvscsi_tgt does not remove the I_T Nexus when a VM is
> active so we can fix this issue by removing the call to
> target_wait_for_sess_cmd() altogether.
> 
> Signed-off-by: Bryant G. Ly <bly@catalogicsoftware.com>
> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index fac3773..2175e9e 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -2266,7 +2266,6 @@ static int ibmvscsis_drop_nexus(struct ibmvscsis_tport *tport)
>  	/*
>  	 * Release the SCSI I_T Nexus to the emulated ibmvscsis Target Port
>  	 */
> -	target_wait_for_sess_cmds(se_sess);
>  	target_remove_session(se_sess);
>  	tport->ibmv_nexus = NULL;
>  	kfree(nexus);
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>

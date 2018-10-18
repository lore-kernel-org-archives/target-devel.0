From: "Martin K. Petersen" <martin.petersen@oracle.com>
Date: Thu, 18 Oct 2018 00:52:45 +0000
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Remove target_wait_for_sess_cmd()
Message-Id: <yq136t4m5ya.fsf@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <1539711249-12634-1-git-send-email-bly@catalogicsoftware.com>
In-Reply-To: <1539711249-12634-1-git-send-email-bly@catalogicsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org


Bryant,

> There is currently a bug with the driver where there is never a call
> to target_sess_cmd_list_set_waiting(), it only called
> target_wait_for_sess_cmd(), which basically means that the
> sess_wait_list would always be empty.
>
> Thus, list_empty(&sess->sess_wait_list) = true, (eg: no se_cmd I/O is
> quiesced, because no se_cmd in sess_wait_list), since commit
> 712db3eb2c35 ("scsi: ibmvscsis: Properly deregister target sessions")
> in 4.9.y code.
>
> ibmvscsi_tgt does not remove the I_T Nexus when a VM is active so we
> can fix this issue by removing the call to target_wait_for_sess_cmd()
> altogether.

Applied to 4.20/scsi-queue, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering

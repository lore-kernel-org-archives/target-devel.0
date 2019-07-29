From: Kees Cook <keescook@chromium.org>
Date: Mon, 29 Jul 2019 16:46:12 +0000
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Mark expected switch fall-throughs
Message-Id: <201907290946.C8FFE767@keescook>
List-Id: <target-devel.vger.kernel.org>
References: <20190729112902.GA3768@embeddedor>
In-Reply-To: <20190729112902.GA3768@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Michael Cyr <mikecyr@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>

On Mon, Jul 29, 2019 at 06:29:02AM -0500, Gustavo A. R. Silva wrote:
> Mark switch cases where we are expecting to fall through.
> 
> This patch fixes the following warnings (Building: powerpc allyesconfig):
> 
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function 'ibmvscsis_adapter_info':
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:1582:6: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    if (connection_broken(vscsi))
>       ^
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:1584:2: note: here
>   default:
>   ^~~~~~~
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c: In function 'ibmvscsis_ping_response':
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:2494:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    vscsi->flags |= CLIENT_FAILED;
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:2495:2: note: here
>   case H_DROPPED:
>   ^~~~
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:2496:16: warning: this statement may fall through [-Wimplicit-fallthrough=]
>    vscsi->flags |= RESPONSE_Q_DOWN;
> drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c:2497:2: note: here
>   case H_REMOTE_PARM:
>   ^~~~
> 
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> index 7f9535392a93..a929fe76102b 100644
> --- a/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> +++ b/drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
> @@ -1581,6 +1581,7 @@ static long ibmvscsis_adapter_info(struct scsi_info *vscsi,
>  	case H_PERMISSION:
>  		if (connection_broken(vscsi))
>  			flag_bits = (RESPONSE_Q_DOWN | CLIENT_FAILED);
> +		/* Fall through */
>  	default:
>  		dev_err(&vscsi->dev, "adapter_info: h_copy_rdma to client failed, rc %ld\n",
>  			rc);
> @@ -2492,8 +2493,10 @@ static long ibmvscsis_ping_response(struct scsi_info *vscsi)
>  		break;
>  	case H_CLOSED:
>  		vscsi->flags |= CLIENT_FAILED;
> +		/* Fall through */
>  	case H_DROPPED:
>  		vscsi->flags |= RESPONSE_Q_DOWN;
> +		/* Fall through */
>  	case H_REMOTE_PARM:
>  		dev_err(&vscsi->dev, "ping_response: h_send_crq failed, rc %ld\n",
>  			rc);
> -- 
> 2.22.0
> 

-- 
Kees Cook

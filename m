From: Maurizio Lombardi <mlombard@redhat.com>
Date: Tue, 15 Sep 2020 11:58:00 +0000
Subject: Re: [PATCH] scsi: target: remove redundant assignment to variable 'ret'
Message-Id: <2410adca-9e8c-d16e-8097-9c6eb8103362@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200914023207.113792-1-jingxiangfeng@huawei.com>
In-Reply-To: <20200914023207.113792-1-jingxiangfeng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jing Xiangfeng <jingxiangfeng@huawei.com>, martin.petersen@oracle.com, bvanassche@acm.org, michael.christie@oracle.com, sudhakar.panneerselvam@oracle.com, ddiss@suse.de, gustavoars@kernel.org
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, linux-kernel@vger.kernel.org



Dne 14. 09. 20 v 4:32 Jing Xiangfeng napsal(a):
> The variable ret has been initialized with a value '0'. The assignment
> in switch-case is redundant. So remove it.
> 
> Signed-off-by: Jing Xiangfeng <jingxiangfeng@huawei.com>
> ---
>  drivers/target/iscsi/iscsi_target.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
> index cd045dc75a58..f5272ac18b16 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c
> @@ -4516,7 +4516,6 @@ int iscsit_logout_post_handler(
>  			iscsit_logout_post_handler_closesession(conn);
>  			break;
>  		}
> -		ret = 0;
>  		break;
>  	case ISCSI_LOGOUT_REASON_CLOSE_CONNECTION:
>  		if (conn->cid = cmd->logout_cid) {
> @@ -4527,7 +4526,6 @@ int iscsit_logout_post_handler(
>  				iscsit_logout_post_handler_samecid(conn);
>  				break;
>  			}
> -			ret = 0;
>  		} else {
>  			switch (cmd->logout_response) {
>  			case ISCSI_LOGOUT_SUCCESS:
> 

Looks ok to me.

Reviewed-by: Maurizio Lombardi <mlombard@redhat.com>

From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Tue, 21 Apr 2020 16:26:23 +0000
Subject: Re: [RFC PATCH 11/12] iscsi target: use session sysfs helpers
Message-Id: <52b52bbb-ec57-eb13-c3ed-a4cf3a4b69ee@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200420191426.17055-1-mchristi@redhat.com>
 <20200420191426.17055-12-mchristi@redhat.com>
In-Reply-To: <20200420191426.17055-12-mchristi@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mike Christie <mchristi@redhat.com>, jsmart2021@gmail.com, bvanassche@acm.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

On 04/20/20 21:14, Mike Christie wrote:

...

> diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
> index f533308..a0ea60f 100644
> --- a/drivers/target/iscsi/iscsi_target_login.c
> +++ b/drivers/target/iscsi/iscsi_target_login.c

...

> @@ -313,7 +303,7 @@ static int iscsi_login_zero_tsih_s1(
>   				ISCSI_LOGIN_STATUS_NO_RESOURCES);
>   		pr_err("Unable to allocate memory for"
>   				" struct iscsi_sess_ops.\n");
> -		goto free_id;
> +		goto free_ops;

Shouldn' this be "goto free_sess;"?

>   	}
>   
>   	sess->se_sess = transport_alloc_session(TARGET_PROT_NORMAL);
> @@ -327,8 +317,6 @@ static int iscsi_login_zero_tsih_s1(
>   
>   free_ops:
>   	kfree(sess->sess_ops);
> -free_id:
> -	ida_free(&sess_ida, sess->session_index);
>   free_sess:
>   	kfree(sess);
>   	conn->sess = NULL;

From: Mike Christie <mchristi@redhat.com>
Date: Thu, 10 May 2018 16:43:27 +0000
Subject: Re: [RESEND] tcmu: fix error resetting qfull_time_out to default
Message-Id: <5AF476AF.1070801@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20180510134218.8261-1-prasanna.kalever@redhat.com>
In-Reply-To: <20180510134218.8261-1-prasanna.kalever@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 05/10/2018 08:42 AM, Prasanna Kumar Kalever wrote:
> Problem:
> -------
> $ cat /sys/kernel/config/target/core/user_0/block/attrib/qfull_time_out
> -1
> 
> $ echo "-1" > /sys/kernel/config/target/core/user_0/block/attrib/qfull_time_out
> -bash: echo: write error: Invalid argument
> 
> Fix:
> ---
> This patch will help reset qfull_time_out to its default i.e. qfull_time_out=-1
> 
> Signed-off-by: Prasanna Kumar Kalever <prasanna.kalever@redhat.com>
> ---
>  drivers/target/target_core_user.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 4ad89ea71a70..4f26bdc3d1dc 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -2121,6 +2121,8 @@ static ssize_t tcmu_qfull_time_out_store(struct config_item *item,
>  
>  	if (val >= 0) {
>  		udev->qfull_time_out = val * MSEC_PER_SEC;
> +	} else if (val = -1) {
> +		udev->qfull_time_out = val;
>  	} else {
>  		printk(KERN_ERR "Invalid qfull timeout value %d\n", val);
>  		return -EINVAL;
> 

Look ok.

Acked-by: Mike Christie <mchristi@redhat.com>

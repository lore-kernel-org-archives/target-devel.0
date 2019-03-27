From: Mike Christie <mchristi@redhat.com>
Date: Wed, 27 Mar 2019 19:43:39 +0000
Subject: Re: [PATCH V2] target:alua: fix the tg_pt_gps_count
Message-Id: <5C9BD26B.80509@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1553695146-4352-1-git-send-email-hndksztwj@163.com>
In-Reply-To: <1553695146-4352-1-git-send-email-hndksztwj@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 03/27/2019 08:59 AM, tangwenji wrote:
> From: tangwenji <tang.wenji@zte.com.cn>
> 
> Reducing the count should be alua_tg_pt_gps_count instead of alua_tg_pt_gps_counter when free alua group.
> 
> Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
> ---
>  drivers/target/target_core_alua.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index e09f0cf..893f1fe 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -1760,8 +1760,10 @@ void core_alua_free_tg_pt_gp(
>  	 * can be made while we are releasing struct t10_alua_tg_pt_gp.
>  	 */
>  	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
> -	list_del(&tg_pt_gp->tg_pt_gp_list);
> -	dev->t10_alua.alua_tg_pt_gps_counter--;
> +	if (tg_pt_gp->tg_pt_gp_valid_id) {
> +		list_del(&tg_pt_gp->tg_pt_gp_list);
> +		dev->t10_alua.alua_tg_pt_gps_count--;
> +	}
>  	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>  
>  	/*
> 

Looks ok to me.

Reviewed-by: Mike Christie <mchristi@redhat.com>

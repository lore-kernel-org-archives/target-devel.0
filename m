From: Mike Christie <mchristi@redhat.com>
Date: Wed, 20 Mar 2019 16:50:58 +0000
Subject: Re: [PATCH] target:alua: fix the tg_pt_gps_count
Message-Id: <5C926F72.3010100@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1552486046-1360-1-git-send-email-hndksztwj@163.com>
In-Reply-To: <1552486046-1360-1-git-send-email-hndksztwj@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 03/13/2019 09:07 AM, tangwenji wrote:
> From: tangwenji <tang.wenji@zte.com.cn>
> 
> Reducing the count should be alua_tg_pt_gps_count instead of alua_tg_pt_gps_counter when free alua group.
> 
> Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
> ---
>  drivers/target/target_core_alua.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_alua.c b/drivers/target/target_core_alua.c
> index e09f0cf..4808654 100644
> --- a/drivers/target/target_core_alua.c
> +++ b/drivers/target/target_core_alua.c
> @@ -1761,7 +1761,7 @@ void core_alua_free_tg_pt_gp(
>  	 */
>  	spin_lock(&dev->t10_alua.tg_pt_gps_lock);
>  	list_del(&tg_pt_gp->tg_pt_gp_list);
> -	dev->t10_alua.alua_tg_pt_gps_counter--;
> +	dev->t10_alua.alua_tg_pt_gps_count--;
>  	spin_unlock(&dev->t10_alua.tg_pt_gps_lock);
>  

I think because its always decremented here we could end up going
negative. If userspace does not call into
target_tg_pt_gp_tg_pt_gp_id_store or it fails, then we will not have
done a count++ and not added it to the list in core_alua_set_tg_pt_gp_id.

I think above above we need to do:

if (tg_pt_gp_valid_id) {
    list_del(&tg_pt_gp->tg_pt_gp_list)
    dev->t10_alua.alua_tg_pt_gps_count--;
}

From: Mike Christie <mchristi@redhat.com>
Date: Mon, 20 Nov 2017 20:16:22 +0000
Subject: Re: [PATCH] fix page addr in tcmu_flush_dcache_range
Message-Id: <5A133816.20000@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <1510996463-26020-1-git-send-email-tang.wenji@zte.com.cn>
In-Reply-To: <1510996463-26020-1-git-send-email-tang.wenji@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 11/18/2017 03:14 AM, tang.wenji@zte.com.cn wrote:
> From: tangwenji <tang.wenji@zte.com.cn>
> 
> The page addr should be update.
> 
> Signed-off-by: tangwenji <tang.wenji@zte.com.cn>
> ---
>  drivers/target/target_core_user.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 942d0942..82dc246 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -470,12 +470,13 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd *se_cmd)
>  static inline void tcmu_flush_dcache_range(void *vaddr, size_t size)
>  {
>  	unsigned long offset = offset_in_page(vaddr);
> +	void *start = vaddr - offset;
>  
>  	size = round_up(size+offset, PAGE_SIZE);
> -	vaddr -= offset;
>  
>  	while (size) {
> -		flush_dcache_page(virt_to_page(vaddr));
> +		flush_dcache_page(virt_to_page(start));
> +		start += PAGE_SIZE;
>  		size -= PAGE_SIZE;
>  	}
>  }
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>

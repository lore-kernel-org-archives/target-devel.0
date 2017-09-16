From: Mike Christie <mchristi@redhat.com>
Date: Sat, 16 Sep 2017 00:47:08 +0000
Subject: Re: [PATCH] target/tcmu: Use macro to call container_of in tcmu_cmd_time_out_show
Message-Id: <59BC748C.80200@redhat.com>
List-Id: <target-devel.vger.kernel.org>
References: <20170915054455.10615-1-nakayamakenjiro@gmail.com>
In-Reply-To: <20170915054455.10615-1-nakayamakenjiro@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 09/15/2017 12:44 AM, Kenjiro Nakayama wrote:
> This patch makes a tiny change that using TCMU_DEV in
> tcmu_cmd_time_out_show so it is consistent with other functions.
> 
> Signed-off-by: Kenjiro Nakayama <nakayamakenjiro@gmail.com>
> ---
>  drivers/target/target_core_user.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 942d094269fb..0705648acba3 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1734,8 +1734,7 @@ static ssize_t tcmu_cmd_time_out_show(struct config_item *item, char *page)
>  {
>  	struct se_dev_attrib *da = container_of(to_config_group(item),
>  					struct se_dev_attrib, da_group);
> -	struct tcmu_dev *udev = container_of(da->da_dev,
> -					struct tcmu_dev, se_dev);
> +	struct tcmu_dev *udev = TCMU_DEV(da->da_dev);
>  
>  	return snprintf(page, PAGE_SIZE, "%lu\n", udev->cmd_time_out / MSEC_PER_SEC);
>  }
> 

Reviewed-by: Mike Christie <mchristi@redhat.com>

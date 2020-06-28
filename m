From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 28 Jun 2020 02:17:14 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Fix crash on ARM during cmd completion
Message-Id: <cc5cc3d3-3895-9850-8f7e-b911a6bf22c0@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
In-Reply-To: <20200624085320.31117-1-bstroesser@ts.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Bodo Stroesser <bstroesser@ts.fujitsu.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: JiangYu <lnsyyj@hotmail.com>, Daniel Meyerholt <dxm523@gmail.com>, Henry Willard <henry.willard@oracle.com>

On 6/24/20 3:53 AM, Bodo Stroesser wrote:
> If tcmu_handle_completions() has to process a padding shorter
> than sizeof(struct tcmu_cmd_entry), the current call to
> tcmu_flush_dcache_range() with sizeof(struct tcmu_cmd_entry) as
> length param is wrong and causes crashes on e.g. ARM, because
> tcmu_flush_dcache_range() in this case calls
> 	flush_dcache_page(vmalloc_to_page(start));
> with start being an invalid address above the end of the
> vmalloc'ed area.
> 
> The fix is to use the maximum of remaining ring space and
> sizeof(struct tcmu_cmd_entry) as the length param.
> 
> The patch was tested on kernel 4.19.118.
> 
> See https://urldefense.com/v3/__https://bugzilla.kernel.org/show_bug.cgi?id 8045*c10__;Iw!!GqivPVa7Brio!Kxr99oE0H1b9Ily4SE23nDN7ElSf8Tclo1RILfNSXb6iPh6DA5cSgtBQQsLMBKdrLsmT$ 
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>
> Tested-by: JiangYu <lnsyyj@hotmail.com>
> ---
>  drivers/target/target_core_user.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index 3885ca532f8f..82e476d48194 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -1221,7 +1221,14 @@ static unsigned int tcmu_handle_completions(struct tcmu_dev *udev)
>  
>  		struct tcmu_cmd_entry *entry = (void *) mb + CMDR_OFF + udev->cmdr_last_cleaned;
>  
> -		tcmu_flush_dcache_range(entry, sizeof(*entry));
> +		/*
> +		 * Flush max. up to end of cmd ring, since current entry might
> +		 * be a padding that is shorter than sizeof(*entry)
> +		 */
> +		size_t ring_left = head_to_end(udev->cmdr_last_cleaned,
> +					       udev->cmdr_size);
> +		tcmu_flush_dcache_range(entry, ring_left < sizeof(*entry) ?
> +					ring_left : sizeof(*entry));
>  
>  		if (tcmu_hdr_get_op(entry->hdr.len_op) = TCMU_OP_PAD) {
>  			UPDATE_HEAD(udev->cmdr_last_cleaned,
> 

Thanks again.

Acked-by: Mike Christie <michael.christie@oracle.com>

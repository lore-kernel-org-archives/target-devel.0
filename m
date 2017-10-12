From: Daniel Vetter <daniel@ffwll.ch>
Date: Thu, 12 Oct 2017 17:55:41 +0000
Subject: Re: [Nouveau] [PATCH 03/10] driver:gpu: return -ENOMEM on allocation failure.
Message-Id: <20171012175541.5jh3ovdzpyj5fflv@phenom.ffwll.local>
List-Id: <target-devel.vger.kernel.org>
References: <1505287939-14106-1-git-send-email-allen.lkml@gmail.com>
 <1505287939-14106-3-git-send-email-allen.lkml@gmail.com>
In-Reply-To: <1505287939-14106-3-git-send-email-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-scsi@vger.kernel.org, nouveau@lists.freedesktop.org, megaraidlinux.pdl@broadcom.com, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, target-devel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, linux-btrfs@vger.kernel.org

On Wed, Sep 13, 2017 at 01:02:12PM +0530, Allen Pais wrote:
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>

Applied to drm-misc-next, thanks.
-Daniel

> ---
>  drivers/gpu/drm/gma500/mid_bios.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/gma500/mid_bios.c b/drivers/gpu/drm/gma500/mid_bios.c
> index d75ecb3..1fa1633 100644
> --- a/drivers/gpu/drm/gma500/mid_bios.c
> +++ b/drivers/gpu/drm/gma500/mid_bios.c
> @@ -237,7 +237,7 @@ static int mid_get_vbt_data_r10(struct drm_psb_private *dev_priv, u32 addr)
>  
>  	gct = kmalloc(sizeof(*gct) * vbt.panel_count, GFP_KERNEL);
>  	if (!gct)
> -		return -1;
> +		return -ENOMEM;
>  
>  	gct_virtual = ioremap(addr + sizeof(vbt),
>  			sizeof(*gct) * vbt.panel_count);
> -- 
> 2.7.4
> 
> _______________________________________________
> Nouveau mailing list
> Nouveau@lists.freedesktop.org
> https://lists.freedesktop.org/mailman/listinfo/nouveau

-- 
Daniel Vetter
Software Engineer, Intel Corporation
http://blog.ffwll.ch

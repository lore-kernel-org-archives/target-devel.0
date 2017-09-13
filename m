From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 13 Sep 2017 12:16:28 +0000
Subject: Re: [PATCH 06/10] drivers:ethernet: return -ENOMEM on allocation failure.
Message-Id: <20170913121628.GB11820@lunn.ch>
List-Id: <target-devel.vger.kernel.org>
References: <1505287939-14106-1-git-send-email-allen.lkml@gmail.com>
 <1505287939-14106-6-git-send-email-allen.lkml@gmail.com>
In-Reply-To: <1505287939-14106-6-git-send-email-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Allen Pais <allen.lkml@gmail.com>
Cc: linux-fbdev@vger.kernel.org, linux-scsi@vger.kernel.org, nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, target-devel@vger.kernel.org, linux-crypto@vger.kernel.org, netdev@vger.kernel.org, linux-btrfs@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, megaraidlinux.pdl@broadcom.com

On Wed, Sep 13, 2017 at 01:02:15PM +0530, Allen Pais wrote:
> Signed-off-by: Allen Pais <allen.lkml@gmail.com>
> ---
>  drivers/net/ethernet/sun/cassini.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/sun/cassini.c b/drivers/net/ethernet/sun/cassini.c
> index 382993c..fc0ea3a 100644
> --- a/drivers/net/ethernet/sun/cassini.c
> +++ b/drivers/net/ethernet/sun/cassini.c
> @@ -3984,7 +3984,7 @@ static inline int cas_alloc_rx_desc(struct cas *cp, int ring)
>  	size = RX_DESC_RINGN_SIZE(ring);
>  	for (i = 0; i < size; i++) {
>  		if ((page[i] = cas_page_alloc(cp, GFP_KERNEL)) = NULL)
> -			return -1;
> +			return -ENOMEM;
>  	}
>  	return 0;
>  }

static int cas_alloc_rxds(struct cas *cp)
{
	int i;

	for (i = 0; i < N_RX_DESC_RINGS; i++) {
		if (cas_alloc_rx_desc(cp, i) < 0) {
	       		cas_free_rxds(cp);
			return -1;
		}
	}
	return 0;
}

Again, your change is correct, but in the end the value is not used.
And if you fix it at the cas_alloc_rxds level, you also need a fix at
the next level up:

	err = -ENOMEM;
	if (cas_tx_tiny_alloc(cp) < 0)
		goto err_unlock;

	/* alloc rx descriptors */
	if (cas_alloc_rxds(cp) < 0)
		goto err_tx_tiny;

again, the return value is discarded.

       Andrew

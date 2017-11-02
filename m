From: Hannes Reinecke <hare@suse.com>
Date: Thu, 02 Nov 2017 14:29:53 +0000
Subject: Re: [PATCH 11/11] usb/gadget: Make it again possible to enable the legacy drivers without enabling U
Message-Id: <f4bff587-0338-f82d-2d6b-dcb0851726f0@suse.com>
List-Id: <target-devel.vger.kernel.org>
References: <20171031180319.19258-12-bart.vanassche@wdc.com>
In-Reply-To: <20171031180319.19258-12-bart.vanassche@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: target-devel@vger.kernel.org

On 10/31/2017 07:03 PM, Bart Van Assche wrote:
> Considerable time ago the legacy gadget menu was added inside the
> USB_ETH choice. I think this was a mistake and that the legacy
> gadget menu should have been added after "endchoice" instead of
> before. Hence this patch.
> 
> Fixes: commit 8443f2d2b778 ("usb: gadget: Gadget directory cleanup - group legacy gadgets")
> Signed-off-by: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: linux-usb@vger.kernel.org
> ---
>  drivers/usb/gadget/Kconfig        |  4 ++--
>  drivers/usb/gadget/legacy/Kconfig | 10 ++++++++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 31cce7805eb2..0a19a76645ad 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -508,8 +508,8 @@ choice
>  	  controller, and the relevant drivers for each function declared
>  	  by the device.
>  
> -source "drivers/usb/gadget/legacy/Kconfig"
> -
>  endchoice
>  
> +source "drivers/usb/gadget/legacy/Kconfig"
> +
>  endif # USB_GADGET
> diff --git a/drivers/usb/gadget/legacy/Kconfig b/drivers/usb/gadget/legacy/Kconfig
> index a12fb459dbd9..9570bbeced4f 100644
> --- a/drivers/usb/gadget/legacy/Kconfig
> +++ b/drivers/usb/gadget/legacy/Kconfig
> @@ -13,6 +13,14 @@
>  # both kinds of controller can also support "USB On-the-Go" (CONFIG_USB_OTG).
>  #
>  
> +menuconfig USB_GADGET_LEGACY
> +	bool "Legacy USB Gadget Support"
> +	help
> +	   Legacy USB gadgets are USB gadgets that do not use the USB gadget
> +	   configfs interface.
> +
> +if USB_GADGET_LEGACY
> +
>  config USB_ZERO
>  	tristate "Gadget Zero (DEVELOPMENT)"
>  	select USB_LIBCOMPOSITE
> @@ -490,3 +498,5 @@ config USB_G_WEBCAM
>  
>  	  Say "y" to link the driver statically, or "m" to build a
>  	  dynamically linked module called "g_webcam".
> +
> +endif
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes

-- 
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.com			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)

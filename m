From: Bart Van Assche <bvanassche@acm.org>
Date: Sat, 18 Apr 2020 22:20:31 +0000
Subject: Re: [RFC PATCH 1/9] kernel.h: add do_empty() macro
Message-Id: <f097242a-1bf0-218b-4890-3ee82c5a0a23@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-2-rdunlap@infradead.org>
In-Reply-To: <20200418184111.13401-2-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Zzy Wysm <zzy@zzywysm.com>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

On 4/18/20 11:41 AM, Randy Dunlap wrote:
> --- linux-next-20200327.orig/include/linux/kernel.h
> +++ linux-next-20200327/include/linux/kernel.h
> @@ -40,6 +40,14 @@
>   #define READ			0
>   #define WRITE			1
>   
> +/*
> + * When using -Wextra, an "if" statement followed by an empty block
> + * (containing only a ';'), produces a warning from gcc:
> + * warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
> + * Replace the empty body with do_empty() to silence this warning.
> + */
> +#define do_empty()		do { } while (0)
> +
>   /**
>    * ARRAY_SIZE - get the number of elements in array @arr
>    * @arr: array to be sized

I'm less than enthusiast about introducing a new macro to suppress 
"empty body" warnings. Anyone who encounters code in which this macro is 
used will have to look up the definition of this macro to learn what it 
does. Has it been considered to suppress empty body warnings by changing 
the empty bodies from ";" into "{}"?

Thanks,

Bart.

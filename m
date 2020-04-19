From: Christoph Hellwig <hch@infradead.org>
Date: Sun, 19 Apr 2020 08:15:50 +0000
Subject: Re: [PATCH 8/9] dax: fix empty-body warnings in bus.c
Message-Id: <20200419081550.GA22341@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-9-rdunlap@infradead.org>
In-Reply-To: <20200418184111.13401-9-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: alsa-devel@alsa-project.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Zzy Wysm <zzy@zzywysm.com>, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, Apr 18, 2020 at 11:41:10AM -0700, Randy Dunlap wrote:
>  				rc = -ENOMEM;
>  		} else
> -			/* nothing to remove */;
> +			do_empty(); /* nothing to remove */
>  	} else if (action = ID_REMOVE) {
>  		list_del(&dax_id->list);
>  		kfree(dax_id);
>  	} else
> -		/* dax_id already added */;
> +		do_empty(); /* dax_id already added */

This is just nasty.  Please just always turn this bogus warning off
as the existing code is a perfectly readable idiom while the new code
is just nasty crap for no good reason at all.

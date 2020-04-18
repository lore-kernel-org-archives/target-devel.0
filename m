From: Chuck Lever <chuck.lever@oracle.com>
Date: Sat, 18 Apr 2020 18:45:55 +0000
Subject: Re: [PATCH 6/9] nfsd: fix empty-body warning in nfs4state.c
Message-Id: <CDCF7717-7CBC-47CA-9E83-3A18ECB3AB89@oracle.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-7-rdunlap@infradead.org>
In-Reply-To: <20200418184111.13401-7-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: Randy Dunlap <rdunlap@infradead.org>
Cc: alsa-devel@alsa-project.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Zzy Wysm <zzy@zzywysm.com>, LKML <linux-kernel@vger.kernel.org>, Bruce Fields <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, linux-input@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Linux NFS Mailing List <linux-nfs@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>



> On Apr 18, 2020, at 2:41 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> 
> Fix gcc empty-body warning when -Wextra is used:
> 
> ../fs/nfsd/nfs4state.c:3898:3: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: "J. Bruce Fields" <bfields@fieldses.org>
> Cc: Chuck Lever <chuck.lever@oracle.com>
> Cc: linux-nfs@vger.kernel.org

I have a patch in my queue that addresses this particular warning,
but your change works for me too.

Acked-by: Chuck Lever <chuck.lever@oracle.com>

Unless Bruce objects.


> ---
> fs/nfsd/nfs4state.c |    3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-next-20200417.orig/fs/nfsd/nfs4state.c
> +++ linux-next-20200417/fs/nfsd/nfs4state.c
> @@ -34,6 +34,7 @@
> 
> #include <linux/file.h>
> #include <linux/fs.h>
> +#include <linux/kernel.h>
> #include <linux/slab.h>
> #include <linux/namei.h>
> #include <linux/swap.h>
> @@ -3895,7 +3896,7 @@ nfsd4_setclientid(struct svc_rqst *rqstp
> 		copy_clid(new, conf);
> 		gen_confirm(new, nn);
> 	} else /* case 4 (new client) or cases 2, 3 (client reboot): */
> -		;
> +		do_empty();
> 	new->cl_minorversion = 0;
> 	gen_callback(new, setclid, rqstp);
> 	add_to_unconfirmed(new);

--
Chuck Lever

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sun, 19 Apr 2020 12:03:04 +0000
Subject: Re: [PATCH 7/9] drivers/base: fix empty-body warnings in devcoredump.c
Message-Id: <20200419120304.GA3668771@kroah.com>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-8-rdunlap@infradead.org>
 <20200418185033.GQ5820@bombadil.infradead.org>
 <b88d6f8b-e6af-7071-cefa-dc12e79116b6@infradead.org>
 <d018321b0f281ff29efb04dd1496c8e6499812fb.camel@perches.com>
 <CAHk-=wi4QU90W1j1VVUrqdrkrq-0XPA06sjGUm-g1VHRB-35YA@mail.gmail.com>
In-Reply-To: <CAHk-=wi4QU90W1j1VVUrqdrkrq-0XPA06sjGUm-g1VHRB-35YA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Rafael Wysocki <rafael@kernel.org>, Zzy Wysm <zzy@zzywysm.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel <target-devel@vger.kernel.org>, Dave Jiang <dave.jiang@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Joe Perches <joe@perches.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, "open list:NFS, SUNRPC,
 AND..." <linux-nfs@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Johannes Berg <johannes@sipsolutions.net>

On Sat, Apr 18, 2020 at 12:15:57PM -0700, Linus Torvalds wrote:
> On Sat, Apr 18, 2020 at 11:57 AM Joe Perches <joe@perches.com> wrote:
> >
> > sysfs_create_link is __must_check
> 
> The way to handle __must_check if you really really don't want to test
> and have good reasons is
> 
>  (a) add a big comment about why this case ostensibly doesn't need the check
> 
>  (b) cast a test of it to '(void)' or something (I guess we could add
> a helper for this). So something like
> 
>         /* We will always clean up, we don't care whether this fails
> or succeeds */
>         (void)!!sysfs_create_link(...)
> 
> There are other alternatives (like using WARN_ON_ONCE() instead, for
> example). So it depends on the code. Which is why that comment is
> important to show why the code chose that option.
> 
> However, I wonder if in this case we should just remove the
> __must_check. Greg? It goes back a long long time.

Yeah, maybe it is time to remove it, the gyrations people go through to
remove the warning when they "know" they are doing it right feels pretty
bad compared to forcing people to check things for "normal" calls to the
function.

thanks,

greg k-h

From: Alan Stern <stern@rowland.harvard.edu>
Date: Tue, 21 Apr 2020 13:58:02 +0000
Subject: Re: [PATCH 5/9] usb: fix empty-body warning in sysfs.c
Message-Id: <Pine.LNX.4.44L0.2004210956590.20254-100000@netrider.rowland.org>
List-Id: <target-devel.vger.kernel.org>
In-Reply-To: <87368xskga.fsf@notabene.neil.brown.name>
References: <20200418184111.13401-6-rdunlap@infradead.org>
In-Reply-To: <20200418184111.13401-6-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: NeilBrown <neilb@suse.de>
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Zzy Wysm <zzy@zzywysm.com>, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, Matthew Wilcox <willy@infradead.org>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

On Tue, 21 Apr 2020, NeilBrown wrote:

> On Sat, Apr 18 2020, Alan Stern wrote:
> 
> > On Sat, 18 Apr 2020, Matthew Wilcox wrote:
> >
> >> On Sat, Apr 18, 2020 at 11:41:07AM -0700, Randy Dunlap wrote:
> >> > +++ linux-next-20200327/drivers/usb/core/sysfs.c
> >> > @@ -1263,7 +1263,7 @@ void usb_create_sysfs_intf_files(struct
> >> >  	if (!alt->string && !(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
> >> >  		alt->string = usb_cache_string(udev, alt->desc.iInterface);
> >> >  	if (alt->string && device_create_file(&intf->dev, &dev_attr_interface))
> >> > -		;	/* We don't actually care if the function fails. */
> >> > +		do_empty(); /* We don't actually care if the function fails. */
> >> >  	intf->sysfs_files_created = 1;
> >> >  }
> >> 
> >> Why not just?
> >> 
> >> +	if (alt->string)
> >> +		device_create_file(&intf->dev, &dev_attr_interface);
> >
> > This is another __must_check function call.
> >
> > The reason we don't care if the call fails is because the file
> > being created holds the USB interface string descriptor, something
> > which is purely informational and hardly ever gets set (and no doubt
> > gets used even less often).
> >
> > Is this another situation where the comment should be expanded and the 
> > code modified to include a useless test and cast-to-void?
> >
> > Or should device_create_file() not be __must_check after all?
> 
> One approach to dealing with __must_check function that you don't want
> to check is to cause failure to call
>    pr_debug("usb: interface descriptor file not created");
> or similar.  It silences the compiler, serves as documentation, and
> creates a message that is almost certainly never seen.
> 
> This is what I did in drivers/md/md.c...
> 
> 	if (mddev->kobj.sd &&
> 	    sysfs_create_group(&mddev->kobj, &md_bitmap_group))
> 		pr_debug("pointless warning\n");
> 
> (I give better warnings elsewhere - I must have run out of patience by
>  this point).

That's a decent idea.  I'll do something along those lines.

Alan Stern

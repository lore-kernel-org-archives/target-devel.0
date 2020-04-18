From: Johannes Berg <johannes@sipsolutions.net>
Date: Sat, 18 Apr 2020 19:16:19 +0000
Subject: Re: [PATCH 7/9] drivers/base: fix empty-body warnings in devcoredump.c
Message-Id: <ae170e7c4988399e63a00ad8505e397665563d22.camel@sipsolutions.net>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-8-rdunlap@infradead.org>
 <20200418185033.GQ5820@bombadil.infradead.org>
 <b88d6f8b-e6af-7071-cefa-dc12e79116b6@infradead.org>
 <d018321b0f281ff29efb04dd1496c8e6499812fb.camel@perches.com>
 <20200418191338.GR5820@bombadil.infradead.org>
In-Reply-To: <20200418191338.GR5820@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Joe Perches <joe@perches.com>
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Zzy Wysm <zzy@zzywysm.com>, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, 2020-04-18 at 12:13 -0700, Matthew Wilcox wrote:
> 
> > > > >  	if (sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
> > > > >  			      "failing_device"))
> > > > > -		/* nothing - symlink will be missing */;
> > > > > +		do_empty(); /* nothing - symlink will be missing */
> > > > >  
> > > > >  	if (sysfs_create_link(&dev->kobj, &devcd->devcd_dev.kobj,
> > > > >  			      "devcoredump"))
> > > > > -		/* nothing - symlink will be missing */;
> > > > > +		do_empty(); /* nothing - symlink will be missing */
> > > > >  
> > > > >  	INIT_DELAYED_WORK(&devcd->del_wk, devcd_del);
> > > > >  	schedule_delayed_work(&devcd->del_wk, DEVCD_TIMEOUT);
> > > > 
> > > > Could just remove the 'if's?
> > > > 
> > > > +	sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
> > > > +			"failing_device");
> > > > 
> > > 
> > > OK.
> > 
> > sysfs_create_link is __must_check
> 
> Oh, I missed the declaration -- I just saw the definition.  This is a
> situation where __must_check hurts us and it should be removed.
> 
> Or this code is wrong and it should be
> 
> 	WARN(sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
> 			"failing_device");

Perhaps it should be. I didn't think it really mattered _that_ much if
the symlink suddenly went missing, but OTOH I don't even know how it
could possibly fail.

johannes

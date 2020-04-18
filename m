From: Matthew Wilcox <willy@infradead.org>
Date: Sat, 18 Apr 2020 19:13:38 +0000
Subject: Re: [PATCH 7/9] drivers/base: fix empty-body warnings in devcoredump.c
Message-Id: <20200418191338.GR5820@bombadil.infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-8-rdunlap@infradead.org>
 <20200418185033.GQ5820@bombadil.infradead.org>
 <b88d6f8b-e6af-7071-cefa-dc12e79116b6@infradead.org>
 <d018321b0f281ff29efb04dd1496c8e6499812fb.camel@perches.com>
In-Reply-To: <d018321b0f281ff29efb04dd1496c8e6499812fb.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Zzy Wysm <zzy@zzywysm.com>, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

On Sat, Apr 18, 2020 at 11:55:05AM -0700, Joe Perches wrote:
> On Sat, 2020-04-18 at 11:53 -0700, Randy Dunlap wrote:
> > On 4/18/20 11:50 AM, Matthew Wilcox wrote:
> > > On Sat, Apr 18, 2020 at 11:41:09AM -0700, Randy Dunlap wrote:
> > > > @@ -294,11 +295,11 @@ void dev_coredumpm(struct device *dev, s
> > > >  
> > > >  	if (sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
> > > >  			      "failing_device"))
> > > > -		/* nothing - symlink will be missing */;
> > > > +		do_empty(); /* nothing - symlink will be missing */
> > > >  
> > > >  	if (sysfs_create_link(&dev->kobj, &devcd->devcd_dev.kobj,
> > > >  			      "devcoredump"))
> > > > -		/* nothing - symlink will be missing */;
> > > > +		do_empty(); /* nothing - symlink will be missing */
> > > >  
> > > >  	INIT_DELAYED_WORK(&devcd->del_wk, devcd_del);
> > > >  	schedule_delayed_work(&devcd->del_wk, DEVCD_TIMEOUT);
> > > 
> > > Could just remove the 'if's?
> > > 
> > > +	sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
> > > +			"failing_device");
> > > 
> > 
> > OK.
> 
> sysfs_create_link is __must_check

Oh, I missed the declaration -- I just saw the definition.  This is a
situation where __must_check hurts us and it should be removed.

Or this code is wrong and it should be

	WARN(sysfs_create_link(&devcd->devcd_dev.kobj, &dev->kobj,
			"failing_device");

like drivers/pci/controller/vmd.c and drivers/i2c/i2c-mux.c

Either way, the do_empty() construct feels like the wrong way of covering
up the warning.

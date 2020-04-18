From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 18:46:32 +0000
Subject: Re: [PATCH 5/9] usb: fix empty-body warning in sysfs.c
Message-Id: <3998d056-e115-4e36-2705-eea132cce7de@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
 <20200418184111.13401-6-rdunlap@infradead.org>
 <20200418184409.GP5820@bombadil.infradead.org>
In-Reply-To: <20200418184409.GP5820@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: alsa-devel@alsa-project.org, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Zzy Wysm <zzy@zzywysm.com>, linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, Takashi Iwai <tiwai@suse.com>, Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

On 4/18/20 11:44 AM, Matthew Wilcox wrote:
> On Sat, Apr 18, 2020 at 11:41:07AM -0700, Randy Dunlap wrote:
>> +++ linux-next-20200327/drivers/usb/core/sysfs.c
>> @@ -1263,7 +1263,7 @@ void usb_create_sysfs_intf_files(struct
>>  	if (!alt->string && !(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
>>  		alt->string = usb_cache_string(udev, alt->desc.iInterface);
>>  	if (alt->string && device_create_file(&intf->dev, &dev_attr_interface))
>> -		;	/* We don't actually care if the function fails. */
>> +		do_empty(); /* We don't actually care if the function fails. */
>>  	intf->sysfs_files_created = 1;
>>  }
> 
> Why not just?
> 
> +	if (alt->string)
> +		device_create_file(&intf->dev, &dev_attr_interface);
> 

Yes, looks good. Thanks.

-- 
~Randy

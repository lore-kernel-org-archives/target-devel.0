From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 18:41:07 +0000
Subject: [PATCH 5/9] usb: fix empty-body warning in sysfs.c
Message-Id: <20200418184111.13401-6-rdunlap@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
In-Reply-To: <20200418184111.13401-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Zzy Wysm <zzy@zzywysm.com>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

Fix gcc empty-body warning when -Wextra is used:

../drivers/usb/core/sysfs.c: In function ‘usb_create_sysfs_intf_files’:
../drivers/usb/core/sysfs.c:1266:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
   ; /* We don't actually care if the function fails. */
   ^

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/usb/core/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200327.orig/drivers/usb/core/sysfs.c
+++ linux-next-20200327/drivers/usb/core/sysfs.c
@@ -1263,7 +1263,7 @@ void usb_create_sysfs_intf_files(struct
 	if (!alt->string && !(udev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
 		alt->string = usb_cache_string(udev, alt->desc.iInterface);
 	if (alt->string && device_create_file(&intf->dev, &dev_attr_interface))
-		;	/* We don't actually care if the function fails. */
+		do_empty(); /* We don't actually care if the function fails. */
 	intf->sysfs_files_created = 1;
 }
 

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 18:41:10 +0000
Subject: [PATCH 8/9] dax: fix empty-body warnings in bus.c
Message-Id: <20200418184111.13401-9-rdunlap@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
In-Reply-To: <20200418184111.13401-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Zzy Wysm <zzy@zzywysm.com>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

Fix gcc empty-body warning when -Wextra is used:

../drivers/dax/bus.c:93:27: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]
../drivers/dax/bus.c:98:29: warning: suggest braces around empty body in an ‘else’ statement [-Wempty-body]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 drivers/dax/bus.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20200417.orig/drivers/dax/bus.c
+++ linux-next-20200417/drivers/dax/bus.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2017-2018 Intel Corporation. All rights reserved. */
 #include <linux/memremap.h>
 #include <linux/device.h>
+#include <linux/kernel.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -90,12 +91,12 @@ static ssize_t do_id_store(struct device
 			} else
 				rc = -ENOMEM;
 		} else
-			/* nothing to remove */;
+			do_empty(); /* nothing to remove */
 	} else if (action = ID_REMOVE) {
 		list_del(&dax_id->list);
 		kfree(dax_id);
 	} else
-		/* dax_id already added */;
+		do_empty(); /* dax_id already added */
 	mutex_unlock(&dax_bus_lock);
 
 	if (rc < 0)

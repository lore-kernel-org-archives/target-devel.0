From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 18:41:06 +0000
Subject: [PATCH 4/9] sound: fix empty-body warning in vx_core.c
Message-Id: <20200418184111.13401-5-rdunlap@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
In-Reply-To: <20200418184111.13401-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Zzy Wysm <zzy@zzywysm.com>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

Fix gcc empty-body warning when -Wextra is used:

../sound/drivers/vx/vx_core.c:515:3: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Cc: alsa-devel@alsa-project.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 sound/drivers/vx/vx_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- linux-next-20200327.orig/sound/drivers/vx/vx_core.c
+++ linux-next-20200327/sound/drivers/vx/vx_core.c
@@ -13,6 +13,7 @@
 #include <linux/init.h>
 #include <linux/device.h>
 #include <linux/firmware.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/io.h>
 #include <sound/core.h>
@@ -512,7 +513,7 @@ irqreturn_t snd_vx_threaded_irq_handler(
 	 * received by the board is equal to one of those given to it).
 	 */
 	if (events & TIME_CODE_EVENT_PENDING)
-		; /* so far, nothing to do yet */
+		do_empty(); /* so far, nothing to do yet */
 
 	/* The frequency has changed on the board (UER mode). */
 	if (events & FREQUENCY_CHANGE_EVENT_PENDING)

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 18:41:04 +0000
Subject: [PATCH 2/9] fs: fix empty-body warning in posix_acl.c
Message-Id: <20200418184111.13401-3-rdunlap@infradead.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200418184111.13401-1-rdunlap@infradead.org>
In-Reply-To: <20200418184111.13401-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Zzy Wysm <zzy@zzywysm.com>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

Fix gcc empty-body warning when -Wextra is used:

../fs/posix_acl.c: In function ‘get_acl’:
../fs/posix_acl.c:127:22: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
   /* fall through */ ;
                      ^

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 fs/posix_acl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200327.orig/fs/posix_acl.c
+++ linux-next-20200327/fs/posix_acl.c
@@ -124,7 +124,7 @@ struct posix_acl *get_acl(struct inode *
 	 * be an unlikely race.)
 	 */
 	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED)
-		/* fall through */ ;
+		do_empty(); /* fall through */
 
 	/*
 	 * Normally, the ACL returned by ->get_acl will be cached.

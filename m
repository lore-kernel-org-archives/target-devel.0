From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 Apr 2020 18:41:02 +0000
Subject: [RFC PATCH 0/9] fix -Wempty-body build warnings
Message-Id: <20200418184111.13401-1-rdunlap@infradead.org>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
To: linux-kernel@vger.kernel.org
Cc: alsa-devel@alsa-project.org, Randy Dunlap <rdunlap@infradead.org>, Zzy Wysm <zzy@zzywysm.com>, "J. Bruce Fields" <bfields@fieldses.org>, target-devel@vger.kernel.org, Dave Jiang <dave.jiang@intel.com>, linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, Vishal Verma <vishal.l.verma@intel.com>, Chuck Lever <chuck.lever@oracle.com>, linux-input@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dan Williams <dan.j.williams@intel.com>, Andrew Morton <akpm@linux-foundation.org>, linux-nfs@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Takashi Iwai <tiwai@suse.com>, linux-usb@vger.kernel.org, linux-fsdevel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Linus Torvalds <torvalds@linux-foundation.org>

Hi,

When -Wextra is used, gcc emits many warnings about an empty 'if' or
'else' body, like this:

../fs/posix_acl.c: In function ‘get_acl’:
../fs/posix_acl.c:127:22: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]
   /* fall through */ ;
                      ^

To quieten these warnings, add a new macro "do_empty()".
I originally wanted to use do_nothing(), but that's already in use.

It would sorta be nice if "fallthrough" could be coerced for this
instead of using something like do_empty().

Or should we just use "{}" in place of ";"?
This causes some odd coding style issue IMO. E.g., see this change:

original:
 	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED)
		/* fall through */ ;

with new macro:
 	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED)
		do_empty(); /* fall through */

using {}:
 	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED)
		{} /* fall through */
or
		{ /* fall through */ }
or even
 	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED) {
		/* fall through */ }
or
 	if (cmpxchg(p, ACL_NOT_CACHED, sentinel) != ACL_NOT_CACHED) {
		} /* fall through */


 drivers/base/devcoredump.c         |    5 +++--
 drivers/dax/bus.c                  |    5 +++--
 drivers/input/mouse/synaptics.c    |    3 ++-
 drivers/target/target_core_pscsi.c |    3 ++-
 drivers/usb/core/sysfs.c           |    2 +-
 fs/nfsd/nfs4state.c                |    3 ++-
 fs/posix_acl.c                     |    2 +-
 include/linux/kernel.h             |    8 ++++++++
 sound/drivers/vx/vx_core.c         |    3 ++-
 9 files changed, 24 insertions(+), 10 deletions(-)

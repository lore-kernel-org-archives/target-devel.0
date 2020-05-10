From: Mike Christie <mchristi@redhat.com>
Date: Sun, 10 May 2020 21:57:29 +0000
Subject: [PATCH v5 00/15] target: add sysfs support
Message-Id: <20200510215744.21999-1-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The following patches made over Linus's current tree allow lio to export
info about structs like the se_session that the kernel initiates creation
of via events like initiator login where there is no local user interaction
like a mkdir.

Why sysfs when we have configfs?

I started with configfs and hit bugs like:

commit cc57c07343bd071cdf1915a91a24ab7d40c9b590
Author: Mike Christie <mchristi@redhat.com>
Date:   Sun Jul 15 18:16:17 2018 -0500

    configfs: fix registered group removal

and it turns out that bug was not really a bug and was just how configfs
was meant to work. It seems it was not meant to be used where the kernel
initiates creation of dirs/files as a result of some internal action. It's
more geared to the user initiating the creation, and my patch just lead
to other bugs and was reverted:

commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Aug 29 23:13:30 2019 -0400

    configfs_register_group() shouldn't be (and isn't) called in
rmdirable parts

So to export the session info we have debugfs, sysfs, ioctl, netlink, etc.
sysfs just seemed like a decent fit since one of the primary users is
rtslib and it already has lots of file/dir handling code.


V4:
- Don't drop const char use in fabric drivers.
- add Documentation/ABI
- use initaitor port prefix instead of generic "session"
- only make session_id file if iSCSI format=1 is being used.

V3:
- drop format field
- delay tpg deletion to allow fabric modules time to remove their
  sessions.
- Added root sessions dir for easier lookup if userspace has the
  session id.
- add session symlink
- use simple ida.
- Fix goto use. Actually moved sysfs addition call to after nego
  to avoid sysfs additions when login ends up failing.
- Dropped target_setup_session callback fixups and dropped the
  init/free session callback for now. It's not immediately needed
  for this base session sysfs info support.

V2:
- rename top level dir to scsi_target
- Fix extra newline
- Copy data that's exported to sysfs so we do not have to worry about
configfs and sysfs refcounts.
- Export session info needed for tracking sessions in userspace and
handling commands like PGRs there (still needs a way to notify userspace
when sessions are added/deleted, but that will be a different set since
the focus is different).

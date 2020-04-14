From: Mike Christie <mchristi@redhat.com>
Date: Tue, 14 Apr 2020 05:15:09 +0000
Subject: [RFC PATCH 0/5] target: add sysfs support
Message-Id: <20200414051514.7296-1-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jsmart2021@gmail.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, nab@linux-iscsi.org

The following patches made over Linus's current tree allow lio to
export info about structs that the kernel initiates creation of
via events like initiator login where there is no user interaction
like a mkdir. These patches specificially focus on the
I_T_nexus/session but could be used for other objects if we want.

Why sysfs when we have configfs?

I started with configfs and hit bugs like:

commit cc57c07343bd071cdf1915a91a24ab7d40c9b590
Author: Mike Christie <mchristi@redhat.com>
Date:   Sun Jul 15 18:16:17 2018 -0500

    configfs: fix registered group removal

but it turns out that bug was not really a bug and was just how
configfs was meant to work. It seems it was not meant to be used
where the kernel initiates creation of dirs/files as a result of
some internal action. It's more geared to the user initiating
the creation, and my patch just lead to other bugs and was
reverted:

commit f19e4ed1e1edbfa3c9ccb9fed17759b7d6db24c6
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Thu Aug 29 23:13:30 2019 -0400

    configfs_register_group() shouldn't be (and isn't) called in
rmdirable parts

So to export the session info we have debugfs, sysfs, ioctl,
netlink, etc. sysfs just seemed like a decent fit since one of the
primary users is rtslib and it already has lots of file/dir
handling code.

From: Mike Christie <michael.christie@oracle.com>
Date: Sat, 27 Jun 2020 04:34:59 +0000
Subject: [RFC PATCH 00/10] target: add configfs interface
Message-Id: <1593232509-13720-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hare@suse.de, bvanassche@acm.org, bstroesser@ts.fujitsu.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The following patches made over linus's current tree (also apply
over Martin's 5.9 scsi queue branch) add a configfs interface to
export LIO's sessions.

With Hannes not liking the refcounting/tricks in the sysfs approach
I took another stab at configfs. This approach works similar to the
loop/vhost/usb/xen nexus interface where there is a special file
that allows userspace to add/remove sessions.

Because the kernel is making sessions for most drivers, we do not
have mkdir/rmdir support for the session dir, but using the special
file approach we can still remove children session in the correct
order and avoid the issues I hit before. The interface is a little
odd configfs wise because we use the special file, but it has the
benefit everything is in the one interface so it's easy to update
the tools.

If this approach is preferred over the sysfs one then I can repost
with some other fixes, the transport id patches and the iscsi
conversion one.

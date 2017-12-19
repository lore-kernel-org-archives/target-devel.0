From: Mike Christie <mchristi@redhat.com>
Date: Tue, 19 Dec 2017 10:03:53 +0000
Subject: [PATCH 0/5]: Fix target_core_user userspace restarts (v2)
Message-Id: <1513677838-6675-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The following patches were made over Linus's tree
and my tcmu update here

https://www.spinics.net/lists/target-devel/msg16283.html

The first patch prevents possible corruption with buggy tcmu userspace
apps. The other 4 patches allow tcmu apps to restart themselves while
IO is being executed. This is needed for management operations like
updating the app and handling crashes.

The last four patches are an update to this RFC:
https://www.spinics.net/lists/target-devel/msg16312.html
Since that posting I moved the files being added to a new
dir "action" which is used for special files that execute
a kernel function that does more than just set a param/attrib
that is exported from the same file.




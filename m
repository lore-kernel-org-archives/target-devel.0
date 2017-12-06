From: Mike Christie <mchristi@redhat.com>
Date: Wed, 06 Dec 2017 07:08:16 +0000
Subject: [RFC PATCH 0/3] Fix target_core_user userspace restarts
Message-Id: <1512544099-7520-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The following patches were made over this patchset:

https://www.spinics.net/lists/target-devel/msg16283.html

The patches allow userspace to recover from unclean shutdowns
by adding 2 device attrs which can be used to stop new IO and
reset the tcmu ring buffer (memory used to pass commands/responses
between user and kernel space).


From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 03:52:37 +0000
Subject: [PATCH 0/3] tcmu: fix hung netlink requests during restarts
Message-Id: <1529639560-9429-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The following patches fix the issues where the userspace daemon
has crashed and left netlink requests dangling. The daemon
can block the interface, kill outstanding requests, reopen
the netlink socket and then unblock and execute new requests.

The patches were made over Martin's for-next branch.


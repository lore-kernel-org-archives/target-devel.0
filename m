From: Mike Christie <mchristi@redhat.com>
Date: Fri, 22 Jun 2018 21:40:17 +0000
Subject: tcmu: fix hung netlink requests and nl related cleanup V2
Message-Id: <1529703623-9606-1-git-send-email-mchristi@redhat.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The following patches fix the issues where the userspace daemon
has crashed and left netlink requests dangling. The daemon
can now block the interface, kill outstanding requests, reopen
the netlink socket and then unblock and execute new requests.

The patches were made over Martin's for-next branch.

v2:
- Return BUSY error immediately when there is a running command.
- Fix nl skb leak when device is blocked.
- Fix check for valid block_netlink input.
- Break out nl code cleanup into separate patch.


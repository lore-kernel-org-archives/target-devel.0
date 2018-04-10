From: Mark Syms <mark@marksyms.me.uk>
Date: Tue, 10 Apr 2018 15:37:58 +0000
Subject: Tearing my hair out
Message-Id: <CA+Ty-0sqZs1Q8YQCeru11k6Ga=snSAcEed9wV+dpGFX2LwWVvw@mail.gmail.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

I'm sure I'm doing something stupid but for the life of me I can see it.

We using LIO within our automated test environment and want to extend
that to allow it to use CHAP iSCSI authentication to test that the
system under test will also attach with CHAP. LIO is running in a
Debian 8 VM and exporting a fileio backstore.

To configure the authentication the following commands are run by the
automation framework

iscsi/ set discovery_auth userid=<userid> password=<password>
iscsi/<iqn>/<tpg> set auth userid=<userid> password=<password>
iscsi/<iqn>/<tpg> set attribute generate_node_acls=1 authentication=1

The system under test successfully connects the the target but the
block device seen by the Linux kernel reports

[sdb] Write Protect is on

which makes me think I've missed a configuration option somewhere but
this seems to follow whats in
http://linux-iscsi.org/wiki/ISCSI#CHAP_initiator_authentication with
the only difference being that the auth is on the tpg not in a host
specific ACL node.

I've redone all this by hand will similar outcomes so I really am just
missing something.

Can someone point out my stupid mistake or how to work out what is the
cause as the logs don't seem to be very enlightening.

Thanks,

Mark.

(I'm not subscribed to the list so please cc me on any responses).

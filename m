From: David Disseldorp <ddiss@suse.de>
Date: Tue, 09 Oct 2018 11:37:02 +0000
Subject: [PATCH 0/4] target: improve Data-Out and NOP timeout error reporting
Message-Id: <20181009113706.27696-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

The following patchset converts existing Data-Out and NOP ping timeout
messages from pr_debug() to pr_error(), to reflect the seriousness of
unexpected connection termination events.

These events can be triggered using a couple of libiscsi client hacks:
https://github.com/ddiss/libiscsi/tree/hack-lio-trigger-dataout-timeout
https://github.com/ddiss/libiscsi/tree/hack-lio-trigger-nop-timeout

Cheers, David

--

 drivers/target/iscsi/iscsi_target_erl1.c | 21 ++++++++++++++++++---
 drivers/target/iscsi/iscsi_target_stat.c |  4 ++--
 drivers/target/iscsi/iscsi_target_util.c |  2 +-
 include/target/iscsi/iscsi_target_core.h |  6 +++---
 include/target/iscsi/iscsi_target_stat.h |  4 ++--
 5 files changed, 26 insertions(+), 11 deletions(-)

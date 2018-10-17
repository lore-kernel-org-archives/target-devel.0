From: David Disseldorp <ddiss@suse.de>
Date: Wed, 17 Oct 2018 15:48:17 +0000
Subject: [RFC PATCH 0/3] target: remove some unused stats
Message-Id: <20181017154820.9722-1-ddiss@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

This patchset removes a couple of unused error stat counters and a
redundant cumulative counter.
I've tagged this patchset RFC, as it may be considered a kernel<->user
(configfs) API change.

Cheers, David
---
 drivers/target/iscsi/iscsi_target_stat.c | 40 ----------------------------------------
 include/target/iscsi/iscsi_target_stat.h |  4 ----
 2 files changed, 44 deletions(-)

From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 25 Oct 2020 23:03:11 +0000
Subject: [RFC PATCH 0/7] target: fix up locking in IO paths
Message-Id: <1603666998-8086-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

This patchset removes se_session sess_cmd_lock for every driver but
tcm qla2xxx and moves the se_device execution lock to per CPU so
we can run submissions from multiple CPUs without hammering on
those locks.

With the patches I'm seeing a 25% improvement in IOPs for small
IO tests like:

fio  --filename=/dev/sdXYZ  --direct=1 --rw=randrw --bs=4k \
--iodepth8  --numjobs

I'm sending this as RFC, because the qla2xxx patches are not
tested and I'm hoping we can maybe just remove the session
locking/list from that driver since it's only used to lookup
commands for aborts when a specific model is used.

The following patches are made over Linus's tree. Some of Martin's
branches are missing:

commit 149415586243bd0ea729760fb6dd7b3c50601871
Author: Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
Date:   Wed Sep 16 23:54:31 2020 +0000

    scsi: target: Fix lun lookup for TARGET_SCF_LOOKUP_LUN_FROM_TAG case

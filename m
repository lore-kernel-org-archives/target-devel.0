From: Mike Christie <michael.christie@oracle.com>
Date: Sun, 01 Nov 2020 18:59:26 +0000
Subject: [PATCH 0/8 v3] target: fix up locking/refcounting in IO paths
Message-Id: <1604257174-4524-1-git-send-email-michael.christie@oracle.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: himanshu.madhani@oracle.com, njavali@marvell.com, james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org

The following patches made over Martin's staging branch fix some
ref counting issues I hit while testing and improves the locking
in the IO paths. To do the latter, the patches:

1. move the sess_cmd_lock to tcm_qla2xxx since it was the only
driver using the sess_cmd_list.

2. makes the execution lock/list per cpu'ish. I just allocate
nr_cpu_ids's worth of lock/lists then make sure we complete
the cmd on the cpu it was started on.

With the patches I'm seeing a 25% improvement in IOPs for small
IO tests like:

fio  --filename=/dev/sdXYZ  --direct=1 --rw=randrw --bs=4k \
--iodepth8  --numjobs

with drivers like vhost (with those other patches on the list to
fix up multiple virtqueue support) and with the included loop
patch when nr hw queues is increased.

v3:
- Fixed issue where qla2xxx's cpuid was overwritten.
- Fixed up email submit prefix to have "qla2xxx".
v2:
- Got access to qla2xxx setup and tested patch. Fixed various issues.
- Added fixes for issues found in the same code paths I was testing:
        - target: fix lun ref count handling
        - target: fix cmd_count ref leak
v1/RFC
- Initial posting.

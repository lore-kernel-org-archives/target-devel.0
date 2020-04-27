From: Bodo Stroesser <bstroesser@ts.fujitsu.com>
Date: Mon, 27 Apr 2020 15:08:19 +0000
Subject: [PATCH 0/4] target: tcmu: allow flexible pr and alua handling
Message-Id: <20200427150823.15350-1-bstroesser@ts.fujitsu.com>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: mchristi@redhat.com, ddiss@suse.de, hch@lst.de, martin.petersen@oracle.com

These patches already were sent to target-devel only. So I'm resending
them now, slightly modified according to review comments from
target-devel.

The goal of the patches is to add more flexibility to tcmu regarding
PGR handling.

Since the attribute emulate_pr is missing for pscsi in the same way as
for tcmu, I'm adding it to pscsi also. 

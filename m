From: Bart Van Assche <bvanassche@acm.org>
Date: Thu, 13 Feb 2020 05:25:12 +0000
Subject: Re: [PATCH 1/2] Revert "RDMA/isert: Fix a recently introduced regression related to logout"
Message-Id: <fcc55797-40d0-a04f-e2de-6a20a02e6fb6@acm.org>
List-Id: <target-devel.vger.kernel.org>
References: <20200213050900.19094-1-bvanassche@acm.org>
In-Reply-To: <20200213050900.19094-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: target-devel@vger.kernel.org

On 2020-02-12 21:08, Bart Van Assche wrote:
> [ ... ]

Oops, the cover letter has not been included. This is the cover letter I
wanted to include:

[PATCH 0/2] Revert two recent iSCSI / iSER patches

Hi Martin,

Recently Dakshaja Uppalapati reported a regression in the iSER driver
and confirmed that the regression is fixed by reverting the two most
recent iSCSI / iSER patches. Hence this patch series with two reverts.

Thanks,

Bart.

Bart Van Assche (2):
  Revert "RDMA/isert: Fix a recently introduced regression related to
    logout"
  Revert "target: iscsi: Wait for all commands to finish before freeing
    a session"

 drivers/infiniband/ulp/isert/ib_isert.c | 12 ++++++++++++
 drivers/target/iscsi/iscsi_target.c     | 16 +++++-----------
 include/scsi/iscsi_proto.h              |  1 -
 3 files changed, 17 insertions(+), 12 deletions(-)

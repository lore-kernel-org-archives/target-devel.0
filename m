From: Michal Suchanek <msuchanek@suse.de>
Date: Thu, 29 Aug 2019 12:31:59 +0000
Subject: [PATCH 0/3] Fix fallthrough warnings.
Message-Id: <cover.1567081143.git.msuchanek@suse.de>
List-Id: <target-devel.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linuxppc-dev@lists.ozlabs.org
Cc: Michal Suchanek <msuchanek@suse.de>, "Manoj N. Kumar" <manoj@linux.ibm.com>, "Matthew R. Ochs" <mrochs@linux.ibm.com>, Uma Krishnan <ukrishn@linux.ibm.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Tyrel Datwyler <tyreld@linux.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Michael Cyr <mikecyr@linux.ibm.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, target-devel@vger.kernel.org

Build with recent compiler results in numerous fallthrough warnings.

The code looks correct to me so just adding the comments to quiet gcc.

Please review if the fallthrough was really intentional.

Thanks

Michal

Michal Suchanek (3):
  scsi: cxlflash: Fix fallthrough warnings.
  scsi: ibmvfc: Fix fallthrough warnings.
  scsi: ibmvscsi: tgt: Fix fallthrough warnings.

 drivers/scsi/cxlflash/main.c             | 8 ++++++++
 drivers/scsi/ibmvscsi/ibmvfc.c           | 3 +++
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 3 +++
 3 files changed, 14 insertions(+)

-- 
2.12.3
